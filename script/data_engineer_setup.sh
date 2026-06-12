#!/usr/bin/env bash

# =============================================================================
# DATA ENGINEER SETUP — Multi-OS Automated Environment
# OS:    linux | macos | wsl2
# DISTRO: ubuntu 26.04 (amd64)
# SHELL:  bash
# =============================================================================

set -euo pipefail

# =============================================================================
# COLORS
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# =============================================================================
# VERSIONS
# =============================================================================
PYTHON_VERSION="3.11.9"
SPARK_VERSION="3.5.1"
HADOOP_VERSION="3"
AIRFLOW_VERSION="2.9.1"
JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

log_header()  { echo ""; echo -e "${BLUE}${BOLD}============================================================${RESET}"; echo -e "${BLUE}${BOLD}  $1${RESET}"; echo -e "${BLUE}${BOLD}============================================================${RESET}"; echo ""; }
log_info()    { echo -e "${CYAN}[INFO]${RESET} $1"; }
log_success() { echo -e "${GREEN}[OK]${RESET} $1"; }
log_warning() { echo -e "${YELLOW}[AVISO]${RESET} $1"; }
log_error()   { echo -e "${RED}[ERRO]${RESET} $1"; }

command_exists() { command -v "$1" &>/dev/null; }

# =============================================================================
# OS DETECTION
# =============================================================================

detect_os() {
    if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]] || grep -qi microsoft /proc/version 2>/dev/null; then
        DETECTED_OS="wsl2"
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        DETECTED_OS="macos"
    elif [[ -f /etc/os-release ]]; then
        source /etc/os-release
        DETECTED_OS="linux"
        DISTRO_ID="${ID:-unknown}"
        DISTRO_VERSION="${VERSION_ID:-unknown}"
    else
        log_error "Sistema operacional não suportado."
        exit 1
    fi

    case "$DETECTED_OS" in
        linux|wsl2)
            SUDO=$( [[ $EUID -ne 0 ]] && echo "sudo" || echo "" )
            PKG_INSTALL="$SUDO apt-get install -y"
            PKG_UPDATE="$SUDO apt-get update -y"
            ;;
        macos)
            SUDO=""
            PKG_INSTALL="brew install"
            PKG_UPDATE="brew update"
            if ! command_exists brew; then
                log_error "Homebrew não encontrado. Instale em: https://brew.sh"
                exit 1
            fi
            ;;
        *)
            log_error "OS não suportado: $DETECTED_OS"
            exit 1
            ;;
    esac

    log_info "OS detectado: ${DETECTED_OS} | Distro: ${DISTRO_ID:-n/a} ${DISTRO_VERSION:-} | Arch: $(uname -m)"
}

# =============================================================================
# INITIAL CHECKS
# =============================================================================

check_requirements() {
    log_header "VERIFICAÇÕES INICIAIS"

    detect_os

    log_info "Verificando conexão com a internet..."
    if ! curl -s --max-time 8 https://google.com > /dev/null; then
        log_error "Sem conexão com a internet. Abortando."
        exit 1
    fi
    log_success "Conexão OK."
}

# =============================================================================
# INTERACTIVE SUMMARY
# =============================================================================

show_summary() {
    log_header "DATA ENGINEER — SETUP AUTOMÁTICO"

    echo -e "${BOLD}O script irá instalar:${RESET}"
    echo ""
    echo -e "  ${GREEN}[1]${RESET}  Atualização do Sistema"
    echo -e "  ${GREEN}[2]${RESET}  Ferramentas Base          (git, curl, wget, jq, build-essential...)"
    echo -e "  ${GREEN}[3]${RESET}  Python ${PYTHON_VERSION} via pyenv"
    echo -e "  ${GREEN}[4]${RESET}  Bibliotecas Python        (pandas, polars, dbt, pyspark...)"
    echo -e "  ${GREEN}[5]${RESET}  Podman + Podman Compose"
    echo -e "  ${GREEN}[6]${RESET}  Apache Spark ${SPARK_VERSION} + Java 11"
    echo -e "  ${GREEN}[7]${RESET}  AWS CLI v2"
    echo -e "  ${GREEN}[8]${RESET}  Apache Airflow ${AIRFLOW_VERSION}"
    echo -e "  ${GREEN}[9]${RESET}  JupyterLab"
    echo -e "  ${GREEN}[10]${RESET} Insomnia"
    echo -e "  ${GREEN}[11]${RESET} Ferramentas de Monitoramento"
    echo -e "  ${GREEN}[12]${RESET} Bancos de Dados via Podman Compose"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${YELLOW}  OS: ${DETECTED_OS} | Arch: $(uname -m)${RESET}"
    echo -e "${YELLOW}  Duração estimada: 15–30 min (depende da internet)${RESET}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    read -rp "Deseja prosseguir? (s/N): " CONFIRM
    if [[ "$CONFIRM" != "s" && "$CONFIRM" != "S" ]]; then
        log_info "Instalação cancelada."
        exit 0
    fi
}

