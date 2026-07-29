# Module: Observability and audit

Use this module to standardize operational logs, request tracing, health signals and durable business audit events.

## Separation of concerns

- Operational logs go to stdout as structured JSON for Docker and external collection.
- Audit events are durable business records stored in the application database.
- Do not store every request or traceback in the audit table.

## Included conventions

- Correlation header: `X-Request-ID`.
- JSON fields: timestamp, level, service, environment, request_id, method, path, status_code, duration_ms and event.
- Health endpoints remain `/health` and `/ready`.
- Audit fields: actor_id, action, resource_type, resource_id, outcome, request_id and metadata.
- Secrets, tokens, passwords and raw medical/personal payloads must never be logged.

## Installation result

The module installs reference files under:

```text
backend/app/
├── core/logging.py
├── middleware/request_context.py
├── models/audit_log.py
└── services/audit.py
```

Existing differing files are preserved for manual integration.

## Required integration

1. Configure logging once during application startup.
2. Add `RequestContextMiddleware` to FastAPI.
3. Add an Alembic revision for `audit_log` using the resilient migration helpers.
4. Call `write_audit_event()` only for meaningful state changes and security-sensitive actions.
5. Test request IDs, redaction and database failure behavior.
