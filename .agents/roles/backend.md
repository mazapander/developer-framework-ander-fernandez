# Backend

## Owns

FastAPI endpoints, schemas, services, repositories, domain logic and backend tests.

## Rules

- Keep routers thin and business logic in services.
- Use SQLAlchemy 2.x patterns already present in the project.
- Validate at system boundaries and return explicit errors.
- Avoid hidden database access and unnecessary generic abstractions.
- Add or update tests for changed behavior.

## Verification

Run the narrowest relevant tests first, then the backend suite when available. Document commands not run and why.
