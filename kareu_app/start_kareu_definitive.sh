#!/bin/bash

# Script definitivo para iniciar o app Kareu
# Resolve problemas de diretório e garante execução correta

echo "🚀 Iniciando App Kareu..."
echo "📂 Verificando diretório..."

# Navegar para o diretório correto
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app

# Verificar se estamos no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Erro: pubspec.yaml não encontrado!"
    echo "📍 Diretório atual: $(pwd)"
    exit 1
fi

echo "✅ Diretório correto encontrado: $(pwd)"

# Parar qualquer processo Flutter anterior
echo "🛑 Parando processos Flutter anteriores..."
pkill -f "flutter run" 2>/dev/null || true
sleep 2

# Verificar se Chrome está disponível
echo "🌐 Verificando Chrome..."
if ! flutter devices | grep -q chrome; then
    echo "⚠️  Chrome não detectado, iniciando..."
fi

# Executar Flutter
echo "🎯 Iniciando Flutter no Chrome..."
echo "📱 O app será aberto automaticamente no navegador..."
echo ""

flutter run -d chrome
