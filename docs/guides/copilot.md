# Copilot IA - RAG, TTS & STT

Assistente de vendas com IA para sugestões contextualizadas, voz e áudio.

---

## 🤖 Recursos do Copilot

| Recurso | Descrição | Endpoint |
|---------|-----------|----------|
| **Suggest** | Sugestões via RAG | `/functions/v1/copilot-suggest` |
| **TTS** | Text-to-Speech (ElevenLabs) | `/functions/v1/copilot-tts` |
| **STT** | Speech-to-Text (OpenAI Whisper) | `/functions/v1/copilot-stt` |
| **Audio Response** | Pipeline completo STT→Suggest→TTS | `/functions/v1/copilot-audio-response` |
| **Lead STT** | Extração de lead por voz | `/functions/v1/new-lead-stt` |

---

## 💬 Obter Sugestão (RAG)

```bash
POST /functions/v1/copilot-suggest
{
  "session_id": "session-123",
  "user_message": "Como abordar cliente que quer seguro auto completo?",
  "tenant_id": "tenant-uuid",
  "user_id": "user-uuid",
  "context": {
    "opportunity_id": "opp-uuid",
    "customer_profile": "high_intent"
  }
}
```

**Resposta**:
```json
{
  "suggestion": "Para seguro auto completo, recomendo...\n\n1. Confirmar dados do veículo\n2. ...",
  "confidence": 0.92,
  "sources": ["Manual de Vendas - Auto", "FAQ Coberturas"],
  "session_id": "session-123"
}
```

---

## 📚 RAG (Retrieval-Augmented Generation)

### 1. Upload de Documento

```bash
POST /rest/v1/salesos_copilot_documents
{
  "tenant_id": "tenant-uuid",
  "title": "Manual de Vendas - Seguros",
  "content": "Conteúdo do manual...",
  "document_type": "manual",
  "metadata": {
    "category": "seguros",
    "version": "2.0"
  }
}
```

### 2. Gerar Embeddings

```bash
POST /functions/v1/generate-embeddings
{
  "document_id": "doc-uuid"
}
```

Isso divide o documento em chunks e gera embeddings para busca semântica.

### 3. Consultar Documentos

```bash
GET /rest/v1/salesos_copilot_documents?
  tenant_id=eq.TENANT_UUID
  &select=id,title,created_at
```

---

## 🎤 Text-to-Speech (TTS)

Converta texto em áudio com vozes naturais.

```bash
POST /functions/v1/copilot-tts
{
  "text": "Olá! Como posso ajudar você hoje?",
  "voice_id": "rachel",  // ou "adam", "domi", etc.
  "tenant_id": "tenant-uuid"
}
```

**Resposta**:
```json
{
  "audio_base64": "UklGRiQAAABXQVZFZm10IBAAAAABAAEA...",
  "duration_seconds": 3.5,
  "voice_id": "rachel"
}
```

**Uso no frontend**:
```javascript
const audio = new Audio(`data:audio/mp3;base64,${response.audio_base64}`);
audio.play();
```

---

## 🎧 Speech-to-Text (STT)

Transcreva áudio para texto.

```bash
POST /functions/v1/copilot-stt
{
  "audio_base64": "UklGRiQAAABXQVZFZm10...",
  "language": "pt-BR",  // opcional
  "tenant_id": "tenant-uuid"
}
```

**Resposta**:
```json
{
  "transcription": "Gostaria de fazer um orçamento de seguro auto",
  "confidence": 0.95,
  "language": "pt"
}
```

---

## 🔄 Pipeline Completo (Audio → Audio)

Receba áudio, processe com IA, retorne áudio.

```bash
POST /functions/v1/copilot-audio-response
{
  "audio_base64": "UklGRiQAAABX...",
  "session_id": "session-123",
  "tenant_id": "tenant-uuid",
  "user_id": "user-uuid"
}
```

**Fluxo**:
1. **STT**: Áudio → Texto
2. **Suggest**: Texto → Sugestão IA (via RAG)
3. **TTS**: Sugestão → Áudio

**Resposta**:
```json
{
  "transcription": "Como faço para...",
  "suggestion": "Para fazer isso, você deve...",
  "audio_response_base64": "UklGRiQAAABXQVZF...",
  "session_id": "session-123"
}
```

---

## 🎯 Lead Extraction (STT + IA)

Extraia informações de lead de conversas por voz.

```bash
POST /functions/v1/new-lead-stt
{
  "audio_base64": "UklGRiQAAAB...",
  "conversation_history": [],  // mensagens anteriores
  "tenant_id": "tenant-uuid"
}
```

**Resposta**:
```json
{
  "transcription": "Meu nome é João Silva, telefone onze nove nove oito oito sete",
  "extracted_data": {
    "customer_name": "João Silva",
    "customer_phone": "11998870000",  // normalizado
    "confidence": 0.88
  },
  "next_question": "Qual é o seu email?"
}
```

---

## 📊 Feedback Loop

Melhore as sugestões com feedback:

```bash
POST /rest/v1/salesos_copilot_feedback
{
  "session_id": "session-123",
  "suggestion_id": "suggestion-uuid",
  "user_id": "user-uuid",
  "tenant_id": "tenant-uuid",
  "rating": 5,  // 1-5
  "feedback_text": "Sugestão muito útil!"
}
```

---

## 💡 Casos de Uso

### 1. Assistente de Vendas por Voz
- Cliente liga → STT converte
- IA sugere resposta baseada no histórico
- TTS fala a resposta

### 2. Onboarding de Leads por Áudio
- Bot de voz pergunta nome/telefone
- `new-lead-stt` extrai dados
- Lead criado automaticamente

### 3. Treinamento com Quizzes
- Pergunta em áudio (TTS)
- Vendedor responde (STT)
- IA avalia resposta

---

<div align="center">
  <p>
    <a href="workflows.md">← Workflows</a> •
    <a href="gamification.md">Gamificação →</a>
  </p>
</div>
