# 🔗 Integração SwaggerHub + GitHub

Guia completo para sincronizar especificação OpenAPI entre SwaggerHub e GitHub.

---

## 🎯 **Benefícios da Integração**

✅ **Auto-sync bi-direcional**
- Commit no GitHub → Atualiza SwaggerHub automaticamente
- Edita no SwaggerHub → Synca com GitHub

✅ **Versionamento**
- Histórico completo de mudanças via Git
- Pull Requests para revisar alterações

✅ **CI/CD**
- Validação automática da especificação
- Deploy automático para SwaggerHub

✅ **Colaboração**
- Equipe pode editar via GitHub OU SwaggerHub
- Sempre sincronizado

---

## 🚀 **Opção 1: Integração Nativa SwaggerHub** (Mais Fácil)

### **Passo 1: Obter Personal Access Token do GitHub**

1. Acesse: https://github.com/settings/tokens
2. Clique em **"Generate new token (classic)"**
3. Configure:
   ```
   Note: SwaggerHub Integration
   Expiration: No expiration (ou 1 year)

   Scopes:
   ✅ repo (full control)
     ✅ repo:status
     ✅ repo_deployment
     ✅ public_repo
     ✅ repo:invite
   ```
4. Clique em **"Generate token"**
5. **⚠️ COPIE O TOKEN** (você não verá novamente!)

### **Passo 2: Configurar no SwaggerHub**

1. Abra: https://app.swaggerhub.com/apis/play2sell-ecd/salesos-eventservice-api/2.0.0
2. **Settings** → **Integrations**
3. Procure **"GitHub"** → **"Add Integration"**
4. Configure:
   ```
   Integration Name: GitHub Sync
   GitHub Account: play2sell-ecd (ou seu username)
   Repository: SalesOS
   Branch: main
   File Path: docs/openapi/salesos-api.yaml

   Token: <cole o token copiado>

   Sync Settings:
   ✅ Push to GitHub on save
   ✅ Pull from GitHub on change
   ```
5. **Save Integration**

### **Passo 3: Testar**

1. Edite algo no SwaggerHub
2. **Save**
3. Verifique no GitHub: https://github.com/play2sell-ecd/SalesOS/commits/main
4. Deve aparecer um commit do SwaggerHub Bot

---

## ⚙️ **Opção 2: GitHub Actions (CI/CD)** (Mais Controle)

### **Passo 1: Obter SwaggerHub API Key**

1. Acesse: https://app.swaggerhub.com/settings/apiKey
2. Clique em **"Create New API Key"**
3. Configure:
   ```
   Key Name: GitHub Actions CI/CD
   Description: Auto-sync com repositório GitHub
   Expiration: 1 year (ou Never)
   ```
4. **Create Key**
5. **⚠️ COPIE A KEY** (exemplo: `abc123def456...`)

### **Passo 2: Adicionar Secret no GitHub**

1. Acesse: https://github.com/play2sell-ecd/SalesOS/settings/secrets/actions
2. Clique em **"New repository secret"**
3. Configure:
   ```
   Name: SWAGGERHUB_API_KEY
   Value: <cole a API key copiada>
   ```
4. **Add secret**

### **Passo 3: Workflows Já Criados** ✅

Já criei 2 workflows prontos para usar:

#### **Workflow 1: GitHub → SwaggerHub**
```
.github/workflows/sync-swaggerhub.yml
```

**Quando executa:**
- Sempre que você faz commit em `docs/openapi/salesos-api.yaml`
- Pode executar manualmente via GitHub Actions

**O que faz:**
1. Valida a especificação OpenAPI
2. Faz upload para SwaggerHub
3. Publica a versão

#### **Workflow 2: SwaggerHub → GitHub**
```
.github/workflows/pull-from-swaggerhub.yml
```

**Quando executa:**
- Diariamente às 9h UTC (6h BRT)
- Pode executar manualmente via GitHub Actions

**O que faz:**
1. Baixa spec do SwaggerHub
2. Compara com versão local
3. Se houver mudanças, cria commit
4. Se estiver na branch `develop`, cria PR para `main`

### **Passo 4: Testar Workflows**

1. Acesse: https://github.com/play2sell-ecd/SalesOS/actions
2. Selecione **"Sync OpenAPI to SwaggerHub"**
3. Clique em **"Run workflow"**
4. Aguarde execução (leva ~1 min)
5. ✅ Deve aparecer como ✓ Successful

---

## 🔄 **Fluxos de Trabalho**

### **Fluxo 1: Desenvolvedor Edita no Código**

