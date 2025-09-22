#!/bin/bash

# Script para iniciar o app Kareu de forma fluida
# Resolve automaticamente problemas de diretório

echo "🚀 Iniciando Kareu App de forma automática..."

# Navegar para o diretório correto
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app

# Verificar se estamos no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Erro: pubspec.yaml não encontrado!"
    echo "📍 Diretório atual: $(pwd)"
    exit 1
fi

echo "✅ Diretório correto confirmado: $(pwd)"

# Limpar processos Flutter anteriores
echo "🧹 Limpando processos anteriores..."
pkill -f "flutter run" 2>/dev/null || true

# Verificar dispositivos disponíveis
echo "📱 Verificando dispositivos..."
flutter devices

# Executar no Chrome (mais estável para desenvolvimento web)
echo "🌐 Iniciando no Chrome..."
flutter run -d chrome --hot

echo "✅ Script concluído!"

