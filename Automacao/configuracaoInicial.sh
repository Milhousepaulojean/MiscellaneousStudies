#!/usr/bin/env bash
set -euo pipefail

echo "🔍 Detectando sistema operacional..."
OS="$(uname -s)"

install_awscli() {
  case "$OS" in
    Darwin*)
      echo "🍎 macOS detectado"
      if ! command -v aws &>/dev/null; then
        if ! command -v brew &>/dev/null; then
          echo "❌ Homebrew não encontrado. Instale em https://brew.sh/"
          exit 1
        fi
        brew install awscli
      fi
      ;;
    Linux*)
      echo "🐧 Linux detectado"
      if ! command -v aws &>/dev/null; then
        curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
        unzip -q awscliv2.zip
        sudo ./aws/install
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      echo "🪟 Windows detectado"
      echo "➡️ Instale o AWS CLI pelo instalador oficial:"
      echo "https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
      exit 0
      ;;
    *)
      echo "❌ Sistema operacional não suportado automaticamente"
      exit 1
      ;;
  esac
}

install_awscli

echo "✅ AWS CLI instalado"
echo "➡️ Iniciando configuração"

read -p "Profile [default]: " PROFILE
PROFILE=${PROFILE:-default}

read -p "Region [us-east-1]: " REGION
REGION=${REGION:-us-east-1}

read -p "Output [json]: " OUTPUT
OUTPUT=${OUTPUT:-json}

read -p "AWS Access Key ID: " AKID
read -s -p "AWS Secret Access Key: " SAK
echo

aws configure set aws_access_key_id "$AKID" --profile "$PROFILE"
aws configure set aws_secret_access_key "$SAK" --profile "$PROFILE"
aws configure set region "$REGION" --profile "$PROFILE"
aws configure set output "$OUTPUT" --profile "$PROFILE"

export AWS_PAGER=""
echo "🔎 Testando acesso..."
aws sts get-caller-identity --profile "$PROFILE" --no-cli-pager

echo "🎉 AWS CLI pronto para uso"
