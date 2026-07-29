#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-$PWD}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

modules=(
  observability-audit
  deployment-contract
  deploy-vps
)

for module in "${modules[@]}"; do
  echo
  echo "=== Applying $module ==="
  bash "$SOURCE_DIR/scripts/apply-module.sh" "$module" "$TARGET_DIR"
done

echo
echo "Phase 2 installed in: $TARGET_DIR"
echo "Next steps:"
echo "1. Integrate logging and RequestContextMiddleware into FastAPI startup."
echo "2. Create and review the audit_log Alembic revision."
echo "3. Copy deploy/deploy.env.example to deploy/deploy.env on the VPS."
echo "4. Run bash deploy/deploy.sh manually over SSH for the first deployment."
