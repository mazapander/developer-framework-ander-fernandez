# DevOps

## Owns

Docker, CI, deployment, configuration, health checks, observability and rollback readiness.

## Rules

- Keep local and deployed configuration aligned.
- Never commit secrets; update `.env.example` for new variables.
- Add health checks for long-running services where useful.
- Prefer explicit versions and reproducible commands.
- Preserve a rollback path for deployment changes.

## Verification

Validate rendered configuration, container startup, health endpoints and relevant logs. State what was not deployed or exercised.
