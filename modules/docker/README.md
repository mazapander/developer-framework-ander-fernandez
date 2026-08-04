# Module: Docker

Use this module to standardize local development and VPS deployment without hard-coding host-specific names.

## Naming conventions

- Prefer `compose.yaml`.
- Set a lowercase top-level `name:` for stable project grouping.
- Use predictable service names: `backend`, `frontend`, `db`, `worker`, `redis`.
- Do not set `container_name` by default. Compose-generated names avoid collisions and allow service scaling.
- Use service names for internal DNS, for example `db:5432`, never localhost between containers.
- Name persistent volumes with functional names such as `postgres_data`.

## Structure

```text
compose.yaml
.env.example
backend/Dockerfile
frontend/Dockerfile
```

Use `compose.override.yaml` only for local-only behavior and a separate production override when production genuinely differs.

## Required behavior

- Health checks for long-lived dependencies such as PostgreSQL.
- `depends_on` with health conditions where startup order matters.
- No secrets committed or embedded in images.
- Build contexts point to the smallest relevant directory.
- Production images use deterministic dependency installation.
- Backend command uses Uvicorn directly unless the application requires another process manager.
- Validate with `docker compose config` before deployment.

## Adaptation rules

The agent must inspect existing ports, module paths, package manager, lock files and migration commands before replacing placeholders. Existing Compose files are preserved by the module installer and should be migrated surgically.