# =============================================================================
# 1/12 — SYSTEM UPDATE
# =============================================================================

install_system_update() {
    log_header "1/12 — ATUALIZAÇÃO DO SISTEMA"

    case "$DETECTED_OS" in
        linux|wsl2)
            $SUDO apt-get update -y
            $SUDO apt-get upgrade -y
            $SUDO apt-get dist-upgrade -y
            $SUDO apt-get autoremove -y
            $SUDO apt-get autoclean -y

            if [[ -f /var/run/reboot-required ]]; then
                log_warning "Reinicialização necessária após atualizações."
                read -rp "Continuar mesmo assim? (s/N): " CONT
                if [[ "$CONT" != "s" && "$CONT" != "S" ]]; then
                    log_info "Execute: sudo reboot"
                    exit 0
                fi
                log_warning "Continuando sem reiniciar."
            fi
            ;;
        macos)
            brew update
            brew upgrade
            ;;
    esac

    log_success "Sistema atualizado."
}

# =============================================================================
# 2/12 — BASE TOOLS
# =============================================================================

install_base_tools() {
    log_header "2/12 — FERRAMENTAS BASE"

    case "$DETECTED_OS" in
        linux|wsl2)
            $SUDO apt-get install -y \
                curl wget git unzip zip tar jq tree vim \
                build-essential libssl-dev libffi-dev libpq-dev \
                software-properties-common apt-transport-https \
                ca-certificates gnupg lsb-release make gcc g++
            ;;
        macos)
            brew install curl wget git jq tree vim make gcc
            ;;
    esac

    log_success "Ferramentas base instaladas."
}

# =============================================================================
# 3/12 — PYTHON + PYENV
# =============================================================================

install_python() {
    log_header "3/12 — PYTHON ${PYTHON_VERSION} + PYENV"

    SHELL_RC="$HOME/.bashrc"
    [[ "$SHELL" == *"zsh"* ]] && SHELL_RC="$HOME/.zshrc"

    if command_exists pyenv || [[ -d "$HOME/.pyenv" ]]; then
        # Diretório ~/.pyenv já existe (instalação completa ou parcial):
        # apenas configura o PATH sem tentar reinstalar.
        log_warning "pyenv já encontrado em $HOME/.pyenv. Configurando PATH e pulando instalação."
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)" 2>/dev/null || true

        # Garante que as linhas de inicialização estão no shell RC
        if ! grep -q 'PYENV_ROOT' "$SHELL_RC" 2>/dev/null; then
            {
                echo ''
                echo '# === PYENV ==='
                echo 'export PYENV_ROOT="$HOME/.pyenv"'
                echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
                echo 'eval "$(pyenv init -)"'
            } >> "$SHELL_RC"
        fi
    else
        case "$DETECTED_OS" in
            linux|wsl2)
                $SUDO apt-get install -y \
                    libbz2-dev libncurses-dev libreadline-dev libsqlite3-dev \
                    libxml2-dev libxmlsec1-dev llvm tk-dev xz-utils zlib1g-dev
                ;;
            macos)
                brew install openssl readline sqlite3 xz zlib tcl-tk
                ;;
        esac

        curl https://pyenv.run | bash

        {
            echo ''
            echo '# === PYENV ==='
            echo 'export PYENV_ROOT="$HOME/.pyenv"'
            echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
            echo 'eval "$(pyenv init -)"'
        } >> "$SHELL_RC"

        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"

        log_success "pyenv instalado."
    fi

    log_info "Instalando Python ${PYTHON_VERSION}..."
    pyenv install -s "$PYTHON_VERSION"
    pyenv global "$PYTHON_VERSION"

    pip install --upgrade pip
    pip install virtualenv

    log_success "Python ${PYTHON_VERSION} configurado."
    python --version && pip --version
}

# =============================================================================
# 4/12 — PYTHON LIBS
# =============================================================================

