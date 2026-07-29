# Module: VPS deployment

This module deploys from an existing clean Git checkout on the VPS. It does not require GitHub Actions.

## Flow

1. Load `deploy/deploy.env`.
2. Refuse a dirty working tree or unexpected branch.
3. Record the previous commit for rollback.
4. Fetch and fast-forward to the remote branch.
5. Run an optional backup command.
6. Build services with Docker Compose.
7. Run Alembic inside the configured backend service.
8. Start services and poll the healthcheck.
9. On failure, restore the previous Git commit and rebuild the previous version.

## Invocation

```bash
bash deploy/deploy.sh
```

The script is intended to be started manually through SSH first. Later, n8n may invoke the same command over SSH without changing the deployment logic.

## Limitations

- Database downgrades are not automatic. A failed migration may need manual recovery.
- Rollback returns application code and containers to the previous commit; it cannot safely undo arbitrary data changes.
- Production secrets and Nginx Proxy Manager configuration remain outside the repository.
