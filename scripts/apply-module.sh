#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODULE="${1:-}"
TARGET_DIR="${2:-$PWD}"

if [[ -z "$MODULE" ]]; then
  echo "Usage: $0 <supabase-auth|docker|alembic-resilient> [target-repository]"
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
    echo "Preserved existing: ${target#$TARGET_DIR/}"
  else
    cp "$source" "$target"
    echo "Created: ${target#$TARGET_DIR/}"
  fi
}

case "$MODULE" in
  supabase-auth)
    if [[ -d "$TARGET_DIR/frontend" ]]; then
      frontend_dir="$TARGET_DIR/frontend"
    else
      frontend_dir="$TARGET_DIR"
    fi

    copy_if_missing "$MODULE_DIR/templates/supabase.ts" "$frontend_dir/src/lib/supabase.ts"
    copy_if_missing "$MODULE_DIR/templates/LoginPage.tsx" "$frontend_dir/src/features/auth/LoginPage.tsx"
    copy_if_missing "$MODULE_DIR/templates/ForgotPasswordPage.tsx" "$frontend_dir/src/features/auth/ForgotPasswordPage.tsx"
    copy_if_missing "$MODULE_DIR/templates/ResetPasswordPage.tsx" "$frontend_dir/src/features/auth/ResetPasswordPage.tsx"

    if [[ ! -f "$TARGET_DIR/.env.example" ]]; then
      cp "$MODULE_DIR/templates/env.example" "$TARGET_DIR/.env.example"
      echo "Created: .env.example"
    else
      while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        key="${line%%=*}"
        grep -q "^${key}=" "$TARGET_DIR/.env.example" || echo "$line" >> "$TARGET_DIR/.env.example"
      done < "$MODULE_DIR/templates/env.example"
    fi

    echo "Install @supabase/supabase-js and react-router-dom with the detected package manager."
    echo "Wire /login, /forgot-password and /reset-password into the existing router and design system."
    ;;
  docker)
    if [[ ! -f "$TARGET_DIR/compose.yaml" && ! -f "$TARGET_DIR/compose.yml" && ! -f "$TARGET_DIR/docker-compose.yml" ]]; then
      cp "$MODULE_DIR/templates/compose.yaml" "$TARGET_DIR/compose.yaml"
      echo "Created: compose.yaml"
    else
      echo "Existing Compose file preserved. Use the module guide to align it manually."
    fi
    copy_if_missing "$MODULE_DIR/templates/backend.Dockerfile" "$TARGET_DIR/backend/Dockerfile"
    copy_if_missing "$MODULE_DIR/templates/frontend.Dockerfile" "$TARGET_DIR/frontend/Dockerfile"
    ;;
  alembic-resilient)
    if [[ -d "$TARGET_DIR/backend/app" ]]; then
      migration_utils_dir="$TARGET_DIR/backend/app/db/migrations"
    elif [[ -d "$TARGET_DIR/app" ]]; then
      migration_utils_dir="$TARGET_DIR/app/db/migrations"
    else
      migration_utils_dir="$TARGET_DIR/backend/app/db/migrations"
    fi
    copy_if_missing "$MODULE_DIR/templates/schema_guard.py" "$migration_utils_dir/schema_guard.py"
    echo "Import schema_guard helpers explicitly from new revisions; existing revisions are never rewritten automatically."
    ;;
esac

echo "Applied module metadata: .agents/modules/$MODULE"
echo "Review .agents/modules/$MODULE/README.md before committing."
