#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODULE="${1:-}"
TARGET_DIR="${2:-$PWD}"

if [[ -z "$MODULE" ]]; then
  echo "Usage: $0 <supabase-auth|docker> [target-repository]"
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

case "$MODULE" in
  supabase-auth)
    if [[ -d "$TARGET_DIR/frontend" ]]; then
      frontend_dir="$TARGET_DIR/frontend"
    else
      frontend_dir="$TARGET_DIR"
    fi
    mkdir -p "$frontend_dir/src/lib"
    if [[ ! -f "$frontend_dir/src/lib/supabase.ts" ]]; then
      cp "$MODULE_DIR/templates/supabase.ts" "$frontend_dir/src/lib/supabase.ts"
      echo "Created: ${frontend_dir#$TARGET_DIR/}/src/lib/supabase.ts"
    fi
    if [[ ! -f "$TARGET_DIR/.env.example" ]]; then
      cp "$MODULE_DIR/templates/env.example" "$TARGET_DIR/.env.example"
    else
      while IFS= read -r line; do
        key="${line%%=*}"
        grep -q "^${key}=" "$TARGET_DIR/.env.example" || echo "$line" >> "$TARGET_DIR/.env.example"
      done < "$MODULE_DIR/templates/env.example"
    fi
    echo "Install @supabase/supabase-js with the repository's detected package manager."
    ;;
  docker)
    if [[ ! -f "$TARGET_DIR/compose.yaml" && ! -f "$TARGET_DIR/compose.yml" && ! -f "$TARGET_DIR/docker-compose.yml" ]]; then
      cp "$MODULE_DIR/templates/compose.yaml" "$TARGET_DIR/compose.yaml"
      echo "Created: compose.yaml"
    else
      echo "Existing Compose file preserved. Use the module guide to align it manually."
    fi
    [[ -f "$TARGET_DIR/backend/Dockerfile" ]] || { mkdir -p "$TARGET_DIR/backend"; cp "$MODULE_DIR/templates/backend.Dockerfile" "$TARGET_DIR/backend/Dockerfile"; }
    [[ -f "$TARGET_DIR/frontend/Dockerfile" ]] || { mkdir -p "$TARGET_DIR/frontend"; cp "$MODULE_DIR/templates/frontend.Dockerfile" "$TARGET_DIR/frontend/Dockerfile"; }
    ;;
esac

echo "Applied module metadata: .agents/modules/$MODULE"
echo "Review .agents/modules/$MODULE/README.md before committing."
