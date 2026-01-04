# EventService API Reference

API completa para emissão e consulta de eventos no SalesOS.

---

## 📡 **Base URL**

```
Production:   https://api.play2sell.com/rest/v1
Staging:      https://staging-api.play2sell.com/rest/v1
Development:  http://localhost:5173/rest/v1
```

---

## 🔐 **Autenticação**

Todas as requisições requerem Bearer token (Supabase anon key):

```bash
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**Onde obter:**
- Supabase Dashboard → Settings → API → Project API keys

---

## 📤 **Emitir Evento**

### `POST /rpc/salesos_emit_event`

Emite um evento no sistema que pode disparar workflows automaticamente.

#### **Request**

```typescript
interface EmitEventRequest {
  p_user_id: string;        // UUID do usuário (obrigatório)
  p_tenant_id: string;      // UUID do tenant (obrigatório)
  p_type: string;           // Tipo do evento (obrigatório)
  p_domain: string;         // Domínio: "leads" | "go" | "workflows" (obrigatório)
  p_payload: object;        // Dados do evento (obrigatório)
  p_source?: string;        // Origem: "application" | "webhook" | "system"
  p_external_ref?: string;  // Referência externa
  p_points?: number;        // Pontos de gamificação
  p_actor_user_id?: string; // UUID do usuário que executou
}
```

#### **Example**

```bash
curl -X POST 'https://api.play2sell.com/rest/v1/rpc/salesos_emit_event' \
  -H 'apikey: YOUR_ANON_KEY' \
  -H 'Authorization: Bearer YOUR_ANON_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "p_user_id": "123e4567-e89b-12d3-a456-426614174000",
    "p_tenant_id": "123e4567-e89b-12d3-a456-426614174001",
    "p_type": "lead.created",
    "p_domain": "leads",
    "p_payload": {
      "lead_id": "lead-123",
      "lead_name": "João Silva",
      "contact_email": "joao@exemplo.com"
    },
    "p_source": "application"
  }'
```

#### **Response**

```json
"123e4567-e89b-12d3-a456-426614174002"
```

#### **Status Codes**

| Code | Descrição |
|------|-----------|
| `200` | Evento emitido com sucesso |
| `400` | Requisição inválida (parâmetros faltando) |
| `401` | Não autenticado (token inválido) |
| `403` | Sem permissão (RLS policy bloqueou) |
| `429` | Rate limit excedido |
| `500` | Erro interno do servidor |

---

## 📥 **Listar Eventos**

### `GET /salesos_events`

Consulta eventos com filtros e ordenação.

#### **Query Parameters**

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| `select` | string | Campos a retornar | `id,type,created_at` |
| `order` | string | Ordenação | `created_at.desc` |
| `limit` | number | Limite de resultados | `20` |
| `type` | string | Filtro por tipo | `eq.lead.created` |
| `domain` | string | Filtro por domínio | `eq.leads` |
| `user_id` | string | Filtro por usuário | `eq.123e4567...` |

#### **Example**

```bash
curl 'https://api.play2sell.com/rest/v1/salesos_events?select=id,type,created_at&order=created_at.desc&limit=10' \
  -H 'apikey: YOUR_ANON_KEY' \
  -H 'Authorization: Bearer YOUR_ANON_KEY'
```

#### **Response**

```json
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174002",
    "type": "lead.created",
    "created_at": "2026-01-04T10:30:00.000Z"
  },
  {
    "id": "123e4567-e89b-12d3-a456-426614174003",
    "type": "call.completed",
    "created_at": "2026-01-04T10:25:00.000Z"
  }
]
```

---

## 📊 **Agregar Pontos**

### `GET /salesos_events` (com agregação)

Soma total de pontos de um usuário.

#### **Example**

```bash
curl 'https://api.play2sell.com/rest/v1/salesos_events?select=points.sum()&user_id=eq.123e4567...&points=not.is.null' \
  -H 'apikey: YOUR_ANON_KEY' \
  -H 'Authorization: Bearer YOUR_ANON_KEY'
```

#### **Response**

```json
[
  {
    "sum": 6995
  }
]
```

---

## 🔄 **Workflows Disparados**

### `GET /salesos_workflow_runs`

Lista execuções de workflows.

#### **Example**

```bash
curl 'https://api.play2sell.com/rest/v1/salesos_workflow_runs?select=id,status,started_at&order=started_at.desc&limit=10' \
  -H 'apikey: YOUR_ANON_KEY' \
  -H 'Authorization: Bearer YOUR_ANON_KEY'
```

#### **Response**

```json
[
  {
    "id": "wf-run-001",
    "status": "completed",
    "started_at": "2026-01-04T10:30:01.000Z"
  }
]
```

---

## 🎯 **Event Types**

### **Domain: leads**

| Tipo | Pontos | Descrição |
|------|--------|-----------|
| `lead.created` | - | Lead capturado |
| `call.completed` | 10 | Ligação realizada |
| `email.sent` | 5 | Email enviado |
| `whatsapp.sent` | 5 | WhatsApp enviado |
| `visit.scheduled` | 15 | Visita agendada |
| `visit.completed` | 20 | Visita realizada |
| `meeting.completed` | 15 | Reunião realizada |
| `proposal.sent` | 25 | Proposta enviada |

### **Domain: go**

| Tipo | Pontos | Descrição |
|------|--------|-----------|
| `quiz.completed` | variável | Quiz completado (baseado no score) |
| `mission.completed` | variável | Missão completada |

**Referência completa:** [Event Types Catalog](../reference/event-types.md)

---

## 🛡️ **Segurança**

### **Row Level Security (RLS)**

- **SELECT**: Apenas eventos do próprio tenant
- **INSERT**: Apenas via função RPC `salesos_emit_event`
- **UPDATE/DELETE**: Bloqueado

### **Rate Limiting**

- 1000 requests / minuto por IP
- 10000 eventos / dia por tenant

### **SECURITY DEFINER**

A função `salesos_emit_event` executa com permissões elevadas (SECURITY DEFINER), mas valida:
- `user_id` e `tenant_id` são válidos
- Usuário pertence ao tenant
- Campos obrigatórios estão presentes

---

## ⚠️ **Troubleshooting**

### **403 Forbidden ao emitir evento**

**Causa:** RLS policy bloqueando INSERT.

**Solução:**
```sql
DROP POLICY IF EXISTS events_insert_via_rpc ON salesos_events;
CREATE POLICY events_insert_allow_all ON salesos_events FOR INSERT TO PUBLIC WITH CHECK (true);
```

### **400 Bad Request**

**Causa:** Parâmetros obrigatórios faltando.

**Solução:** Verificar se `p_user_id`, `p_tenant_id`, `p_type`, `p_domain` estão presentes.

### **Evento criado mas workflow não dispara**

**Causa:** Nenhum workflow configurado para o evento.

**Verificar:**
```sql
SELECT * FROM salesos_workflow_triggers WHERE event_type = 'lead.created';
```

---

## 📚 **Ver Também**

- [OpenAPI Specification](../openapi/salesos-api.yaml)
- [Lead Events Reference](./leads-events.md)
- [GO Events Reference](./go-events.md)
- [Troubleshooting Guide](../guides/troubleshooting.md)

---

**Última atualização:** 2026-01-04
