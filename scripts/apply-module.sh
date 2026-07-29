#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODULE="${1:-}"
TARGET_DIR="${2:-$PWD}"

if [[ -z "$MODULE" ]]; then
  echo "Usage: $0 <fastapi-base|supabase-auth|backend-supabase-jwt|testing-base|alembic-resilient|docker> [target-repository]"
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
MODULE_DIR="$SOURCE_DIR/modules/$MODULE"

if [[ ! -d "$MODULE_DIR" ]]; then
  echo "Unknown module: $MODULE"
  exit 1
fi

mkdir -p "$TARGET_DIR/.agents/modules"
if [[ -e "$TARGET_DIR/.agents/modules/$MODULE" ]]; then
  echo "Module metadata already exists: .agents/modules/$MODULE"
else
  cp -R "$MODULE_DIR" "$TARGET_DIR/.agents/modules/$MODULE"
fi

copy_if_missing() {
  local source="$1"
  local target="$2"
  mkdir -p "$(dirname "$target")"
  if [[ -f "$target" ]]; then
    if cmp -s "$source" "$target"; then
      echo "SKIPPED_EQUAL: ${target#$TARGET_DIR/}"
    else
      echo "PRESERVED_DIFFERENT: ${target#$TARGET_DIR/}"
    fi
  else
    cp "$source" "$target"
    echo "CREATED: ${target#$TARGET_DIR/}"
  fi
}

if [[ -d "$TARGET_DIR/backend/app" ]]; then
  backend_root="$TARGET_DIR/backend"
elif [[ -d "$TARGET_DIR/app" ]]; then
  backend_root="$TARGET_DIR"
else
  backend_root="$TARGET_DIR/backend"
fi
app_dir="$backend_root/app"

case "$MODULE" in
  fastapi-base)
    copy_if_missing "$MODULE_DIR/templates/main.py" "$app_dir/main.py"
    copy_if_missing "$MODULE_DIR/templates/config.py" "$app_dir/core/config.py"
    copy_if_missing "$MODULE_DIR/templates/router.py" "$app_dir/api/router.py"
    copy_if_missing "$MODULE_DIR/templates/health.py" "$app_dir/api/routes/health.py"
    echo "Review imports, package initializers and dependencies before running the application."
    ;;
  supabase-auth)
    if [[ -d "$TARGET_DIR/frontend" ]]; then frontend_dir="$TARGET_DIR/frontend"; else frontend_dir="$TARGET_DIR"; fi
    copy_if_missing "$MODULE_DIR/templates/supabase.ts" "$frontend_dir/src/lib/supabase.ts"
    copy_if_missing "$MODULE_DIR/templates/LoginPage.tsx" "$frontend_dir/src/features/auth/LoginPage.tsx"
    copy_if_missing "$MODULE_DIR/templates/ForgotPasswordPage.tsx" "$frontend_dir/src/features/auth/ForgotPasswordPage.tsx"
    copy_if_missing "$MODULE_DIR/templates/ResetPasswordPage.tsx" "$frontend_dir/src/features/auth/ResetPasswordPage.tsx"
    if [[ ! -f "$TARGET_DIR/.env.example" ]]; then
      cp "$MODULE_DIR/templates/env.example" "$TARGET_DIR/.env.example"
    else
      while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        key="${line%%=*}"
        grep -q "^${key}=" "$TARGET_DIR/.env.example" || echo "$line" >> "$TARGET_DIR/.env.example"
      done < "$MODULE_DIR/templates/env.example"
    fi
    ;;
  backend-supabase-jwt)
    copy_if_missing "$MODULE_DIR/templates/supabase_jwt.py" "$app_dir/core/supabase_jwt.py"
    copy_if_missing "$MODULE_DIR/templates/auth.py" "$app_dir/dependencies/auth.py"
    echo "Add Supabase issuer/audience settings and install PyJWT[crypto]."
    ;;
  testing-base)
    copy_if_missing "$MODULE_DIR/templates/conftest.py" "$backend_root/tests/conftest.py"
    copy_if_missing "$MODULE_DIR/templates/test_health.py" "$backend_root/tests/test_health.py"
    echo "Install pytest and add the real test command to .agents/project.yaml."
    ;;
  alembic-resilient)
    copy_if_missing "$MODULE_DIR/templates/schema_guard.py" "$app_dir/db/migrations/schema_guard.py"
    copy_if_missing "$MODULE_DIR/templates/revision_example.py" "$app_dir/db/migrations/revision_example.py"
    echo "Existing revisions are never rewritten automatically. Run alembic check after model changes."
    ;;
  docker)
    if [[ ! -f "$TARGET_DIR/compose.yaml" && ! -f "$TARGET_DIR/compose.yml" && ! -f "$TARGET_DIR/docker-compose.yml" ]]; then
      cp "$MODULE_DIR/templates/compose.yaml" "$TARGET_DIR/compose.yaml"
      echo "CREATED: compose.yaml"
    else
      echo "PRESERVED: existing Compose file"
    fi
    copy_if_missing "$MODULE_DIR/templates/backend.Dockerfile" "$TARGET_DIR/backend/Dockerfile"
    copy_if_missing "$MODULE_DIR/templates/frontend.Dockerfile" "$TARGET_DIR/frontend/Dockerfile"
    ;;
esac

echo "Applied module metadata: .agents/modules/$MODULE"
echo "Review .agents/modules/$MODULE/README.md before committing."
