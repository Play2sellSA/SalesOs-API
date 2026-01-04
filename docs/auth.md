# Autenticação

Guia completo de autenticação OAuth 2.0 com Auth0 e Supabase.

---

## 🔐 Fluxo de Autenticação

```
1. Auth0 (OAuth)  →  2. Token JWT  →  3. Supabase API
   username/password   access_token     Authorization: Bearer
```

---

## 🚀 Obter Token (Password Grant)

```bash
curl -X POST https://salesos.us.auth0.com/oauth/token \
  -H "Content-Type: application/json" \
  -d '{
    "grant_type": "password",
    "username": "seu@email.com",
    "password": "sua-senha",
    "client_id": "SEU_CLIENT_ID",
    "client_secret": "SEU_CLIENT_SECRET",
    "audience": "https://api.play2sell.com",
    "scope": "openid profile email"
  }'
```

**Resposta**:
```json
{
  "access_token": "eyJhbGci....",
  "token_type": "Bearer",
  "expires_in": 86400
}
```

---

## 🔄 Trocar de Tenant

```bash
POST /functions/v1/switch-tenant
{
  "tenant_id": "novo-tenant-uuid"
}
```

Retorna **novo JWT** com tenant atualizado.

---

## ⏱️ Refresh Token

Tokens expiram em 24h. Renove antes de expirar:

```bash
POST https://salesos.us.auth0.com/oauth/token
{
  "grant_type": "refresh_token",
  "client_id": "SEU_CLIENT_ID",
  "refresh_token": "REFRESH_TOKEN"
}
```

---

## 🔑 API Keys (Máquina-a-Máquina)

Para integrações server-side:

```bash
GET /rest/v1/salesos_tenant_api_keys?
  tenant_id=eq.TENANT_UUID
  &status=eq.active
```

Use o header:
```
X-API-Key: sk_live_xxxx
```

---

<div align="center">
  <p>
    <a href="quickstart.md">← Quickstart</a> •
    <a href="errors.md">Erros →</a>
  </p>
</div>