install_python_libs() {
    log_header "4/12 — BIBLIOTECAS PYTHON"

    log_info "Instalando bibliotecas de Data Engineering..."
    # typing_extensions>=4.12.0 é necessário para pydantic-core (Sentinel).
    # Deve ser instalado ANTES do pydantic para evitar downgrade pelo constraint do Airflow.
    pip install "typing_extensions>=4.12.0"

    pip install \
        pandas \
        numpy \
        polars \
        pyarrow \
        fastparquet \
        sqlalchemy \
        psycopg2-binary \
        pymysql \
        dbt-core \
        dbt-postgres \
        great-expectations \
        pydantic \
        python-dotenv \
        requests \
        httpx \
        boto3 \
        kafka-python \
        loguru \
        rich \
        typer \
        podman-compose

    # pyspark e delta-spark instalados separadamente com --prefer-binary
    # para evitar falha de build de wheel (failed-wheel-build-for-install)
    log_info "Instalando pyspark==${SPARK_VERSION} e delta-spark (prefer-binary)..."
    pip install --prefer-binary \
        "pyspark==${SPARK_VERSION}" \
        "delta-spark"

    log_success "Bibliotecas Python instaladas."
}

# =============================================================================
# 5/12 — PODMAN + PODMAN COMPOSE
# =============================================================================

install_podman() {
    log_header "5/12 — PODMAN + PODMAN COMPOSE"

    case "$DETECTED_OS" in
        linux|wsl2)
            if command_exists podman; then
                log_warning "Podman já instalado."
                podman --version
            else
                log_info "Instalando Podman via repositório Ubuntu..."
                # Ubuntu 22.04+ tem podman nos repositórios oficiais
                $SUDO apt-get install -y podman

                # Configura registro padrão docker.io
                REGISTRIES_CONF="/etc/containers/registries.conf"
                if [[ -f "$REGISTRIES_CONF" ]] && ! grep -q "docker.io" "$REGISTRIES_CONF"; then
                    printf '\n[registries.search]\nregistries = ["docker.io", "quay.io"]\n' \
                        | $SUDO tee -a "$REGISTRIES_CONF" > /dev/null
                fi

                if [[ "$DETECTED_OS" != "wsl2" ]]; then
                    systemctl --user enable --now podman.socket 2>/dev/null || \
                        log_warning "podman.socket não habilitado (normal em alguns ambientes)."
                fi

                log_success "Podman instalado."
                podman --version
            fi
            ;;
        macos)
            if command_exists podman; then
                log_warning "Podman já instalado."
            else
                brew install podman
                podman machine init
                podman machine start
                log_success "Podman instalado."
            fi
            ;;
    esac

    # podman-compose instalado via pip (etapa 4)
    if command_exists podman-compose; then
        log_success "podman-compose já disponível."
    else
        log_info "Instalando podman-compose via pip..."
        pip install podman-compose
    fi

    log_success "Podman + Podman Compose prontos."
}

# =============================================================================
# 6/12 — APACHE SPARK + JAVA 11
# =============================================================================

install_spark() {
    log_header "6/12 — APACHE SPARK ${SPARK_VERSION} + JAVA 11"

    case "$DETECTED_OS" in
        linux|wsl2)
            $SUDO apt-get install -y openjdk-11-jdk
            ;;
        macos)
            brew install openjdk@11
            JAVA_HOME_PATH="$(brew --prefix openjdk@11)/libexec/openjdk.jdk/Contents/Home"
            ;;
    esac

    export JAVA_HOME="$JAVA_HOME_PATH"
    export PATH="$JAVA_HOME/bin:$PATH"

    if [[ -d "/opt/spark" ]]; then
        log_warning "Apache Spark já instalado em /opt/spark. Pulando."
    else
        log_info "Baixando Apache Spark ${SPARK_VERSION}..."
        SPARK_TGZ="spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
        SPARK_URL="https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_TGZ}"

        wget -q --show-progress "$SPARK_URL" -O "/tmp/${SPARK_TGZ}"

        $SUDO tar -xzf "/tmp/${SPARK_TGZ}" -C /opt/
        $SUDO mv "/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" /opt/spark
        rm -f "/tmp/${SPARK_TGZ}"

        SHELL_RC="$HOME/.bashrc"
        [[ "$SHELL" == *"zsh"* ]] && SHELL_RC="$HOME/.zshrc"

        {
            echo ''
            echo '# === APACHE SPARK ==='
            echo "export JAVA_HOME=${JAVA_HOME_PATH}"
            echo 'export SPARK_HOME=/opt/spark'
            echo 'export PATH="$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH"'
            echo 'export PYSPARK_PYTHON=python3'
        } >> "$SHELL_RC"

        export SPARK_HOME=/opt/spark
        export PATH="$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH"

        log_success "Apache Spark ${SPARK_VERSION} instalado em /opt/spark."
    fi
}

