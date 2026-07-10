"""
parser.py — Leitura e parse de arquivos Markdown.

Responsável por extrair título, conteúdo, metadados,
estrutura e validar o input antes do processamento com IA.
"""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any

import frontmatter


class MarkdownParser:
    """Lê e estrutura arquivos Markdown para processamento com IA."""

    # ------------------------------------------------------------------ #
    # Público                                                              #
    # ------------------------------------------------------------------ #

    def load_file(self, filepath: str) -> dict[str, Any]:
        """
        Lê um arquivo .md e retorna estrutura padronizada.

        Returns:
            {
                "title": str,           # Do frontmatter ou H1
                "content": str,         # Corpo do texto (sem H1)
                "metadata": dict,       # Frontmatter YAML se existir
                "word_count": int,
                "headings": list[str],
                "raw": str,
                "file_path": str,
            }
        """
        path = Path(filepath)
        if not path.exists():
            raise FileNotFoundError(f"Arquivo não encontrado: {filepath}")
        if path.suffix.lower() != ".md":
            raise ValueError(f"Arquivo não é Markdown: {filepath}")

        raw: str = path.read_text(encoding="utf-8")

        # Parseia frontmatter YAML (se existir)
        post = frontmatter.loads(raw)
        content: str = post.content
        metadata: dict = dict(post.metadata)

        # Título: frontmatter > primeiro H1 > nome do arquivo
        title: str = str(metadata.get("title", "")).strip()
        if not title:
            h1_match = re.search(r"^#\s+(.+)$", content, re.MULTILINE)
            if h1_match:
                title = h1_match.group(1).strip()
                # Remove o H1 do corpo para não duplicar
                content = re.sub(
                    r"^#\s+.+\n?", "", content, count=1, flags=re.MULTILINE
                ).strip()

        if not title:
            title = path.stem.replace("-", " ").replace("_", " ").title()

        headings: list[str] = re.findall(r"^#{1,6}\s+(.+)$", content, re.MULTILINE)
        word_count: int = len(content.split())

        return {
            "title": title,
            "content": content.strip(),
            "metadata": metadata,
            "word_count": word_count,
            "headings": headings,
            "raw": raw,
            "file_path": str(path.resolve()),
        }

    def extract_structure(self, content: str) -> dict[str, Any]:
        """
        Extrai elementos estruturais do conteúdo Markdown.

        Returns:
            {
                "sections": list[str],          # Títulos H2 e H3
                "code_blocks": list[str],        # Conteúdo dos blocos de código
                "bullet_lists": list[str],       # Itens de lista
                "external_links": list[tuple],   # (texto, url)
                "blockquotes": list[str],        # Citações
            }
        """
        # Seções H2 e H3
        sections: list[str] = re.findall(
            r"^#{2,3}\s+(.+)$", content, re.MULTILINE
        )

        # Blocos de código — captura linguagem e conteúdo
        code_blocks: list[str] = re.findall(
            r"```[\w]*\n(.*?)```", content, re.DOTALL
        )

        # Bullets (*, -, +)
        bullet_lists: list[str] = re.findall(
            r"^[\*\-\+]\s+(.+)$", content, re.MULTILINE
        )

        # Links externos [texto](https://...)
        external_links: list[tuple[str, str]] = re.findall(
            r"\[([^\]]+)\]\((https?://[^\)]+)\)", content
        )

        # Blockquotes
        blockquotes: list[str] = re.findall(
            r"^>\s+(.+)$", content, re.MULTILINE
        )

        return {
            "sections": sections,
            "code_blocks": [b.strip() for b in code_blocks],
            "bullet_lists": bullet_lists,
            "external_links": external_links,
            "blockquotes": blockquotes,
        }

    def validate_input(self, parsed: dict[str, Any]) -> tuple[bool, list[str]]:
        """
        Valida se o arquivo atende aos requisitos mínimos.

        Returns:
            (is_valid, errors): tuple com status e lista de erros encontrados.
        """
        errors: list[str] = []

        if parsed["word_count"] < 300:
            errors.append(
                f"Conteúdo muito curto: {parsed['word_count']} palavras "
                f"(mínimo: 300)."
            )

        if not parsed["title"]:
            errors.append(
                "Título não encontrado. "
                "Adicione 'title' no frontmatter ou um H1 no início do arquivo."
            )

        if not parsed["headings"]:
            errors.append(
                "Nenhuma seção encontrada. "
                "Adicione ao menos um subtítulo (## ou ###)."
            )

        return (len(errors) == 0, errors)
