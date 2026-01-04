# 📤 Como Publicar no SwaggerHub

Instruções passo a passo para publicar a API.

---

## ✅ **Método Recomendado: Upload Manual** (2 minutos)

### **Passo 1: Abrir SwaggerHub**

```
https://app.swaggerhub.com/hub/play2sell-ecd
```

Faça login se necessário.

---

### **Passo 2: Criar Nova API**

1. Clique no botão verde **"Create New"** (canto superior direito)
2. Selecione **"Create New API"**

![Screenshot esperado: Menu "Create New" com opções]

---

### **Passo 3: Importar Arquivo**

Na tela de criação da API:

1. Clique na aba **"Import and Document API"** (segunda aba)
2. Clique em **"Browse files"** ou arraste o arquivo
3. Navegue até:
   ```
   /Users/play2sell/SalesOS/docs/openapi/salesos-api.yaml
   ```
4. Selecione o arquivo

![Screenshot esperado: Área de upload de arquivo]

---

### **Passo 4: Configurar Detalhes**

Preencha os campos:

```
┌─────────────────────────────────────────┐
│ Owner:        play2sell-ecd             │
│ API Name:     SalesOS-EventService-API  │
│ Version:      2.0.0                     │
│ Visibility:   ● Private  ○ Public       │
│ Auto Mocking: ☑ Enabled                 │
└─────────────────────────────────────────┘
```

**IMPORTANTE:** Mantenha como **Private** se não quiser que seja público.

---

### **Passo 5: Criar API**

1. Clique no botão **"Import and Create API"**
2. Aguarde o upload (leva ~5 segundos)
3. ✅ Pronto!

---

### **Passo 6: Verificar Resultado**

Você será redirecionado para:

```
https://app.swaggerhub.com/apis/play2sell-ecd/SalesOS-EventService-API/2.0.0
```

**O que você deve ver:**
- ✅ Menu lateral com todos os endpoints
- ✅ Seção "Servers" com 3 ambientes (prod, staging, dev)
- ✅ Seção "Schemas" com todos os modelos
- ✅ Exemplos de código (cURL, JavaScript, Python, etc.)

---

### **Passo 7: Testar Mock Server**

SwaggerHub cria automaticamente um mock server:

```bash
# Testar endpoint mock
curl https://virtserver.swaggerhub.com/play2sell-ecd/SalesOS-EventService-API/2.0.0/rest/v1/rpc/salesos_emit_event
```

---

## 🔧 **Método Alternativo: CLI** (Requer setup inicial)

Se preferir automação para futuras atualizações:

### **Setup Único (5 min)**

```bash
# 1. Instalar CLI
npm install -g swaggerhub-cli

# 2. Obter API Key
# Acesse: https://app.swaggerhub.com/settings/apiKey
# Clique em "Generate New API Key"
# Copie a key gerada

# 3. Configurar CLI
swaggerhub configure
# Cole a API key quando solicitado
```

### **Publicar (30 segundos)**

```bash
cd /Users/play2sell/SalesOS/docs/openapi

# Executar script
./publish-swaggerhub.sh
```

Ou manualmente:

```bash
swaggerhub api:create play2sell-ecd/SalesOS-EventService-API/2.0.0 \
  --file salesos-api.yaml \
  --visibility private \
  --published=publish
```

---

## 🔄 **Atualizar API (Futuro)**

Quando fizer mudanças no `salesos-api.yaml`:

### **Via Interface Web:**

1. Abra a API no SwaggerHub
2. Clique em **"Edit"** (canto superior direito)
3. Clique em **"Import"** → Selecione o arquivo atualizado
4. Clique em **"Save"**

### **Via CLI:**

```bash
cd /Users/play2sell/SalesOS/docs/openapi

swaggerhub api:update play2sell-ecd/SalesOS-EventService-API/2.0.0 \
  --file salesos-api.yaml
```

---

## 📊 **Recursos Úteis Após Publicação**

### **1. Compartilhar Documentação**

URL pública (se configurar como Public):
```
https://app.swaggerhub.com/apis-docs/play2sell-ecd/SalesOS-EventService-API/2.0.0
```

### **2. Gerar Código Client**

No SwaggerHub:
1. Clique em **"Export"** → **"Client SDK"**
2. Escolha linguagem: TypeScript, Python, Java, etc.
3. Download do SDK gerado

### **3. Mock Server**

Testar sem backend real:
```
https://virtserver.swaggerhub.com/play2sell-ecd/SalesOS-EventService-API/2.0.0
```

### **4. Embedar em Site**

```html
<iframe
  src="https://app.swaggerhub.com/apis-docs/play2sell-ecd/SalesOS-EventService-API/2.0.0"
  width="100%"
  height="800"
></iframe>
```

---

## ✅ **Checklist de Verificação**

Após publicar, verifique:

- [ ] API aparece em: https://app.swaggerhub.com/hub/play2sell-ecd
- [ ] Consegue visualizar todos os endpoints
- [ ] Consegue ver exemplos de código (cURL, JavaScript)
- [ ] Mock server responde: `curl https://virtserver.swaggerhub.com/...`
- [ ] Consegue gerar SDK client
- [ ] Visibilidade está correta (Private ou Public)

---

## 🆘 **Troubleshooting**

### **Erro: "Invalid OpenAPI specification"**

**Solução:**
```bash
# Validar localmente primeiro
npx @apidevtools/swagger-cli validate salesos-api.yaml
```

### **Erro: "API already exists"**

**Solução:**
- Use "Update" em vez de "Create"
- Ou mude a versão (ex: 2.0.1)

### **Não encontro o botão "Create New"**

**Solução:**
- Verifique se está logado
- Verifique se tem permissões na organização play2sell-ecd

---

## 📞 **Suporte**

Precisa de ajuda?
- 📧 Email: dev@play2sell.com
- 📚 SwaggerHub Docs: https://support.smartbear.com/swaggerhub/docs/

---

**Última atualização:** 2026-01-04
