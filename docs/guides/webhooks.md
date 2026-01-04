# Webhooks & Eventos

Guia completo para integrar webhooks externos (Meta Ads, Zapier, CRMs) e trabalhar com o EventService.

---

## 📋 Visão Geral

O SalesOS suporta webhooks **bidirecionais**:

<table>
  <tr>
    <td><strong>🔵 Incoming Webhooks</strong></td>
    <td>Receber eventos de sistemas externos</td>
    <td>Meta Ads, Zapier, RD Station, etc.</td>
  </tr>
  <tr>
    <td><strong>🟢 Outgoing Actions</strong></td>
    <td>Enviar dados para sistemas externos</td>
    <td>Via workflow actions (HTTP POST)</td>
  </tr>
  <tr>
    <td><strong>⚡ EventService</strong></td>
    <td>Hub central que processa todos os eventos</td>
    <td>Alimenta workflows, gamification, analytics</td>
  </tr>
</table>

---

## 🔵 Incoming Webhooks

### 1. Meta Ads Lead Ads

Receba leads do Facebook/Instagram automaticamente.

**Endpoint**: `POST /webhooks/meta-ads`

**Configuração no Meta**:
1. Acesse Business Manager → Configurações de Eventos
2. Configure webhook URL: `https://api.play2sell.com/webhooks/meta-ads`
3. Token de verificação: (fornecido pelo suporte)
4. Eventos subscritos: `leadgen`

**Payload recebido**:

```json
{
  "entry": [
    {
      "id": "page-id-123",
      "time": 1704369600,
      "changes": [
        {
          "field": "leadgen",
          "value": {
            "leadgen_id": "987654321",
            "page_id": "page-id-123",
            "form_id": "form-id-456",
            "adgroup_id": "adgroup-789",
            "ad_id": "ad-012",
            "created_time": 1704369600
          }
        }
      ]
    }
  ]
}
```

**O que acontece automaticamente**:
1. ✅ SalesOS busca dados completos do lead na Graph API
2. ✅ Cria oportunidade em `salesos_opportunities`
3. ✅ Emite evento `lead.created` no EventService
4. ✅ Dispara workflows configurados (ex: atribuição)
5. ✅ Atribui pontos de gamificação

**Dados extraídos do lead**:
- Nome completo
- Email
- Telefone
- Campos customizados (pergunta_1, pergunta_2, etc.)

---

### 2. Zapier Integration

Conecte qualquer ferramenta via Zapier.

**Endpoint**: `POST /webhooks/zapier`

**Setup no Zapier**:
1. Trigger: Qualquer app (ex: Google Forms, Typeform)
2. Action: Webhooks by Zapier → POST
3. URL: `https://api.play2sell.com/webhooks/zapier`
4. Headers:
   ```
   Content-Type: application/json
   Authorization: Bearer SEU_TOKEN
   ```

**Payload exemplo**:

```json
{
  "event_type": "lead.created",
  "source": "zapier_typeform",
  "customer_name": "Maria Santos",
  "customer_email": "maria@example.com",
  "customer_phone": "11988776655",
  "custom_fields": {
    "company": "Acme Corp",
    "interest": "Seguro Auto"
  }
}
```

**Mapeamento de campos**:
- `customer_name` → Obrigatório
- `customer_email` ou `customer_phone` → Pelo menos 1
- `source` → Identificador da origem
- `custom_fields` → Metadados adicionais

---

### 3. Webhook Genérico (HTTP POST)

Para qualquer sistema que envie HTTP POST.

**Endpoint**: `POST /webhooks/generic`

**Headers obrigatórios**:
```http
Content-Type: application/json
X-Tenant-ID: seu-tenant-uuid
X-Webhook-Secret: secret-compartilhado
```

**Payload mínimo**:

```json
{
  "event_type": "lead.created",
  "customer_name": "João Silva",
  "customer_phone": "11999887766"
}
```

**Validação de segurança**:
- ✅ HMAC signature no header `X-Webhook-Signature`
- ✅ Verificação de `X-Webhook-Secret`
- ✅ Rate limit: 100 req/min por endpoint

**Gerar signature (exemplo Node.js)**:

```javascript
const crypto = require('crypto');

function generateSignature(payload, secret) {
  return crypto
    .createHmac('sha256', secret)
    .update(JSON.stringify(payload))
    .digest('hex');
}

// Uso
const signature = generateSignature(payload, 'seu-secret');
headers['X-Webhook-Signature'] = signature;
```

---

## ⚡ EventService

O EventService é o coração do SalesOS. **Todos os eventos** passam por ele.

### Emitir Evento Customizado

**Endpoint**: `POST /functions/v1/emit-event`

```bash
curl -X POST https://api.play2sell.com/functions/v1/emit-event \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "event_type": "proposal.sent",
    "user_id": "user-uuid",
    "tenant_id": "tenant-uuid",
    "payload": {
      "opportunity_id": "opp-uuid",
      "proposal_value": 50000,
      "proposal_type": "standard"
    },
    "source": "crm_integration",
    "points": 25
  }'
```

