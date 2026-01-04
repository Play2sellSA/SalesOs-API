# 📋 Event Types Catalog

Catálogo completo de todos os tipos de eventos disponíveis no SalesOS.

---

## 🎯 **Domain: leads**

Eventos relacionados ao ciclo de vida de oportunidades de venda.

### **lead.created**

Emitido quando um novo lead é capturado no sistema.

```typescript
await EventService.leadCreated({
  tenantId: string,
  userId: string,
  leadId: string,
  leadName: string,
  contactEmail?: string,
  contactPhone?: string,
  leadSource: string,
});
```

**Payload:**
```json
{
  "lead_id": "lead-123",
  "lead_name": "João Silva",
  "contact_email": "joao@exemplo.com",
  "contact_phone": "+55 11 99999-9999",
  "lead_source": "website"
}
```

**Pontos:** Nenhum (configurável via workflow)
**Workflows Comuns:** Atribuir lead a vendedor, Enviar email de boas-vindas

---

### **call.completed**

Emitido após uma ligação telefônica com o lead.

```typescript
await EventService.callCompleted({
  tenantId: string,
  userId: string,
  opportunityId: string,
  durationSeconds?: number,
  notes?: string,
});
```

**Payload:**
```json
{
  "opportunity_id": "opp-456",
  "duration_seconds": 180,
  "notes": "Cliente demonstrou interesse em apartamento 2 quartos"
}
```

**Pontos:** 10 pontos
**Workflows Comuns:** Atualizar score do lead, Agendar follow-up

---

### **email.sent**

Emitido quando um email é enviado ao lead.

```typescript
await EventService.emailSent({
  tenantId: string,
  userId: string,
  opportunityId: string,
  recipient: string,
  subject?: string,
});
```

**Payload:**
```json
{
  "opportunity_id": "opp-456",
  "recipient": "cliente@exemplo.com",
  "subject": "Proposta Comercial - Residencial Vista Verde"
}
```

**Pontos:** 5 pontos
**Workflows Comuns:** Registrar interação, Agendar follow-up

---

### **whatsapp.sent**

Emitido quando uma mensagem WhatsApp é enviada.

```typescript
await EventService.whatsappSent({
  tenantId: string,
  userId: string,
  opportunityId: string,
  recipient: string,
  messagePreview?: string,
});
```

**Payload:**
```json
{
  "opportunity_id": "opp-456",
  "recipient": "+55 11 99999-9999",
  "message_preview": "Olá! Tudo bem? Gostaria de agendar..."
}
```

**Pontos:** 5 pontos
**Workflows Comuns:** Registrar interação

---

### **visit.scheduled**

Emitido quando uma visita é agendada com o lead.

```typescript
await EventService.visitScheduled({
  tenantId: string,
  userId: string,
  opportunityId: string,
  scheduledDate: string,
  location?: string,
});
```

**Payload:**
```json
{
  "opportunity_id": "opp-456",
  "scheduled_date": "2026-01-10T14:00:00Z",
  "location": "Residencial Vista Verde - Av. Paulista, 1000"
}
```

**Pontos:** 15 pontos
**Workflows Comuns:** Enviar lembrete, Atualizar pipeline

---

### **visit.completed**

Emitido após a conclusão de uma visita.

```typescript
await EventService.visitCompleted({
  tenantId: string,
  userId: string,
  opportunityId: string,
  outcome?: string,
  nextSteps?: string,
});
```

**Payload:**
```json
{
  "opportunity_id": "opp-456",
  "outcome": "Cliente gostou muito, vai pensar e dar retorno",
  "next_steps": "Enviar proposta formal em 48h"
}
```

**Pontos:** 20 pontos
**Workflows Comuns:** Criar tarefa follow-up, Atualizar score

---

### **meeting.completed**

Emitido após reunião com o lead.

```typescript
await EventService.meetingCompleted({
  tenantId: string,
  userId: string,
  opportunityId: string,
  durationMinutes?: number,
  notes?: string,
});
```

