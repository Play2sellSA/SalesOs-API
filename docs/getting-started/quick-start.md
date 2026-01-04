# 🚀 Quick Start

Get up and running with SalesOS EventService in 5 minutes.

---

## Prerequisites

- Node.js 18+ instalado
- Acesso ao Supabase (projeto configurado)
- Postman instalado (opcional, para testes)

---

## Passo 1: Entender o Básico

SalesOS usa **arquitetura orientada a eventos**:

```
┌─────────────┐      ┌──────────────┐      ┌──────────────┐
│ Aplicação   │─────▶│ EventService │─────▶│  Workflows   │
│ (Frontend)  │ emit │  (Backend)   │ trigger│ (Automações)│
└─────────────┘      └──────────────┘      └──────────────┘
```

**Fluxo:**
1. Aplicação chama `EventService.leadCreated()`
2. EventService salva evento no banco (`salesos_events`)
3. Workflows são disparados automaticamente via database triggers
4. Workflows executam ações (enviar email, atualizar pontos, etc.)

---

## Passo 2: Configurar Credenciais

### 2.1 Obter Supabase URL e API Key

```bash
# 1. Acesse: https://supabase.com/dashboard
# 2. Selecione seu projeto
# 3. Settings → API
# 4. Copie:
#    - Project URL (ex: https://abc123.supabase.co)
#    - anon/public key (eyJhbGc...)
```

### 2.2 Obter User ID e Tenant ID

Execute no **Supabase SQL Editor**:

```sql
SELECT
  u.id as user_id,
  ut.tenant_id
FROM salesos_users u
JOIN salesos_user_tenants ut ON ut.user_id = u.id
WHERE u.email = 'seu-email@exemplo.com'
LIMIT 1;
```

Resultado:
```
user_id:   123e4567-e89b-12d3-a456-426614174000
tenant_id: 123e4567-e89b-12d3-a456-426614174001
```

---

## Passo 3: Emitir Seu Primeiro Evento

### Opção A: Via Postman (Mais Fácil)

1. **Importar Collection:**
   ```
   File → Import → postman/SalesOS-Webhooks-EventService.postman_collection.json
   ```

2. **Configurar Environment:**
   ```
   Environments → SalesOS - Local Development

   supabase_url = https://abc123.supabase.co
   supabase_anon_key = eyJhbGc...
   user_id = <seu-user-id>
   tenant_id = <seu-tenant-id>
   ```

3. **Executar Request:**
   ```
   2. EventService - Eventos de Leads → Lead Criado → Send
   ```

4. **Resultado Esperado:**
   ```json
   "123e4567-e89b-12d3-a456-426614174002"
   ```

### Opção B: Via Código TypeScript

```typescript
import { EventService } from '@/services/EventService';

// Emitir evento de lead criado
const eventId = await EventService.leadCreated({
  tenantId: '123e4567-e89b-12d3-a456-426614174001',
  userId: '123e4567-e89b-12d3-a456-426614174000',
  leadId: 'lead-123',
  leadName: 'João Silva',
  contactEmail: 'joao@exemplo.com',
  contactPhone: '+55 11 99999-9999',
  leadSource: 'website',
});

console.log('Evento criado:', eventId);
// Output: Evento criado: 123e4567-e89b-12d3-a456-426614174002
```

### Opção C: Via cURL

```bash
curl -X POST 'https://abc123.supabase.co/rest/v1/rpc/salesos_emit_event' \
  -H 'apikey: eyJhbGc...' \
  -H 'Authorization: Bearer eyJhbGc...' \
  -H 'Content-Type: application/json' \
  -d '{
    "p_user_id": "123e4567-e89b-12d3-a456-426614174000",
    "p_tenant_id": "123e4567-e89b-12d3-a456-426614174001",
    "p_type": "lead.created",
    "p_domain": "leads",
    "p_payload": {
      "lead_id": "lead-123",
      "lead_name": "João Silva"
    },
    "p_source": "application"
  }'
```

---

## Passo 4: Verificar Evento Criado

### Via Postman

```
4. Queries - Verificação → Listar Eventos Recentes → Send
```

Resultado:
```json
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174002",
    "type": "lead.created",
    "domain": "leads",
    "source": "application",
    "created_at": "2026-01-04T10:30:00.000Z",
    "payload": {
      "lead_id": "lead-123",
      "lead_name": "João Silva"
    }
  }
]
```

### Via SQL

```sql
SELECT
  id,
  type,
  domain,
  source,
  created_at,
  payload
FROM salesos_events
ORDER BY created_at DESC
LIMIT 10;
```

---

## Passo 5: Verificar Workflows Disparados

```sql
SELECT
  wr.id,
  wr.status,
  w.name as workflow_name,
  wr.started_at,
  wr.finished_at
FROM salesos_workflow_runs wr
JOIN salesos_workflows w ON w.id = wr.workflow_id
ORDER BY wr.started_at DESC
LIMIT 10;
```

Resultado esperado:
```
status: completed
workflow_name: Award Points for Lead Created
finished_at: 2026-01-04 10:30:01
```

---

## ⚠️ Troubleshooting

### Erro 403 Forbidden

**Problema:**
```
POST /rest/v1/salesos_events 403 (Forbidden)
```

**Solução:**
Execute no Supabase SQL Editor:

```sql
DROP POLICY IF EXISTS events_insert_via_rpc ON salesos_events;

CREATE POLICY events_insert_allow_all ON salesos_events
FOR INSERT
TO PUBLIC
WITH CHECK (true);
```

**Por quê?**
RLS policy bloqueia INSERTs antes da função SECURITY DEFINER executar. A solução permite INSERTs via RLS, pois a segurança já está na função.

---

## 🎯 Próximos Passos

1. ✅ Emitir outros tipos de eventos:
   - [Lead Events Reference](../api-reference/leads-events.md)
   - [GO Events Reference](../api-reference/go-events.md)

2. ✅ Criar seu primeiro workflow:
   - [Creating Workflows Guide](../guides/creating-workflows.md)

3. ✅ Integrar webhooks externos:
   - [Webhook Integration Guide](../guides/webhook-integration.md)

4. ✅ Entender a arquitetura:
   - [Architecture Overview](../architecture/overview.md)

---

## 📚 Documentação Relacionada

- [API Reference - EventService](../api-reference/eventservice.md)
- [Concepts - Event-Driven Architecture](../concepts/event-driven-architecture.md)
- [Postman Collection Guide](../../postman/README.md)

---

**Dúvidas?** Consulte o [Troubleshooting Guide](../guides/troubleshooting.md)
