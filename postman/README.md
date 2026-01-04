# 📮 Postman Collection - SalesOS Webhooks & EventService

Coleção completa para testar webhooks e EventService do SalesOS.

---

## 📥 **Como Importar**

### **1. Importar Collection**

1. Abra o Postman
2. Clique em **Import**
3. Selecione o arquivo: `SalesOS-Webhooks-EventService.postman_collection.json`
4. Clique em **Import**

### **2. Importar Environment**

1. Clique em **Environments** (ícone de engrenagem)
2. Clique em **Import**
3. Selecione o arquivo: `SalesOS-Local.postman_environment.json`
4. Clique em **Import**

---

## ⚙️ **Configuração**

### **1. Obter Credenciais do Supabase**

```bash
# No Supabase Dashboard:
# Settings → API

supabase_url: https://xxxxx.supabase.co
supabase_anon_key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### **2. Obter User ID e Tenant ID**

Execute no Supabase SQL Editor:

```sql
-- Pegar user_id do felipe@play2sell.com
SELECT
  u.id as user_id,
  ut.tenant_id
FROM salesos_users u
JOIN salesos_user_tenants ut ON ut.user_id = u.id
WHERE u.email = 'felipe@play2sell.com'
LIMIT 1;
```

### **3. Configurar Environment**

No Postman, vá em **Environments** → **SalesOS - Local Development** e preencha:

| Variável | Valor | Onde Obter |
|----------|-------|------------|
| `supabase_url` | https://xxx.supabase.co | Supabase Dashboard → Settings → API |
| `supabase_anon_key` | eyJhbGc... | Supabase Dashboard → Settings → API |
| `tenant_id` | uuid | Query SQL acima |
| `user_id` | uuid | Query SQL acima |
| `webhook_token` | seu-token-secreto | Criar seu próprio |
| `base_url` | http://localhost:5173 | URL do frontend local |

---

## 🧪 **Como Testar**

### **Teste 1: Emitir Evento Lead Criado (Básico)**

1. Selecione o environment **SalesOS - Local Development**
2. Configure as variáveis: `supabase_url`, `supabase_anon_key`, `user_id`, `tenant_id`
3. Vá em **2. EventService - Eventos de Leads**
4. Execute: **Lead Criado**

**Esperado:**
```json
"uuid-do-evento-criado"
```

**Validar:**
1. Console do browser deve mostrar: `[EventService] Evento lead.created emitido`
2. Execute: **4. Queries - Verificação → Listar Eventos Recentes**
3. Deve aparecer o evento criado com `type = "lead.created"`
4. Execute: **4. Queries - Verificação → Workflows Disparados**
5. Deve ter workflows executados com `status = "completed"`

---

### **Teste 2: Testar Todos os Eventos de Interação**

Execute em sequência (na pasta **2. EventService - Eventos de Leads**):

1. **Email Enviado** → Deve retornar UUID + 5 pontos
2. **WhatsApp Enviado** → Deve retornar UUID + 5 pontos
3. **Ligação Completada** → Deve retornar UUID + 10 pontos
4. **Visita Agendada** → Deve retornar UUID + 15 pontos
5. **Visita Completada** → Deve retornar UUID + 20 pontos
6. **Reunião Completada** → Deve retornar UUID + 15 pontos
7. **Proposta Enviada** → Deve retornar UUID + 25 pontos

**Validar:**
- Execute: **4. Queries - Verificação → Pontos do Usuário**
- Deve mostrar soma de todos os pontos acumulados

---

### **Teste 3: Gamificação (Quiz e Missões)**

Execute em sequência (na pasta **3. EventService - Eventos GO**):

1. **Quiz Completado** → Deve retornar UUID + 42 pontos
2. **Missão Completada** → Deve retornar UUID + 100 pontos

**Validar:**
- Eventos criados com `domain = "go"`
- Workflows de gamificação disparados

---

### **Teste 4: Testes Automáticos**

Todos os requests incluem testes automáticos:

✅ **Status code válido** (200, 201, ou 204)
⚡ **Response time** < 3000ms
🔍 **Validação de UUID** (em alguns requests)

**Ver resultados:**
1. Após executar qualquer request, vá em **Test Results**
2. Deve mostrar todos os testes passando
3. Console mostra logs de debug e performance

---

## 📊 **Estrutura da Collection (v2)**

### **1. Webhooks Recebidos (Incoming)**
Simula sistemas externos enviando dados para o SalesOS:
- **Meta Ads** - Novo lead de campanha
- **Zapier** - Lead de automação

### **2. EventService - Eventos de Leads**
Todos os eventos do domínio "leads" via RPC:
- Lead Criado (`lead.created`)
- Ligação Completada (`call.completed`)
- Email Enviado (`email.sent`)
- WhatsApp Enviado (`whatsapp.sent`)
- Visita Agendada (`visit.scheduled`)
- Visita Completada (`visit.completed`)
- Reunião Completada (`meeting.completed`)
- Proposta Enviada (`proposal.sent`)

### **3. EventService - Eventos GO (Gamificação)**
Eventos do domínio "go":
- Quiz Completado (`quiz.completed`)
- Missão Completada (`mission.completed`)

### **4. Queries - Verificação**
Consultas para validar eventos e workflows:
- Listar Eventos Recentes (últimos 20)
- Workflows Disparados (últimos 20)
- Eventos por Tipo (filtro)
- Pontos do Usuário (soma)

### **5. Webhooks Enviados (Outgoing)**
Testar webhooks que o SalesOS envia para sistemas externos:
- Usa webhook.site para simular recebimento

---

## 🔐 **Segurança**

### **Validar Assinaturas de Webhooks**

#### **Meta Ads:**
```typescript
import crypto from 'crypto';

