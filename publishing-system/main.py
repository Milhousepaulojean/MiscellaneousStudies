"""
main.py — Ponto de entrada do sistema de publicação com IA.

Fluxo principal:
  1. Receber filepath via CLI
  2. Parsear o arquivo MD
  3. Validar o input
  4. Processar para Medium
  5. Validar output Medium (score >= 0.75 para prosseguir)
  6. Salvar artigo Medium
  7. Receber URL do Medium (se não fornecida via CLI)
  8. Processar para LinkedIn
  9. Validar conformidade LinkedIn
  10. Salvar post LinkedIn
  11. Opcionalmente copiar para clipboard
  12. Exibir relatório final com scores de qualidade
"""

from __future__ import annotations

import logging
import sys
import time
from datetime import datetime
from pathlib import Path
from typing import Any

from dotenv import load_dotenv
from rich import box
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Confirm
from rich.table import Table

from src.cli import parse_args
from src.generator import ContentGenerator
from src.parser import MarkdownParser
from src.processor import AIProcessor
from src.validator import QualityValidator

# ── Inicialização ──────────────────────────────────────────────────────────
load_dotenv()

Path("logs").mkdir(exist_ok=True)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-8s | %(message)s",
    handlers=[
        logging.FileHandler(
            f"logs/run_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log",
            encoding="utf-8",
        ),
    ],
)
logger = logging.getLogger(__name__)
console = Console()


# ── Comandos ───────────────────────────────────────────────────────────────