# =============================================================================
# 7/12 — AWS CLI v2
# =============================================================================

install_aws_cli() {
    log_header "7/12 — AWS CLI v2"

    if command_exists aws; then
        log_warning "AWS CLI já instalado."
        aws --version
        return
    fi

    case "$DETECTED_OS" in
        linux|wsl2)
            log_info "Instalando AWS CLI v2 (amd64)..."
            curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
                -o /tmp/awscliv2.zip
            unzip -q /tmp/awscliv2.zip -d /tmp/awscli
            $SUDO /tmp/awscli/aws/install
            rm -rf /tmp/awscliv2.zip /tmp/awscli
            ;;
        macos)
            brew install awscli
            ;;
    esac

    log_success "AWS CLI instalado."
    aws --version
}

# =============================================================================
# 8/12 — APACHE AIRFLOW
# =============================================================================

install_airflow() {
    log_header "8/12 — APACHE AIRFLOW ${AIRFLOW_VERSION}"

    if command_exists airflow; then
        log_warning "Apache Airflow já instalado."
        airflow version
        return
    fi

    PYTHON_VER=$(python --version 2>&1 | awk '{print $2}' | cut -d. -f1,2)
    CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VER}.txt"

    log_info "Instalando Apache Airflow ${AIRFLOW_VERSION} (Python ${PYTHON_VER})..."
    pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

    SHELL_RC="$HOME/.bashrc"
    [[ "$SHELL" == *"zsh"* ]] && SHELL_RC="$HOME/.zshrc"

    {
        echo ''
        echo '# === APACHE AIRFLOW ==='
        echo 'export AIRFLOW_HOME=~/airflow'
    } >> "$SHELL_RC"

    export AIRFLOW_HOME=~/airflow

    # O constraint do Airflow pode fazer downgrade de typing_extensions para uma
    # versão < 4.12.0, quebrando pydantic-core (ImportError: cannot import name 'Sentinel').
    # Forçamos o upgrade após a instalação do Airflow e reconstruímos pydantic-core.
    log_info "Corrigindo compatibilidade typing_extensions/pydantic-core pós-Airflow..."
    pip install --upgrade "typing_extensions>=4.12.0" pydantic-core pydantic

    airflow db migrate

    log_success "Apache Airflow ${AIRFLOW_VERSION} instalado."
    airflow version
}

# =============================================================================
# 9/12 — JUPYTERLAB
# =============================================================================

install_jupyter() {
    log_header "9/12 — JUPYTERLAB"

    if command_exists jupyter; then
        log_warning "Jupyter já instalado."
        jupyter --version
        return
    fi

    pip install jupyterlab ipykernel ipywidgets

    log_success "JupyterLab instalado."
    jupyter --version
}

# =============================================================================
# 10/12 — INSOMNIA
# =============================================================================

install_insomnia() {
    log_header "10/12 — INSOMNIA"

    case "$DETECTED_OS" in
        linux|wsl2)
            if command_exists insomnia; then
                log_warning "Insomnia já instalado."
                return
            fi

            # O repositório APT do Kong (download.konghq.com) foi descontinuado.
            # Instalação via .deb direto do GitHub Releases (método oficial atual).
            log_info "Obtendo versão mais recente do Insomnia no GitHub..."
            INSOMNIA_TAG=$(curl -s https://api.github.com/repos/Kong/insomnia/releases/latest \
                | grep '"tag_name"' \
                | sed 's/.*"tag_name": *"core@\([^"]*\)".*/\1/')

            if [[ -z "$INSOMNIA_TAG" ]]; then
                log_warning "Não foi possível obter a versão do Insomnia via API GitHub."
                log_warning "Baixe manualmente: https://github.com/Kong/insomnia/releases/latest"
                return
            fi

            log_info "Instalando Insomnia ${INSOMNIA_TAG}..."
            INSOMNIA_DEB="/tmp/Insomnia.Core-${INSOMNIA_TAG}.deb"
            INSOMNIA_URL="https://github.com/Kong/insomnia/releases/download/core%40${INSOMNIA_TAG}/Insomnia.Core-${INSOMNIA_TAG}.deb"

            if wget -q --show-progress "$INSOMNIA_URL" -O "$INSOMNIA_DEB"; then
                $SUDO apt-get install -y "$INSOMNIA_DEB"
                rm -f "$INSOMNIA_DEB"
                log_success "Insomnia ${INSOMNIA_TAG} instalado."
            else
                log_warning "Falha ao baixar o Insomnia."
                log_warning "URL: ${INSOMNIA_URL}"
                log_warning "Baixe manualmente: https://github.com/Kong/insomnia/releases/latest"
                rm -f "$INSOMNIA_DEB"
            fi
            ;;
        macos)
            if command_exists insomnia; then
                log_warning "Insomnia já instalado."
                return
            fi
            brew install --cask insomnia || \
                log_warning "Instale manualmente: https://insomnia.rest/download"
            ;;
    esac
}

