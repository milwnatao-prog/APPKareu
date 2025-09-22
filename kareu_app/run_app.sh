#!/bin/bash

# Script definitivo para executar o app Kareu
# Garante que sempre execute no diretório correto

echo "🚀 Iniciando app Kareu..."

# Navegar para o diretório correto
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app

# Verificar se estamos no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Erro: pubspec.yaml não encontrado!"
    echo "Diretório atual: $(pwd)"
    exit 1
fi

echo "✅ Diretório correto confirmado: $(pwd)"

# Limpar processos Flutter anteriores
echo "🧹 Limpando processos anteriores..."
pkill -f flutter 2>/dev/null || true
pkill -f dart 2>/dev/null || true

# Verificar dispositivos
echo "📱 Verificando dispositivos..."
flutter devices

# Executar o app
echo "🎯 Executando app no emulador..."
flutter run --device-id emulator-5554

echo "✅ Script concluído!"

