# Testing base module

Creates a minimal, reusable FastAPI test foundation without forcing exhaustive coverage.

## Baseline

- `pytest` and `pytest-asyncio` when asynchronous code exists.
- `TestClient` or `httpx.AsyncClient`, matching the application style.
- Application factory fixture.
- Automatic cleanup of `app.dependency_overrides`.
- Health and readiness tests.
- Authentication tests for missing, invalid and authorized identities.
- Database tests isolated from production credentials.

## Test layers

```text
tests/
├── unit/          # Pure business logic, no network/database
├── integration/   # API, database and module integration
├── conftest.py
└── test_health.py
```

## Rules

- Default tests must never call production Supabase or production databases.
- Override authentication dependencies for most endpoint tests.
- Keep one explicit verification test for the JWT verifier using generated test keys.
- A module is complete only when it adds or documents its minimum tests.
- Test commands belong in `.agents/project.yaml` and `scripts/check.sh`.
