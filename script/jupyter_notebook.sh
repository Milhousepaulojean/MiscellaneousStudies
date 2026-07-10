#!/usr/bin/env python3
# ============================================================
# Script Universal de Instalação do Jupyter Notebook
# Compatível com: Windows (CMD/PowerShell) | Linux | macOS
# Shells: bash, zsh, CMD, PowerShell
# Modo: Guiado para iniciantes
# Inclui: pandas, numpy, matplotlib, seaborn, scikit-learn, pyspark
# Todos os pacotes instalados DENTRO do ambiente virtual
# Arquivos de teste criados na pasta ./notebooks ao lado do script
# Autor: Paulo
# Data: 10/07/2026
# ============================================================

import os
import sys
import json
import csv
import platform
import subprocess
import shutil
import time
import textwrap
from pathlib import Path
from datetime import datetime

# ------------------------------------------------------------
# CORES
# ------------------------------------------------------------
class Color:
    GREEN  = '\033[0;32m'
    YELLOW = '\033[1;33m'
    RED    = '\033[0;31m'
    CYAN   = '\033[0;36m'
    BOLD   = '\033[1m'
    RESET  = '\033[0m'

if platform.system() == "Windows":
    os.system("color")

def ok(msg):    print(f"{Color.GREEN}[OK]{Color.RESET} {msg}")
def skip(msg):  print(f"{Color.YELLOW}[PULANDO]{Color.RESET} {msg} — já existe.")
def info(msg):  print(f"{Color.CYAN}[INFO]{Color.RESET} {msg}")
def erro(msg):  print(f"{Color.RED}[ERRO]{Color.RESET} {msg}")
def dica(msg):  print(f"{Color.BOLD}💡 {msg}{Color.RESET}")
def passo(msg): print(f"\n{Color.BOLD}{Color.CYAN}{msg}{Color.RESET}")
def aviso(msg): print(f"{Color.YELLOW}[AVISO]{Color.RESET} {msg}")
def aguardar(): time.sleep(1)

def separador(char="=", tamanho=56):
    print(char * tamanho)

def pausar(msg="  Pressione ENTER para continuar..."):
    input(f"\n{Color.YELLOW}{msg}{Color.RESET}")

def strip_docstring(texto: str) -> str:
    return textwrap.dedent(texto).strip("\n") + "\n"

# ============================================================
# DETECÇÃO DE AMBIENTE
# ============================================================
OS   = platform.system()
HOME = Path.home()
SCRIPT_DIR = Path(__file__).resolve().parent if "__file__" in globals() else Path.cwd().resolve()

# Pasta local de arquivos de teste, ao lado do script
NOTEBOOKS_DIR = SCRIPT_DIR / "notebooks"

# Ambiente virtual permanece no HOME, para manter isolamento dos pacotes
VENV = HOME / "jupyter-env"

pip_exec     = VENV / ("Scripts/pip"     if OS == "Windows" else "bin/pip")
python_exec  = VENV / ("Scripts/python"  if OS == "Windows" else "bin/python")
jupyter_exec = VENV / ("Scripts/jupyter" if OS == "Windows" else "bin/jupyter")

def detectar_shell():
    if OS == "Windows":
        return "powershell" if os.environ.get("PSModulePath") else "cmd"
    return Path(os.environ.get("SHELL", "/bin/bash")).name

def detectar_rc_file(shell):
    if OS == "Windows":
        if shell == "powershell":
            try:
                result = subprocess.run(
                    ["powershell", "-NoProfile", "-Command", "echo $PROFILE"],
                    capture_output=True, text=True
                )
                profile = result.stdout.strip()
                return Path(profile) if profile else (HOME / "Documents" / "PowerShell" / "Microsoft.PowerShell_profile.ps1")
            except Exception:
                return HOME / "Documents" / "PowerShell" / "Microsoft.PowerShell_profile.ps1"
        return HOME / "jupyter-start.bat"
    if shell == "zsh":  return HOME / ".zshrc"
    if shell == "bash": return HOME / ".bashrc"
    return HOME / ".profile"

SHELL   = detectar_shell()
RC_FILE = detectar_rc_file(SHELL)

def run(cmd, shell=True, check=True, capture=False):
    return subprocess.run(
        cmd,
        shell=shell,
        check=check,
        capture_output=capture,
        text=True
    )

def run_silencioso(cmd):
    try:
        subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        return True
    except subprocess.CalledProcessError:
        return False

def pip_install(pacote, nome_exibicao=None):
    nome = nome_exibicao or pacote
    if not pip_exec.exists():
        erro(f"pip do ambiente virtual não encontrado em: {pip_exec}")
        sys.exit(1)

    check = subprocess.run(
        f'"{pip_exec}" show {pacote.split("[")[0]}',
        shell=True, capture_output=True, text=True
    )
    if check.returncode == 0:
        skip(f"{nome} já instalado no venv.")
        return

    info(f"Instalando {nome} dentro do ambiente virtual...")
    result = subprocess.run(f'"{pip_exec}" install {pacote}', shell=True)
    if result.returncode == 0:
        ok(f"{nome} instalado com sucesso.")
    else:
        erro(f"Falha ao instalar {nome}.")

def pip_checar_versao(pacote, import_name=None):
    import_name = import_name or pacote
    if not python_exec.exists():
        return False

    result = subprocess.run(
        f'"{python_exec}" -c "import {import_name}; print({import_name}.__version__)"',
        shell=True,
        capture_output=True,
        text=True
    )
    if result.returncode == 0:
        ok(f"{pacote}: {result.stdout.strip()}")
        return True
    else:
        erro(f"{pacote}: não encontrado dentro do venv")
        return False

# ============================================================
# LIMPEZA E BACKUP
# ============================================================
def remover_bloco_por_marcadores(texto, inicio, fim):
    linhas = texto.splitlines()
    saida  = []
    dentro = False
    for linha in linhas:
        if inicio in linha:
            dentro = True
            continue
        if fim in linha:
            dentro = False
            continue
        if not dentro:
            saida.append(linha)
    return "\n".join(saida).rstrip() + "\n"

