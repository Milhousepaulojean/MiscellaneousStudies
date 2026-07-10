"""
generator.py — Persistência dos outputs gerados.

Salva os artigos Medium e posts LinkedIn em disco com timestamp,
mantém metadados de qualidade e oferece listagem dos outputs existentes.
"""

from __future__ import annotations

import json
import re
from datetime import datetime
from pathlib import Path
from typing import Any


class ContentGenerator:
    """Persiste outputs de Medium e LinkedIn em disco com metadados."""

    def __init__(self, output_dir: str = "./outputs") -> None:
        """
        Args:
            output_dir: Diretório raiz para salvar os outputs.
        """
        self.output_dir = Path(output_dir)
        self.medium_dir = self.output_dir / "medium"
        self.linkedin_dir = self.output_dir / "linkedin"

        self.medium_dir.mkdir(parents=True, exist_ok=True)
        self.linkedin_dir.mkdir(parents=True, exist_ok=True)

    # ------------------------------------------------------------------ #
    # Público                                                              #
    # ------------------------------------------------------------------ #

    def save_medium_output(
        self,
        content: str,
        title: str,
        quality_report: dict[str, Any],
    ) -> Path:
        """
        Salva artigo Medium em Markdown com cabeçalho de auditoria.

        Args:
            content:        Artigo gerado pela IA.
            title:          Título do artigo.
            quality_report: Relatório retornado por QualityValidator.

        Returns:
            Caminho do arquivo salvo.
        """
        timestamp = self._timestamp()
        slug = self._slugify(title)
        filepath = self.medium_dir / f"{timestamp}_{slug}.md"

        header = (
            f"---\n"
            f"generated_at: {datetime.now().isoformat()}\n"
            f"title: \"{title}\"\n"
            f"quality_score: {quality_report.get('overall', 0):.2f}\n"
            f"approved: {quality_report.get('approved', False)}\n"
            f"---\n\n"
        )
        filepath.write_text(header + content, encoding="utf-8")

        # Metadados em JSON para auditoria
        meta_path = self.medium_dir / f"{timestamp}_{slug}_meta.json"
        meta_path.write_text(
            json.dumps(
                {
                    "generated_at": datetime.now().isoformat(),
                    "title": title,
                    "file": filepath.name,
                    "quality": quality_report,
                },
                indent=2,
                ensure_ascii=False,
            ),
            encoding="utf-8",
        )

        return filepath

    def save_linkedin_output(
        self,
        content: str,
        title: str,
        compliance: dict[str, Any],
    ) -> Path:
        """
        Salva post LinkedIn em plain text com metadados de conformidade.

        Args:
            content:    Post gerado pela IA.
            title:      Título do artigo de origem.
            compliance: Relatório retornado por QualityValidator.

        Returns:
            Caminho do arquivo salvo.
        """
        timestamp = self._timestamp()
        slug = self._slugify(title)
        filepath = self.linkedin_dir / f"{timestamp}_{slug}.txt"
        filepath.write_text(content, encoding="utf-8")

        meta_path = self.linkedin_dir / f"{timestamp}_{slug}_meta.json"
        meta_path.write_text(
            json.dumps(
                {
                    "generated_at": datetime.now().isoformat(),
                    "title": title,
                    "file": filepath.name,
                    "compliance": compliance,
                },
                indent=2,
                ensure_ascii=False,
            ),
            encoding="utf-8",
        )

        return filepath

    def list_outputs(self) -> dict[str, list[dict[str, Any]]]:
        """
        Lista todos os outputs gerados com status de qualidade.

        Returns:
            {
                "medium": [{"file": str, "generated_at": str, "score": float}],
                "linkedin": [{"file": str, "generated_at": str, "compliant": bool}],
            }
        """
        medium_entries = self._load_entries(self.medium_dir, "*.md", "quality")
        linkedin_entries = self._load_entries(self.linkedin_dir, "*.txt", "compliance")

        return {"medium": medium_entries, "linkedin": linkedin_entries}

    # ------------------------------------------------------------------ #
    # Privado                                                              #
    # ------------------------------------------------------------------ #

    @staticmethod
    def _timestamp() -> str:
        return datetime.now().strftime("%Y%m%d_%H%M%S")

    @staticmethod
    def _slugify(text: str) -> str:
        """Converte título em slug seguro para nome de arquivo."""
        text = text.lower()
        text = re.sub(r"[^\w\s-]", "", text)
        text = re.sub(r"[\s_]+", "-", text)
        text = re.sub(r"-+", "-", text)
        return text[:50].strip("-")

    def _load_entries(
        self,
        directory: Path,
        pattern: str,
        meta_key: str,
    ) -> list[dict[str, Any]]:
        """Carrega entradas de uma pasta baseando-se nos arquivos meta JSON."""
        entries = []
        for meta_file in sorted(directory.glob("*_meta.json"), reverse=True):
            try:
                data = json.loads(meta_file.read_text(encoding="utf-8"))
                entry: dict[str, Any] = {
                    "file": data.get("file", meta_file.stem),
                    "title": data.get("title", ""),
                    "generated_at": data.get("generated_at", ""),
                }
                meta_data = data.get(meta_key, {})
                if meta_key == "quality":
                    entry["score"] = meta_data.get("overall", 0.0)
                    entry["approved"] = meta_data.get("approved", False)
                else:
                    entry["compliant"] = meta_data.get("compliant", False)
                    entry["char_count"] = meta_data.get("char_count", 0)
                entries.append(entry)
            except (json.JSONDecodeError, OSError):
                continue
        return entries
