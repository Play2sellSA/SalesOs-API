# Workflows & Automação

Automações event-driven que reagem a eventos em tempo real.

---

## 📋 Conceitos

**Workflow** = Automação que:
1. **Escuta** eventos (`lead.created`, `call.completed`, etc.)
2. **Filtra** baseado em condições
3. **Executa** ações (HTTP, email, atribuição, etc.)

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Evento    │ →  │   Workflow   │ →  │    Ação     │
│ lead.created│    │ (se filtros) │    │ Atribuir +  │
│             │    │   passarem   │    │ Notificar   │
└─────────────┘    └──────────────┘    └─────────────┘
```

---

## 🚀 Criar Workflow Básico

### Passo 1: Criar o Workflow

```bash
POST /rest/v1/salesos_workflows
{
  "tenant_id": "tenant-uuid",
  "name": "Atribuir Lead Meta Ads",
  "description": "Atribui leads do Meta para vendedor disponível",
  "is_active": true,
  "priority": 10,
  "max_retries": 3
}
```

**Retorna**: `workflow_id`

### Passo 2: Configurar Trigger

```bash
POST /rest/v1/salesos_workflow_triggers
{
  "workflow_id": "workflow-uuid",
  "event_type": "lead.created",
  "filters": {
    "source": "meta_ads",
    "payload.customer_phone": { "neq": null }
  }
}
```

**Filtros disponíveis**:
- `source`: Origem do evento
- `user_id`: Usuário específico
- `payload.*`: Qualquer campo do payload
- Operadores: `eq`, `neq`, `gt`, `lt`, `in`, `like`

### Passo 3: Definir Ações

```bash
POST /rest/v1/salesos_workflow_runs
{
  "workflow_id": "workflow-uuid",
  "definition": {
    "steps": [
      {
        "key": "atribuir_vendedor",
        "type": "assign_user",
        "config": {
          "strategy": "round_robin",
          "role": "vendedor",
          "fallback_user_id": "manager-uuid"
        }
      },
      {
        "key": "enviar_sms",
        "type": "http_request",
        "config": {
          "url": "https://api.twilio.com/2010-04-01/Accounts/ACCT/Messages.json",
          "method": "POST",
          "auth": "basic",
          "username": "{{env.TWILIO_SID}}",
          "password": "{{env.TWILIO_TOKEN}}",
          "body": {
            "To": "{{payload.customer_phone}}",
            "From": "+551140405050",
            "Body": "Olá {{payload.customer_name}}! Entraremos em contato em breve."
          }
        }
      }
    ]
  }
}
```

---

## 🔧 Tipos de Ação

### 1. HTTP Request

Chamar APIs externas:

```json
{
  "type": "http_request",
  "config": {
    "url": "https://hooks.slack.com/services/...",
    "method": "POST",
    "headers": {
      "Content-Type": "application/json"
    },
    "body": {
      "text": "Novo lead: {{payload.customer_name}}"
    }
  }
}
```

### 2. Assign User (Atribuição)

```json
{
  "type": "assign_user",
  "config": {
    "strategy": "round_robin",  // ou "least_busy", "weighted"
    "role": "vendedor",
    "filters": {
      "status": "active",
      "location": "{{payload.customer_state}}"
    }
  }
}
```

### 3. Update Opportunity

```json
{
  "type": "update_opportunity",
  "config": {
    "opportunity_id": "{{payload.opportunity_id}}",
    "updates": {
      "status": "qualified",
      "priority": "high",
      "assigned_to": "{{steps.atribuir_vendedor.user_id}}"
    }
  }
}
```

### 4. Send Email

```json
{
  "type": "send_email",
  "config": {
    "to": "{{payload.customer_email}}",
    "from": "vendas@play2sell.com",
    "subject": "Bem-vindo ao SalesOS!",
    "template_id": "template-welcome",
    "variables": {
      "customer_name": "{{payload.customer_name}}"
    }
  }
}
```

### 5. Emit Event (Evento em Cadeia)

```json
{
  "type": "emit_event",
  "config": {
    "event_type": "lead.qualified",
    "payload": {
      "opportunity_id": "{{payload.opportunity_id}}",
      "qualified_by": "workflow_automation"
    }
  }
}
```

### 6. Wait / Delay

```json
{
  "type": "wait",
  "config": {
    "duration_seconds": 3600,  // 1 hora
    "until": "{{payload.scheduled_followup_at}}"
  }
}
```

---

## 🎯 Casos de Uso

### 1. Lead Warm-Up (Sequência de Follow-ups)

```json
{
  "steps": [
    { "type": "send_sms", "config": {...}, "wait_after": 3600 },
    { "type": "send_email", "config": {...}, "wait_after": 86400 },
    { "type": "assign_user", "config": {...} }
  ]
}
```

### 2. Escalação Automática

```json
{
  "steps": [
    {
      "type": "conditional",
      "condition": "{{payload.deal_value}} > 100000",
      "then": [
        { "type": "assign_user", "config": { "role": "gerente" } }
      ],
      "else": [
        { "type": "assign_user", "config": { "role": "vendedor" } }
      ]
    }
  ]
}
```

### 3. Integração CRM Externo

```json
{
  "steps": [
    {
      "type": "http_request",
      "config": {
        "url": "https://crm.example.com/api/leads",
        "method": "POST",
        "headers": { "X-API-Key": "{{env.CRM_API_KEY}}" },
        "body": {
          "name": "{{payload.customer_name}}",
          "email": "{{payload.customer_email}}",
          "source": "salesos"
        }
      }
    }
  ]
}
```

---

## ⚙️ Configurações Avançadas

### Retry Policy

```json
{
  "workflow_id": "...",
  "retry_policy": {
    "max_attempts": 3,
    "backoff_ms": 1000,
    "backoff_multiplier": 2
  }
}
```

### Conflict Resolution

Quando múltiplos workflows disparam para o mesmo evento:

```bash
POST /rest/v1/salesos_workflow_conflict_resolutions
{
  "tenant_id": "tenant-uuid",
  "domain": "lead_assignment",
  "event_type": "lead.created",
  "resolution_mode": "highest_priority",  // ou "all", "first"
  "workflow_precedence": [
    "workflow-vip-uuid",
    "workflow-normal-uuid"
  ]
}
```

---

## 📊 Monitoramento

### Ver execuções recentes

```bash
GET /rest/v1/salesos_workflow_runs?
  order=created_at.desc
  &limit=50
```

### Filtrar por status

```bash
GET /rest/v1/salesos_workflow_runs?
  status=eq.failed
  &workflow_id=eq.WORKFLOW_UUID
```

### Ver steps de uma execução

```bash
GET /rest/v1/salesos_workflow_run_steps?
  run_id=eq.RUN_UUID
  &select=*
```

---

## 🐛 Troubleshooting

**Workflow não dispara?**
- ✅ `is_active = true`?
- ✅ Trigger configurado corretamente?
- ✅ Filtros estão passando?

**Action falhou?**
- Ver `salesos_workflow_run_steps` com `status=failed`
- Checar `error_message` e `error_code`

**Performance lenta?**
- Reduzir `max_retries`
- Usar `async` mode para ações HTTP lentas

---

<div align="center">
  <p>
    <a href="webhooks.md">← Webhooks</a> •
    <a href="copilot.md">Copilot IA →</a>
  </p>
</div>