def fazer_backup():
    backup_dir = HOME / f".jupyter-backup-{datetime.now():%Y%m%d-%H%M%S}"
    backup_dir.mkdir(parents=True, exist_ok=True)

    if RC_FILE.exists():
        try:
            shutil.copy2(RC_FILE, backup_dir / RC_FILE.name)
        except Exception:
            pass

    startup_file = HOME / ".ipython" / "profile_default" / "startup" / "00_pyspark_env.py"
    if startup_file.exists():
        try:
            (backup_dir / "ipython_startup").mkdir(parents=True, exist_ok=True)
            shutil.copy2(startup_file, backup_dir / "ipython_startup" / startup_file.name)
        except Exception:
            pass

    if NOTEBOOKS_DIR.exists():
        try:
            shutil.copytree(NOTEBOOKS_DIR, backup_dir / "notebooks", dirs_exist_ok=True)
        except Exception:
            pass

    ok(f"Backup salvo em: {backup_dir}")
    return backup_dir

def limpar_instalacao_anterior():
    fazer_backup()

    # Remove ambiente virtual
    if VENV.exists():
        info("Removendo ambiente virtual antigo...")
        shutil.rmtree(VENV, ignore_errors=True)
        ok("Ambiente virtual removido.")
    else:
        skip("Nenhum ambiente virtual encontrado.")

    # Remove pasta local de testes
    if NOTEBOOKS_DIR.exists():
        info("Removendo pasta de testes notebooks/...")
        shutil.rmtree(NOTEBOOKS_DIR, ignore_errors=True)
        ok("Pasta notebooks/ removida.")
    else:
        skip("Pasta notebooks/ não existe.")

    # Remove arquivo de startup
    startup_file = HOME / ".ipython" / "profile_default" / "startup" / "00_pyspark_env.py"
    if startup_file.exists():
        startup_file.unlink()
        ok("Arquivo de startup removido.")

    # Remove blocos do RC file
    if RC_FILE.exists() and RC_FILE.suffix != ".bat":
        texto = RC_FILE.read_text(encoding="utf-8", errors="ignore")
        texto = remover_bloco_por_marcadores(
            texto,
            "# >>> INNERAI_JUPYTER_START",
            "# <<< INNERAI_JUPYTER_END"
        )
        texto = remover_bloco_por_marcadores(
            texto,
            "# >>> INNERAI_JAVA_START",
            "# <<< INNERAI_JAVA_END"
        )
        RC_FILE.write_text(texto, encoding="utf-8")
        ok(f"Configurações antigas removidas de {RC_FILE.name}")
    elif RC_FILE.exists() and RC_FILE.suffix == ".bat":
        RC_FILE.unlink()
        ok("Atalho CMD removido.")

    dica("Ambiente limpo. Reinstalando tudo do zero...")
    time.sleep(1)

# ============================================================
# DETECÇÃO DE INSTALAÇÃO EXISTENTE
# ============================================================
def verificar_instalacao_existente():
    r = {}
    r["venv"]    = VENV.exists() and pip_exec.exists()
    r["jupyter"] = jupyter_exec.exists()

    if r["venv"] and python_exec.exists():
        pacotes = [
            ("pandas", "pandas"),
            ("numpy", "numpy"),
            ("matplotlib", "matplotlib"),
            ("seaborn", "seaborn"),
            ("scikit-learn", "sklearn"),
            ("pyspark", "pyspark"),
        ]
        for nome, imp in pacotes:
            result = subprocess.run(
                f'"{python_exec}" -c "import {imp}"',
                shell=True,
                capture_output=True,
                text=True
            )
            r[imp if nome != "scikit-learn" else "sklearn"] = (result.returncode == 0)
    else:
        for chave in ["pandas", "numpy", "matplotlib", "seaborn", "sklearn", "pyspark"]:
            r[chave] = False

    startup = HOME / ".ipython" / "profile_default" / "startup" / "00_pyspark_env.py"
    r["startup"]   = startup.exists()
    r["notebooks"] = NOTEBOOKS_DIR.exists()

    return r

# ============================================================
# BOAS-VINDAS E ESCOLHA DO MODO
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador()
print(f"{Color.BOLD}  Bem-vindo ao Instalador do Jupyter Notebook!{Color.RESET}")
separador()
print(f"""
  Sistema  : {Color.GREEN}{OS}{Color.RESET}
  Terminal : {Color.GREEN}{SHELL}{Color.RESET}
  Script   : {Color.GREEN}{SCRIPT_DIR}{Color.RESET}
  Venv     : {Color.GREEN}{VENV}{Color.RESET}
""")

instalacao  = verificar_instalacao_existente()
tem_venv    = instalacao["venv"]
tem_jupyter = instalacao["jupyter"]
MODO        = None

if tem_venv or tem_jupyter:
    separador("-")
    print(f"\n{Color.YELLOW}{Color.BOLD}  Uma instalação anterior foi detectada!{Color.RESET}\n")

    status = [
        ("Ambiente virtual (venv)", instalacao["venv"]),
        ("Jupyter",                 instalacao["jupyter"]),
        ("pandas",                  instalacao["pandas"]),
        ("numpy",                   instalacao["numpy"]),
        ("matplotlib",              instalacao["matplotlib"]),
        ("seaborn",                 instalacao["seaborn"]),
        ("scikit-learn",            instalacao["sklearn"]),
        ("pyspark",                 instalacao["pyspark"]),
        ("Startup PySpark",         instalacao["startup"]),
        ("Pasta notebooks",         instalacao["notebooks"]),
    ]

    for nome, existe in status:
        icone = f"{Color.GREEN}✅{Color.RESET}" if existe else f"{Color.RED}❌{Color.RESET}"
        print(f"    {icone}  {nome}")

    print(f"""
  Escolha como quer continuar:

  {Color.GREEN}1{Color.RESET} — Instalação limpa
      Apaga o ambiente virtual, a pasta notebooks/ e recria tudo do zero

  {Color.YELLOW}2{Color.RESET} — Usar o que já existe
      Mantém a instalação atual e só instala o que faltar

      {Color.YELLOW}⚠️  Atenção:{Color.RESET} configurações antigas podem causar conflito
      entre versões e gerar erros inesperados no Jupyter.
""")

    while True:
        escolha = input("  Digite 1 ou 2: ").strip()
        if escolha in ("1", "2"):
            MODO = "limpo" if escolha == "1" else "existente"
            break
        print("  Opção inválida. Digite 1 ou 2.")

    if MODO == "limpo":
        print(f"\n  {Color.RED}{Color.BOLD}ATENÇÃO:{Color.RESET} Isso vai apagar o ambiente virtual,")
        print("  a pasta notebooks/ e as configurações criadas por este script.\n")
        confirmar = input("  Digite LIMPAR para confirmar: ").strip().upper()
        if confirmar != "LIMPAR":
            print("\n  Operação cancelada.")
            sys.exit(0)
        limpar_instalacao_anterior()
    else:
        aviso("Continuando com a instalação existente.")
        aviso("Caso haja conflito, rode novamente e escolha a opção 1.")
        time.sleep(2)
