#!/bin/bash

# =========================================================
# Script para Publicar API no SwaggerHub
# =========================================================

set -e

echo "🚀 Publicando SalesOS API no SwaggerHub..."

# Verificar se SwaggerHub CLI está instalado
if ! command -v swaggerhub &> /dev/null; then
    echo "📦 SwaggerHub CLI não encontrado. Instalando..."
    npm install -g swaggerhub-cli
fi

# Verificar se está configurado
if [ ! -f ~/.swaggerhub-cli.json ]; then
    echo "⚙️  Configure suas credenciais do SwaggerHub:"
    echo "   1. Acesse: https://app.swaggerhub.com/settings/apiKey"
    echo "   2. Gere uma API Key"
    echo "   3. Execute: swaggerhub configure"
    echo ""
    read -p "Pressione Enter após configurar..."
    swaggerhub configure
fi

# Variáveis
OWNER="play2sell-ecd"
API_NAME="SalesOS-EventService-API"
VERSION="2.0.0"
FILE_PATH="salesos-api.yaml"

# Verificar se o arquivo existe
if [ ! -f "$FILE_PATH" ]; then
    echo "❌ Arquivo não encontrado: $FILE_PATH"
    exit 1
fi

# Validar especificação
echo "✅ Validando especificação OpenAPI..."
npx @apidevtools/swagger-cli validate "$FILE_PATH"

# Verificar se API já existe
echo "🔍 Verificando se API já existe..."
if swaggerhub api:get "$OWNER/$API_NAME/$VERSION" &> /dev/null; then
    echo "📝 API já existe. Atualizando..."
    swaggerhub api:update "$OWNER/$API_NAME/$VERSION" \
        --file "$FILE_PATH" \
        --published=publish
    echo "✅ API atualizada com sucesso!"
else
    echo "🆕 Criando nova API..."
    swaggerhub api:create "$OWNER/$API_NAME/$VERSION" \
        --file "$FILE_PATH" \
        --visibility private \
        --published=publish
    echo "✅ API criada com sucesso!"
fi

# URL final
echo ""
echo "🎉 API publicada com sucesso!"
echo "📖 Visualizar: https://app.swaggerhub.com/apis/$OWNER/$API_NAME/$VERSION"
echo "🔗 Mock Server: https://virtserver.swaggerhub.com/$OWNER/$API_NAME/$VERSION"
echo ""
