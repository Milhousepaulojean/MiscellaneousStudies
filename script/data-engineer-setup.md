# ROLE
Expert bash/shell engineer. Generate OS-aware setup script for Data Engineers.

# CONTEXT
- Target: Data Engineer environment setup
- Runtime: Linux (apt) | macOS (brew) | Windows WSL2 (apt)
- Container: Podman + Podman Compose
- Databases: containers only (no local install)
- Output: 1 script + 1 markdown doc

# INPUT [FILL BEFORE RUN]
OS: [linux | macos | wsl2]
DISTRO: [ubuntu | debian | fedora] # only if OS=linux or wsl2
VERSION: [22.04 | 12 | etc]        # only if OS=linux or wsl2
SHELL: [bash | zsh]
ARCH: [amd64 | arm64]

# TOOLS — ALWAYS INSTALL
- System update
- Base tools: git curl wget jq tree vim unzip zip tar make gcc
- pyenv + Python 3.11.9
- Python libs: pandas numpy polars pyarrow sqlalchemy psycopg2-binary
  pymysql dbt-core dbt-postgres great-expectations pydantic
  python-dotenv requests httpx boto3 delta-spark pyspark
  kafka-python loguru rich typer virtualenv podman-compose
- Podman + Podman Compose
- Apache Spark 3.5.1 + Java 11
- AWS CLI v2
- Apache Airflow 2.9.1
- JupyterLab + ipykernel + ipywidgets
- Insomnia
- Monitor tools: htop ncdu tmux fzf bat ripgrep fd-find watch

# DATABASES — PODMAN COMPOSE ONLY
Generate ~/data-engineer/databases/ with:
- docker-compose.yml: postgres:16 mysql:8 mongo:7 redis:7.2 kafka zookeeper minio
- .env: all connection strings
- README.md: commands table

# SCRIPT RULES
- bash strict mode: set -euo pipefail
- Functions: log_header log_info log_success log_warning log_error
- Colors: RED GREEN YELLOW BLUE CYAN BOLD RESET
- Check before install: command_exists()
- Idempotent: skip if already installed
- Interactive: confirm before start
- Detect reboot required after update
- OS switch: use if/elif/else blocks per OS
- macOS: use brew instead of apt
- WSL2: use apt + disable systemctl where needed
- Steps numbered: X/12

# OS SWITCH PATTERN
Use this structure:
case "$DETECTED_OS" in
  linux|wsl2) # apt-get commands ;;
  macos)      # brew commands    ;;
  *)          log_error "Unsupported OS" ; exit 1 ;;
esac

# OUTPUT FORMAT
## BLOCK 1 — SCRIPT
File: data_engineer_setup.sh
Language: bash
Full executable script.

## BLOCK 2 — DOCUMENTATION
File: SETUP.md
Sections:
1. Overview
2. Requirements table (OS | version | arch)
3. Tools table (tool | version | purpose)
4. Databases table (service | port | user | pass)
5. Step-by-step usage
6. Post-install commands
7. Troubleshooting (top 5 common errors)

# SDD ANCHORS [do not remove]
@dense: script structure, colors, functions, rules
@sparse: OS-specific install commands, package managers
@generate: when INPUT is filled, expand @sparse per OS value

# KNOWN INSTALL CHANGES
## Insomnia — repositório APT descontinuado
- O repositório APT `download.konghq.com` foi descontinuado pelo Kong
- Método atual: baixar `.deb` direto do GitHub Releases (Kong/insomnia)
- Script usa GitHub API para obter a versão mais recente dinamicamente
- URL pattern: `https://github.com/Kong/insomnia/releases/download/core%40{VERSION}/Insomnia.Core-{VERSION}.deb`
- macOS: `brew install --cask insomnia` (sem alteração)

## Airflow + Pydantic (typing_extensions)
- Airflow 2.9.1 constraint file pins typing_extensions to a version < 4.12.0
- pydantic-core >= 2.x requires typing_extensions >= 4.12.0 (Sentinel symbol)
- Fix: install typing_extensions>=4.12.0 BEFORE pydantic in the libs block
- Fix: after Airflow install, force upgrade: pip install --upgrade "typing_extensions>=4.12.0" pydantic-core pydantic
- Error signature: ImportError: cannot import name 'Sentinel' from 'typing_extensions'

# CONSTRAINTS
- Max tokens output: efficient, no redundant comments
- Comments: only on non-obvious blocks
- No placeholders in final output
- Generate both files in sequence
- Use tables in markdown, not plain lists