**Payload:**
```json
{
  "opportunity_id": "opp-456",
  "duration_minutes": 45,
  "notes": "Reunião produtiva. Cliente quer condições especiais de pagamento."
}
```

**Pontos:** 15 pontos
**Workflows Comuns:** Criar tarefa para proposta, Notificar gerente

---

### **proposal.sent**

Emitido quando uma proposta comercial é enviada.

```typescript
await EventService.proposalSent({
  tenantId: string,
  userId: string,
  opportunityId: string,
  proposalValue?: number,
  terms?: string,
});
```

**Payload:**
```json
{
  "opportunity_id": "opp-456",
  "proposal_value": 850000,
  "terms": "Entrada 30% + 70% financiamento em 360 meses"
}
```

**Pontos:** 25 pontos
**Workflows Comuns:** Agendar follow-up, Notificar gerente, Atualizar CRM

---

## 🎮 **Domain: go** (Gamificação)

Eventos relacionados ao sistema de gamificação.

### **quiz.completed**

Emitido quando um usuário completa um quiz de treinamento.

```typescript
await EventService.quizCompleted({
  tenantId: string,
  userId: string,
  quizId: string,
  score: number,
  correctAnswers: number,
  totalQuestions: number,
});
```

**Payload:**
```json
{
  "quiz_id": "quiz-789",
  "score": 85,
  "correct_answers": 17,
  "total_questions": 20,
  "xp_earned": 42
}
```

**Pontos:** Variável (baseado no score)
- Score < 50%: 0 pontos
- Score 50-70%: 20 pontos
- Score 70-85%: 35 pontos
- Score 85-95%: 42 pontos
- Score > 95%: 50 pontos

**Workflows Comuns:** Atualizar XP, Desbloquear conquistas, Atualizar ranking

---

### **mission.completed**

Emitido quando uma missão é completada.

```typescript
await EventService.missionCompleted({
  tenantId: string,
  userId: string,
  missionId: string,
  missionName: string,
  rewardXp?: number,
});
```

**Payload:**
```json
{
  "mission_id": "mission-daily-001",
  "mission_name": "Primeira Venda do Mês",
  "reward_xp": 100
}
```

**Pontos:** Variável (configurado na missão)
**Workflows Comuns:** Atualizar XP, Desbloquear próxima missão, Enviar notificação

---

## 🔄 **Domain: workflows** (Sistema Interno)

Eventos internos do sistema de workflows.

### **workflow.started**

Emitido quando um workflow inicia execução.

**Uso Interno:** Gerado automaticamente pelo sistema.

---

### **workflow.completed**

Emitido quando um workflow termina com sucesso.

**Uso Interno:** Gerado automaticamente pelo sistema.

---

### **workflow.failed**

Emitido quando um workflow falha.

**Uso Interno:** Gerado automaticamente pelo sistema.

---

## 📊 **Resumo de Pontos**

| Evento | Pontos | Domínio |
|--------|--------|---------|
| lead.created | 0 | leads |
| call.completed | 10 | leads |
| email.sent | 5 | leads |
| whatsapp.sent | 5 | leads |
| visit.scheduled | 15 | leads |
| visit.completed | 20 | leads |
| meeting.completed | 15 | leads |
| proposal.sent | 25 | leads |
| quiz.completed | 0-50 | go |
| mission.completed | variável | go |

---

## 🎯 **Próximos Eventos (Roadmap)**

### **v2.1**
- `deal.won` - Venda fechada
- `deal.lost` - Venda perdida
- `contract.signed` - Contrato assinado

### **v2.2**
- `achievement.unlocked` - Conquista desbloqueada
- `level.up` - Subiu de nível
- `badge.earned` - Badge ganho

---

## 📚 **Ver Também**

- [API Reference](../api-reference/eventservice.md)
- [Workflow Actions](./workflow-actions.md)
- [Points & Rewards System](./points-rewards.md)

---

**Última atualização:** 2026-01-04
**Versão:** 2.0.0
