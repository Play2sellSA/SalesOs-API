# 📤 Publicar no SwaggerHub

Guia para publicar a API do SalesOS no SwaggerHub.

---

## 🚀 **Quick Start**

### **Opção 1: Upload Manual (Mais Fácil)**

1. Acesse: https://app.swaggerhub.com/hub/play2sell-ecd
2. Clique em **Create New** → **Create New API**
3. **Import from file** → Selecione `salesos-api.yaml`
4. Configurar:
   ```
   Owner: play2sell-ecd
   Name: SalesOS-EventService-API
   Version: 2.0.0
   Visibility: Private (ou Public)
   ```
5. Clique em **Create API**

### **Opção 2: SwaggerHub CLI**

```bash
# Instalar CLI
npm install -g swaggerhub-cli

# Configurar credenciais
swaggerhub configure

# Criar API
swaggerhub api:create play2sell-ecd/SalesOS-EventService-API/2.0.0 \
  --file salesos-api.yaml \
  --visibility private

# URL gerada:
# https://app.swaggerhub.com/apis/play2sell-ecd/SalesOS-EventService-API/2.0.0
```

---

## ⚙️ **Configuração Recomendada**

### **Settings**

```yaml
Owner: play2sell-ecd
API Name: SalesOS-EventService-API
Version: 2.0.0
Visibility: Private  # ou Public se for open source
Auto Mocking: Enabled
Documentation URL: https://docs.salesos.com
```

### **Domains**

Configurar domínios personalizados:

```
Production:  https://api.play2sell.com
Staging:     https://staging-api.play2sell.com
Development: http://localhost:5173
```

### **Auto Mocking**

SwaggerHub gera automaticamente um mock server:

```
https://virtserver.swaggerhub.com/play2sell-ecd/SalesOS-EventService-API/2.0.0
```

Use para testar sem backend real!

---

## 🔄 **Atualizar Versão**

### **Manual**

1. Edite `salesos-api.yaml` localmente
2. Vá em SwaggerHub → **Edit** → **Import**
3. Selecione o arquivo atualizado
4. Save

### **CLI**

```bash
# Atualizar versão existente
swaggerhub api:update play2sell-ecd/SalesOS-EventService-API/2.0.0 \
  --file salesos-api.yaml

# Criar nova versão
swaggerhub api:create play2sell-ecd/SalesOS-EventService-API/2.1.0 \
  --file salesos-api.yaml
```

---

## 🌐 **Gerar Documentação Pública**

### **1. Ativar Public Docs**

```
Settings → Documentation → Enable Public Documentation
```

### **2. Customizar Aparência**

```
Settings → Branding
  - Logo: Upload logo do SalesOS
  - Primary Color: #0066FF
  - Favicon: Upload favicon
```

### **3. Embedar em Site**

```html
<!-- Embed no seu site -->
<iframe
  src="https://app.swaggerhub.com/apis-docs/play2sell-ecd/SalesOS-EventService-API/2.0.0"
  width="100%"
  height="800"
  frameborder="0"
></iframe>
```

---

## 🔌 **Integrations**

### **GitHub Auto-Sync**

```yaml
# Em .github/workflows/sync-swagger.yml
name: Sync to SwaggerHub

on:
  push:
    paths:
      - 'docs/openapi/salesos-api.yaml'

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Install SwaggerHub CLI
        run: npm install -g swaggerhub-cli

      - name: Update API
        env:
          SWAGGERHUB_API_KEY: ${{ secrets.SWAGGERHUB_API_KEY }}
        run: |
          swaggerhub api:update play2sell-ecd/SalesOS-EventService-API/2.0.0 \
            --file docs/openapi/salesos-api.yaml
```

### **Postman Integration**

SwaggerHub pode exportar diretamente para Postman:

```
Export → Postman Collection (v2.1)
```

---

## 📊 **Analytics & Monitoring**

SwaggerHub fornece analytics:

- 📈 API calls por endpoint
- 🌍 Geolocalização de usuários
- ⏱️ Response times
- ❌ Error rates

Acesse em: **Analytics** tab

---

## 🔐 **API Keys**

Gerar API key para CI/CD:

1. Account Settings → API Keys
2. Create New API Key
3. Salvar no GitHub Secrets como `SWAGGERHUB_API_KEY`

---

## 🎯 **Próximos Passos**

Após publicar no SwaggerHub:

1. ✅ Compartilhar URL com equipe
   ```
   https://app.swaggerhub.com/apis/play2sell-ecd/SalesOS-EventService-API/2.0.0
   ```

2. ✅ Configurar auto-sync com GitHub

3. ✅ Gerar SDK clients automaticamente:
   ```
   Settings → Integrations → Code Generation
   ```

4. ✅ Ativar API mocking para testes

5. ✅ Embedar docs no site de documentação

---

## 📚 **Recursos**

| Recurso | Link |
|---------|------|
| SwaggerHub Dashboard | https://app.swaggerhub.com/hub/play2sell-ecd |
| SwaggerHub CLI Docs | https://www.npmjs.com/package/swaggerhub-cli |
| Integrations Guide | https://support.smartbear.com/swaggerhub/docs/integrations/ |

---

**Última atualização:** 2026-01-04
