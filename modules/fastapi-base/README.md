# FastAPI base module

Provides the stable backend layout used by the other framework modules.

## Target structure

```text
backend/
├── app/
│   ├── main.py
│   ├── api/router.py
│   ├── api/routes/health.py
│   ├── core/config.py
│   ├── core/errors.py
│   ├── core/logging.py
│   ├── db/base.py
│   ├── db/session.py
│   ├── dependencies/
│   ├── middleware/
│   ├── models/
│   ├── schemas/
│   └── services/
├── tests/
└── pyproject.toml
```

## Python virtual environment

Applying this module creates a repository-root `.venv` using `python -m venv` when it does not already exist. It also ensures `.venv/` is ignored by Git.

```bash
source .venv/bin/activate
# Windows PowerShell
.venv\Scripts\Activate.ps1
```

The environment starts empty. Dependencies must come from the project's declared dependency file instead of hidden installer assumptions.

## Contract

- Use an application factory so tests and deployment can create the app consistently.
- Centralize environment settings with `pydantic-settings`.
- Include all application routes from one root router.
- Expose `/health` for process health and `/ready` for dependency readiness.
- Keep database sessions, authentication dependencies and domain services separate.
- Do not move an existing project automatically. Generate a migration plan when its structure differs.

## Installer outcomes

- `CREATE`: create missing base files in an empty or compatible backend.
- `SKIP_EQUAL`: keep equivalent files and log the decision.
- `PRESERVE`: keep project-owned implementations requiring adaptation.
- `CONFLICT`: stop when applying the module would create a second application entry point or incompatible package layout.

Other modules should target this structure but must read `.agents/project.yaml` before assuming paths.
