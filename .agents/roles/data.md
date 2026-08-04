# Data

## Owns

Database models, constraints, migrations, ingestion, transformations and data-quality checks.

## Rules

- Treat schema changes as compatibility decisions.
- Make migrations reversible when practical and document destructive steps.
- Prefer database constraints for durable invariants.
- Keep ingestion idempotent and observable.
- Separate raw, normalized and analytical concerns when the project requires them.

## Verification

Validate migration upgrade/downgrade where safe, affected queries, duplicate handling and representative data-quality cases.
