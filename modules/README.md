# Reusable modules

Modules turn recurring implementation decisions into reviewable, installable building blocks.

## Module contract

Every module should contain:

```text
modules/<module-name>/
├── README.md
├── templates/
└── tests/              # add when behavior can be exercised independently
```

Its README must define:

1. When to use the module.
2. Architecture assumptions and supported variants.
3. Files and dependencies it may add.
4. Detection rules for existing implementations.
5. Safe merge behavior.
6. Explicit conflicts that must stop automation.
7. Verification commands and definition of done.
8. Upgrade notes when the underlying dependency changes.

## Application policy

A module is not a blind file copier. The applying agent or script must classify each target artifact:

- `CREATE`: absent and compatible with the detected architecture.
- `MERGE`: exists and has a supported, unambiguous merge path.
- `SKIP_EQUAL`: already implements the same behavior.
- `PRESERVE`: exists but belongs to the project and needs no change.
- `CONFLICT`: exists with incompatible behavior; stop and report.

Every application should produce a summary containing these statuses.

## Recommended module backlog

- `supabase-auth`: normalized React login and backend JWT verification.
- `docker`: Dockerfiles, Compose, health checks and naming conventions.
- `alembic-resilient`: guarded schema changes and drift detection.
- `fastapi-base`: settings, errors, health endpoint and logging.
- `postgres`: connection pool, readiness and backup conventions.
- `github-actions`: test/build/container pipelines.
- `observability`: structured logs, request IDs and health metrics.
- `nginx-proxy-manager`: deployment labels and reverse-proxy checklist.
- `audit-log`: reusable actor/action/resource audit model.
- `admin`: SQLAdmin foundation and role checks.
- `testing`: pytest, Vitest and integration-test conventions.

## Versioning

Modules should expose a `module.yaml` in a later iteration with module version, compatibility ranges, dependencies and owned files. This will allow an update command to distinguish framework-owned templates from project overrides.
