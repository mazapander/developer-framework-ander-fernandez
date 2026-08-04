#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTRACT_FILE="$ROOT_DIR/deploy/deploy.env"

if [[ ! -f "$CONTRACT_FILE" ]]; then
  echo "ERROR: missing deploy/deploy.env. Copy deploy.env.example and configure it on the VPS."
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$CONTRACT_FILE"
set +a

: "${DEPLOY_BRANCH:?DEPLOY_BRANCH is required}"
: "${COMPOSE_FILE:?COMPOSE_FILE is required}"
: "${BACKEND_SERVICE:?BACKEND_SERVICE is required}"
: "${MIGRATION_COMMAND:?MIGRATION_COMMAND is required}"
: "${HEALTHCHECK_URL:?HEALTHCHECK_URL is required}"

HEALTHCHECK_RETRIES="${HEALTHCHECK_RETRIES:-12}"
HEALTHCHECK_INTERVAL_SECONDS="${HEALTHCHECK_INTERVAL_SECONDS:-5}"
cd "$ROOT_DIR"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "ERROR: deployment checkout is dirty"
  exit 1
fi

current_branch="$(git branch --show-current)"
if [[ "$current_branch" != "$DEPLOY_BRANCH" ]]; then
  echo "ERROR: expected branch $DEPLOY_BRANCH, found $current_branch"
  exit 1
fi

previous_sha="$(git rev-parse HEAD)"
echo "DEPLOY_START previous_sha=$previous_sha branch=$DEPLOY_BRANCH"

git fetch origin "$DEPLOY_BRANCH"
git merge --ff-only "origin/$DEPLOY_BRANCH"
new_sha="$(git rev-parse HEAD)"
echo "DEPLOY_TARGET sha=$new_sha"

rollback() {
  echo "DEPLOY_ROLLBACK target=$previous_sha"
  git reset --hard "$previous_sha"
  docker compose -f "$COMPOSE_FILE" up -d --build
}
trap 'echo "DEPLOY_FAILED sha=${new_sha:-unknown}"; rollback' ERR

if [[ -n "${BACKUP_COMMAND:-}" ]]; then
  echo "DEPLOY_BACKUP_START"
  bash -lc "$BACKUP_COMMAND"
  echo "DEPLOY_BACKUP_OK"
fi

docker compose -f "$COMPOSE_FILE" build
docker compose -f "$COMPOSE_FILE" run --rm "$BACKEND_SERVICE" sh -lc "$MIGRATION_COMMAND"
docker compose -f "$COMPOSE_FILE" up -d --remove-orphans

for ((attempt=1; attempt<=HEALTHCHECK_RETRIES; attempt++)); do
  if curl --fail --silent --show-error "$HEALTHCHECK_URL" >/dev/null; then
    trap - ERR
    echo "DEPLOY_OK sha=$new_sha attempts=$attempt"
    exit 0
  fi
  echo "DEPLOY_HEALTH_WAIT attempt=$attempt/$HEALTHCHECK_RETRIES"
  sleep "$HEALTHCHECK_INTERVAL_SECONDS"
done

false
