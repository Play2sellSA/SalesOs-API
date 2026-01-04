# Monitoring & Observability Endpoints

## Overview

The monitoring endpoints provide real-time visibility into the health and performance of the SalesOS workflow infrastructure, including queue metrics, event consumption statistics, and failure tracking.

---

## Endpoint: Get System Metrics

### Request

```http
GET /functions/v1/monitoring?metric={type}
```

### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `metric` | string | No | `all` | Type of metrics to retrieve: `all`, `queue`, `consumption`, or `failures` |

### Authentication

**Required:** Yes
**Header:** `Authorization: Bearer {token}`

### Response Format

#### Metric: `all` (Default)

Returns comprehensive system health data across all monitoring views.

```json
{
  "metric": "all",
  "data": {
    "queue": {
      "pending_count": 0,
      "processing_count": 0,
      "completed_today": 380,
      "dead_letter_count": 4,
      "avg_latency_seconds": 43,
      "max_latency_seconds": 162,
      "error_rate_percent": 1.04,
      "oldest_pending": null,
      "last_processed_at": "2026-01-04T15:40:02.031Z",
      "total_items": 384
    },
    "consumption": [
      {
        "consumer_key": "workflow:gamification_engine",
        "successful_events": 1,
        "failed_events": 0,
        "currently_processing": 0,
        "success_rate_percent": 100.00,
        "avg_duration_ms": null,
        "max_duration_ms": null,
        "total_retries": 0,
        "avg_retries": 0.00,
        "first_processed": "2026-01-04T15:29:27.399Z",
        "last_processed": "2026-01-04T15:29:27.399Z",
        "total_events": 1
      }
    ],
    "failures": []
  },
  "errors": {
    "queue": null,
    "consumption": null,
    "failures": null
  },
  "timestamp": "2026-01-04T15:45:00.000Z"
}
```

#### Metric: `queue`

Returns workflow queue health metrics.

```json
{
  "metric": "queue",
  "data": {
    "pending_count": 0,
    "processing_count": 0,
    "completed_today": 380,
    "dead_letter_count": 4,
    "avg_latency_seconds": 43,
    "max_latency_seconds": 162,
    "error_rate_percent": 1.04,
    "oldest_pending": null,
    "last_processed_at": "2026-01-04T15:40:02.031Z",
    "total_items": 384
  }
}
```

**Queue Metrics Explained:**

- `pending_count`: Items waiting to be processed
- `processing_count`: Items currently being processed
- `completed_today`: Items successfully processed in last 24h
- `dead_letter_count`: Items that failed max retries
- `avg_latency_seconds`: Average time from creation to completion
- `max_latency_seconds`: Maximum observed latency
- `error_rate_percent`: Percentage of items that failed
- `oldest_pending`: Timestamp of oldest unprocessed item
- `last_processed_at`: Timestamp of most recent completion
- `total_items`: Total items processed in last 24h

#### Metric: `consumption`

Returns event consumption statistics by consumer.

```json
{
  "metric": "consumption",
  "data": [
    {
      "consumer_key": "workflow_worker:f79c41a2-7d77-4bba-a41a-1038b57d3e57",
      "successful_events": 1,
      "failed_events": 0,
      "currently_processing": 0,
      "success_rate_percent": 100.00,
      "avg_duration_ms": 150,
      "max_duration_ms": 150,
      "total_retries": 0,
      "avg_retries": 0.00,
      "first_processed": "2026-01-04T15:30:00.904Z",
      "last_processed": "2026-01-04T15:30:00.904Z",
      "total_events": 1
    }
  ]
}
```

**Consumption Metrics Explained:**

- `consumer_key`: Unique identifier for the event consumer
- `successful_events`: Count of successfully processed events
- `failed_events`: Count of failed events
- `currently_processing`: Events in progress
- `success_rate_percent`: Success rate (0-100)
- `avg_duration_ms`: Average processing time in milliseconds
- `max_duration_ms`: Maximum processing time observed
- `total_retries`: Total retry attempts across all events
- `avg_retries`: Average retries per event
- `first_processed`: First event processed timestamp
- `last_processed`: Most recent event processed timestamp
- `total_events`: Total events processed by this consumer

