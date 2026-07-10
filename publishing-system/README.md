# Sistema de Publicação com IA

Transforma arquivos Markdown locais em artigos prontos para o **Medium** e posts otimizados para o **LinkedIn**, usando GPT-4o como motor de reformulação com fidelidade factual total.

---

## Estrutura

```
publishing-system/
├── src/
│   ├── parser.py       # Leitura e parse de arquivos MD
│   ├── processor.py    # Processamento com OpenAI
│   ├── generator.py    # Persistência dos outputs
│   ├── validator.py    # Validação de qualidade e conformidade
│   └── cli.py          # Interface de linha de comando
├── templates/
│   ├── medium_prompt.j2
│   └── linkedin_prompt.j2
├── outputs/
│   ├── medium/
│   └── linkedin/
├── logs/
├── .env.example
├── config.yaml
├── requirements.txt
└── main.py
```

---

## Instalação

```bash
cd publishing-system

# Crie e ative um ambiente virtual
python -m venv .venv
source .venv/bin/activate   # Linux/macOS
# .venv\Scripts\activate    # Windows

# Instale as dependências
pip install -r requirements.txt

# Configure as variáveis de ambiente
cp .env.example .env
# Edite .env e adicione sua OPENAI_API_KEY
```

---

## Uso

```bash
# Processar arquivo e gerar conteúdo para Medium e LinkedIn
python main.py publish ./meus-artigos/arquitetura-microsservicos.md

# Com URL do Medium já publicado
python main.py publish artigo.md --url https://medium.com/@user/artigo

# Copiar post LinkedIn para o clipboard
python main.py publish artigo.md --url https://medium.com/@user/artigo --copy linkedin

# Saída verbosa
python main.py publish artigo.md --verbose

# Monitorar pasta automaticamente
python main.py watch ./meus-artigos/

# Validar sem gerar conteúdo
python main.py validate artigo.md

# Listar outputs gerados
python main.py list-outputs
```

---

## Guardrails Anti-Alucinação

O sistema implementa quatro camadas de proteção:

1. **Ancoragem no prompt** — instrução explícita de usar apenas o conteúdo original
2. **Verificação pós-geração** — cada sentença do output é comparada com o original
3. **Score de integridade factual** — percentual de conteúdo rastreável ao original
4. **Alerta automático** — se integridade < 85%, o usuário é avisado antes de continuar

---

## Relatório de Qualidade

```
━━━━━━━━━━━━━━━━━━━━━━━ RELATÓRIO DE PUBLICAÇÃO ━━━━━━━━━━━━━━━━━━━━━━━
Arquivo processado: meu-artigo.md

MEDIUM
  ✅ Integridade factual:  0.97
  ✅ Legibilidade:         0.88
  ✅ Estrutura:            1.00
  ✅ Tom humano:           0.85
📊 Score geral: 0.93 — APROVADO

LINKEDIN
  ✅ Caracteres:    987 / 1300
  ✅ Hook presente: sim
  ✅ Hashtags:      4
  ✅ Link presente: sim
  ✅ CTA presente:  sim
📊 Status: PRONTO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Variáveis de Ambiente

| Variável              | Obrigatória | Descrição                     |
|-----------------------|-------------|-------------------------------|
| `OPENAI_API_KEY`      | ✅ sim      | Chave da API OpenAI           |
| `DEFAULT_MEDIUM_AUTHOR` | não       | Nome padrão do autor          |
| `DEFAULT_LANGUAGE`    | não         | Idioma padrão (default: pt-BR) |
| `LOG_LEVEL`           | não         | Nível de log (default: INFO)  |

---

## Configuração (`config.yaml`)

| Parâmetro                        | Default   | Descrição                              |
|----------------------------------|-----------|----------------------------------------|
| `ai.model`                       | gpt-4o    | Modelo OpenAI                          |
| `ai.temperature`                 | 0.7       | Temperatura de geração                 |
| `ai.medium_max_tokens`           | 4000      | Limite de tokens para artigo Medium    |
| `ai.linkedin_max_tokens`         | 800       | Limite de tokens para post LinkedIn    |
| `quality.minimum_overall_score`  | 0.75      | Score mínimo para aprovação automática |
| `validation.min_word_count`      | 300       | Mínimo de palavras no arquivo MD       |
| `validation.max_linkedin_chars`  | 1300      | Máximo de caracteres no post LinkedIn  |
