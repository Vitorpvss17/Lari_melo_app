#!/bin/bash

# Instala o Flutter
echo "Instalando Flutter..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

# Verifica a instalação
flutter doctor

# Instala as dependências do projeto
echo "Instalando dependências..."
flutter pub get

# Executa o build para web
echo "Executando build para web..."
flutter build web

echo "Build concluído!"