def cmd_publish(args: Any) -> None:
    """Fluxo completo de geração de conteúdo para Medium e LinkedIn."""

    filepath: str = args.filepath
    output_dir: str = getattr(args, "output", "./outputs")
    medium_url: str = getattr(args, "url", "") or ""
    verbose: bool = getattr(args, "verbose", False)
    copy_to: str | None = getattr(args, "copy", None)

    console.rule("[bold cyan]SISTEMA DE PUBLICAÇÃO COM IA[/bold cyan]")
    logger.info("Iniciando publicação: %s", filepath)

    # ── 1. Parse ────────────────────────────────────────────────────────
    _step(1, f"Lendo arquivo: [cyan]{filepath}[/cyan]")
    parser = MarkdownParser()
    try:
        parsed = parser.load_file(filepath)
    except (FileNotFoundError, ValueError) as exc:
        _abort(str(exc))

    if verbose:
        console.print(f"   [dim]Título:[/dim] {parsed['title']}")
        console.print(f"   [dim]Palavras:[/dim] {parsed['word_count']}")
        if parsed["headings"]:
            console.print(f"   [dim]Seções:[/dim] {', '.join(parsed['headings'])}")

    logger.info(
        "Arquivo parseado — título: %s, palavras: %d",
        parsed["title"],
        parsed["word_count"],
    )

    # ── 2. Validação do input ───────────────────────────────────────────
    _step(2, "Validando conteúdo de entrada...")
    is_valid, errors = parser.validate_input(parsed)
    if not is_valid:
        console.print("[red]Erros de validação:[/red]")
        for err in errors:
            console.print(f"   ❌ {err}")
        logger.error("Validação falhou: %s", errors)
        sys.exit(1)
    console.print("   ✅ Conteúdo válido")

    # ── 3. Processamento Medium ─────────────────────────────────────────
    _step(3, "Gerando artigo para Medium (aguarde)...")
    processor = AIProcessor()
    try:
        t0 = time.time()
        medium_content = processor.process_for_medium(parsed)
        elapsed = time.time() - t0
    except Exception as exc:
        _abort(f"Erro ao chamar a API OpenAI: {exc}")

    console.print(f"   ✅ Artigo gerado em {elapsed:.1f}s")
    logger.info("Medium gerado — %d caracteres", len(medium_content))

    # ── 4. Validação Medium ─────────────────────────────────────────────
    _step(4, "Validando qualidade do artigo...")
    validator = QualityValidator()
    quality = validator.validate_medium_output(parsed["content"], medium_content)
    hallucinations = validator.check_hallucination_risk(
        parsed["content"], medium_content
    )

    if quality["warnings"]:
        for w in quality["warnings"]:
            console.print(f"   [yellow]⚠️  {w}[/yellow]")

    if hallucinations:
        console.print(
            f"   [yellow]⚠️  {len(hallucinations)} trecho(s) suspeito(s) "
            f"detectado(s) — revise antes de publicar:[/yellow]"
        )
        for snippet in hallucinations[:3]:
            console.print(f"   [dim]→ {snippet[:110]}...[/dim]")

    if quality["overall"] < 0.75:
        console.print(
            f"\n[bold yellow]Score geral: {quality['overall']:.2f} — "
            f"abaixo do mínimo (0.75)[/bold yellow]"
        )
        if not Confirm.ask("Deseja continuar mesmo assim?", default=False):
            console.print("[dim]Processo cancelado pelo usuário.[/dim]")
            sys.exit(0)
    else:
        console.print(
            f"   ✅ Score: [green]{quality['overall']:.2f}[/green] — aprovado"
        )

    # ── 5. Salvar Medium ────────────────────────────────────────────────
    _step(5, "Salvando artigo Medium...")
    generator = ContentGenerator(output_dir)
    medium_path = generator.save_medium_output(
        medium_content, parsed["title"], quality
    )
    console.print(f"   💾 Salvo em: [cyan]{medium_path}[/cyan]")
    logger.info("Medium salvo: %s", medium_path)

    # ── 6. URL do Medium ────────────────────────────────────────────────
    if not medium_url:
        console.print(
            "\n[bold]6.[/bold] Informe a URL do Medium "
            "[dim](deixe em branco se ainda não publicou)[/dim]:"
        )
        medium_url = console.input("   URL: ").strip()
        if not medium_url:
            medium_url = "https://medium.com (URL pendente)"

    # ── 7. Processamento LinkedIn ───────────────────────────────────────
    _step(7, "Gerando post para LinkedIn (aguarde)...")
    try:
        t0 = time.time()
        linkedin_content = processor.process_for_linkedin(
            medium_url, parsed, medium_content
        )
        elapsed = time.time() - t0
    except Exception as exc:
        _abort(f"Erro ao gerar LinkedIn: {exc}")

    console.print(f"   ✅ Post gerado em {elapsed:.1f}s")
    logger.info("LinkedIn gerado — %d caracteres", len(linkedin_content))

    # ── 8. Validação LinkedIn ───────────────────────────────────────────
    _step(8, "Validando conformidade LinkedIn...")
    compliance = validator.check_linkedin_compliance(linkedin_content)

    if not compliance["within_limit"]:
        console.print(
            f"   [yellow]⚠️  Post com {compliance['char_count']} caracteres "
            f"(limite: 1300)[/yellow]"
        )
    if not compliance["hashtags_ok"]:
        console.print(
            f"   [yellow]⚠️  {compliance['hashtag_count']} hashtag(s) "
            f"(ideal: 3 a 5)[/yellow]"
        )

    # ── 9. Salvar LinkedIn ──────────────────────────────────────────────
    _step(9, "Salvando post LinkedIn...")
    linkedin_path = generator.save_linkedin_output(
        linkedin_content, parsed["title"], compliance
    )
    console.print(f"   💾 Salvo em: [cyan]{linkedin_path}[/cyan]")
    logger.info("LinkedIn salvo: %s", linkedin_path)

    # ── 10. Clipboard ───────────────────────────────────────────────────
    if copy_to:
        _copy_to_clipboard(copy_to, medium_content, linkedin_content)

    # ── 11. Relatório final ─────────────────────────────────────────────
    _print_report(filepath, quality, compliance)
    logger.info("Publicação concluída com sucesso.")


def cmd_validate(args: Any) -> None:
    """Valida um arquivo Markdown sem gerar conteúdo."""
    parser = MarkdownParser()
    try:
        parsed = parser.load_file(args.filepath)
    except (FileNotFoundError, ValueError) as exc:
        _abort(str(exc))

    is_valid, errors = parser.validate_input(parsed)

    if is_valid:
        console.print(f"[green]✅ Arquivo válido:[/green] {args.filepath}")
        console.print(f"   Título:   {parsed['title']}")
        console.print(f"   Palavras: {parsed['word_count']}")
        console.print(f"   Seções:   {len(parsed['headings'])}")
    else:
        console.print(f"[red]❌ Arquivo inválido:[/red] {args.filepath}")
        for err in errors:
            console.print(f"   → {err}")
        sys.exit(1)


