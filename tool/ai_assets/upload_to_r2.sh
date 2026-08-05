#!/usr/bin/env bash
# Upload a local staging directory to Cloudflare R2 (deenfocus-ai-assets).
#
# Usage:
#   tool/ai_assets/upload_to_r2.sh <r2-key-prefix> <local-dir>
#
# Example (translation pack):
#   tool/ai_assets/upload_to_r2.sh \
#     translations/en-saheeh/1.0.0 \
#     tool/ai_assets/staging/quran-translation-en/1.0.0
#
# Example (single file, e.g. catalog.json):
#   tool/ai_assets/upload_to_r2.sh catalog.json /tmp/release/catalog.json \
#     --cache-control "public, max-age=60"
#
# Conventions (ADR-009):
#   - Versioned artifact paths get long Cache-Control (immutable).
#   - catalog.json gets short Cache-Control (upload LAST after artifacts).
#   - Public base: https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/

set -euo pipefail

BUCKET="${R2_BUCKET:-deenfocus-ai-assets}"
PUBLIC_BASE="${R2_PUBLIC_BASE:-https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev}"
IMMUTABLE_CC="public, max-age=31536000, immutable"
CATALOG_CC="public, max-age=60"

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <r2-key-prefix-or-key> <local-path> [--cache-control <value>]" >&2
  exit 2
fi

KEY_PREFIX="${1%/}"
LOCAL_PATH="$2"
shift 2

CACHE_CONTROL=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --cache-control)
      CACHE_CONTROL="$2"
      shift 2
      ;;
    *)
      echo "Unknown arg: $1" >&2
      exit 2
      ;;
  esac
done

if [[ -f "$LOCAL_PATH" ]]; then
  # Single-file upload (e.g. catalog.json)
  KEY="$KEY_PREFIX"
  if [[ -z "$CACHE_CONTROL" ]]; then
    if [[ "$KEY" == "catalog.json" || "$KEY" == */catalog.json ]]; then
      CACHE_CONTROL="$CATALOG_CC"
    else
      CACHE_CONTROL="$IMMUTABLE_CC"
    fi
  fi
  CT="application/octet-stream"
  case "$LOCAL_PATH" in
    *.json) CT="application/json" ;;
    *.txt) CT="text/plain" ;;
  esac
  echo "Uploading $LOCAL_PATH → r2://$BUCKET/$KEY"
  wrangler r2 object put "$BUCKET/$KEY" \
    --file "$LOCAL_PATH" \
    --content-type "$CT" \
    --cache-control "$CACHE_CONTROL" \
    --remote \
    -y
  echo "Public: $PUBLIC_BASE/$KEY"
  exit 0
fi

if [[ ! -d "$LOCAL_PATH" ]]; then
  echo "Not a file or directory: $LOCAL_PATH" >&2
  exit 1
fi

CACHE_CONTROL="${CACHE_CONTROL:-$IMMUTABLE_CC}"
ROOT="$(cd "$LOCAL_PATH" && pwd)"

while IFS= read -r -d '' file; do
  rel="${file#"$ROOT"/}"
  key="$KEY_PREFIX/$rel"
  ct="application/octet-stream"
  case "$file" in
    *.json) ct="application/json" ;;
    *.txt) ct="text/plain" ;;
    *.onnx) ct="application/octet-stream" ;;
  esac
  echo "Uploading $rel → r2://$BUCKET/$key"
  wrangler r2 object put "$BUCKET/$key" \
    --file "$file" \
    --content-type "$ct" \
    --cache-control "$CACHE_CONTROL" \
    --remote \
    -y
  echo "  Public: $PUBLIC_BASE/$key"
done < <(find "$ROOT" -type f -print0 | sort -z)

echo "Done. Prefix: $PUBLIC_BASE/$KEY_PREFIX/"
