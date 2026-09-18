#!/usr/bin/env bash
# Idempotent setup for the documentation development environment.
# Builds a Python virtualenv with MkDocs + Material to preview and validate
# the Markdown guides in this repository.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# The base image ships Python without venv/ensurepip support, so add it once.
if ! python3 -c "import venv, ensurepip" >/dev/null 2>&1; then
  sudo apt-get update -qq
  sudo apt-get install -y --no-install-recommends python3-venv
fi

if [ ! -x .venv/bin/python ]; then
  python3 -m venv .venv
fi

.venv/bin/python -m pip install --quiet --upgrade pip
.venv/bin/python -m pip install --quiet -r requirements-docs.txt

echo "Documentation environment ready. Run '.venv/bin/mkdocs serve' to preview."
