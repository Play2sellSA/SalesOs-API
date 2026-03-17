# SalesOS Default Integration API

> Send numbered activities (001-999) from any CRM or external system to SalesOS.

[![OpenAPI](https://img.shields.io/badge/OpenAPI-3.1.0-green.svg)](https://play2sellsa.github.io/SalesOs-API/)
[![License](https://img.shields.io/badge/license-Proprietary-blue.svg)](LICENSE)
[![API Status](https://img.shields.io/badge/status-Production-success.svg)](https://api.play2sell.com)

---

## Overview

The Default Integration allows you to connect **any CRM or external system** to SalesOS — even without a dedicated integration. You send numbered activities (001-999) via a single REST endpoint, and your team maps them to SalesOS missions in the Dashboard.

**Endpoint:** `POST /functions/v1/default-integration`

**Two actions:**
- `sync_collaborators` — Register your sales team
- `sync_activities` — Send activity events (phone calls, meetings, proposals, etc.)

---

## Quick Start

### 1. Get your API Key

Go to **Admin > Integrations > API Keys** in the SalesOS Dashboard. Create a key with scope `default:sync`.

### 2. Register your team

```bash
curl -X POST https://api.play2sell.com/functions/v1/default-integration \
  -H "Authorization: Bearer sk_live_YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "sync_collaborators",
    "collaborators": [
      {
        "external_id": "emp-101",
        "name": "Maria Santos",
        "email": "maria@yourcompany.com",
        "team": "Sales Team A",
        "role": "sales_rep"
      }
    ]
  }'
```

**Response:**
```json
{
  "data": { "created": 1, "existing": 0, "errors": [], "total": 1 },
  "meta": { "request_id": "f47ac10b-...", "timestamp": "2026-03-17T10:00:00.000Z" }
}
```

### 3. Send activities

```bash
curl -X POST https://api.play2sell.com/functions/v1/default-integration \
  -H "Authorization: Bearer sk_live_YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "action": "sync_activities",
    "activities": [
      {
        "activity_code": "001",
        "external_id": "crm-call-5001",
        "collaborator_email": "maria@yourcompany.com",
        "data": { "client": "Acme Corp", "duration_min": 12 },
        "occurred_at": "2026-03-17T09:15:00-03:00"
      }
    ]
  }'
```

**Response:**
```json
{
  "data": { "processed": 1, "skipped": 0, "duplicates": 0, "errors": [], "total": 1 },
  "meta": { "request_id": "c3d4e5f6-...", "timestamp": "2026-03-17T09:20:00.000Z" }
}
```

### 4. Map activities to missions

In the Dashboard, go to **Missions > Configure**, select **"Default"**, and map activity codes to missions.

---

## Authentication

All requests require an API Key:

```
Authorization: Bearer sk_live_YOUR_API_KEY
```

| Property | Details |
|----------|---------|
| **Format** | `sk_live_` (production) or `sk_test_` (testing) |
| **Scope** | `default:sync` |
| **Rate limit** | 1,000 requests/hour (configurable) |
| **Security** | Hashed with bcrypt, optional IP allowlist |

---

## API Reference

### `sync_collaborators`

Register or update salespeople. Matched by email (idempotent).

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `external_id` | string | Yes | Unique ID in your system (max 255) |
| `name` | string | Yes | Full name (max 255) |
| `email` | string | Yes | Valid email — used to match activities |
| `phone` | string | No | Phone number |
| `document` | string | No | ID document like CPF (max 20) |
| `team` | string | No | Team name (max 100) |
| `role` | string | No | Role (max 50) |
| `metadata` | object | No | Any extra key-value data |

**Limits:** Max 500 per request.

### `sync_activities`

Send activity events. Deduplicated by `external_id`.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `activity_code` | string | Yes | 3-digit code: `"001"` through `"999"` |
| `external_id` | string | Yes | Unique ID for deduplication (max 255) |
| `collaborator_email` | string | Yes | Email of the salesperson |
| `data` | object | No | Any additional context |
| `occurred_at` | string | No | ISO 8601 timestamp (defaults to now) |

**Limits:** Max 1,000 per request.

---

## Error Codes

| Status | Code | Description |
|--------|------|-------------|
| 400 | `VALIDATION_ERROR` | Invalid body, missing fields, bad activity code |
| 401 | `UNAUTHORIZED` | Missing, invalid, or expired API key |
| 403 | `FORBIDDEN` | Key lacks `default:sync` scope |
| 429 | `RATE_LIMITED` | Too many requests — check `retry_after` |
| 500 | `SERVER_ERROR` | Internal error |

---

## Idempotency

The `external_id` field prevents duplicates. Sending the same activity twice returns `duplicates: 1` instead of processing it again.

---

## Documentation

- [Interactive API Playground](https://docs.play2sell.com/api/integrations/default) — Try the API live with examples (Mintlify)
- [OpenAPI Specification](openapi/salesos-api.yaml) — Download the spec
- [Postman Collection](postman/) — Ready-to-use collection

> The OpenAPI spec in this repo is synced to [docs.play2sell.com](https://docs.play2sell.com) where it powers the interactive API Playground.

---

## Environments

| Environment | Base URL |
|-------------|----------|
| **Production** | `https://api.play2sell.com` |
| **Staging** | `https://api-staging.play2sell.com` |

---

## Support

- Documentation: [docs.play2sell.com](https://docs.play2sell.com)
- Email: [suporte@play2sell.com](mailto:suporte@play2sell.com)
- Issues: [GitHub Issues](https://github.com/Play2sellSA/SalesOs-API/issues)

---

**Made by [Play2Sell](https://play2sell.com)**