def cmd_list_outputs(args: Any) -> None:
    """Lista todos os outputs gerados com status de qualidade."""
    generator = ContentGenerator(getattr(args, "output", "./outputs"))
    outputs = generator.list_outputs()

    console.rule("[bold]Outputs Gerados[/bold]")

    table = Table(
        box=box.SIMPLE_HEAVY,
        show_header=True,
        header_style="bold cyan",
    )
    table.add_column("Tipo", style="cyan", min_width=10)
    table.add_column("Arquivo", min_width=40)
    table.add_column("Título", min_width=25)
    table.add_column("Data/Hora", min_width=18)
    table.add_column("Status", justify="center")

    for entry in outputs["medium"]:
        score = entry.get("score", 0.0)
        status = (
            f"[green]✅ {score:.2f}[/green]"
            if entry.get("approved")
            else f"[yellow]⚠️ {score:.2f}[/yellow]"
        )
        table.add_row(
            "Medium",
            entry["file"],
            entry.get("title", "")[:25],
            entry.get("generated_at", "")[:16].replace("T", " "),
            status,
        )

    for entry in outputs["linkedin"]:
        chars = entry.get("char_count", 0)
        compliant = entry.get("compliant", False)
        status = (
            f"[green]✅ {chars}c[/green]"
            if compliant
            else f"[yellow]⚠️ {chars}c[/yellow]"
        )
        table.add_row(
            "LinkedIn",
            entry["file"],
            entry.get("title", "")[:25],
            entry.get("generated_at", "")[:16].replace("T", " "),
            status,
        )

    if not outputs["medium"] and not outputs["linkedin"]:
        console.print("[dim]Nenhum output encontrado.[/dim]")
    else:
        console.print(table)


def cmd_watch(args: Any) -> None:
    """Monitora uma pasta e processa automaticamente novos arquivos .md."""
    try:
        from watchdog.events import FileSystemEventHandler, FileCreatedEvent
        from watchdog.observers import Observer
    except ImportError:
        _abort(
            "watchdog não instalado. "
            "Instale com: pip install watchdog"
        )

    directory = args.directory
    output_dir = getattr(args, "output", "./outputs")

    class _MDHandler(FileSystemEventHandler):
        def on_created(self, event: FileCreatedEvent) -> None:  # type: ignore[override]
            if not event.is_directory and str(event.src_path).endswith(".md"):
                console.print(
                    f"\n[cyan]Novo arquivo detectado:[/cyan] {event.src_path}"
                )

                class _MockArgs:
                    filepath = event.src_path
                    output = output_dir
                    url = ""
                    copy = None
                    validate = False
                    verbose = False

                try:
                    cmd_publish(_MockArgs())
                except SystemExit:
                    pass
                except Exception as exc:
                    console.print(f"[red]Erro ao processar {event.src_path}: {exc}[/red]")

    observer = Observer()
    observer.schedule(_MDHandler(), directory, recursive=False)
    observer.start()
    console.print(f"[green]Monitorando:[/green] {directory}")
    console.print("[dim]Pressione Ctrl+C para parar.[/dim]")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
    console.print("\n[dim]Monitor encerrado.[/dim]")


# ── Utilitários ────────────────────────────────────────────────────────────

def _step(n: int, message: str) -> None:
    console.print(f"\n[bold]{n}.[/bold] {message}")


def _abort(message: str) -> None:
    console.print(f"[bold red]Erro:[/bold red] {message}")
    logger.error(message)
    sys.exit(1)


def _copy_to_clipboard(target: str, medium: str, linkedin: str) -> None:
    try:
        import pyperclip  # type: ignore[import]

        if target in ("medium", "both"):
            pyperclip.copy(medium)
            console.print("   📋 Artigo Medium copiado para o clipboard.")
        if target in ("linkedin", "both"):
            pyperclip.copy(linkedin)
            console.print("   📋 Post LinkedIn copiado para o clipboard.")
    except ImportError:
        console.print(
            "[yellow]pyperclip não instalado. "
            "Instale com: pip install pyperclip[/yellow]"
        )


