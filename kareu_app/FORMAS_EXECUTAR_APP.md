# 🚀 Formas de Executar o App Kareu

## ✅ Método 1 - Script Robusto (Recomendado)
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app
./start_kareu_definitive.sh
```

## ✅ Método 2 - Comando Direto
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app && flutter run -d chrome
```

## ✅ Método 3 - Comando Absoluto
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app && /usr/bin/flutter run -d chrome
```

## ✅ Método 4 - Com Verificações
```bash
pkill -f "flutter run"; sleep 2; cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app && flutter run -d chrome
```

## ✅ Método 5 - Modo Debug Verbose
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app && flutter run -d chrome --verbose
```

## ✅ Método 6 - Hot Reload Ativado
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app && flutter run -d chrome --hot
```

## 🛠️ Resolução de Problemas

### Se der erro "No pubspec.yaml":
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app
pwd  # Deve mostrar: /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app
ls pubspec.yaml  # Deve mostrar: pubspec.yaml
flutter run -d chrome
```

### Se der erro de cache:
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app
flutter clean
flutter pub get
flutter run -d chrome
```

### Se o Chrome não abrir:
```bash
cd /home/guest/Documentos/GitHub/APPKareu/APPKareu/kareu_app
flutter devices  # Verificar se chrome está listado
flutter run -d web-server --web-port 8080
# Depois abrir manualmente: http://localhost:8080
```

## 📱 Funcionalidades Implementadas
- ✅ Menu Profissional na tela "Meus Pacientes"
- ✅ Menu Paciente com "Contratos" (substitui "Favoritos")  
- ✅ Navegação entre todas as telas
- ✅ Tela "Minha Conta" funcionando
