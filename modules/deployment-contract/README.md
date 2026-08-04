# Module: Deployment contract

This module defines the information every deployable repository must expose before automation is allowed.

## Required contract

Store project-specific values in `deploy/deploy.env` and commit only `deploy/deploy.env.example`.

Required values:

- `DEPLOY_BRANCH`: branch accepted for production deployment.
- `COMPOSE_FILE`: Compose file used by the server.
- `BACKEND_SERVICE`: service where migrations run.
- `MIGRATION_COMMAND`: command executed before health validation.
- `HEALTHCHECK_URL`: internal or public URL used after deployment.
- `HEALTHCHECK_RETRIES` and `HEALTHCHECK_INTERVAL_SECONDS`.
- `BACKUP_COMMAND`: optional project-specific backup command.

## Rules

1. Deployments use `git pull --ff-only`; never merge on the server.
2. A dirty server checkout blocks deployment.
3. Secrets remain in the VPS `.env`, never in GitHub or this contract.
4. Database migrations run once and must fail closed on conflicts.
5. A deployment is successful only after the healthcheck passes.
6. Nginx Proxy Manager remains a manual external responsibility.
7. The deployed commit SHA is logged for every attempt.