else:
    MODO = "limpo"
    info("Nenhuma instalação anterior encontrada. Iniciando instalação limpa.")
    time.sleep(1)

pausar("  Pressione ENTER para começar a instalação...")

# ============================================================
# ETAPA 1: Verificar Python
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 1 de 11 — Verificando o Python")
separador("-")
aguardar()

version = sys.version_info
if version.major < 3 or (version.major == 3 and version.minor < 8):
    erro(f"Python 3.8+ necessário. Encontrado: {sys.version}")
    dica("Baixe em: https://www.python.org/downloads/")
    sys.exit(1)

ok(f"Python {version.major}.{version.minor}.{version.micro} encontrado!")
pausar()

# ============================================================
# ETAPA 2: Dependências do sistema
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 2 de 11 — Instalando ferramentas do sistema")
separador("-")
pausar()

if OS == "Linux":
    info("Atualizando repositórios...")
    run("sudo apt update -y && sudo apt upgrade -y")
    DEPS = ["python3-pip", "python3-venv", "curl", "git"]
    missing = []
    for dep in DEPS:
        result = subprocess.run(f"dpkg -s {dep}", shell=True, capture_output=True, text=True)
        if result.returncode == 0:
            skip(dep)
        else:
            missing.append(dep)
    if missing:
        run(f"sudo apt install -y {' '.join(missing)}")
    ok("Ferramentas do sistema prontas.")

