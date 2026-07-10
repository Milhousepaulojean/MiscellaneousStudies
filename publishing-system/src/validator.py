"""
validator.py — Validação de qualidade dos outputs gerados pela IA.

Verifica integridade factual, legibilidade, conformidade LinkedIn
e risco de alucinação (conteúdo inventado pela IA).
"""

from __future__ import annotations

import re
from typing import Any


# Padrões que indicam tom robótico/corporativo
_ROBOTIC_PATTERNS: list[str] = [
    r"\bé importante notar\b",
    r"\bé crucial\b",
    r"\bcabe destacar\b",
    r"\bà luz do exposto\b",
    r"\bno contexto atual\b",
    r"\bem suma\b",
    r"\bdestarte\b",
    r"\boutrossim\b",
    r"\bconsoante\b",
    r"\bhodierno\b",
    r"\bno que tange\b",
    r"\bno que concerne\b",
    r"\bé mister\b",
    r"\bé salutar\b",
]

# Padrões que indicam voz ativa / tom pessoal
_HUMAN_PATTERNS: list[str] = [
    r"\b(eu|meu|minha|aprendi|descobri|percebi|acredito|prefiro|uso|fiz|criei)\b",
]


class QualityValidator:
    """Valida qualidade e conformidade dos outputs gerados pela IA."""

    # ------------------------------------------------------------------ #
    # Público — Medium                                                     #
    # ------------------------------------------------------------------ #

    def validate_medium_output(
        self, original: str, generated: str
    ) -> dict[str, Any]:
        """
        Gera relatório de qualidade para o artigo Medium.

        Args:
            original:  Conteúdo original do arquivo Markdown.
            generated: Artigo gerado pela IA.

        Returns:
            {
                "factual_integrity": float,   # 0 a 1
                "readability_score": float,   # 0 a 1
                "structure_score": float,     # 0 a 1
                "human_tone_score": float,    # 0 a 1
                "overall": float,
                "warnings": list[str],
                "approved": bool,
            }
        """
        factual = self._check_factual_integrity(original, generated)
        readability = self._check_readability(generated)
        structure = self._check_structure(generated)
        human_tone = self._check_human_tone(generated)

        # Ponderação: integridade factual tem peso maior
        overall = (
            factual * 0.40
            + readability * 0.20
            + structure * 0.20
            + human_tone * 0.20
        )

        warnings: list[str] = []
        if factual < 0.85:
            warnings.append(
                f"Integridade factual baixa ({factual:.2f}). "
                "Revise manualmente para verificar informações inventadas."
            )
        if human_tone < 0.70:
            warnings.append("Tom muito formal ou robótico detectado.")
        if structure < 0.70:
            warnings.append(
                "Estrutura incompleta — verifique subtítulos e seções."
            )
        if readability < 0.70:
            warnings.append(
                "Sentenças muito longas. Considere revisar para maior clareza."
            )

        return {
            "factual_integrity": round(factual, 2),
            "readability_score": round(readability, 2),
            "structure_score": round(structure, 2),
            "human_tone_score": round(human_tone, 2),
            "overall": round(overall, 2),
            "warnings": warnings,
            "approved": overall >= 0.75,
        }

    def check_hallucination_risk(
        self, original: str, generated: str
    ) -> list[str]:
        """
        Identifica trechos do output que não têm correspondência no original.

        Estratégia: para cada sentença do output, verifica se as palavras
        de conteúdo (len > 4) têm sobreposição mínima com o original.
        Trechos com menos de 20% de sobreposição são sinalizados.

        Args:
            original:  Texto original do arquivo Markdown.
            generated: Artigo gerado pela IA.

        Returns:
            Lista de sentenças suspeitas para revisão manual.
        """
        suspicious: list[str] = []
        original_lower = original.lower()

        sentences = re.split(r"(?<=[.!?])\s+", generated)

        for sentence in sentences:
            words = sentence.split()
            if len(words) < 6:
                continue  # Sentenças curtas têm baixo risco

            content_words = [w.lower() for w in words if len(w) > 4]
            if not content_words:
                continue

            matches = sum(1 for w in content_words if w in original_lower)
            overlap_ratio = matches / len(content_words)

            if overlap_ratio < 0.20:
                suspicious.append(sentence.strip())

        return suspicious

    # ------------------------------------------------------------------ #
    # Público — LinkedIn                                                   #
    # ------------------------------------------------------------------ #

    def check_linkedin_compliance(self, post: str) -> dict[str, Any]:
        """
        Valida conformidade do post LinkedIn com as regras da plataforma.

        Args:
            post: Texto do post gerado pela IA.

        Returns:
            {
                "char_count": int,
                "within_limit": bool,
                "has_hook": bool,
                "has_link": bool,
                "hashtag_count": int,
                "hashtags_ok": bool,
                "has_cta": bool,
                "emoji_count": int,
                "emojis_ok": bool,
                "compliant": bool,
            }
        """
        char_count = len(post)

        # Hook: primeira linha com tamanho ideal para parar a rolagem
        lines = post.strip().splitlines()
        first_line = lines[0].strip() if lines else ""
        has_hook = 10 < len(first_line) < 150

        has_link = bool(re.search(r"https?://\S+", post))

        hashtags = re.findall(r"#[\w\u00C0-\u017E]+", post)
        hashtag_count = len(hashtags)

        has_cta = bool(
            re.search(
                r"(\?|pense nisso|me conta|você já|o que você|compartilhe"
                r"|deixe seu|comente|e você\?|já passou|alguma vez)",
                post,
                re.IGNORECASE,
            )
        )

        # Emojis — faixa Unicode principal
        emojis = re.findall(
            r"[\U0001F300-\U0001F9FF\U00002600-\U000027BF]", post
        )
        emoji_count = len(emojis)

        compliant = (
            char_count <= 1300
            and has_hook
            and has_link
            and 3 <= hashtag_count <= 5
        )

        return {
            "char_count": char_count,
            "within_limit": char_count <= 1300,
            "has_hook": has_hook,
            "has_link": has_link,
            "hashtag_count": hashtag_count,
            "hashtags_ok": 3 <= hashtag_count <= 5,
            "has_cta": has_cta,
            "emoji_count": emoji_count,
            "emojis_ok": emoji_count <= 5,
            "compliant": compliant,
        }

    # ------------------------------------------------------------------ #
    # Privado — métricas                                                   #
    # ------------------------------------------------------------------ #

    def _check_factual_integrity(self, original: str, generated: str) -> float:
        """
        Score de integridade factual baseado em sobreposição de vocabulário
        entre o original e o gerado, sentença por sentença.
        """
        original_words = set(
            w.lower() for w in original.split() if len(w) > 3
        )
        sentences = re.split(r"(?<=[.!?])\s+", generated)

        scores: list[float] = []
        for sentence in sentences:
            words = [w.lower() for w in sentence.split() if len(w) > 3]
            if len(words) < 4:
                continue
            word_set = set(words)
            overlap = word_set & original_words
            scores.append(len(overlap) / len(word_set))

        return round(sum(scores) / len(scores), 4) if scores else 0.5

    def _check_readability(self, text: str) -> float:
        """
        Score de legibilidade baseado no comprimento médio das sentenças.
        Sentenças mais curtas = score maior (mais legível).
        """
        sentences = [
            s for s in re.split(r"(?<=[.!?])\s+", text) if s.strip()
        ]
        if not sentences:
            return 0.0

        total_words = sum(len(s.split()) for s in sentences)
        avg_len = total_words / len(sentences)

        if avg_len <= 12:
            return 1.0
        elif avg_len <= 15:
            return 0.92
        elif avg_len <= 20:
            return 0.80
        elif avg_len <= 25:
            return 0.65
        else:
            return 0.45

    def _check_structure(self, text: str) -> float:
        """
        Score de estrutura baseado na presença dos elementos obrigatórios.
        """
        checks: list[tuple[bool, float]] = [
            (bool(re.search(r"^##\s+.+", text, re.MULTILINE)), 0.30),  # H2
            (bool(re.search(r"^###\s+.+", text, re.MULTILINE)), 0.15),  # H3
            (len(text.split()) >= 300, 0.20),                            # Tamanho
            (text.count("\n\n") >= 3, 0.20),                             # Parágrafos
            (bool(re.search(r"^[\*\-]\s+.+", text, re.MULTILINE)), 0.15),  # Listas
        ]
        return sum(weight for condition, weight in checks if condition)

    def _check_human_tone(self, text: str) -> float:
        """
        Score de tom humano: penaliza padrões robóticos, recompensa voz ativa.
        """
        score = 1.0

        for pattern in _ROBOTIC_PATTERNS:
            if re.search(pattern, text, re.IGNORECASE):
                score -= 0.05

        for pattern in _HUMAN_PATTERNS:
            if re.search(pattern, text, re.IGNORECASE):
                score = min(1.0, score + 0.05)
                break  # Uma recompensa é suficiente

        return round(max(0.0, score), 4)
