"""
processor.py — Lógica de processamento com IA (OpenAI).

Converte conteúdo Markdown parseado em artigos para Medium
e posts otimizados para LinkedIn usando templates Jinja2.
"""

from __future__ import annotations

import os
from pathlib import Path
from typing import Any

import yaml
from dotenv import load_dotenv
from jinja2 import Environment, FileSystemLoader, select_autoescape
from openai import OpenAI

load_dotenv()

_BASE_DIR = Path(__file__).parent.parent


class AIProcessor:
    """Processa conteúdo Markdown com IA para gerar publicações."""

    def __init__(self, model: str = "gpt-4o") -> None:
        """
        Inicializa o processador de IA.

        Args:
            model: Modelo OpenAI a ser usado (default: gpt-4o).
        """
        self.model = model

        # Carrega configuração
        config_path = _BASE_DIR / "config.yaml"
        with open(config_path, encoding="utf-8") as f:
            config: dict = yaml.safe_load(f)

        ai_cfg = config.get("ai", {})
        self.temperature: float = ai_cfg.get("temperature", 0.7)
        self.medium_max_tokens: int = ai_cfg.get("medium_max_tokens", 4000)
        self.linkedin_max_tokens: int = ai_cfg.get("linkedin_max_tokens", 800)

        # Cliente OpenAI
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise EnvironmentError(
                "OPENAI_API_KEY não encontrada. "
                "Configure a variável de ambiente ou o arquivo .env."
            )
        self.client = OpenAI(api_key=api_key)

        # Jinja2 — templates da pasta /templates
        templates_dir = _BASE_DIR / "templates"
        self.jinja_env = Environment(
            loader=FileSystemLoader(str(templates_dir)),
            autoescape=select_autoescape(disabled_extensions=("j2",)),
        )

    # ------------------------------------------------------------------ #
    # Público                                                              #
    # ------------------------------------------------------------------ #

    def process_for_medium(self, parsed_content: dict[str, Any]) -> str:
        """
        Gera artigo para Medium a partir do conteúdo parseado.

        Regras:
        - Fidelidade factual total ao conteúdo original
        - Tom humano e conversacional
        - Parágrafos curtos (máx 3 linhas)
        - Voz ativa predominante
        - H2 e H3 para estrutura
        - Introdução com gancho + conclusão com CTA

        Args:
            parsed_content: Dicionário retornado por MarkdownParser.load_file()

        Returns:
            Artigo formatado em Markdown, pronto para publicação.
        """
        template = self.jinja_env.get_template("medium_prompt.j2")
        prompt = template.render(
            content=parsed_content["content"],
            title=parsed_content["title"],
            headings=parsed_content.get("headings", []),
            word_count=parsed_content.get("word_count", 0),
        )

        return self._call_api(
            system_message=(
                "Você é um escritor técnico especializado em conteúdo "
                "para o Medium. Seu trabalho é reformular e humanizar — "
                "nunca inventar informações."
            ),
            user_message=prompt,
            max_tokens=self.medium_max_tokens,
        )

    def process_for_linkedin(
        self,
        medium_url: str,
        parsed_content: dict[str, Any],
        medium_content: str = "",
    ) -> str:
        """
        Gera post para LinkedIn a partir do artigo Medium gerado.

        Regras:
        - Máximo 1300 caracteres antes do "ver mais"
        - Hook poderoso na primeira linha
        - Tom pessoal, primeira pessoa
        - Máximo 5 emojis
        - 3 a 5 hashtags relevantes
        - CTA ou pergunta para engajamento
        - Link do Medium incluído naturalmente

        Args:
            medium_url:      URL do artigo no Medium.
            parsed_content:  Dicionário retornado por MarkdownParser.load_file()
            medium_content:  Artigo Medium já gerado (para contexto).

        Returns:
            Texto do post LinkedIn em plain text.
        """
        reference = medium_content if medium_content else parsed_content["content"]

        template = self.jinja_env.get_template("linkedin_prompt.j2")
        prompt = template.render(
            medium_content=reference,
            title=parsed_content["title"],
            medium_url=medium_url,
        )

        return self._call_api(
            system_message=(
                "Você é um especialista em conteúdo para LinkedIn. "
                "Crie posts pessoais e envolventes, nunca corporativos."
            ),
            user_message=prompt,
            max_tokens=self.linkedin_max_tokens,
        )

    def build_prompt(self, template: str, variables: dict[str, Any]) -> str:
        """
        Constrói um prompt a partir de uma string Jinja2 e variáveis.

        Args:
            template:  String com template Jinja2.
            variables: Dicionário de variáveis para renderização.

        Returns:
            Prompt renderizado.
        """
        tmpl = self.jinja_env.from_string(template)
        return tmpl.render(**variables)

    # ------------------------------------------------------------------ #
    # Privado                                                              #
    # ------------------------------------------------------------------ #

    def _call_api(
        self,
        system_message: str,
        user_message: str,
        max_tokens: int,
    ) -> str:
        """Chama a API OpenAI e retorna o conteúdo gerado."""
        response = self.client.chat.completions.create(
            model=self.model,
            temperature=self.temperature,
            max_tokens=max_tokens,
            messages=[
                {"role": "system", "content": system_message},
                {"role": "user", "content": user_message},
            ],
        )
        content = response.choices[0].message.content
        if content is None:
            raise RuntimeError("A API retornou resposta vazia.")
        return content.strip()
