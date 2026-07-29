#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="${1:-$PWD}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

if [[ "$SOURCE_DIR" == "$TARGET_DIR" ]]; then
  echo "Refusing to install the framework into its own source repository."
  exit 1
fi

mkdir -p "$TARGET_DIR/.agents"

copy_path() {
  local source="$1"
  local target="$2"
  if [[ -e "$target" ]]; then
    echo "Preserved existing: ${target#$TARGET_DIR/}"
    return
  fi
  cp -R "$source" "$target"
  echo "Installed: ${target#$TARGET_DIR/}"
}

copy_path "$SOURCE_DIR/AGENTS.md" "$TARGET_DIR/AGENTS.md"
copy_path "$SOURCE_DIR/CODEX.md" "$TARGET_DIR/CODEX.md"
copy_path "$SOURCE_DIR/.agents/README.md" "$TARGET_DIR/.agents/README.md"
copy_path "$SOURCE_DIR/.agents/registry.yaml" "$TARGET_DIR/.agents/registry.yaml"
copy_path "$SOURCE_DIR/.agents/roles" "$TARGET_DIR/.agents/roles"
copy_path "$SOURCE_DIR/.agents/workflows" "$TARGET_DIR/.agents/workflows"
copy_path "$SOURCE_DIR/.codex" "$TARGET_DIR/.codex"

project_name="$(basename "$TARGET_DIR" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9_-' '-')"
backend="none"
frontend="none"
database="unknown"
migrations="none"
package_manager=""

[[ -f "$TARGET_DIR/backend/pyproject.toml" || -f "$TARGET_DIR/backend/requirements.txt" || -f "$TARGET_DIR/pyproject.toml" ]] && backend="Python"
grep -Rqs "fastapi" "$TARGET_DIR/backend" "$TARGET_DIR/pyproject.toml" "$TARGET_DIR/requirements.txt" 2>/dev/null && backend="FastAPI"

if [[ -f "$TARGET_DIR/frontend/package.json" ]]; then
  frontend="React/Vite"
elif [[ -f "$TARGET_DIR/package.json" ]]; then
  frontend="JavaScript/TypeScript"
fi

[[ -f "$TARGET_DIR/pnpm-lock.yaml" || -f "$TARGET_DIR/frontend/pnpm-lock.yaml" ]] && package_manager="pnpm"
[[ -z "$package_manager" && ( -f "$TARGET_DIR/yarn.lock" || -f "$TARGET_DIR/frontend/yarn.lock" ) ]] && package_manager="yarn"
[[ -z "$package_manager" && ( -f "$TARGET_DIR/package-lock.json" || -f "$TARGET_DIR/frontend/package-lock.json" ) ]] && package_manager="npm"

find "$TARGET_DIR" -maxdepth 4 -type d -name alembic 2>/dev/null | grep -q . && migrations="Alembic"
grep -Rqs "postgres" "$TARGET_DIR/compose.yaml" "$TARGET_DIR/compose.yml" "$TARGET_DIR/docker-compose.yml" "$TARGET_DIR/.env.example" 2>/dev/null && database="PostgreSQL"

if [[ ! -f "$TARGET_DIR/.agents/project.yaml" ]]; then
  cat > "$TARGET_DIR/.agents/project.yaml" <<EOF
version: 1
project:
  name: $project_name
  objective: define-me
  status: discovery

stack:
  backend: $backend
  frontend: $frontend
  database: $database
  migrations: $migrations
  infrastructure: $([[ -f "$TARGET_DIR/compose.yaml" || -f "$TARGET_DIR/compose.yml" || -f "$TARGET_DIR/docker-compose.yml" ]] && echo "Docker Compose" || echo "none")
  package_manager: ${package_manager:-unknown}

commands:
  install: ""
  test_backend: ""
  test_frontend: ""
  lint: ""
  build: ""
  migrate: ""
  run: ""

modules:
  auth: none
  docker: detected

boundaries:
  protected_paths: [.env, secrets/]
  generated_paths: []
  do_not_change_without_request: [authentication, database schema, deployment configuration]

quality_gates:
  require_tests_for_logic_changes: true
  require_migration_for_schema_changes: true
  require_env_example_for_new_variables: true
  require_documented_unverified_items: true
EOF
  echo "Generated: .agents/project.yaml"
else
  echo "Preserved existing: .agents/project.yaml"
fi

cat <<EOF

Framework installed in: $TARGET_DIR
Detected backend: $backend
Detected frontend: $frontend
Detected database: $database
Detected migrations: $migrations

Next steps:
1. Review .agents/project.yaml.
2. Run scripts/apply-module.sh from the framework source when a reusable module is needed.
3. Run scripts/validate-agent-framework.sh inside the target repository.
EOF
