# 📡 SalesOS API

> Event-driven sales automation platform with gamification

Complete API documentation for integrating with SalesOS - a modern sales automation platform with built-in gamification, workflows, and webhooks.

[![OpenAPI](https://img.shields.io/badge/OpenAPI-3.1.0-green.svg)](https://app.swaggerhub.com/apis/play2sell-ecd/salesos-eventservice-api/2.0.0)
[![License](https://img.shields.io/badge/license-Proprietary-blue.svg)](LICENSE)
[![API Status](https://img.shields.io/badge/status-Production-success.svg)](https://api.play2sell.com)

---

## 🚀 Quick Start

Get up and running in 5 minutes:

```bash
# 1. Get your API credentials
# Visit: https://app.salesos.com/settings/api

# 2. Test the API
curl -X POST 'https://api.play2sell.com/rest/v1/rpc/salesos_emit_event' \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -H 'Content-Type: application/json' \
  -d '{
    "p_user_id": "YOUR_USER_ID",
    "p_tenant_id": "YOUR_TENANT_ID",
    "p_type": "lead.created",
    "p_domain": "leads",
    "p_payload": {
      "lead_name": "John Doe",
      "contact_email": "john@example.com"
    }
  }'
```

**Response:**
```json
"123e4567-e89b-12d3-a456-426614174000"
```

👉 **[Full Quick Start Guide](docs/getting-started/quick-start.md)**

---

## 📚 Documentation

### **API Reference**
- 📖 **[Interactive Docs (Swagger)](https://app.swaggerhub.com/apis/play2sell-ecd/salesos-eventservice-api/2.0.0)** - Try the API live
- 📄 **[OpenAPI Specification](openapi/salesos-api.yaml)** - Download the spec
- 📋 **[Event Types Catalog](docs/event-types.md)** - All available events
- 🔌 **[Webhooks Guide](docs/api-reference/eventservice.md)** - Incoming/Outgoing webhooks

### **Guides**
- 🏃 **[Quick Start](docs/getting-started/quick-start.md)** - 5-minute setup
- 🧪 **[Testing with Postman](postman/README.md)** - Ready-to-use collection
- 🎯 **[Use Cases](docs/examples/)** - Common integration patterns

### **Resources**
- 📦 **[Postman Collection](postman/SalesOS-Webhooks-EventService.postman_collection.json)** - Import and test
- 🔧 **[Code Examples](docs/examples/)** - TypeScript, Python, cURL

---

## 🎯 What Can You Do?

### **EventService** - Emit Events
Trigger workflows by emitting events:

```typescript
import { EventService } from '@salesos/sdk';

// Lead created
await EventService.leadCreated({
  tenantId: 'your-tenant-id',
  userId: 'your-user-id',
  leadId: 'lead-123',
  leadName: 'John Doe',
  leadSource: 'website'
});

// Call completed
await EventService.callCompleted({
  tenantId: 'your-tenant-id',
  userId: 'your-user-id',
  opportunityId: 'opp-456',
  durationSeconds: 180
});
```

### **Webhooks** - Receive Data
Integrate with external platforms:

- 🔵 **Meta Ads** - Auto-capture leads from Facebook/Instagram
- ⚡ **Zapier** - Connect to 5000+ apps
- 🔧 **Custom** - Any system via webhooks

### **Gamification** - Engage Your Team
Built-in points, leaderboard, and achievements:

```javascript
// Get user stats
const stats = await api.getUserStats(userId);
// { total_points: 1250, level: 5, rank_position: 3 }

// Get leaderboard
const leaderboard = await api.getLeaderboard(tenantId);
// [{ user_name: "Alice", total_points: 2500, rank_position: 1 }, ...]
```

---

## 📡 API Endpoints

### **EventService**
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/rpc/salesos_emit_event` | POST | Emit event |
| `/salesos_events` | GET | List events |
| `/rpc/get_events_summary` | POST | Event statistics |

### **Webhooks (Incoming)**
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/webhooks/meta-leads` | POST | Meta Ads leads |
| `/api/webhooks/zapier-leads` | POST | Zapier automation |
| `/api/webhooks/crm-updates` | POST | CRM updates |

### **Gamification**
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/rpc/get_user_stats` | POST | User statistics |
| `/rpc/get_leaderboard` | POST | Top users ranking |
| `/salesos_go_user_achievements` | GET | Achievements |

### **Workflows**
| Endpoint | Method | Description |
|----------|--------|-------------|
| `/salesos_workflows` | GET | List workflows |
| `/salesos_workflow_runs` | GET | Execution history |
| `/rpc/execute_workflow_manual` | POST | Execute manually |

**👉 [Full API Reference](docs/api-reference/eventservice.md)**

---

## 🔐 Authentication

All API requests require a Bearer token:

```bash
Authorization: Bearer YOUR_SUPABASE_ANON_KEY
```

**Get your API key:**
1. Login to SalesOS
2. Settings → API
3. Copy your anon key

---

## 🌍 Environments

| Environment | Base URL | Use For |
|-------------|----------|---------|
| **Production** | `https://api.play2sell.com` | Production apps |
| **Staging** | `https://staging-api.play2sell.com` | Testing |
| **Development** | `http://localhost:5173` | Local dev |

---

## 📦 SDKs & Tools

### **Official SDKs** (Coming Soon)
- 🟦 TypeScript/JavaScript
- 🐍 Python
- 💎 Ruby

### **Community Tools**
- 🧪 **[Postman Collection](postman/)** - Ready-to-use collection
- 📄 **[OpenAPI Spec](openapi/salesos-api.yaml)** - Generate your own SDK

### **Generate SDK**
```bash
# Using OpenAPI Generator
npx @openapitools/openapi-generator-cli generate \
  -i https://raw.githubusercontent.com/play2sell-ecd/SalesOS-API/main/openapi/salesos-api.yaml \
  -g typescript-axios \
  -o ./sdk
```

---

## 🎮 Event Types

### **Leads Domain**
| Event Type | Points | Description |
|------------|--------|-------------|
| `lead.created` | - | New lead captured |
| `call.completed` | 10 | Phone call made |
| `email.sent` | 5 | Email sent |
| `whatsapp.sent` | 5 | WhatsApp message |
| `visit.completed` | 20 | In-person visit |
| `proposal.sent` | 25 | Proposal sent |

### **GO Domain (Gamification)**
| Event Type | Points | Description |
|------------|--------|-------------|
| `quiz.completed` | 0-50 | Training quiz |
| `mission.completed` | Variable | Mission accomplished |

**👉 [Complete Event Types Catalog](docs/event-types.md)**

---

## 🔌 Webhooks

### **Incoming Webhooks**
Receive data from external platforms:

```javascript
// Meta Ads webhook handler
app.post('/api/webhooks/meta-leads', async (req, res) => {
  const { entry } = req.body;
  const leadData = entry[0].changes[0].value;

  // Process lead
  await EventService.leadCreated({
    // ... lead data
  });

  res.send('OK');
});
```

### **Outgoing Webhooks**
Send notifications to external systems via Workflow Actions.

**👉 [Webhooks Guide](postman/README.md)**

---

## 💡 Examples

### **Create Lead from Form Submission**

```typescript
import { EventService } from '@salesos/sdk';

app.post('/api/contact', async (req, res) => {
  const { name, email, phone } = req.body;

  // Emit event
  const eventId = await EventService.leadCreated({
    tenantId: process.env.TENANT_ID,
    userId: process.env.DEFAULT_USER_ID,
    leadName: name,
    contactEmail: email,
    contactPhone: phone,
    leadSource: 'website'
  });

  res.json({ success: true, eventId });
});
```

### **Track Sales Activity**

```typescript
// Log phone call
await EventService.callCompleted({
  tenantId: 'tenant-id',
  userId: 'user-id',
  opportunityId: 'opp-123',
  durationSeconds: 300,
  notes: 'Client interested in product X'
});

// Send proposal
await EventService.proposalSent({
  tenantId: 'tenant-id',
  userId: 'user-id',
  opportunityId: 'opp-123',
  proposalValue: 50000,
  terms: 'Net 30'
});
```

**👉 [More Examples](docs/examples/)**

---

## 🚦 Rate Limits

| Limit | Value |
|-------|-------|
| Requests per minute | 1,000 |
| Events per day (per tenant) | 10,000 |
| Webhook requests per minute | 100 |

**Need higher limits?** Contact [sales@play2sell.com](mailto:sales@play2sell.com)

---

## 🆘 Support

### **Resources**
- 📖 **[API Documentation](https://app.swaggerhub.com/apis/play2sell-ecd/salesos-eventservice-api/2.0.0)**
- 🧪 **[Postman Collection](postman/)**
- 💬 **[Discord Community](#)** (Coming Soon)

### **Contact**
- 📧 Email: [dev@play2sell.com](mailto:dev@play2sell.com)
- 🐛 Issues: [GitHub Issues](https://github.com/play2sell-ecd/SalesOS-API/issues)
- 💼 Sales: [sales@play2sell.com](mailto:sales@play2sell.com)

---

## 📄 License

Proprietary - © 2026 Play2Sell

---

## 🔗 Links

- 🌐 **[Website](https://salesos.com)**
- 📊 **[Status Page](https://status.salesos.com)**
- 📖 **[Full Documentation](https://docs.salesos.com)**
- 🔧 **[Developer Portal](https://developers.salesos.com)**

---

**Made with ❤️ by [Play2Sell](https://play2sell.com)**
