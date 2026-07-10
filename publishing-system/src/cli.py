"""
cli.py — Interface de linha de comando do sistema de publicação.

Define os subcomandos: publish, watch, validate, list-outputs.
O parser de argumentos é instanciado aqui e consumido por main.py.
"""

from __future__ import annotations

import argparse
import sys


def create_parser() -> argparse.ArgumentParser:
    """Cria e retorna o parser principal da CLI."""
    parser = argparse.ArgumentParser(
        prog="python main.py",
        description=(
            "Sistema de publicação com IA — "
            "gera artigos para Medium e posts para LinkedIn a partir de Markdown."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  python main.py publish artigo.md
  python main.py publish artigo.md --url https://medium.com/@user/artigo
  python main.py publish artigo.md --url https://medium.com/@user/artigo --copy linkedin
  python main.py watch ./meus-artigos/
  python main.py validate artigo.md
  python main.py list-outputs
        """,
    )

    subparsers = parser.add_subparsers(dest="command", metavar="COMANDO")

    # ── publish ──────────────────────────────────────────────────────────
    publish = subparsers.add_parser(
        "publish",
        help="Processa um arquivo .md e gera conteúdo para Medium e LinkedIn.",
    )
    publish.add_argument(
        "filepath",
        help="Caminho para o arquivo Markdown (.md) a ser processado.",
    )
    publish.add_argument(
        "--url",
        metavar="URL",
        default="",
        help="URL do artigo no Medium (se já publicado).",
    )
    publish.add_argument(
        "--output",
        metavar="DIR",
        default="./outputs",
        help="Diretório de saída (default: ./outputs).",
    )
    publish.add_argument(
        "--copy",
        choices=["medium", "linkedin", "both"],
        metavar="TARGET",
        help="Copia resultado para o clipboard: medium | linkedin | both.",
    )
    publish.add_argument(
        "--validate",
        action="store_true",
        help="Exibe relatório detalhado de validação de qualidade.",
    )
    publish.add_argument(
        "--verbose",
        action="store_true",
        help="Exibe detalhes do processamento passo a passo.",
    )

    # ── watch ────────────────────────────────────────────────────────────
    watch = subparsers.add_parser(
        "watch",
        help="Monitora uma pasta e processa automaticamente novos arquivos .md.",
    )
    watch.add_argument(
        "directory",
        help="Pasta a ser monitorada.",
    )
    watch.add_argument(
        "--output",
        metavar="DIR",
        default="./outputs",
        help="Diretório de saída (default: ./outputs).",
    )

    # ── validate ─────────────────────────────────────────────────────────
    validate = subparsers.add_parser(
        "validate",
        help="Valida um arquivo .md sem gerar conteúdo.",
    )
    validate.add_argument(
        "filepath",
        help="Caminho para o arquivo Markdown (.md) a ser validado.",
    )

    # ── list-outputs ─────────────────────────────────────────────────────
    list_out = subparsers.add_parser(
        "list-outputs",
        help="Lista todos os outputs gerados com status de qualidade.",
    )
    list_out.add_argument(
        "--output",
        metavar="DIR",
        default="./outputs",
        help="Diretório de saída (default: ./outputs).",
    )

    return parser


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    """Parseia os argumentos e exibe ajuda se nenhum comando for fornecido."""
    parser = create_parser()
    args = parser.parse_args(argv)

    if not args.command:
        parser.print_help()
        sys.exit(0)

    return args
