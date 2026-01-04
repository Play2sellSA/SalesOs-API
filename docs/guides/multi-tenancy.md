# Multi-tenancy & RBAC

Gestão de múltiplos tenants, planos, capabilities e controle de acesso.

---

## 🏢 Hierarquia

```
Tenant (Organização)
├─ Plans (Planos contratados)
│  └─ Capabilities (Features disponíveis)
├─ Users (Usuários do tenant)
│  └─ Roles (Papéis/permissões)
└─ Segments (Categorização)
```

---

## 🔑 Capabilities (Feature Flags)

### Listar Capabilities Disponíveis

```bash
GET /rest/v1/salesos_capabilities
```

**Exemplos**:
- `workflows.create`
- `copilot.rag`
- `gamification.quizzes`
- `api.webhooks.incoming`

### Verificar Capabilities do Tenant

```bash
GET /rest/v1/salesos_tenant_entitlements?
  tenant_id=eq.TENANT_UUID
```

**Resposta**:
```json
{
  "modules": ["copilot", "workflows", "gamification"],
  "capabilities": [
    "workflows.create",
    "copilot.rag",
    "gamification.quizzes"
  ]
}
```

### Conceder Capability Específica

```bash
POST /rest/v1/salesos_tenant_capabilities
{
  "tenant_id": "tenant-uuid",
  "capability_id": "capability-uuid",
  "override_type": "grant",
  "source": "manual",
  "reason": "Cliente solicitou feature beta"
}
```

---

## 📦 Planos & Módulos

### Listar Planos

```bash
GET /rest/v1/salesos_plans?
  module_id=eq.MODULE_UUID
  &is_active=eq.true
```

### Atribuir Plano ao Tenant

```bash
POST /rest/v1/salesos_tenant_plans
{
  "tenant_id": "tenant-uuid",
  "plan_id": "plan-pro-uuid",
  "limits": {
    "max_users": 50,
    "max_workflows": 20
  },
  "is_active": true
}
```

---

## 👥 Roles & Permissões

### Criar Role

```bash
POST /rest/v1/salesos_tenant_roles
{
  "tenant_id": "tenant-uuid",
  "role_name": "vendedor",
  "description": "Vendedor padrão",
  "permissions": {
    "leads": ["read", "create", "update"],
    "workflows": ["read"]
  }
}
```

### Atribuir Role ao Usuário

```bash
POST /rest/v1/salesos_user_tenants
{
  "user_id": "user-uuid",
  "tenant_id": "tenant-uuid",
  "role": "vendedor",
  "is_active": true
}
```

---

## 🔄 Trocar Tenant

```bash
POST /functions/v1/switch-tenant
{
  "tenant_id": "new-tenant-uuid"
}
```

**Retorna novo JWT** com `tenant_id` atualizado.

---

<div align="center">
  <p>
    <a href="gamification.md">← Gamificação</a> •
    <a href="../quickstart.md">Quickstart →</a>
  </p>
</div>
