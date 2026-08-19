#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

python3 -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
echo "OK: venv ready at $ROOT/.venv"
echo "Next: export HF_TOKEN (or use .env) then ./scripts/download_model.py --profile web-asr"