def _print_report(
    filepath: str,
    quality: dict[str, Any],
    compliance: dict[str, Any],
) -> None:
    """Exibe o relatório final formatado no terminal."""
    console.rule("[bold]RELATÓRIO DE PUBLICAÇÃO[/bold]")
    console.print(f"Arquivo processado: [cyan]{Path(filepath).name}[/cyan]\n")

    # ── Medium ──────────────────────────────────────────────────────────
    def _icon(val: float) -> str:
        return "✅" if val >= 0.75 else "⚠️ "

    med_table = Table(box=box.SIMPLE, show_header=False, padding=(0, 1))
    med_table.add_column("", style="bold", min_width=28)
    med_table.add_column("", justify="right", min_width=6)

    med_table.add_row(
        f"{_icon(quality['factual_integrity'])} Integridade factual:",
        f"[{'green' if quality['factual_integrity'] >= 0.85 else 'yellow'}]"
        f"{quality['factual_integrity']:.2f}[/]",
    )
    med_table.add_row(
        f"{_icon(quality['readability_score'])} Legibilidade:",
        f"[{'green' if quality['readability_score'] >= 0.75 else 'yellow'}]"
        f"{quality['readability_score']:.2f}[/]",
    )
    med_table.add_row(
        f"{_icon(quality['structure_score'])} Estrutura:",
        f"[{'green' if quality['structure_score'] >= 0.75 else 'yellow'}]"
        f"{quality['structure_score']:.2f}[/]",
    )
    med_table.add_row(
        f"{_icon(quality['human_tone_score'])} Tom humano:",
        f"[{'green' if quality['human_tone_score'] >= 0.75 else 'yellow'}]"
        f"{quality['human_tone_score']:.2f}[/]",
    )

    console.print(Panel(med_table, title="MEDIUM", border_style="cyan"))

    status_m = "APROVADO" if quality["approved"] else "REVISAR"
    color_m = "green" if quality["approved"] else "yellow"
    console.print(
        f"[{color_m}]📊 Score geral: {quality['overall']:.2f} — {status_m}[/{color_m}]\n"
    )

    # ── LinkedIn ────────────────────────────────────────────────────────
    li_table = Table(box=box.SIMPLE, show_header=False, padding=(0, 1))
    li_table.add_column("", style="bold", min_width=28)
    li_table.add_column("", justify="right", min_width=12)

    li_table.add_row(
        f"{'✅' if compliance['within_limit'] else '❌'} Caracteres:",
        f"[{'green' if compliance['within_limit'] else 'red'}]"
        f"{compliance['char_count']} / 1300[/]",
    )
    li_table.add_row(
        f"{'✅' if compliance['has_hook'] else '❌'} Hook presente:",
        "sim" if compliance["has_hook"] else "[red]não[/red]",
    )
    li_table.add_row(
        f"{'✅' if compliance['hashtags_ok'] else '⚠️ '} Hashtags:",
        f"[{'green' if compliance['hashtags_ok'] else 'yellow'}]"
        f"{compliance['hashtag_count']}[/]",
    )
    li_table.add_row(
        f"{'✅' if compliance['has_link'] else '❌'} Link presente:",
        "sim" if compliance["has_link"] else "[red]não[/red]",
    )
    li_table.add_row(
        f"{'✅' if compliance['has_cta'] else '⚠️ '} CTA presente:",
        "sim" if compliance["has_cta"] else "[yellow]não[/yellow]",
    )

    console.print(Panel(li_table, title="LINKEDIN", border_style="blue"))

    status_li = "PRONTO" if compliance["compliant"] else "REVISAR"
    color_li = "green" if compliance["compliant"] else "yellow"
    console.print(f"[{color_li}]📊 Status: {status_li}[/{color_li}]")
    console.rule()


# ── Entrypoint ─────────────────────────────────────────────────────────────

def main() -> None:
    """Ponto de entrada principal."""
    args = parse_args()

    dispatch = {
        "publish": cmd_publish,
        "validate": cmd_validate,
        "list-outputs": cmd_list_outputs,
        "watch": cmd_watch,
    }

    handler = dispatch.get(args.command)
    if handler:
        handler(args)
    else:
        console.print(f"[red]Comando desconhecido: {args.command}[/red]")
        sys.exit(1)


if __name__ == "__main__":
    main()
