# Changelog

Histórico de mudanças da API SalesOS.

---

## v3.0.0 (Janeiro 2026) - Current

### ✨ Novidades

**30 Novos Endpoints REST**:
- Security & API Keys (4)
- Gamificação & Missões (6)
- Users & Context (5)
- Tenants & Plans (7)
- Organizational (2)
- Workflows (4)
- Copilot & Opportunities (2)

**14 Edge Functions Documentadas**:
- `user-context-v2`: Auth0 integration
- `action-consumer`: Queue worker
- `new-lead-stt`: Lead extraction por voz
- `copilot-audio-response`: Pipeline STT→Suggest→TTS
- `copilot-suggest`, `copilot-tts`, `copilot-stt`
- `copilot-feedback`, `generate-embeddings`
- `token_exchange_edge_function`, `switch-tenant`
- `reconcile-user-context`, `workflow-worker`
- `social-auth-callback`

**Portal de Documentação**:
- 📖 Portal completo (Markdown + OpenAPI)
- 🚀 Quickstart funcional (5min)
- 📚 5 guias práticos
- ⚠️ Catálogo de erros
- 🌐 Domínio customizado: docs.play2sell.com

### 📊 Estatísticas

- **140+ endpoints** (126 REST + 14 Edge Functions)
- **100% cobertura** (57/57 tabelas Supabase)
- **13 categorias** organizadas

### 🔄 Migrações

- ✅ SwaggerHub → Redocly
- ❌ Removida API v2.1 (desatualizada)
- ✅ Deploy automático via GitHub Actions

---

## v2.1.0 (Dezembro 2025) - Deprecated

- API básica com 8 endpoints
- Sem Edge Functions documentadas
- **Status**: Removida em v3.0.0

---

## v2.0.0 (Novembro 2025)

- Primeira versão pública
- EventService básico
- Workflows iniciais

---

<div align="center">
  <p>
    <a href="../index.md">← Início</a> •
    <a href="quickstart.md">Quickstart →</a>
  </p>
</div>
