# 📡 OpenAPI Specification

Documentação interativa da API do SalesOS usando OpenAPI 3.1.

---

## 🎯 **Como Usar**

### **Opção 1: Swagger UI Online (Mais Rápido)**

1. Acesse: https://editor.swagger.io
2. File → Import File → Selecione `salesos-api.yaml`
3. Navegue pela documentação interativa

### **Opção 2: Swagger UI Local**

```bash
# Instalar Swagger UI
npm install -g swagger-ui-watcher

# Servir documentação
cd docs/openapi
swagger-ui-watcher salesos-api.yaml

# Abrir no browser
open http://localhost:8000
```

### **Opção 3: Redoc (Alternativa)**

```bash
# Instalar Redoc CLI
npm install -g redoc-cli

# Gerar HTML estático
redoc-cli bundle salesos-api.yaml -o salesos-api.html

# Abrir no browser
open salesos-api.html
```

### **Opção 4: VS Code Extension**

1. Instalar extensão: **Swagger Viewer**
2. Abrir `salesos-api.yaml`
3. Pressionar `Shift + Alt + P` → Preview Swagger

---

## 📦 **O Que Está Incluído**

### **Endpoints Documentados**

- ✅ `POST /rpc/salesos_emit_event` - Emitir eventos
- ✅ `GET /salesos_events` - Listar eventos
- ✅ `GET /salesos_workflow_runs` - Listar workflows

### **Schemas Completos**

- ✅ `EmitEventRequest` - Request body para emitir eventos
- ✅ `Event` - Estrutura de um evento
- ✅ `WorkflowRun` - Estrutura de execução de workflow
- ✅ `Error` - Formato de erros

### **Exemplos de Uso**

- ✅ Lead Criado
- ✅ Ligação Completada
- ✅ Email Enviado
- ✅ Quiz Completado
- ✅ E mais...

---

## 🚀 **Gerar Client SDK**

### **TypeScript/JavaScript**

```bash
# Instalar OpenAPI Generator
npm install @openapitools/openapi-generator-cli -g

# Gerar SDK
openapi-generator-cli generate \
  -i salesos-api.yaml \
  -g typescript-axios \
  -o ../../src/generated/api

# Usar no código
import { DefaultApi } from '@/generated/api';

const api = new DefaultApi({
  basePath: 'https://api.play2sell.com',
  apiKey: 'YOUR_ANON_KEY'
});

await api.emitEvent({
  p_user_id: '...',
  p_tenant_id: '...',
  p_type: 'lead.created',
  p_domain: 'leads',
  p_payload: { ... }
});
```

### **Python**

```bash
openapi-generator-cli generate \
  -i salesos-api.yaml \
  -g python \
  -o ./python-sdk
```

### **Outros Linguagens Suportadas**

- Java
- Go
- Ruby
- PHP
- C#
- Rust
- Kotlin
- Swift

**Ver todas:** https://openapi-generator.tech/docs/generators

---

## ✅ **Validar Especificação**

```bash
# Instalar validator
npm install -g @apidevtools/swagger-cli

# Validar
swagger-cli validate salesos-api.yaml

# Output esperado:
# ✅ salesos-api.yaml is valid
```

---

## 🔄 **Atualizar Especificação**

Sempre que adicionar novos endpoints ou schemas:

1. Editar `salesos-api.yaml`
2. Validar: `swagger-cli validate salesos-api.yaml`
3. Gerar preview: `swagger-ui-watcher salesos-api.yaml`
4. Commit changes

---

## 📚 **Recursos**

| Recurso | Link |
|---------|------|
| OpenAPI 3.1 Spec | https://spec.openapis.org/oas/v3.1.0 |
| Swagger Editor | https://editor.swagger.io |
| OpenAPI Generator | https://openapi-generator.tech |
| Redoc | https://redocly.com/redoc |

---

## 🆕 **Changelog**

### v2.0.0 (2026-01-04)
- ✅ Especificação completa do EventService
- ✅ Todos os event types documentados
- ✅ Exemplos para cada endpoint
- ✅ Error responses documentados

---

**Última atualização:** 2026-01-04
