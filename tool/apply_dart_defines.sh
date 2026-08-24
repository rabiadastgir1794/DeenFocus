#!/usr/bin/env bash
# Encodes repo-root dart_defines.json into ios/Flutter/DartDefines.xcconfig
# so Xcode runs pick up secrets the same way `flutter run --dart-define-from-file` does.
#
# Android: android/app/build.gradle.kts merges the same dart_defines.json into
# Flutter's dart-defines (Flutter CLI alone only injects FLUTTER_* unless
# --dart-define-from-file is passed).
set -euo pipefail

if [ -n "${SRCROOT:-}" ]; then
  ROOT="$(cd "$SRCROOT/.." && pwd)"
else
  ROOT="$(cd "$(dirname "$0")/.." && pwd)"
fi

SRC="$ROOT/dart_defines.json"
OUT="$ROOT/ios/Flutter/DartDefines.xcconfig"

if [ ! -f "$SRC" ]; then
  printf '// dart_defines.json not found — compile-time secrets (GROQ_API_KEY) will be empty.\n' > "$OUT"
  exit 0
fi

python3 - "$SRC" "$OUT" <<'PY'
import base64, json, pathlib, sys

src, out = map(pathlib.Path, sys.argv[1:])
data = json.loads(src.read_text())
parts = []
for key, value in data.items():
    if not isinstance(key, str):
        continue
    encoded = base64.b64encode(f"{key}={value}".encode("utf-8")).decode("ascii")
    parts.append(encoded)
out.write_text("DART_DEFINES=" + ",".join(parts) + "\n")
PY
