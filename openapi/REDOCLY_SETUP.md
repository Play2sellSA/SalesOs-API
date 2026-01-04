# Redocly Setup Guide

Este guia explica como configurar o Redocly para hospedar a documentação da API SalesOS.

## 🚀 Overview

Migramos do SwaggerHub para o **Redocly.com** para hospedar nossa documentação de API.

**Benefícios do Redocly:**
- ✅ Interface moderna e responsiva
- ✅ Melhor performance
- ✅ Temas customizáveis
- ✅ Suporte a múltiplas versões de API
- ✅ Analytics integrado
- ✅ Geração automática de exemplos de código

## 📋 Pré-requisitos

1. **Conta no Redocly**
   - Acesse: https://redocly.com/
   - Crie uma conta (Free tier disponível)
   - Crie uma organização: `play2sell`

2. **API Key do Redocly**
   - No Redocly dashboard, acesse: Settings → API Keys
   - Clique em "Create API Key"
   - Copie a chave gerada

## ⚙️ Configuração no GitHub

### 1. Adicionar Secret no GitHub

1. Acesse: https://github.com/felipeplay2sellcom/SalesOs-API/settings/secrets/actions
2. Clique em **"New repository secret"**
3. Configure:
   - **Name**: `REDOCLY_API_KEY`
   - **Value**: Cole a API key do Redocly
4. Clique em **"Add secret"**

### 2. Estrutura de Arquivos

```
SalesOS-API/
├── .github/
│   └── workflows/
│       └── deploy-redocly.yml    # Workflow de deploy automático
├── openapi/
│   ├── salesos-api-v3.0.yaml     # API v3.0
│   ├── salesos-api-v2.1.yaml     # API v2.1
│   └── REDOCLY_SETUP.md          # Este arquivo
└── redocly.yaml                  # Configuração do Redocly
```

## 🔄 Deploy Automático

O deploy é **totalmente automático** via GitHub Actions:

**Trigger**: Push para `main` branch com alterações em:
- `openapi/salesos-api-v3.0.yaml`
- `openapi/salesos-api-v2.1.yaml`
- `redocly.yaml`

**Processo**:
1. ✅ Lint das especificações OpenAPI
2. 🚀 Deploy para Redocly
3. 📖 Publicação online

## 📖 URLs da Documentação

Após o deploy, a documentação estará disponível em:

- **v3.0**: https://redocly.com/docs/salesos-api/v3
- **v2.1**: https://redocly.com/docs/salesos-api/v2.1

## 🛠️ Comandos Locais

### Instalar Redocly CLI

```bash
npm install -g @redocly/cli@latest
```

### Lint Local

```bash
# Validar v3.0
redocly lint openapi/salesos-api-v3.0.yaml

# Validar v2.1
redocly lint openapi/salesos-api-v2.1.yaml
```

### Preview Local

```bash
# Preview v3.0
redocly preview-docs openapi/salesos-api-v3.0.yaml

# Preview v2.1
redocly preview-docs openapi/salesos-api-v2.1.yaml
```

### Deploy Manual (opcional)

```bash
# Definir API key
export REDOCLY_AUTHORIZATION="your-api-key-here"

# Deploy v3.0
redocly push openapi/salesos-api-v3.0.yaml "@salesos-api/v3" \
  --organization play2sell \
  --public

# Deploy v2.1
redocly push openapi/salesos-api-v2.1.yaml "@salesos-api/v2.1" \
  --organization play2sell \
  --public
```

## 🎨 Personalização

Edite `redocly.yaml` para customizar:

- **Regras de lint**: Ajuste warnings/errors
- **Tema**: Cores, logo, layout
- **Code samples**: Linguagens exibidas
- **Features**: Console interativo, etc.

Exemplo:

```yaml
theme:
  openapi:
    showConsole: true
    generateCodeSamples:
      languages:
        - lang: curl
        - lang: javascript
        - lang: python
```

## 🐛 Troubleshooting

### Erro: "TOKEN_UNKNOWN" ou "Unauthorized"

**Solução**: Verifique se o secret `REDOCLY_API_KEY` está configurado corretamente no GitHub.

### Erro: "Organization not found"

**Solução**: Certifique-se de que criou a organização `play2sell` no Redocly.

### Workflow não executa

**Solução**: Verifique se alterou um dos arquivos que dispara o workflow (`openapi/*.yaml` ou `redocly.yaml`).

## 📚 Recursos

- **Redocly Docs**: https://redocly.com/docs
- **Redocly CLI**: https://redocly.com/docs/cli
- **GitHub Actions**: https://github.com/Redocly/redocly-cli-github-action
- **OpenAPI Spec**: https://spec.openapis.org/oas/latest.html

## 🔄 Migração do SwaggerHub

✅ **Concluído** - Removemos todos os workflows do SwaggerHub:
- ❌ `pull-from-swaggerhub.yml` (removido)
- ❌ `sync-swaggerhub.yml` (removido)
- ❌ `sync-swaggerhub-v2.1.yml` (removido)

✅ **Novo** - Workflow Redocly:
- ✅ `deploy-redocly.yml` (ativo)

---

**Dúvidas?** Entre em contato com o time de desenvolvimento.