elif OS == "Darwin":
    if not shutil.which("brew"):
        info("Instalando Homebrew...")
        run('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
    else:
        skip("Homebrew")
    run("brew install python git curl 2>/dev/null || true")
    ok("Ferramentas do macOS verificadas.")

elif OS == "Windows":
    if not shutil.which("python") and not shutil.which("python3"):
        erro("Python não encontrado no PATH.")
        dica("Instale em https://www.python.org/downloads/")
        dica("Marque 'Add Python to PATH' durante a instalação.")
        sys.exit(1)
    ok("Python disponível no Windows.")

pausar()

# ============================================================
# ETAPA 3: Java
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 3 de 11 — Instalando e configurando o Java")
separador("-")
print("""
  O PySpark precisa do Java para funcionar.

  Além de instalar, vamos configurar o JAVA_HOME
  para que o Jupyter consiga encontrar o Java
  corretamente ao rodar PySpark no navegador.
""")
aguardar()

def java_instalado():
    return run_silencioso("java -version")

def detectar_java_home():
    if OS == "Linux":
        result = subprocess.run(
            "dirname $(dirname $(readlink -f $(which java)))",
            shell=True, capture_output=True, text=True
        )
        return result.stdout.strip()

    if OS == "Darwin":
        result = subprocess.run(
            ["/usr/libexec/java_home"],
            capture_output=True, text=True
        )
        if result.returncode == 0:
            return result.stdout.strip()
        return ""

    return ""

JAVA_HOME_PATH = ""

if OS == "Linux":
    if java_instalado():
        result = subprocess.run("java -version", shell=True, capture_output=True, text=True)
        linha = result.stderr.strip().splitlines()[0] if result.stderr.strip() else "Java já instalado"
        skip(linha)
    else:
        info("Instalando Java (OpenJDK 17)...")
        run("sudo apt install -y default-jdk")
        ok("Java instalado.")

    JAVA_HOME_PATH = detectar_java_home()

    if JAVA_HOME_PATH:
        RC_FILE.touch(exist_ok=True)
        content = RC_FILE.read_text(encoding="utf-8", errors="ignore")
        if "INNERAI_JAVA_START" not in content:
            with open(RC_FILE, "a", encoding="utf-8") as f:
                f.write(
                    f"\n# >>> INNERAI_JAVA_START\n"
                    f'export JAVA_HOME="{JAVA_HOME_PATH}"\n'
                    f'export PATH="$JAVA_HOME/bin:$PATH"\n'
                    f'export SPARK_LOCAL_IP="127.0.0.1"\n'
                    f"# <<< INNERAI_JAVA_END\n"
                )
            ok(f"JAVA_HOME configurado: {JAVA_HOME_PATH}")
        else:
            skip("JAVA_HOME já configurado no RC file.")

        os.environ["JAVA_HOME"]      = JAVA_HOME_PATH
        os.environ["SPARK_LOCAL_IP"] = "127.0.0.1"
        os.environ["PATH"]           = JAVA_HOME_PATH + "/bin:" + os.environ.get("PATH", "")
        ok("JAVA_HOME aplicado na sessão atual.")
    else:
        aviso("Não foi possível detectar JAVA_HOME automaticamente.")

elif OS == "Darwin":
    if java_instalado():
        skip("Java já instalado.")
    else:
        info("Instalando Java via Homebrew...")
        run("brew install openjdk@17")
        ok("Java instalado.")
    JAVA_HOME_PATH = detectar_java_home()
    if JAVA_HOME_PATH:
        os.environ["JAVA_HOME"]      = JAVA_HOME_PATH
        os.environ["SPARK_LOCAL_IP"] = "127.0.0.1"
        os.environ["PATH"]           = JAVA_HOME_PATH + "/bin:" + os.environ.get("PATH", "")
        ok(f"JAVA_HOME configurado: {JAVA_HOME_PATH}")

elif OS == "Windows":
    if java_instalado():
        skip("Java já instalado.")
    else:
        info("Java não encontrado.")
        dica("Baixe em: https://www.java.com/pt-BR/download/")
        pausar("ENTER para continuar sem Java (PySpark pode não funcionar)...")
    # Em Windows, a configuração pode ser feita externamente no sistema se necessário

pausar()

# ============================================================
# ETAPA 4: Criar ambiente virtual
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 4 de 11 — Criando o ambiente virtual")
separador("-")
print(f"""
  Criando o ambiente virtual isolado em:

    📁 {VENV}

  TODOS os pacotes serão instalados aqui dentro.
  O Jupyter no navegador vai enxergar tudo corretamente.
""")
pausar()

activate_file = VENV / ("Scripts/activate" if OS == "Windows" else "bin/activate")

if activate_file.exists():
    skip(f"Ambiente virtual já existe em {VENV}")
else:
    run(f'"{sys.executable}" -m venv "{VENV}"')
    ok(f"Ambiente virtual criado em {VENV}")

if not pip_exec.exists():
    erro(f"pip não encontrado em {pip_exec}")
    sys.exit(1)

ok("pip do venv confirmado.")
info("Atualizando pip dentro do ambiente virtual...")
run(f'"{pip_exec}" install --upgrade pip')
ok("pip atualizado.")
pausar()

# ============================================================
# ETAPA 5: Instalar Jupyter
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 5 de 11 — Instalando Jupyter")
separador("-")
print("""
  Instalando Jupyter Notebook e JupyterLab
  dentro do ambiente virtual.

  Aguarde... ☕
""")
pausar()

pip_install("jupyter",    "Jupyter")
pip_install("notebook",   "Notebook")
pip_install("jupyterlab", "JupyterLab")
pausar()

# ============================================================
# ETAPA 6: Pacotes de dados
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 6 de 11 — Instalando pacotes de dados")
separador("-")
print("""
  Instalando pacotes essenciais de ciência de dados
  dentro do ambiente virtual:

    🐼 pandas       — tabelas e dados
    🔢 numpy        — cálculos matemáticos
    📊 matplotlib   — gráficos
    🎨 seaborn      — gráficos avançados
    🤖 scikit-learn — machine learning

  Aguarde... ☕
""")
pausar()

pip_install("pandas",       "pandas")
pip_install("numpy",        "numpy")
pip_install("matplotlib",   "matplotlib")
pip_install("seaborn",      "seaborn")
pip_install("scikit-learn", "scikit-learn")
pausar()

# ============================================================
# ETAPA 7: PySpark
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 7 de 11 — Instalando PySpark")
separador("-")
print("""
  Instalando o PySpark dentro do ambiente virtual.
  Ele vai usar o Java configurado na Etapa 3.

  Aguarde... ☕
""")
pausar()

pip_install("pyspark", "PySpark")
pausar()

# ============================================================
# ETAPA 8: Startup do Jupyter
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 8 de 11 — Configurando variáveis no Jupyter")
separador("-")
print("""
  Criando um arquivo de startup para que o Jupyter
  carregue o JAVA_HOME automaticamente toda vez que abrir.

  Isso ajuda a evitar o erro:
    TypeError: 'JavaPackage' object is not callable
""")
aguardar()

if OS != "Windows" and JAVA_HOME_PATH:
    jupyter_startup = HOME / ".ipython" / "profile_default" / "startup"
    jupyter_startup.mkdir(parents=True, exist_ok=True)
    startup_file = jupyter_startup / "00_pyspark_env.py"

    conteudo_startup = strip_docstring(f"""
        # Gerado automaticamente pelo instalador
        import os, subprocess

        try:
            r = subprocess.run(
                "dirname $(dirname $(readlink -f $(which java)))",
                shell=True, capture_output=True, text=True
            )
            jh = r.stdout.strip()
            if jh:
                os.environ["JAVA_HOME"] = jh
                os.environ["SPARK_LOCAL_IP"] = "127.0.0.1"
                os.environ["PATH"] = jh + "/bin:" + os.environ.get("PATH", "")
        except Exception:
            pass
    """)

    if startup_file.exists():
        skip("Arquivo de startup já existe.")
    else:
        startup_file.write_text(conteudo_startup, encoding="utf-8")
        ok(f"Startup criado: {startup_file}")

    dica("O Jupyter vai carregar JAVA_HOME automaticamente em todo notebook.")

pausar()

# ============================================================
# ETAPA 9: Permissões e atalho
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 9 de 11 — Permissões e atalho jupyter-start")
separador("-")
aguardar()

if OS in ("Linux", "Darwin"):
    run(f'chmod -R u+rwX "{VENV}"')
    ok("Permissões ajustadas.")

def configurar_alias_unix():
    alias = f'alias jupyter-start="source \\"{VENV}/bin/activate\\" && jupyter notebook"'
    RC_FILE.touch(exist_ok=True)
    content = RC_FILE.read_text(encoding="utf-8", errors="ignore")
    if "INNERAI_JUPYTER_START" in content:
        skip("Atalho já existe.")
        return
    with open(RC_FILE, "a", encoding="utf-8") as f:
        f.write(
            f"\n# >>> INNERAI_JUPYTER_START\n"
            f"{alias}\n"
            f"# <<< INNERAI_JUPYTER_END\n"
        )
    ok(f"Atalho adicionado em {RC_FILE}")

def configurar_alias_powershell():
    RC_FILE.parent.mkdir(parents=True, exist_ok=True)
    RC_FILE.touch(exist_ok=True)
    content = RC_FILE.read_text(encoding="utf-8", errors="ignore")
    if "INNERAI_JUPYTER_START" in content:
        skip("Atalho já existe.")
        return
    func = strip_docstring(f"""
        # >>> INNERAI_JUPYTER_START
        function jupyter-start {{
            & "{VENV}\\Scripts\\Activate.ps1"
            jupyter notebook
        }}
        # <<< INNERAI_JUPYTER_END
    """)
    with open(RC_FILE, "a", encoding="utf-8") as f:
        f.write(func)
    ok(f"Atalho adicionado em {RC_FILE}")

def configurar_alias_cmd():
    RC_FILE.parent.mkdir(parents=True, exist_ok=True)
    if RC_FILE.exists():
        skip(f"{RC_FILE} já existe.")
        return
    RC_FILE.write_text(
        f'@echo off\ncall "{VENV}\\Scripts\\activate.bat"\njupyter notebook\n',
        encoding="utf-8"
    )
    ok(f"Atalho criado em {RC_FILE}")

if OS == "Windows":
    configurar_alias_powershell() if SHELL == "powershell" else configurar_alias_cmd()
else:
    configurar_alias_unix()

pausar()

# ============================================================
# ETAPA 10: Pasta notebooks + CSVs + Notebook de exemplo
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 10 de 11 — Criando pasta notebooks, CSVs e notebook de exemplo")
separador("-")
print(f"""
  Criando a estrutura de arquivos de exemplo na raiz do script:

    📁 {NOTEBOOKS_DIR}
       ├── herois_marvel.csv
       ├── herois_dc.csv
       └── exemplo_completo.ipynb
""")
aguardar()

if NOTEBOOKS_DIR.exists():
    skip("Pasta notebooks/ já existe.")
else:
    NOTEBOOKS_DIR.mkdir(parents=True, exist_ok=True)
    ok(f"Pasta criada: {NOTEBOOKS_DIR}")

# ------------------------------------------------------------
# CSV Marvel
# ------------------------------------------------------------
marvel_csv = NOTEBOOKS_DIR / "herois_marvel.csv"
marvel_data = [
    ["nome","alter_ego","universo","poder_principal","forca","inteligencia","velocidade","equipe","ativo"],
    ["Homem de Ferro","Tony Stark","Marvel","Armadura tecnológica",85,98,70,"Vingadores",True],
    ["Capitão América","Steve Rogers","Marvel","Super soldado",95,75,65,"Vingadores",True],
    ["Thor","Thor Odinson","Marvel","Controle do trovão",100,80,90,"Vingadores",True],
    ["Hulk","Bruce Banner","Marvel","Força bruta",150,90,60,"Vingadores",True],
    ["Homem-Aranha","Peter Parker","Marvel","Agilidade e teia",70,85,80,"Vingadores",True],
    ["Viúva Negra","Natasha Romanoff","Marvel","Combate e espionagem",60,88,75,"Vingadores",True],
    ["Pantera Negra","T'Challa","Marvel","Vibranium",80,85,78,"Vingadores",True],
    ["Doutor Estranho","Stephen Strange","Marvel","Magia e feitiçaria",65,99,50,"Vingadores",True],
    ["Star-Lord","Peter Quill","Marvel","Combate espacial",68,70,72,"Guardiões",True],
    ["Wolverine","James Howlett","Marvel","Regeneração e garras",88,70,65,"X-Men",True],
    ["Ciclope","Scott Summers","Marvel","Raios ópticos",72,80,68,"X-Men",True],
    ["Tempestade","Ororo Munroe","Marvel","Controle do clima",70,78,85,"X-Men",True],
    ["Jean Grey","Jean Grey","Marvel","Telepatia e telecinese",68,92,70,"X-Men",True],
    ["Demolidor","Matt Murdock","Marvel","Sentidos apurados",72,80,80,"Solo",True],
    ["Luke Cage","Carl Lucas","Marvel","Pele de aço",90,65,55,"Defensores",True],
]

if marvel_csv.exists():
    skip("herois_marvel.csv já existe.")
else:
    with open(marvel_csv, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(marvel_data)
    ok(f"herois_marvel.csv criado com {len(marvel_data)-1} heróis.")

# ------------------------------------------------------------
# CSV DC
# ------------------------------------------------------------
dc_csv = NOTEBOOKS_DIR / "herois_dc.csv"
dc_data = [
    ["nome","alter_ego","universo","poder_principal","forca","inteligencia","velocidade","equipe","ativo"],
    ["Superman","Clark Kent","DC","Superforça e voo",150,90,95,"Liga da Justiça",True],
    ["Batman","Bruce Wayne","DC","Inteligência e gadgets",60,99,70,"Liga da Justiça",True],
    ["Mulher Maravilha","Diana Prince","DC","Combate e força divina",120,88,85,"Liga da Justiça",True],
    ["Flash","Barry Allen","DC","Super velocidade",55,85,200,"Liga da Justiça",True],
    ["Aquaman","Arthur Curry","DC","Controle dos mares",110,80,88,"Liga da Justiça",True],
    ["Lanterna Verde","Hal Jordan","DC","Anel do poder",75,88,95,"Liga da Justiça",True],
    ["Shazam","Billy Batson","DC","Poderes mágicos e força",130,80,90,"Liga da Justiça",True],
    ["Ciborgue","Victor Stone","DC","Interface tecnológica",85,92,75,"Liga da Justiça",True],
    ["Coringa","Desconhecido","DC","Caos e imprevisibilidade",55,88,60,"Vilões",True],
    ["Lex Luthor","Lex Luthor","DC","Inteligência e tecnologia",50,99,55,"Vilões",True],
    ["Caçadora","Helena Bertinelli","DC","Combate e precisão",68,78,72,"Aves de Rapina",True],
    ["Canário Negro","Dinah Lance","DC","Grito sônico",65,80,75,"Aves de Rapina",True],
    ["Arqueiro Verde","Oliver Queen","DC","Precisão com arco",65,78,68,"Liga da Justiça",True],
    ["Martian Manhunter","J'onn J'onzz","DC","Telepatia e forma variável",115,95,88,"Liga da Justiça",True],
    ["Zatanna","Zatanna Zatara","DC","Magia",60,90,70,"Liga da Justiça",True],
]

if dc_csv.exists():
    skip("herois_dc.csv já existe.")
else:
    with open(dc_csv, "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerows(dc_data)
    ok(f"herois_dc.csv criado com {len(dc_data)-1} heróis.")

# ------------------------------------------------------------
# Notebook de exemplo
# ------------------------------------------------------------
notebook_path = NOTEBOOKS_DIR / "exemplo_completo.ipynb"

def md_cell(texto, cell_id):
    return {
        "cell_type": "markdown",
        "id": cell_id,
        "metadata": {},
        "source": strip_docstring(texto).splitlines(keepends=True)
    }

def code_cell(texto, cell_id):
    return {
        "cell_type": "code",
        "execution_count": None,
        "id": cell_id,
        "metadata": {},
        "outputs": [],
        "source": strip_docstring(texto).splitlines(keepends=True)
    }

notebook_content = {
    "nbformat": 4,
    "nbformat_minor": 5,
    "metadata": {
        "kernelspec": {
            "display_name": "Python 3",
            "language": "python",
            "name": "python3"
        },
        "language_info": {
            "name": "python",
            "version": f"{version.major}.{version.minor}.{version.micro}"
        }
    },
    "cells": [
        md_cell("""
            # 🦸 Jupyter Notebook — Heróis Marvel & DC

            Notebook gerado automaticamente pelo instalador.
            Use os heróis da Marvel e DC para aprender pandas, gráficos, CRUD e PySpark.

            ---
        """, "capa"),

        md_cell("""
            ## 📦 Imports
        """, "md_imports"),

        code_cell("""
            import os
            import pandas as pd
            import numpy as np
            import matplotlib.pyplot as plt
            import seaborn as sns
            import warnings
            from pathlib import Path

            warnings.filterwarnings('ignore')
            %matplotlib inline
            plt.rcParams['figure.figsize'] = (10, 5)
            sns.set_theme(style='whitegrid')

            print('✅ Imports OK')
            print('pandas     :', pd.__version__)
            print('numpy      :', np.__version__)
            print('seaborn    :', sns.__version__)
        """, "cell_imports"),

        md_cell("""
            ---
            ## 📄 Leitura dos CSVs

            Vamos carregar os arquivos da pasta `notebooks/`.
        """, "md_leitura"),

        code_cell("""
            from pathlib import Path

            def resolver_base_dados():
                candidatos = [
                    Path.cwd() / 'notebooks',
                    Path.cwd(),
                ]
                for base in candidatos:
                    if (base / 'herois_marvel.csv').exists() and (base / 'herois_dc.csv').exists():
                        return base
                return Path.cwd()

            base = resolver_base_dados()
            print('Base de dados:', base)

            df_marvel = pd.read_csv(base / 'herois_marvel.csv')
            df_dc     = pd.read_csv(base / 'herois_dc.csv')
            df        = pd.concat([df_marvel, df_dc], ignore_index=True)

            print(f'✅ Total: {len(df)} heróis carregados')
            print(f'   Marvel: {len(df_marvel)} | DC: {len(df_dc)}')
            df.head(10)
        """, "cell_leitura"),

        md_cell("""
            ---
            ## 🔍 Exploração
        """, "md_exploracao"),

        code_cell("""
            print(f'Shape   : {df.shape}')
            print(f'Colunas : {list(df.columns)}')
            print()
            df[['forca', 'inteligencia', 'velocidade']].describe().round(1)
        """, "cell_info"),

        md_cell("""
            ---
            ## 🔎 READ — Filtros e consultas
        """, "md_read"),

        code_cell("""
            # Heróis Marvel
            marvel = df[df['universo'] == 'Marvel']
            print(f'Marvel: {len(marvel)} heróis')
            marvel[['nome', 'alter_ego', 'poder_principal']].head(8)
        """, "cell_read_1"),

        code_cell("""
            # Heróis com força > 90
            super_fortes = df[df['forca'] > 90].sort_values('forca', ascending=False)
            print(f'Heróis com força > 90: {len(super_fortes)}')
            super_fortes[['nome', 'universo', 'forca', 'poder_principal']]
        """, "cell_read_2"),

        code_cell("""
            # Mais inteligente por universo
            mais_intel = df.loc[df.groupby('universo')['inteligencia'].idxmax()]
            print('🧠 Mais inteligente por universo:')
            mais_intel[['universo', 'nome', 'inteligencia', 'poder_principal']]
        """, "cell_read_3"),

        md_cell("""
            ---
            ## ➕ CREATE — Adicionando novos heróis
        """, "md_create"),

        code_cell("""
            novos = pd.DataFrame([
                {
                    'nome': 'Deadpool',
                    'alter_ego': 'Wade Wilson',
                    'universo': 'Marvel',
                    'poder_principal': 'Regeneração e humor',
                    'forca': 75,
                    'inteligencia': 72,
                    'velocidade': 70,
                    'equipe': 'Solo',
                    'ativo': True
                },
                {
                    'nome': 'Supergirl',
                    'alter_ego': 'Kara Zor-El',
                    'universo': 'DC',
                    'poder_principal': 'Superforça e voo',
                    'forca': 140,
                    'inteligencia': 88,
                    'velocidade': 92,
                    'equipe': 'Liga da Justiça',
                    'ativo': True
                },
                {
                    'nome': 'Capitã Marvel',
                    'alter_ego': 'Carol Danvers',
                    'universo': 'Marvel',
                    'poder_principal': 'Absorção de energia',
                    'forca': 130,
                    'inteligencia': 85,
                    'velocidade': 95,
                    'equipe': 'Vingadores',
                    'ativo': True
                }
            ])

            df = pd.concat([df, novos], ignore_index=True)
            print(f'✅ {len(novos)} heróis adicionados! Total: {len(df)}')
            df.tail(4)
        """, "cell_create"),

        md_cell("""
            ---
            ## ✏️ UPDATE — Atualizando dados
        """, "md_update"),

        code_cell("""
            print('Antes:')
            print(df[df['nome'] == 'Hulk'][['nome', 'forca', 'inteligencia']])

            df.loc[df['nome'] == 'Hulk', 'forca'] = 180
            df.loc[df['nome'] == 'Hulk', 'inteligencia'] = 95

            print()
            print('Depois:')
            print(df[df['nome'] == 'Hulk'][['nome', 'forca', 'inteligencia']])
        """, "cell_update_1"),

        code_cell("""
            # Coluna calculada: poder_geral
            df['poder_geral'] = ((df['forca'] + df['inteligencia'] + df['velocidade']) / 3).round(1)
            print('✅ Coluna poder_geral criada!')
            df[['nome', 'universo', 'forca', 'inteligencia', 'velocidade', 'poder_geral']] \\
                .sort_values('poder_geral', ascending=False).head(10)
        """, "cell_update_2"),

        md_cell("""
            ---
            ## ❌ DELETE — Removendo registros
        """, "md_delete"),

        code_cell("""
            print(f'Total antes: {len(df)}')
            df = df[df['equipe'] != 'Vilões'].reset_index(drop=True)
            print(f'Total depois: {len(df)}')
            print('✅ Vilões removidos!')
        """, "cell_delete_1"),

        code_cell("""
            df = df.drop(columns=['ativo'])
            print('Colunas:', list(df.columns))
        """, "cell_delete_2"),

        md_cell("""
            ---
            ## 💾 Salvando o resultado final
        """, "md_salvar"),

        code_cell("""
            output = base / 'herois_final.csv'
            df.to_csv(output, index=False)
            df_check = pd.read_csv(output)
            print(f'✅ Salvo em: {output}')
            print(f'   Total: {len(df_check)} heróis')
        """, "cell_salvar"),

        md_cell("""
            ---
            ## 📊 Visualizações — Marvel vs DC
        """, "md_graficos"),

        code_cell("""
            medias = df.groupby('universo')[['forca', 'inteligencia', 'velocidade', 'poder_geral']].mean().round(1)
            medias.T.plot(kind='bar', colormap='Set2', rot=0)
            plt.title('Média de Atributos — Marvel vs DC')
            plt.xlabel('Atributo')
            plt.ylabel('Valor médio')
            plt.legend(title='Universo')
            plt.tight_layout()
            plt.show()
            print(medias)
        """, "cell_grafico_1"),

        code_cell("""
            top10 = df.nlargest(10, 'poder_geral')
            cores = ['#E23636' if u == 'Marvel' else '#0476D0' for u in top10['universo']]

            plt.figure(figsize=(12, 5))
            plt.barh(top10['nome'], top10['poder_geral'], color=cores)
            plt.xlabel('Poder Geral')
            plt.title('🏆 Top 10 Heróis por Poder Geral')
            plt.gca().invert_yaxis()

            from matplotlib.patches import Patch
            plt.legend(handles=[
                Patch(color='#E23636', label='Marvel'),
                Patch(color='#0476D0', label='DC')
            ])
            plt.tight_layout()
            plt.show()
        """, "cell_grafico_2"),

        code_cell("""
            plt.figure(figsize=(10, 6))
            for universo, grupo in df.groupby('universo'):
                cor = '#E23636' if universo == 'Marvel' else '#0476D0'
                plt.scatter(grupo['forca'], grupo['inteligencia'],
                            label=universo, color=cor, s=100, alpha=0.8)
                for _, row in grupo.iterrows():
                    plt.annotate(row['nome'], (row['forca'], row['inteligencia']),
                                 textcoords='offset points', xytext=(5, 4), fontsize=7)

            plt.xlabel('Força')
            plt.ylabel('Inteligência')
            plt.title('Força x Inteligência — Marvel vs DC')
            plt.legend()
            plt.tight_layout()
            plt.show()
        """, "cell_grafico_3"),

        code_cell("""
            equipes = df['equipe'].value_counts()
            plt.figure(figsize=(10, 4))
            sns.barplot(x=equipes.values, y=equipes.index, palette='viridis')
            plt.xlabel('Número de heróis')
            plt.title('Heróis por Equipe')
            plt.tight_layout()
            plt.show()
        """, "cell_grafico_4"),

        md_cell("""
            ---
            ## ⚡ PySpark — Heróis com Big Data
        """, "md_pyspark"),

        code_cell("""
            import os, subprocess

            try:
                r = subprocess.run(
                    'dirname $(dirname $(readlink -f $(which java)))',
                    shell=True, capture_output=True, text=True
                )
                jh = r.stdout.strip()
                if jh:
                    os.environ['JAVA_HOME']      = jh
                    os.environ['SPARK_LOCAL_IP'] = '127.0.0.1'
                    os.environ['PATH']           = jh + '/bin:' + os.environ.get('PATH', '')
                    print('JAVA_HOME:', jh)
            except Exception as e:
                print('Aviso:', e)

            import pyspark
            from pyspark.sql import SparkSession
            from pyspark.sql.functions import col, avg, round as spark_round

            spark = SparkSession.builder \\
                .appName('herois_marvel_dc') \\
                .master('local[*]') \\
                .config('spark.driver.host', '127.0.0.1') \\
                .getOrCreate()

            spark.sparkContext.setLogLevel('ERROR')
            print('✅ Spark iniciado! Versão:', spark.version)
        """, "cell_pyspark_1"),

        code_cell("""
            csv_final = str(base / 'herois_final.csv')

            df_spark = spark.read \\
                .option('header', 'true') \\
                .option('inferSchema', 'true') \\
                .csv(csv_final)

            print(f'Total: {df_spark.count()} heróis')
            df_spark.show(5)
        """, "cell_pyspark_2"),

        code_cell("""
            print('📊 Médias por universo:')
            df_spark.groupBy('universo').agg(
                spark_round(avg(col('forca')), 1).alias('media_forca'),
                spark_round(avg(col('inteligencia')), 1).alias('media_intel'),
                spark_round(avg(col('velocidade')), 1).alias('media_vel'),
                spark_round(avg(col('poder_geral')), 1).alias('media_poder')
            ).show()
        """, "cell_pyspark_3"),

        code_cell("""
            df_spark.createOrReplaceTempView('herois')
            print('🏆 Top 5 por poder geral (Spark SQL):')
            spark.sql(\"\"\"
                SELECT nome, universo, equipe, poder_geral
                FROM herois
                ORDER BY poder_geral DESC
                LIMIT 5
            \"\"\").show()
        """, "cell_pyspark_4"),

        md_cell("""
            ---
            ## 🤖 scikit-learn — Prevendo o poder de um herói
        """, "md_sklearn"),

        code_cell("""
            import sklearn
            from sklearn.linear_model import LinearRegression
            from sklearn.model_selection import train_test_split
            from sklearn.metrics import mean_absolute_error, r2_score

            X = df[['forca', 'inteligencia', 'velocidade']].values
            y = df['poder_geral'].values

            X_train, X_test, y_train, y_test = train_test_split(
                X, y, test_size=0.3, random_state=42
            )

            modelo = LinearRegression()
            modelo.fit(X_train, y_train)
            y_pred = modelo.predict(X_test)

            print('scikit-learn versão:', sklearn.__version__)
            print(f'MAE : {mean_absolute_error(y_test, y_pred):.2f}')
            print(f'R²  : {r2_score(y_test, y_pred):.4f}')

            novo = [[100, 95, 90]]
            print(f'\\n🦸 Previsão para forca=100, intel=95, vel=90: {modelo.predict(novo)[0]:.1f}')
        """, "cell_sklearn"),

        md_cell("""
            ---
            ## ✅ Tudo funcionando!

            | Tópico | O que foi feito |
            |---|---|
            | **Leitura CSV** | `pd.read_csv()` com Marvel e DC |
            | **Exploração** | `.shape`, `.dtypes`, `.describe()` |
            | **READ** | Filtros, `.groupby()`, `.sort_values()` |
            | **CREATE** | `pd.concat()` com novos heróis |
            | **UPDATE** | `.loc[]` para atualizar e criar colunas |
            | **DELETE** | Remoção de linhas e colunas |
            | **Exportar CSV** | `.to_csv()` |
            | **Gráficos** | Barras, dispersão e distribuição |
            | **PySpark** | Leitura, agregação e Spark SQL |
            | **scikit-learn** | Regressão linear |

            **Próximos passos:** importe seus próprios dados e explore! 🚀
        """, "md_final"),
    ]
}

if notebook_path.exists():
    skip(f"Notebook já existe: {notebook_path.name}")
else:
    with open(notebook_path, "w", encoding="utf-8") as f:
        json.dump(notebook_content, f, indent=2, ensure_ascii=False)
    ok(f"Notebook criado: {notebook_path}")

dica(f"Arquivos salvos em: {NOTEBOOKS_DIR}")
pausar()

# ============================================================
# ETAPA 11: Validação final
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador("-")
passo("ETAPA 11 de 11 — Validação final")
separador("-")
print("""
  Verificando se tudo foi instalado e criado corretamente
  dentro do ambiente virtual e na pasta local notebooks/.
""")
aguardar()

erros_encontrados = []

# Jupyter
result = subprocess.run(
    f'"{jupyter_exec}" --version',
    shell=True, capture_output=True, text=True
)
if result.returncode == 0:
    primeira_linha = result.stdout.strip().splitlines()[0] if result.stdout.strip() else "ok"
    ok(f"jupyter: {primeira_linha}")
else:
    erro("jupyter: falha na validação")
    erros_encontrados.append("jupyter")

# Pacotes
pacotes_validar = [
    ("pandas",       "pandas"),
    ("numpy",        "numpy"),
    ("matplotlib",   "matplotlib"),
    ("seaborn",      "seaborn"),
    ("scikit-learn", "sklearn"),
    ("pyspark",      "pyspark"),
]

for nome, import_name in pacotes_validar:
    if not pip_checar_versao(nome, import_name):
        erros_encontrados.append(nome)

# Java
if OS != "Windows":
    if run_silencioso("java -version"):
        result = subprocess.run("java -version", shell=True, capture_output=True, text=True)
        linha = result.stderr.strip().splitlines()[0] if result.stderr.strip() else "java ok"
        ok(f"java: {linha}")
    else:
        erro("java: não encontrado")
        erros_encontrados.append("java")

# Startup
startup_file = HOME / ".ipython" / "profile_default" / "startup" / "00_pyspark_env.py"
if OS != "Windows":
    if startup_file.exists():
        ok("startup pyspark: configurado")
    else:
        aviso("startup pyspark: não encontrado")
        erros_encontrados.append("startup-pyspark")

# Pasta notebooks
if NOTEBOOKS_DIR.exists():
    ok(f"pasta notebooks: {NOTEBOOKS_DIR}")
else:
    erro("pasta notebooks: não encontrada")
    erros_encontrados.append("pasta-notebooks")

# Arquivos de exemplo
arquivos_verificar = [
    (NOTEBOOKS_DIR / "herois_marvel.csv", "CSV Marvel"),
    (NOTEBOOKS_DIR / "herois_dc.csv", "CSV DC"),
    (NOTEBOOKS_DIR / "exemplo_completo.ipynb", "Notebook exemplo"),
]

for caminho, label in arquivos_verificar:
    if caminho.exists():
        ok(f"{label}: {caminho.name}")
    else:
        erro(f"{label}: não encontrado")
        erros_encontrados.append(label)

pausar()

# ============================================================
# RESUMO FINAL
# ============================================================
os.system("cls" if OS == "Windows" else "clear")
separador()

if erros_encontrados:
    print(f"{Color.YELLOW}{Color.BOLD}  ⚠️  Instalação concluída com avisos!{Color.RESET}")
    separador()
    print(f"\n  Itens com problema: {', '.join(erros_encontrados)}")
    print()
    dica("Se precisar reinstalar algo manualmente, use o pip do venv:")
    print(f'    "{pip_exec}" install NOME_DO_PACOTE')
else:
    print(f"{Color.GREEN}{Color.BOLD}  🎉 Tudo pronto! Instalação 100% concluída!{Color.RESET}")

separador()
print(f"""
  Tudo instalado DENTRO do ambiente virtual:

    ✅ Jupyter Notebook + JupyterLab
    ✅ pandas          (tabelas e dados)
    ✅ numpy           (cálculos matemáticos)
    ✅ matplotlib      (gráficos)
    ✅ seaborn         (gráficos avançados)
    ✅ scikit-learn    (machine learning)
    ✅ pyspark         (big data)
    ✅ Java            (motor do PySpark)
    ✅ JAVA_HOME       (automático no Jupyter)
    ✅ SPARK_LOCAL_IP  (127.0.0.1)
    ✅ Atalho          jupyter-start
    ✅ Pasta           notebooks/
    ✅ CSV Marvel      notebooks/herois_marvel.csv
    ✅ CSV DC          notebooks/herois_dc.csv
    ✅ Notebook        notebooks/exemplo_completo.ipynb

  Modo usado : {Color.GREEN}{'Instalação limpa' if MODO == 'limpo' else 'Reutilizou existente'}{Color.RESET}
  Script     : {SCRIPT_DIR}
  Ambiente   : {VENV}
  Sistema    : {OS} | Terminal: {SHELL}
""")

separador("-")
print(f"{Color.BOLD}  Como usar:{Color.RESET}")
separador("-")
print("""
  OPÇÃO 1 — Atalho (reabra o terminal primeiro):
    jupyter-start

  OPÇÃO 2 — Direto (funciona agora mesmo):
""")

if OS == "Windows":
    print(f'    CMD        : "{VENV}\\Scripts\\activate" && jupyter notebook')
    print(f'    PowerShell : & "{VENV}\\Scripts\\Activate.ps1"; jupyter notebook')
else:
    print(f'    {Color.CYAN}source "{VENV}/bin/activate" && jupyter notebook{Color.RESET}')

print(f"""
  Depois abra o notebook de exemplo:
    📓 {Color.CYAN}{NOTEBOOKS_DIR / 'exemplo_completo.ipynb'}{Color.RESET}

  Acesse no navegador:
    🌐 {Color.CYAN}http://localhost:8888{Color.RESET}
""")

separador("-")
dica("Rode cada célula do notebook para confirmar que tudo funciona.")
separador()
print()