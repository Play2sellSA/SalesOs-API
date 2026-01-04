# Gamificação & Missões

Sistema de pontos, quizzes e missões para engajamento de vendas.

---

## 🎮 Componentes

| Componente | Descrição | Tabelas |
|------------|-----------|---------|
| **Pontos** | XP por eventos | `salesos_event_points_config`, `salesos_user_scores` |
| **Missões** | Metas diárias/semanais | `salesos_mission_definitions`, `salesos_user_missions` |
| **Quizzes** | Treinamento gamificado | `salesos_go_quizzes`, `salesos_go_quiz_questions`, `salesos_go_quiz_attempts` |

---

## ⭐ Sistema de Pontos

### Configurar Pontos por Evento

```bash
POST /rest/v1/salesos_event_points_config
{
  "tenant_id": null,  // null = global, UUID = tenant específico
  "event_type": "lead.created",
  "points": 10,
  "description": "Criar novo lead",
  "is_active": true
}
```

**Eventos comuns**:
- `lead.created`: 10 pts
- `call.completed`: 5 pts
- `deal.won`: 100 pts
- `checkin.registered`: 2 pts

### Consultar Score do Usuário

```bash
GET /rest/v1/salesos_user_scores?
  user_id=eq.USER_UUID
  &tenant_id=eq.TENANT_UUID
```

---

## 🎯 Missões

### Criar Missão

```bash
POST /rest/v1/salesos_mission_definitions
{
  "tenant_id": "tenant-uuid",
  "key": "daily_calls_10",
  "name": "10 Ligações Hoje",
  "description": "Faça 10 ligações hoje e ganhe 50 pontos",
  "category": "calls",
  "trigger_events": ["call.completed"],
  "target_count": 10,
  "points_reward": 50,
  "period_type": "daily",  // ou "weekly", "monthly"
  "is_active": true
}
```

### Progresso do Usuário

```bash
GET /rest/v1/salesos_user_missions?
  user_id=eq.USER_UUID
  &status=eq.active
```

**Resposta**:
```json
[
  {
    "id": "mission-uuid",
    "mission_definition_id": "def-uuid",
    "current_count": 7,
    "target_count": 10,
    "status": "active",
    "period_start": "2026-01-04",
    "period_end": "2026-01-04"
  }
]
```

---

## 📝 Quizzes (SalesOS GO)

### Criar Quiz

```bash
POST /rest/v1/salesos_go_quizzes
{
  "tenant_id": "tenant-uuid",
  "name": "Produtos - Seguro Auto",
  "description": "Quiz sobre coberturas de seguro auto",
  "status": "published",
  "xp_reward": 100,
  "passing_score": 70,
  "time_limit_seconds": 30
}
```

### Adicionar Questões

```bash
POST /rest/v1/salesos_go_quiz_questions
{
  "quiz_id": "quiz-uuid",
  "question_text": "Qual cobertura é obrigatória?",
  "question_type": "multiple_choice",
  "options": ["RCF-V", "Colisão", "Roubo", "Vidros"],
  "correct_option_index": 0,
  "feedback_correct": "Correto! RCF-V é obrigatória por lei.",
  "difficulty_level": 2,
  "xp_value": 10
}
```

### Iniciar Tentativa

```bash
POST /rest/v1/salesos_go_quiz_attempts
{
  "quiz_id": "quiz-uuid",
  "user_id": "user-uuid",
  "tenant_id": "tenant-uuid",
  "total_questions": 10
}
```

### Enviar Respostas

```bash
PATCH /rest/v1/salesos_go_quiz_attempts?id=eq.ATTEMPT_UUID
{
  "answers": [
    {"question_id": "q1", "selected_index": 0, "correct": true},
    {"question_id": "q2", "selected_index": 2, "correct": false}
  ],
  "correct_answers": 8,
  "score": 80,
  "xp_earned": 80,
  "status": "completed",
  "completed_at": "2026-01-04T10:30:00Z"
}
```

---

## 🏆 Rankings

```bash
GET /rest/v1/salesos_user_scores?
  tenant_id=eq.TENANT_UUID
  &order=total_score.desc
  &limit=10
```

---

<div align="center">
  <p>
    <a href="copilot.md">← Copilot IA</a> •
    <a href="multi-tenancy.md">Multi-tenancy →</a>
  </p>
</div>