function validateMetaSignature(body: string, signature: string, secret: string): boolean {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(body)
    .digest('hex');

  return signature === `sha256=${expectedSignature}`;
}
```

#### **Zapier:**
```typescript
function validateZapierSecret(headers: Headers, secret: string): boolean {
  return headers.get('X-Zapier-Secret') === secret;
}
```

#### **Bearer Token:**
```typescript
function validateBearerToken(headers: Headers, validToken: string): boolean {
  const authHeader = headers.get('Authorization');
  return authHeader === `Bearer ${validToken}`;
}
```

---

## 🧪 **Testes Automatizados**

A collection já inclui testes automáticos:

```javascript
// Executados em todas as requisições:
pm.test('Status code is 200 or 201', function () {
    pm.expect(pm.response.code).to.be.oneOf([200, 201]);
});

pm.test('Response time is less than 2000ms', function () {
    pm.expect(pm.response.responseTime).to.be.below(2000);
});
```

### **Adicionar Testes Customizados:**

```javascript
// Na aba "Tests" de cada request:
pm.test('Event was created', function () {
    const jsonData = pm.response.json();
    pm.expect(jsonData.data).to.be.a('string');
    pm.expect(jsonData.data).to.have.lengthOf(36); // UUID
});
```

---

## 🌐 **Webhook.site (Teste de Webhooks Outgoing)**

Para testar webhooks que o SalesOS ENVIA:

1. Acesse: https://webhook.site
2. Copie a URL única gerada (ex: `https://webhook.site/abc-123`)
3. No environment do Postman, configure: `your_unique_url = abc-123`
4. Configure workflow action para enviar webhook para essa URL
5. Crie evento no SalesOS
6. Veja o webhook recebido no webhook.site

---

## 📝 **Criar Workflow Action de Webhook**

Execute no Supabase SQL Editor:

```sql
-- 1. Criar workflow
INSERT INTO salesos_workflows (name, domain, is_active, tenant_id)
VALUES ('Notificar Sistema Externo', 'leads', true, NULL)
RETURNING id;

-- 2. Criar trigger (escutar lead.created)
INSERT INTO salesos_workflow_triggers (workflow_id, event_type)
VALUES ('<workflow-id>', 'lead.created');

-- 3. Criar versão com webhook action
INSERT INTO salesos_workflow_versions (
  workflow_id,
  version,
  status,
  definition,
  execution_mode,
  max_depth
) VALUES (
  '<workflow-id>',
  1,
  'published',
  '{
    "steps": [
      {
        "key": "send_webhook",
        "type": "webhook",
        "config": {
          "url": "https://webhook.site/your-unique-url",
          "method": "POST",
          "headers": {
            "Content-Type": "application/json",
            "Authorization": "Bearer your-token"
          },
          "body": {
            "event_type": "lead.created",
            "lead_id": "{{payload.lead_id}}",
            "lead_name": "{{payload.lead_name}}",
            "timestamp": "{{occurred_at}}"
          }
        }
      }
    ]
  }'::jsonb,
  'sync',
  1
) RETURNING id;
```

---

## 🐛 **Troubleshooting**

### **Erro: "403 Forbidden" ao emitir evento**
Este é o erro mais comum após migração. Acontece quando a RLS policy bloqueia INSERTs.

**Sintomas:**
```
POST https://api.play2sell.com/rest/v1/salesos_events 403 (Forbidden)
```

**Solução:**
1. Execute a migração `migrations/fix_events_rls_policy_v2.sql` no Supabase SQL Editor
2. Verifique se foi aplicada: `migrations/verify_rls_fix.sql`
3. Teste novamente via Postman: **"2. EventService - Eventos de Leads" → "Lead Criado"**

**Por que acontece:**
- RLS WITH CHECK avalia no contexto do caller (anon key), não do SECURITY DEFINER
- A função tem permissões elevadas, mas RLS bloqueia antes dela executar
- A solução é permitir INSERTs via RLS, pois a segurança está na função

---

### **Erro: "Invalid API key"**
- Verificar se `supabase_anon_key` está correto
- Verificar se está usando o environment correto

### **Erro: "User not authenticated"**
- Verificar se `user_id` e `tenant_id` estão corretos
- Execute a query SQL para obter IDs corretos

### **Evento criado mas workflow não dispara**
```sql
-- Verificar se há workflow escutando o evento
SELECT * FROM salesos_workflow_triggers
WHERE event_type = 'lead.created';
```

### **Webhook não está sendo enviado**
- Verificar se workflow está `is_active = true`
- Verificar se versão está `status = 'published'`
- Verificar logs: `SELECT * FROM salesos_workflow_runs WHERE status = 'failed'`

---

## 📚 **Referências**

- [EventService README](../src/services/README.md)
- [Migrations Guide](../migrations/README.md)
- [Postman Documentation](https://learning.postman.com/docs/getting-started/introduction/)

---

**Última atualização:** 2026-01-04