**Parâmetros**:
- `event_type`: Tipo do evento (ex: `lead.created`, `call.completed`)
- `user_id`: UUID do usuário que gerou o evento
- `tenant_id`: UUID do tenant
- `payload`: Dados customizados (JSON)
- `source`: Origem do evento (opcional)
- `points`: Pontos de gamificação (opcional)

---

### Tipos de Evento Padrão

| Event Type | Quando Disparar | Payload Esperado |
|------------|-----------------|------------------|
| `lead.created` | Novo lead capturado | `customer_name`, `customer_email/phone` |
| `lead.qualified` | Lead qualificado para vendas | `opportunity_id`, `qualification_score` |
| `call.completed` | Ligação finalizada | `duration_seconds`, `call_outcome` |
| `proposal.sent` | Proposta enviada | `proposal_value`, `proposal_type` |
| `deal.won` | Venda fechada | `deal_value`, `product_id` |
| `deal.lost` | Oportunidade perdida | `loss_reason` |
| `checkin.registered` | Check-in em localização | `location_id`, `latitude`, `longitude` |
| `mission.completed` | Missão concluída | `mission_id`, `reward_points` |

[Ver todos os event types →](../event-types.md)

---

### Consultar Eventos

**Listar eventos recentes**:

```bash
GET /rest/v1/salesos_events?
  select=*
  &order=created_at.desc
  &limit=50
```

**Filtrar por tipo**:

```bash
GET /rest/v1/salesos_events?
  event_type=eq.lead.created
  &created_at=gte.2026-01-01
```

**Buscar eventos de um usuário**:

```bash
GET /rest/v1/salesos_events?
  user_id=eq.USER_UUID
  &tenant_id=eq.TENANT_UUID
```

---

## 🟢 Outgoing Actions (via Workflows)

Envie dados para sistemas externos quando eventos ocorrem.

### Exemplo: Notificar Slack quando lead chega

**1. Crie um workflow**:

```bash
POST /rest/v1/salesos_workflows
{
  "tenant_id": "tenant-uuid",
  "name": "Notificar Slack - Novo Lead",
  "description": "Envia mensagem no Slack quando lead é criado",
  "is_active": true,
  "priority": 5
}
```

**2. Configure o trigger**:

```bash
POST /rest/v1/salesos_workflow_triggers
{
  "workflow_id": "workflow-uuid",
  "event_type": "lead.created",
  "filters": {
    "source": "meta_ads"
  }
}
```

**3. Adicione ação HTTP**:

```bash
POST /rest/v1/salesos_workflow_runs
{
  "workflow_id": "workflow-uuid",
  "definition": {
    "steps": [
      {
        "type": "http_request",
        "config": {
          "url": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
          "method": "POST",
          "headers": {
            "Content-Type": "application/json"
          },
          "body": {
            "text": "🎯 Novo Lead: {{payload.customer_name}}",
            "blocks": [
              {
                "type": "section",
                "text": {
                  "type": "mrkdwn",
                  "text": "*Nome:* {{payload.customer_name}}\n*Telefone:* {{payload.customer_phone}}\n*Origem:* Meta Ads"
                }
              }
            ]
          }
        }
      }
    ]
  }
}
```

**Variáveis disponíveis**:
- `{{payload.*}}`: Dados do evento
- `{{user_id}}`: UUID do usuário
- `{{tenant_id}}`: UUID do tenant
- `{{event_type}}`: Tipo do evento

---

## 🔧 Debugging & Monitoramento

### Ver logs de webhooks

```bash
# Últimos 100 webhooks recebidos
GET /rest/v1/salesos_events?
  source=like.*webhook*
  &order=created_at.desc
  &limit=100
```

### Webhook falhou?

**Verificar**:
1. Payload está no formato JSON válido?
2. Headers obrigatórios estão presentes?
3. Signature HMAC está correta?
4. Rate limit não foi excedido?

**Logs de erro**:

```bash
# Ver eventos com erro
GET /rest/v1/salesos_workflow_runs?
  status=eq.failed
  &order=created_at.desc
```

---

## 💡 Casos de Uso Comuns

### 1. Lead do Facebook → CRM Externo

**Fluxo**:
1. Meta Ads dispara webhook → SalesOS
2. SalesOS cria oportunidade
3. Workflow envia para CRM (via HTTP POST)

### 2. Typeform → Atribuição Automática

**Fluxo**:
1. Typeform → Zapier → SalesOS webhook
2. SalesOS emite `lead.created`
3. Workflow atribui lead para vendedor (round-robin)

### 3. Sincronizar eventos para Analytics

**Fluxo**:
1. Qualquer evento no SalesOS
2. Workflow envia para Google Analytics / Mixpanel
3. Dashboard atualizado em tempo real

---

## 📞 Suporte

- 📧 Configuração de webhooks: dev@play2sell.com
- 🔐 Solicitar webhook secrets: (incluir tenant_id)
- 🐛 Reportar falhas: GitHub Issues

---

<div align="center">
  <p>
    <a href="../quickstart.md">← Quickstart</a> •
    <a href="workflows.md">Workflows →</a>
  </p>
</div>
