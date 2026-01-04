# 🚀 Quick Start - Postman Collection

Guia rápido para começar a testar o EventService via Postman.

---

## ⚡ **Setup Rápido (5 minutos)**

### 1. **Importar Collection e Environment**

```bash
# No Postman:
# 1. Import → Selecione os 2 arquivos:
#    - SalesOS-Webhooks-EventService.postman_collection.json
#    - SalesOS-Local.postman_environment.json
```

### 2. **Obter Credenciais do Supabase**

```sql
-- Execute no Supabase SQL Editor:

-- Passo 1: Pegar user_id e tenant_id
SELECT
  u.id as user_id,
  ut.tenant_id
FROM salesos_users u
JOIN salesos_user_tenants ut ON ut.user_id = u.id
WHERE u.email = 'felipe@play2sell.com'  -- ⚠️ ALTERE PARA SEU EMAIL
LIMIT 1;
```

```bash
# Passo 2: Pegar supabase_url e supabase_anon_key
# No Supabase Dashboard:
# Settings → API → copie URL e anon key
```

### 3. **Configurar Environment**

No Postman, selecione **SalesOS - Local Development** e preencha:

| Variável | Onde copiar |
|----------|-------------|
| `supabase_url` | Supabase → Settings → API → Project URL |
| `supabase_anon_key` | Supabase → Settings → API → Project API keys (anon) |
| `tenant_id` | Query SQL acima |
| `user_id` | Query SQL acima |

---

## ✅ **Primeiro Teste (2 minutos)**

### 1. **Aplicar fix do RLS** (se ainda não aplicou)

```sql
-- Execute no Supabase SQL Editor:
-- migrations/fix_events_rls_policy_v2.sql

DROP POLICY IF EXISTS events_insert_via_rpc ON salesos_events;

CREATE POLICY events_insert_allow_all ON salesos_events
FOR INSERT
TO PUBLIC
WITH CHECK (true);
```

### 2. **Emitir primeiro evento**

1. No Postman, abra: **2. EventService - Eventos de Leads → Lead Criado**
2. Clique em **Send**
3. Deve retornar: `"uuid-do-evento"`

### 3. **Verificar evento criado**

1. Execute: **4. Queries - Verificação → Listar Eventos Recentes**
2. Deve aparecer o evento com `type = "lead.created"`

---

## 📋 **Testes Recomendados**

### **Teste Completo de Interações (5 min)**

Execute em ordem:

```
2. EventService - Eventos de Leads
  ✅ Lead Criado
  ✅ Ligação Completada
  ✅ Email Enviado
  ✅ WhatsApp Enviado
  ✅ Visita Agendada
  ✅ Visita Completada
  ✅ Reunião Completada
  ✅ Proposta Enviada

4. Queries - Verificação
  📊 Pontos do Usuário → Deve mostrar total de pontos
```

---

## 🔍 **Troubleshooting Rápido**

### ❌ **403 Forbidden**

**Problema:** RLS policy bloqueando INSERT

**Solução:**
```sql
-- Execute no Supabase SQL Editor:
DROP POLICY IF EXISTS events_insert_via_rpc ON salesos_events;
CREATE POLICY events_insert_allow_all ON salesos_events FOR INSERT TO PUBLIC WITH CHECK (true);
```

### ❌ **Invalid API key**

**Problema:** `supabase_anon_key` incorreto

**Solução:**
1. Vá em Supabase Dashboard → Settings → API
2. Copie novamente o **anon/public key**
3. Cole no environment `supabase_anon_key`

### ❌ **Evento criado mas sem pontos**

**Problema:** Payload não tem campo `p_points`

**Solução:**
- Verifique se o request inclui: `"p_points": 10`
- Exemplo: Ligação = 10, Email = 5, Proposta = 25

---

## 🎯 **Próximos Passos**

1. ✅ Testar todos os eventos de leads
2. ✅ Testar eventos de gamificação (Quiz, Missões)
3. ✅ Verificar workflows disparados
4. ✅ Validar pontos acumulados
5. 📖 Ler documentação completa: `README.md`

---

## 📚 **Referências Rápidas**

| O que | Onde |
|-------|------|
| Documentação completa | `postman/README.md` |
| Verificar RLS fix | `migrations/verify_rls_fix.sql` |
| EventService código | `src/services/EventService.ts` |
| Migrations | `migrations/README.md` |

---

**Última atualização:** 2026-01-04