# =============================================================================
# 11/12 — MONITORING TOOLS
# =============================================================================

install_monitoring_tools() {
    log_header "11/12 — FERRAMENTAS DE MONITORAMENTO"

    case "$DETECTED_OS" in
        linux|wsl2)
            $SUDO apt-get install -y \
                htop ncdu tmux fzf bat ripgrep fd-find watch
            ;;
        macos)
            brew install htop ncdu tmux fzf bat ripgrep fd watch
            ;;
    esac

    log_success "Ferramentas de monitoramento instaladas."
}

# =============================================================================
# 12/12 — DATABASE COMPOSE FILES
# =============================================================================

generate_databases_compose() {
    log_header "12/12 — GERANDO ARQUIVOS DE BANCO DE DADOS (PODMAN)"

    DB_DIR="$HOME/data-engineer/databases"
    mkdir -p "$DB_DIR"

    cat > "$DB_DIR/docker-compose.yml" << 'EOF'
# Bancos de Dados — Data Engineer | Runtime: Podman Compose
version: "3.8"

networks:
  data-network:
    driver: bridge

volumes:
  postgres_data:
  mysql_data:
  mongo_data:
  redis_data:
  kafka_data:
  minio_data:

services:

  postgres:
    image: postgres:16-alpine
    container_name: de_postgres
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${POSTGRES_USER:-admin}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD:-admin123}
      POSTGRES_DB: ${POSTGRES_DB:-dataengineering}
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - data-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U admin -d dataengineering"]
      interval: 10s
      timeout: 5s
      retries: 5

  mysql:
    image: mysql:8.0
    container_name: de_mysql
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD:-root123}
      MYSQL_DATABASE: ${MYSQL_DB:-dataengineering}
      MYSQL_USER: ${MYSQL_USER:-admin}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD:-admin123}
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - data-network
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "admin", "-padmin123"]
      interval: 10s
      timeout: 5s
      retries: 5

  mongo:
    image: mongo:7.0
    container_name: de_mongo
    restart: unless-stopped
    environment:
      MONGO_INITDB_ROOT_USERNAME: ${MONGO_USER:-admin}
      MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD:-admin123}
      MONGO_INITDB_DATABASE: ${MONGO_DB:-dataengineering}
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db
    networks:
      - data-network
    healthcheck:
      test: ["CMD", "mongosh", "--eval", "db.adminCommand('ping')"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7.2-alpine
    container_name: de_redis
    restart: unless-stopped
    command: redis-server --requirepass ${REDIS_PASSWORD:-admin123}
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - data-network
    healthcheck:
      test: ["CMD", "redis-cli", "-a", "admin123", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  zookeeper:
    image: confluentinc/cp-zookeeper:7.6.0
    container_name: de_zookeeper
    restart: unless-stopped
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    networks:
      - data-network

  kafka:
    image: confluentinc/cp-kafka:7.6.0
    container_name: de_kafka
    restart: unless-stopped
    depends_on:
      - zookeeper
    ports:
      - "9092:9092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_AUTO_CREATE_TOPICS_ENABLE: "true"
    volumes:
      - kafka_data:/var/lib/kafka/data
    networks:
      - data-network
    healthcheck:
      test: ["CMD", "kafka-broker-api-versions", "--bootstrap-server", "localhost:9092"]
      interval: 15s
      timeout: 10s
      retries: 5

  minio:
    image: minio/minio:latest
    container_name: de_minio
    restart: unless-stopped
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER: ${MINIO_ACCESS_KEY:-minioadmin}
      MINIO_ROOT_PASSWORD: ${MINIO_SECRET_KEY:-minioadmin123}
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio_data:/data
    networks:
      - data-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 10s
      timeout: 5s
      retries: 5
EOF

    cat > "$DB_DIR/.env" << 'EOF'
# =============================================================================
# Variáveis de Conexão — Bancos de Dados
# ATENÇÃO: não commite este arquivo. Adicione ao .gitignore.
# =============================================================================

# PostgreSQL
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin123
POSTGRES_DB=dataengineering
POSTGRES_URL=postgresql://admin:admin123@localhost:5432/dataengineering

# MySQL
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=admin
MYSQL_ROOT_PASSWORD=root123
MYSQL_PASSWORD=admin123
MYSQL_DB=dataengineering
MYSQL_URL=mysql+pymysql://admin:admin123@localhost:3306/dataengineering

# MongoDB
MONGO_HOST=localhost
MONGO_PORT=27017
MONGO_USER=admin
MONGO_PASSWORD=admin123
MONGO_DB=dataengineering
MONGO_URL=mongodb://admin:admin123@localhost:27017/dataengineering

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=admin123
REDIS_URL=redis://:admin123@localhost:6379/0

# Kafka
KAFKA_BOOTSTRAP_SERVERS=localhost:9092

# MinIO
MINIO_ENDPOINT=http://localhost:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin123
AWS_ENDPOINT_URL=http://localhost:9000
EOF

    log_success "Arquivos gerados em: ${DB_DIR}"
    echo -e "    ${CYAN}~/data-engineer/databases/${RESET}"
    echo -e "    ├── docker-compose.yml"
    echo -e "    └── .env"
}

# =============================================================================
# FINAL REPORT
# =============================================================================

print_summary() {
    log_header "INSTALAÇÃO CONCLUÍDA — RELATÓRIO FINAL"

    check_tool() {
        local name="$1" cmd="$2"
        command_exists "$cmd" \
            && echo -e "  ${GREEN}✔${RESET} ${name}" \
            || echo -e "  ${RED}✘${RESET} ${name} — não encontrado no PATH (recarregue o shell)"
    }

    echo -e "${BOLD}Status das ferramentas:${RESET}"
    echo ""
    check_tool "Git"               git
    check_tool "Python"            python
    check_tool "pip"               pip
    check_tool "pyenv"             pyenv
    check_tool "Podman"            podman
    check_tool "Podman Compose"    podman-compose
    check_tool "AWS CLI"           aws
    check_tool "Airflow"           airflow
    check_tool "Jupyter"           jupyter
    check_tool "spark-submit"      spark-submit
    check_tool "Insomnia"          insomnia
    check_tool "tmux"              tmux
    check_tool "htop"              htop
    check_tool "jq"                jq
    check_tool "fzf"               fzf

    echo ""
    echo -e "${YELLOW}${BOLD}PRÓXIMOS PASSOS:${RESET}"
    echo ""
    echo -e "  ${CYAN}1.${RESET} Recarregue o shell:         source ~/.bashrc"
    echo -e "  ${CYAN}2.${RESET} Suba os bancos de dados:"
    echo -e "           cd ~/data-engineer/databases && podman-compose up -d"
    echo -e "  ${CYAN}3.${RESET} Configure AWS:              aws configure"
    echo -e "  ${CYAN}4.${RESET} Inicie JupyterLab:          jupyter lab"
    echo -e "  ${CYAN}5.${RESET} Inicie Airflow:             airflow standalone"
    echo -e "  ${CYAN}6.${RESET} Alias Docker → Podman:      echo \"alias docker=podman\" >> ~/.bashrc"
    echo ""
    echo -e "${GREEN}${BOLD}Setup concluído! Bons pipelines!${RESET}"
    echo ""
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    check_requirements
    show_summary

    install_system_update       # 1/12
    install_base_tools          # 2/12
    install_python              # 3/12
    install_python_libs         # 4/12
    install_podman              # 5/12
    install_spark               # 6/12
    install_aws_cli             # 7/12
    install_airflow             # 8/12
    install_jupyter             # 9/12
    install_insomnia            # 10/12
    install_monitoring_tools    # 11/12
    generate_databases_compose  # 12/12

    print_summary
}

main "$@"
