#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-$PWD}"

for module in fastapi-base backend-supabase-jwt testing-base alembic-resilient; do
  echo
  echo "== Applying $module =="
  "$SOURCE_DIR/scripts/apply-module.sh" "$module" "$TARGET_DIR"
done

cat <<'EOF'

Phase 1 installed conservatively.
Required manual review:
1. Resolve every PRESERVED_DIFFERENT entry.
2. Add package dependencies and environment variables.
3. Configure Alembic target_metadata and run `alembic check`.
4. Run pytest and the application health endpoints.
5. Commit only after imports and paths match the target repository.
EOF
