#!/usr/bin/env bash
# Copy generated canonical lexicon pack into native bundle locations (ADR-010 M1).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="${ROOT}/memory/features/tajweed/fixtures/canonical_lexicon_v1"
IOS_DST="${ROOT}/ios/Runner/Tajweed/canonical_lexicon"
ANDROID_DST="${ROOT}/android/app/src/main/assets/tajweed/canonical_lexicon"

if [[ ! -f "${SRC}/manifest.json" || ! -f "${SRC}/ayahs.ndjson" ]]; then
  echo "Missing pack at ${SRC}; run: cd tajweed-lab && PYTHONPATH=. python3 scripts/generate_lexicon.py" >&2
  exit 1
fi

mkdir -p "${IOS_DST}" "${ANDROID_DST}"
cp "${SRC}/manifest.json" "${IOS_DST}/"
cp "${SRC}/ayahs.ndjson" "${IOS_DST}/"
cp "${SRC}/manifest.json" "${ANDROID_DST}/"
cp "${SRC}/ayahs.ndjson" "${ANDROID_DST}/"

echo "Synced canonical lexicon pack to:"
echo "  ${IOS_DST}"
echo "  ${ANDROID_DST}"
