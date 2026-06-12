# SETUP — Data Engineer Environment

## 1. Overview

Instalação automatizada e idempotente de ambiente completo para Engenharia de Dados.  
Compatível com Linux, macOS e WSL2. Bancos de dados gerenciados exclusivamente via Podman Compose.

---

## 2. Requirements

| OS | Distro | Version | Arch | Shell |
|---|---|---|---|---|
| Linux | Ubuntu | 26.04 LTS | amd64 | bash |
| Linux | Debian | 12+ | amd64 | bash/zsh |
| macOS | — | 14+ (Sonoma) | arm64/amd64 | bash/zsh |
| WSL2 | Ubuntu | 22.04+ | amd64 | bash |

**Pré-requisitos:**
- Acesso `sudo` (Linux/WSL2) ou Homebrew (macOS)
- Conexão com a internet
- ~10 GB de espaço livre em disco

---

## 3. Tools

| Ferramenta | Versão | Propósito |
|---|---|---|
| Python | 3.11.9 | Runtime principal |
| pyenv | latest | Gerenciador de versões Python |
| pandas | latest | Manipulação de dados |
| polars | latest | DataFrames de alta performance |
| PyArrow | latest | Formato columnar / Parquet |
| SQLAlchemy | latest | ORM / conexões SQL |
| dbt-core | latest | Transformações SQL (ELT) |
| dbt-postgres | latest | Adapter PostgreSQL para dbt |
| great-expectations | latest | Validação de dados |
| pyspark | 3.5.1 | Processamento distribuído (Python) |
| delta-spark | latest | Delta Lake (ACID em Spark) |
| kafka-python | latest | Produtor/Consumidor Kafka |
| boto3 | latest | SDK AWS (S3, Glue, etc.) |
| Pydantic | latest | Validação de modelos de dados |
| loguru | latest | Logging moderno |
| rich | latest | Output terminal formatado |
| typer | latest | CLIs em Python |
| Podman | latest | Container runtime (rootless) |
| Podman Compose | latest | Orquestração local de containers |
| Apache Spark | 3.5.1 | Processamento distribuído |
| Java | 11 (OpenJDK) | Runtime do Spark |
| AWS CLI | v2 | Interface cloud Amazon |
| Apache Airflow | 2.9.1 | Orquestração de pipelines |
| JupyterLab | latest | Notebooks interativos |
| Insomnia | latest | Cliente REST/GraphQL/gRPC |
| htop | latest | Monitor de processos |
| tmux | latest | Multiplexador de terminal |
| fzf | latest | Fuzzy finder |
| ripgrep | latest | Busca rápida em arquivos |

---

## 4. Databases

Todos os bancos são gerenciados via Podman Compose em `~/data-engineer/databases/`.

| Serviço | Porta | Usuário | Senha | Imagem |
|---|---|---|---|---|
| PostgreSQL | 5432 | admin | admin123 | postgres:16-alpine |
| MySQL | 3306 | admin | admin123 | mysql:8.0 |
| MongoDB | 27017 | admin | admin123 | mongo:7.0 |
| Redis | 6379 | — | admin123 | redis:7.2-alpine |
| Kafka | 9092 | — | — | confluentinc/cp-kafka:7.6.0 |
| Zookeeper | 2181 | — | — | confluentinc/cp-zookeeper:7.6.0 |
| MinIO API | 9000 | minioadmin | minioadmin123 | minio/minio:latest |
| MinIO UI | 9001 | minioadmin | minioadmin123 | minio/minio:latest |

---

## 5. Step-by-step Usage

### 1. Clone / copie o script
```bash
git clone <repo>
cd script/
```

### 2. Torne executável
```bash
chmod +x data_engineer_setup.sh
```

### 3. Execute
```bash
./data_engineer_setup.sh
```

O script exibe um sumário e solicita confirmação antes de iniciar.

### 4. Recarregue o shell após conclusão
```bash
source ~/.bashrc   # bash
# ou
source ~/.zshrc    # zsh
```

---

## 6. Post-install Commands

### Subir todos os bancos de dados
```bash
cd ~/data-engineer/databases
podman-compose up -d
```

### Verificar status dos containers
```bash
podman-compose ps
podman-compose logs -f postgres
```

### Parar containers
```bash
podman-compose down        # mantém volumes
podman-compose down -v     # remove volumes
```

### Acessar bancos via CLI
```bash
podman exec -it de_postgres psql -U admin -d dataengineering
podman exec -it de_mysql mysql -u admin -padmin123 dataengineering
podman exec -it de_mongo mongosh -u admin -p admin123
podman exec -it de_redis redis-cli -a admin123
```

### Configurar AWS CLI
```bash
aws configure
# AWS Access Key ID: <sua-key>
# AWS Secret Access Key: <seu-secret>
# Default region: us-east-1
# Output format: json
```

### Iniciar JupyterLab
```bash
jupyter lab --ip=0.0.0.0 --no-browser
```

### Iniciar Airflow (modo standalone)
```bash
export AIRFLOW_HOME=~/airflow
airflow standalone
```

### Criar tópico Kafka
```bash
podman exec de_kafka kafka-topics \
  --create --topic meu-topico \
  --bootstrap-server localhost:9092 \
  --partitions 3 --replication-factor 1
```

### Alias Docker → Podman (opcional)
```bash
echo "alias docker=podman" >> ~/.bashrc
source ~/.bashrc
```

### Conexão Python via .env
```python
from dotenv import load_dotenv
import os

load_dotenv("~/data-engineer/databases/.env")

POSTGRES_URL = os.getenv("POSTGRES_URL")
KAFKA_SERVERS = os.getenv("KAFKA_BOOTSTRAP_SERVERS")
```

---

## 7. Troubleshooting

| # | Erro | Causa | Solução |
|---|---|---|---|
| 1 | `failed-wheel-build-for-install` no pyspark | pip tenta compilar wheel sem ambiente de build | Script já usa `--prefer-binary`. Se persistir: `export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 && pip install --prefer-binary pyspark==3.5.1` |
| 2 | `pyenv: command not found` após instalação | PATH não recarregado | Execute `source ~/.bashrc` e tente novamente |
| 3 | Podman: `cannot connect to Podman socket` | Socket não iniciado | `systemctl --user start podman.socket` ou em WSL2: `podman system service --time=0 &` |
| 4 | Insomnia: erro no repositório APT | Repositório Kong (`download.konghq.com`) foi **descontinuado** | O script agora baixa o `.deb` direto do GitHub Releases. Instalação manual: `wget https://github.com/Kong/insomnia/releases/download/core%4012.6.0/Insomnia.Core-12.6.0.deb && sudo apt install ./Insomnia.Core-12.6.0.deb` |
| 5 | Airflow: `ModuleNotFoundError` | Dependências instaladas em pyenv mas airflow roda no sistema Python | Garanta `pyenv global 3.11.9` ativo: `python --version` deve retornar `3.11.9` |
| 8 | `ImportError: cannot import name 'Sentinel' from 'typing_extensions'` ao executar `airflow db migrate` | O constraint do Airflow 2.9.1 faz downgrade de `typing_extensions` para versão < 4.12.0, quebrando `pydantic-core` | Execute: `pip install --upgrade "typing_extensions>=4.12.0" pydantic-core pydantic` e repita `airflow db migrate` |
| 6 | `reboot-required` durante update | Kernel atualizado | Reinicie: `sudo reboot` e reexecute o script |
| 7 | `JAVA_HOME` não encontrado pelo Spark | Java não instalado ou caminho errado | `sudo apt-get install -y openjdk-11-jdk && export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64` |
