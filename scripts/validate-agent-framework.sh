#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
required=(
  "AGENTS.md"
  ".agents/README.md"
  ".agents/registry.yaml"
  ".agents/project.yaml"
  ".codex/README.md"
)

failed=0
for path in "${required[@]}"; do
  if [[ ! -f "$root/$path" ]]; then
    printf 'missing: %s\n' "$path" >&2
    failed=1
  else
    printf 'ok: %s\n' "$path"
  fi
done

if grep -RInE '(api[_-]?key|secret|password|token)[[:space:]]*[:=][[:space:]]*[^$<{[:space:]]+' \
  "$root/.agents" "$root/.codex" 2>/dev/null; then
  printf 'warning: review possible hard-coded credentials above\n' >&2
  failed=1
fi

if [[ "$failed" -ne 0 ]]; then
  exit 1
fi

printf 'agent framework validation passed\n'
