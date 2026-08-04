# CODEX.md

Codex must use `AGENTS.md` as the repository contract.

## Loading sequence

1. Read `AGENTS.md`.
2. Read `.agents/project.yaml`.
3. Read `.agents/registry.yaml` and select one primary role.
4. Load the relevant workflow from `.agents/workflows/`.
5. Read only the minimum code and tests required for the task.

Reusable role and workflow instructions belong in `.agents/`. Codex-specific examples belong in `.codex/`. Do not duplicate or override the root rules here.

## Execution rules

- Keep changes surgical.
- Do not over-engineer.
- Work through issues, branches and pull requests.
- Define acceptance criteria before implementation.
- Use the real commands declared in `.agents/project.yaml`.
- Never claim a verification passed unless it was run.
- Report unverified items and residual risk explicitly.

## Preferred default stack

- FastAPI
- SQLAlchemy 2.x
- PostgreSQL
- Alembic
- React
- Vite
- TypeScript
- Tailwind CSS
- shadcn/ui
- OIDC authentication
- SQLAdmin
- Docker Compose

Project-specific choices in `.agents/project.yaml` take precedence over these defaults.
