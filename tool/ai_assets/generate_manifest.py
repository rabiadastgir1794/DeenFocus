#!/usr/bin/env python3
"""Generate a per-asset `model_manifest.json` for the AI Asset Manager (ADR-009).

Computes a SHA-256 for every artifact file so nobody hand-types a hash (the
single most common way to accidentally ship a manifest that fails
`verifyStaging`/`verifySHA` on-device). Deliberately asset-kind-agnostic: it
has no built-in knowledge of Tajweed's `encoder`/`pronunciationHead`/`tokenizer`/
`tokens` keys — those are just friendly names the *spec file* chooses. The same
script produces a manifest for a future Qari audio pack, translation pack, or
tafsir pack by using different friendly names in the spec.

Usage:
    python3 tool/ai_assets/generate_manifest.py \\
        --spec tool/ai_assets/specs/hafs-en-v1-1.0.0-android.example.json \\
        --out /tmp/release/tajweed/packs/hafs-en-v1/1.0.0/android/model_manifest.json

Spec file shape (see tool/ai_assets/specs/*.example.json for real examples):
    {
      "version": "1.0.0",           # required, becomes manifest["version"]
      "packId": "hafs-en-v1",       # required, becomes manifest["packId"]
      "kind": "tajweed_model",      # optional, free-form (ADR-009)
      "minimumAppVersion": "1.0.0", # optional
      "artifactBaseUrl": "https://assets.deenfocus.app/tajweed/packs/hafs-en-v1/1.0.0/android/",
      "filesDir": "./staging/hafs-en-v1/1.0.0/android",  # resolved relative to the spec file
      "files": {                    # friendly name -> filename (relative to filesDir)
        "encoder": "model_with_encoder.onnx",
        "pronunciationHead": "pronunciation_head.onnx",
        "tokenizer": "tokenizer.model",
        "tokens": "tokens.txt"
      },
      "extra": { "language": "en", "riwayah": "Hafs" }  # merged verbatim into the manifest
    }

Output manifest:
    {
      "version": "1.0.0",
      "packId": "hafs-en-v1",
      "kind": "tajweed_model",
      "minimumAppVersion": "1.0.0",
      "artifactBaseUrl": "...",
      "language": "en", "riwayah": "Hafs",   # from "extra"
      "encoder": "model_with_encoder.onnx",  # passthrough of "files"
      "pronunciationHead": "pronunciation_head.onnx",
      "tokenizer": "tokenizer.model",
      "tokens": "tokens.txt",
      "sha256": {
        "encoder": "<hex>", "pronunciationHead": "<hex>",
        "tokenizer": "<hex>", "tokens": "<hex>"
      }
    }
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

CHUNK_SIZE = 1024 * 1024
REQUIRED_SPEC_KEYS = ("version", "packId", "files")


def _sha256_of(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as f:
        while chunk := f.read(CHUNK_SIZE):
            digest.update(chunk)
    return digest.hexdigest()


def build_manifest(spec: dict, spec_dir: Path) -> tuple[dict, int]:
    """Returns (manifest_dict, total_bytes_across_all_named_files)."""
    missing = [k for k in REQUIRED_SPEC_KEYS if k not in spec]
    if missing:
        raise ValueError(f"Spec is missing required key(s): {', '.join(missing)}")
    files: dict[str, str] = spec["files"]
    if not files:
        raise ValueError("Spec 'files' must list at least one friendly-name -> filename entry.")

    files_dir = spec_dir
    if "filesDir" in spec:
        candidate = Path(spec["filesDir"])
        files_dir = candidate if candidate.is_absolute() else (spec_dir / candidate)

    manifest: dict = {"version": spec["version"], "packId": spec["packId"]}
    for optional_key in ("kind", "minimumAppVersion", "artifactBaseUrl"):
        if optional_key in spec:
            manifest[optional_key] = spec[optional_key]
    manifest.update(spec.get("extra", {}))

    sha256_map: dict[str, str] = {}
    total_bytes = 0
    for friendly_name, filename in files.items():
        file_path = files_dir / filename
        if not file_path.is_file():
            raise FileNotFoundError(f"'{friendly_name}' -> file not found: {file_path}")
        sha256_map[friendly_name] = _sha256_of(file_path)
        total_bytes += file_path.stat().st_size
        manifest[friendly_name] = filename

    manifest["sha256"] = sha256_map
    return manifest, total_bytes


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--spec", required=True, type=Path, help="Path to the manifest spec JSON file.")
    parser.add_argument("--out", required=True, type=Path, help="Path to write the generated model_manifest.json to.")
    args = parser.parse_args()

    spec = json.loads(args.spec.read_text(encoding="utf-8"))
    manifest, total_bytes = build_manifest(spec, args.spec.resolve().parent)

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

    print(f"Wrote {args.out} ({len(manifest['sha256'])} file(s), {total_bytes:,} bytes total)")
    print(f"approxSizeBytes for this platform's catalog.json entry: {total_bytes}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
