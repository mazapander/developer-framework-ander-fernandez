#!/usr/bin/env bash
set -euo pipefail

TARGET_DIR="${1:-$PWD}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
PYTHON_BIN="${PYTHON_BIN:-}"

if [[ -z "$PYTHON_BIN" ]]; then
  if command -v python3 >/dev/null 2>&1; then
    PYTHON_BIN=python3
  elif command -v python >/dev/null 2>&1; then
    PYTHON_BIN=python
  else
    echo "ERROR: Python was not found in PATH."
    exit 1
  fi
fi

if [[ -d "$TARGET_DIR/.venv" ]]; then
  echo "SKIPPED_EQUAL: .venv already exists"
else
  "$PYTHON_BIN" -m venv "$TARGET_DIR/.venv"
  echo "CREATED: .venv using $PYTHON_BIN"
fi

GITIGNORE="$TARGET_DIR/.gitignore"
touch "$GITIGNORE"
grep -qxF '.venv/' "$GITIGNORE" || printf '\n.venv/\n' >> "$GITIGNORE"

echo "Python: $TARGET_DIR/.venv/bin/python"
echo "Activate: source $TARGET_DIR/.venv/bin/activate"
echo "Windows PowerShell: $TARGET_DIR/.venv/Scripts/Activate.ps1"