#### Metric: `failures`

Returns recent failed event processing attempts (last 7 days, max 20).

```json
{
  "metric": "failures",
  "data": [
    {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "consumer_key": "workflow_worker:abc123",
      "event_id": "987fcdeb-51a2-43f1-ba65-123456789abc",
      "event_type": "call.completed",
      "entity_type": "opportunity",
      "entity_id": "555e4567-e89b-12d3-a456-426614174999",
      "error_code": "23505",
      "error_message": "duplicate key value violates unique constraint",
      "error_context": {
        "workflow": "gamification_engine",
        "step": "award_points"
      },
      "retry_count": 3,
      "failed_at": "2026-01-04T15:35:00.000Z",
      "last_retry_at": "2026-01-04T15:36:30.000Z",
      "event_created_at": "2026-01-04T15:34:00.000Z",
      "time_since_failure": "00:10:00"
    }
  ]
}
```

**Failure Metrics Explained:**

- `id`: Unique ID of the consumption record
- `consumer_key`: Consumer that failed to process the event
- `event_id`: ID of the event that failed
- `event_type`: Type of event (e.g., "call.completed")
- `entity_type`: Entity type (e.g., "opportunity")
- `entity_id`: Entity ID
- `error_code`: PostgreSQL error code or custom error code
- `error_message`: Human-readable error description
- `error_context`: Additional context (JSON)
- `retry_count`: Number of retry attempts
- `failed_at`: When the failure occurred
- `last_retry_at`: Last retry attempt timestamp
- `event_created_at`: When the original event was created
- `time_since_failure`: Time elapsed since failure (interval)

---

## Use Cases

### 1. Health Dashboard

Monitor overall system health with real-time metrics:

```bash
curl -H "Authorization: Bearer {token}" \
  "https://api.play2sell.com/functions/v1/monitoring?metric=all"
```

### 2. Queue Monitoring

Track workflow queue performance:

```bash
curl -H "Authorization: Bearer {token}" \
  "https://api.play2sell.com/functions/v1/monitoring?metric=queue"
```

**Alert Conditions:**
- `pending_count > 100`: Queue is backing up
- `error_rate_percent > 5.0`: High failure rate
- `avg_latency_seconds > 120`: Performance degradation
- `oldest_pending > 5 minutes ago`: Stuck items

### 3. Consumer Performance

Analyze event consumption by consumer:

```bash
curl -H "Authorization: Bearer {token}" \
  "https://api.play2sell.com/functions/v1/monitoring?metric=consumption"
```

**Analysis Points:**
- Identify slow consumers (high `avg_duration_ms`)
- Find consumers with low `success_rate_percent`
- Detect consumers requiring frequent retries

### 4. Failure Investigation

Debug recent failures:

```bash
curl -H "Authorization: Bearer {token}" \
  "https://api.play2sell.com/functions/v1/monitoring?metric=failures"
```

**Debugging Workflow:**
1. Review `error_message` and `error_code`
2. Check `error_context` for workflow/step details
3. Verify `retry_count` to understand retry attempts
4. Correlate `event_id` with original event in `salesos_events`

---

## Error Responses

### 500 Internal Server Error

```json
{
  "error": "Failed to fetch monitoring data: connection timeout"
}
```

**Possible Causes:**
- Database connectivity issues
- View query timeout
- Invalid metric parameter

---

## Data Sources

The monitoring endpoint queries these database views:

1. **vw_workflow_queue_monitoring**: Aggregates `salesos_workflow_queue` metrics (last 24h)
2. **vw_event_consumption_summary**: Groups `salesos_event_consumption` by consumer (last 24h)
3. **vw_event_consumption_failures**: Filters failed events from `salesos_event_consumption` (last 7 days)

---

## Rate Limiting

**Limit:** 100 requests/minute per tenant
**Header:** `X-RateLimit-Remaining: 95`

For higher limits, contact support.

---

## Changelog

### v1.0.0 (2026-01-04)
- Initial release
- Support for `queue`, `consumption`, `failures`, and `all` metrics
- Real-time monitoring data from last 24 hours
- Failure tracking for last 7 days