```
1. Dev edita: docs/openapi/salesos-api.yaml
2. Commit & Push para GitHub
3. GitHub Action executa automaticamente
4. Valida spec
5. Atualiza SwaggerHub
6. ✅ SwaggerHub sincronizado!
```

### **Fluxo 2: Product Manager Edita no SwaggerHub**

```
1. PM edita no SwaggerHub UI
2. Save
3. SwaggerHub push para GitHub (via integração nativa)
   OU
   Workflow puxa mudanças diariamente
4. ✅ GitHub sincronizado!
```

### **Fluxo 3: CI/CD Completo**

```
1. Dev cria branch: feature/new-endpoint
2. Edita spec
3. Push
4. GitHub Action valida (mas não publica)
5. Dev abre PR
6. Review da equipe
7. Merge para main
8. GitHub Action publica no SwaggerHub
9. ✅ Versionamento + CI/CD!
```

---

## 📊 **Comparação: Nativa vs GitHub Actions**

| Recurso | Integração Nativa | GitHub Actions |
|---------|-------------------|----------------|
| Setup | ⚡ Rápido (5 min) | 🔧 Médio (10 min) |
| Bi-direcional | ✅ Sim | ✅ Sim (com 2 workflows) |
| Validação | ❌ Não | ✅ Sim |
| CI/CD | ❌ Limitado | ✅ Completo |
| Pull Requests | ❌ Não | ✅ Sim |
| Controle | ⚠️ Básico | ✅ Total |
| Custo | 💰 Grátis | 💰 Grátis |

**Recomendação:** Use **Integração Nativa** se quiser simplicidade, ou **GitHub Actions** se quiser controle total e CI/CD.

---

## 🧪 **Testar Integração**

### **Teste 1: GitHub → SwaggerHub**

```bash
# 1. Editar spec localmente
cd /Users/play2sell/SalesOS
vim docs/openapi/salesos-api.yaml
# (adicione um comentário ou mude a descrição)

# 2. Commit
git add docs/openapi/salesos-api.yaml
git commit -m "test: Update OpenAPI description"
git push

# 3. Verificar no GitHub Actions
# https://github.com/play2sell-ecd/SalesOS/actions

# 4. Verificar no SwaggerHub
# https://app.swaggerhub.com/apis/play2sell-ecd/salesos-eventservice-api/2.0.0
```

### **Teste 2: SwaggerHub → GitHub**

```bash
# 1. Editar no SwaggerHub UI
# Adicione uma descrição em algum endpoint

# 2. Save

# 3. Executar workflow manualmente
# https://github.com/play2sell-ecd/SalesOS/actions
# "Pull OpenAPI from SwaggerHub" → Run workflow

# 4. Verificar commit
git pull
git log --oneline
# Deve aparecer: "🔄 Auto-sync from SwaggerHub"
```

---

## 🆘 **Troubleshooting**

### **Workflow falha com "Invalid API key"**

**Solução:**
1. Verifique secret: https://github.com/play2sell-ecd/SalesOS/settings/secrets/actions
2. Certifique que o nome é exatamente: `SWAGGERHUB_API_KEY`
3. Regere a key no SwaggerHub se necessário

### **SwaggerHub não puxa mudanças do GitHub**

**Solução:**
1. Verifique token do GitHub nas integrações do SwaggerHub
2. Certifique que o token tem permissão `repo`
3. Verifique o path do arquivo está correto

### **Conflitos de merge**

**Solução:**
```bash
# Se editar nos 2 lugares ao mesmo tempo:
git pull
# Resolver conflitos manualmente
git add docs/openapi/salesos-api.yaml
git commit -m "fix: Resolve merge conflict"
git push
```

---

## 📚 **Próximos Passos**

Após configurar integração:

1. ✅ **Branch Protection**
   - Requer PR para `main`
   - Requer aprovação de 1 pessoa
   - Requer CI passar

2. ✅ **CODEOWNERS**
   - Define quem deve revisar mudanças na spec
   ```
   # .github/CODEOWNERS
   docs/openapi/ @seu-username @tech-lead
   ```

3. ✅ **Status Badge**
   - Adicionar badge no README mostrando status do sync
   ```markdown
   ![OpenAPI Sync](https://github.com/play2sell-ecd/SalesOS/workflows/Sync%20OpenAPI%20to%20SwaggerHub/badge.svg)
   ```

---

## 🎓 **Recursos**

| Recurso | Link |
|---------|------|
| SwaggerHub Integrations | https://support.smartbear.com/swaggerhub/docs/integrations/ |
| GitHub Actions Docs | https://docs.github.com/en/actions |
| SwaggerHub CLI | https://www.npmjs.com/package/swaggerhub-cli |

---

**Última atualização:** 2026-01-04
