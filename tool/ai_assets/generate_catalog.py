#!/usr/bin/env python3
"""Generate the shared `catalog.json` for the AI Asset Manager (ADR-009).

One catalog lists every registered asset (Tajweed models, and eventually Qari
audio / translation / tafsir packs) side by side — see ADR-009 §1 for the
schema. This tool validates required fields, stamps `updatedAt`, and
optionally computes `approxSizeBytes` for you from a local artifact directory
instead of requiring a human to add up file sizes by hand.

Usage:
    python3 tool/ai_assets/generate_catalog.py \\
        --spec tool/ai_assets/specs/catalog.example.json \\
        --out /tmp/release/catalog.json

Spec file shape (see tool/ai_assets/specs/catalog.example.json):
    {
      "recommendedCheckIntervalHours": 24,   # optional, defaults to 24
      "packs": [
        {
          "packId": "hafs-en-v1",            # required
          "kind": "tajweed_model",           # optional, free-form (ADR-009)
          "displayName": "Hafs (Arabic) + English feedback",
          "language": "en", "riwayah": "Hafs", "isDefault": true,
          "latestVersion": "1.0.0",          # required
          "minimumAppVersion": "1.0.0",
          "manifestUrl": {                   # required, at least one platform
            "ios": "https://assets.deenfocus.app/tajweed/packs/hafs-en-v1/1.0.0/ios/model_manifest.json",
            "android": "https://assets.deenfocus.app/tajweed/packs/hafs-en-v1/1.0.0/android/model_manifest.json"
          },
          "approxSizeBytes": { "ios": 210000000, "android": 465000000 },
          # OR, instead of hand-typing approxSizeBytes, point at the local
          # per-platform artifact directories used to build that version and
          # let this tool sum the file sizes for you:
          "approxSizeBytesFromDir": {
            "ios": "/tmp/release/tajweed/packs/hafs-en-v1/1.0.0/ios",
            "android": "/tmp/release/tajweed/packs/hafs-en-v1/1.0.0/android"
          }
        }
      ]
    }
"""
from __future__ import annotations

import argparse
import copy
import datetime
import json
import sys
from pathlib import Path

REQUIRED_PACK_KEYS = ("packId", "latestVersion", "manifestUrl")


def _dir_size_bytes(directory: Path) -> int:
    # Excludes the manifest itself: `model_manifest.json` is fetched separately
    # (via `manifestUrl`), never as one of the plugin's own `fileSpecs()`
    # artifacts, so including it here would overstate the real download size.
    return sum(
        f.stat().st_size
        for f in directory.rglob("*")
        if f.is_file() and f.name != "model_manifest.json"
    )


def build_catalog(spec: dict) -> dict:
    packs_in = spec.get("packs")
    if not packs_in:
        raise ValueError("Spec must have a non-empty 'packs' array.")

    seen_ids: set[str] = set()
    packs_out = []
    for i, pack in enumerate(packs_in):
        missing = [k for k in REQUIRED_PACK_KEYS if k not in pack]
        if missing:
            raise ValueError(f"packs[{i}] is missing required key(s): {', '.join(missing)}")
        if not pack["manifestUrl"]:
            raise ValueError(f"packs[{i}] ('{pack['packId']}') 'manifestUrl' must not be empty.")
        if pack["packId"] in seen_ids:
            raise ValueError(f"Duplicate packId in catalog: '{pack['packId']}'")
        seen_ids.add(pack["packId"])

        pack_out = copy.deepcopy(pack)
        if "approxSizeBytesFromDir" in pack_out:
            from_dir = pack_out.pop("approxSizeBytesFromDir")
            computed = pack_out.get("approxSizeBytes", {}) or {}
            for platform, dir_path in from_dir.items():
                directory = Path(dir_path)
                if not directory.is_dir():
                    raise FileNotFoundError(
                        f"packs[{i}] ('{pack['packId']}') approxSizeBytesFromDir.{platform}: "
                        f"not a directory: {directory}"
                    )
                computed[platform] = _dir_size_bytes(directory)
            pack_out["approxSizeBytes"] = computed
        packs_out.append(pack_out)

    return {
        "catalogVersion": spec.get("catalogVersion", 1),
        "updatedAt": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "recommendedCheckIntervalHours": spec.get("recommendedCheckIntervalHours", 24),
        "packs": packs_out,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--spec", required=True, type=Path, help="Path to the catalog spec JSON file.")
    parser.add_argument("--out", required=True, type=Path, help="Path to write the generated catalog.json to.")
    args = parser.parse_args()

    spec = json.loads(args.spec.read_text(encoding="utf-8"))
    catalog = build_catalog(spec)

    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(catalog, indent=2) + "\n", encoding="utf-8")

    print(f"Wrote {args.out} ({len(catalog['packs'])} pack(s)): " + ", ".join(p["packId"] for p in catalog["packs"]))
    return 0


if __name__ == "__main__":
    sys.exit(main())
