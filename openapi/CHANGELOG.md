# 📝 OpenAPI Changelog

Histórico de mudanças na especificação da API.

---

## v2.1.0 (2026-01-04) - Especificação Completa ⭐

### ✨ **Novos Endpoints Adicionados**

#### **Webhooks Incoming (3 endpoints)**
- ✅ `POST /api/webhooks/meta-leads` - Receber leads do Meta Ads
- ✅ `POST /api/webhooks/zapier-leads` - Receber leads do Zapier
- ✅ `POST /api/webhooks/crm-updates` - Receber atualizações de CRM

#### **Queries - Events (2 endpoints)**
- ✅ `GET /rest/v1/salesos_events` - Listar eventos (expandido com mais filtros)
- ✅ `POST /rest/v1/rpc/get_events_summary` - Resumo/estatísticas de eventos

#### **Queries - Workflows (3 endpoints)**
- ✅ `GET /rest/v1/salesos_workflows` - Listar workflows
- ✅ `GET /rest/v1/salesos_workflow_runs` - Listar execuções
- ✅ `GET /rest/v1/salesos_workflow_triggers` - Listar triggers

#### **Gamificação - GO (3 endpoints)**
- ✅ `POST /rest/v1/rpc/get_user_stats` - Estatísticas do usuário (pontos, XP, rank)
- ✅ `POST /rest/v1/rpc/get_leaderboard` - Ranking (leaderboard)
- ✅ `GET /rest/v1/salesos_go_user_achievements` - Conquistas desbloqueadas

#### **Workflow Management (3 endpoints)**
- ✅ `POST /rest/v1/rpc/create_workflow` - Criar workflow
- ✅ `POST /rest/v1/rpc/update_workflow` - Atualizar workflow
- ✅ `POST /rest/v1/rpc/execute_workflow_manual` - Executar manualmente

#### **Admin (3 endpoints)**
- ✅ `GET /rest/v1/salesos_users` - Listar usuários
- ✅ `GET /rest/v1/salesos_tenants` - Listar tenants
- ✅ `GET /rest/v1/salesos_user_tenants` - Relação user-tenant

### 📊 **Estatísticas**

```
Total de Endpoints: 20+
  - EventService: 1
  - Webhooks Incoming: 3
  - Queries (Events): 2
  - Queries (Workflows): 3
  - Gamification: 3
  - Workflow Management: 3
  - Admin: 3
  - (v2.0: 2 endpoints)

Tags: 7
Schemas: 5
Security Schemes: 3
```

### 🔐 **Novos Security Schemes**

- ✅ `webhookSecret` - Para validação de webhooks incoming
- ✅ `zapierSecret` - Para webhooks do Zapier

### 📝 **Melhorias**

- ✅ Descrições expandidas em todos os endpoints
- ✅ Exemplos de request/response completos
- ✅ Parâmetros reutilizáveis (SelectParam, OrderParam, LimitParam)
- ✅ Responses padronizadas (Forbidden, InternalError)
- ✅ Validação de assinaturas de webhooks documentada

---

## v2.0.0 (2026-01-04) - Versão Inicial

### ✨ **Primeira Versão**

- ✅ `POST /rest/v1/rpc/salesos_emit_event` - Emitir eventos
- ✅ `GET /rest/v1/salesos_events` - Listar eventos (básico)
- ✅ `GET /rest/v1/salesos_workflow_runs` - Listar workflow runs
- ✅ Schemas: EmitEventRequest, Event, WorkflowRun, Error
- ✅ Security: Bearer Auth (Supabase)
- ✅ 10+ exemplos de eventos (lead.created, call.completed, etc.)

---

## 📈 **Roadmap**

### v2.2.0 (Planejado)
- 🔲 Endpoints de notificações
- 🔲 Endpoints de relatórios
- 🔲 Webhooks outgoing (callbacks)
- 🔲 Batch operations

### v3.0.0 (Futuro)
- 🔲 GraphQL API
- 🔲 WebSocket para real-time
- 🔲 Rate limiting detalhado

---

## 🔄 **Como Atualizar**

### **Automático (SwaggerHub)**
```bash
cd docs/openapi
./publish-swaggerhub.sh
```

### **Manual**
1. Acesse: https://app.swaggerhub.com/apis/play2sell-ecd/salesos-eventservice-api/2.0.0
2. Edit → Import → Selecione `salesos-api.yaml`
3. Save

---

**Última atualização:** 2026-01-04
