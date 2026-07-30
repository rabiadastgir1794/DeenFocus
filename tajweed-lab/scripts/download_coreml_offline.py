#!/usr/bin/env python3
"""Download CoreML offline ANE pack into tajweed-lab/models/coreml/ (gitignored).

Requires HF access accepted for:
  https://huggingface.co/Muno459/fastconformer-quran-coreml-offline

Usage (from tajweed-lab with venv):
  source .venv/bin/activate
  python scripts/download_coreml_offline.py
"""

from __future__ import annotations

import hashlib
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from dotenv import load_dotenv

load_dotenv(ROOT / ".env")

REPO = "Muno459/fastconformer-quran-coreml-offline"
OUT = ROOT / "models" / "coreml"

FILES = [
    "LICENSE",
    "README.md",
    "tokenizer.model",
    "tokens.txt",
    "fastconformer-quran-offline-ane.mlpackage/Manifest.json",
    "fastconformer-quran-offline-ane.mlpackage/Data/com.apple.CoreML/model.mlmodel",
    "fastconformer-quran-offline-ane.mlpackage/Data/com.apple.CoreML/weights/weight.bin",
    "pronunciation-head.mlpackage/Manifest.json",
    "pronunciation-head.mlpackage/Data/com.apple.CoreML/model.mlmodel",
    "pronunciation-head.mlpackage/Data/com.apple.CoreML/weights/weight.bin",
]


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    token = os.environ.get("HF_TOKEN") or os.environ.get("HUGGING_FACE_HUB_TOKEN")
    if not token:
        print("ERROR: set HF_TOKEN in tajweed-lab/.env", file=sys.stderr)
        return 1
    try:
        from huggingface_hub import hf_hub_download
    except ImportError:
        print("ERROR: activate tajweed-lab/.venv first", file=sys.stderr)
        return 1

    OUT.mkdir(parents=True, exist_ok=True)
    print(f"Downloading CoreML pack from {REPO} → {OUT}")
    for rel in FILES:
        print(f"  → {rel}")
        try:
            hf_hub_download(repo_id=REPO, filename=rel, local_dir=str(OUT), token=token)
        except Exception as e:
            print(f"FAILED: {e}", file=sys.stderr)
            print(
                "Accept the model gate in a browser, then retry.",
                file=sys.stderr,
            )
            return 1

    encoder_w = OUT / "fastconformer-quran-offline-ane.mlpackage/Data/com.apple.CoreML/weights/weight.bin"
    head_w = OUT / "pronunciation-head.mlpackage/Data/com.apple.CoreML/weights/weight.bin"
    tok = OUT / "tokenizer.model"
    tokens = OUT / "tokens.txt"
    manifest = {
        "version": "1.0.0",
        "encoder": "fastconformer-quran-offline-ane.mlpackage",
        "pronunciationHead": "pronunciation-head.mlpackage",
        "tokenizer": "tokenizer.model",
        "tokens": "tokens.txt",
        "sha256": {
            "encoder": sha256_file(encoder_w),
            "pronunciationHead": sha256_file(head_w),
            "tokenizer": sha256_file(tok),
            "tokens": sha256_file(tokens),
        },
        "minimumAppVersion": "1.0.0",
    }
    (OUT / "model_manifest.json").write_text(
        json.dumps(manifest, indent=2) + "\n", encoding="utf-8"
    )
    print("Wrote model_manifest.json with SHA-256 digests.")
    print("Copy this folder to the iOS Simulator Documents/TajweedImport to install.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
