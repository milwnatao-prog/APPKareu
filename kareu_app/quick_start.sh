#!/bin/bash

# Quick Start para Kareu - Execução super rápida
# Use: ./quick_start.sh

echo "⚡ Quick Start Kareu..."

# Garantir que estamos no diretório correto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Verificar pubspec.yaml
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Erro: Não é um projeto Flutter válido"
    exit 1
fi

echo "✅ Projeto Flutter confirmado"

# Matar processos anteriores
pkill -f "flutter run" 2>/dev/null || true

# Executar
echo "🚀 Iniciando Kareu no Chrome..."
flutter run -d chrome --hot

