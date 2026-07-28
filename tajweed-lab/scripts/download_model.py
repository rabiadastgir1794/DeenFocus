#!/usr/bin/env python3
"""Download slim artifacts from Muno459/fastconformer-quran into tajweed-lab/."""

from __future__ import annotations

import argparse
import os
import shutil
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from dotenv import load_dotenv

load_dotenv(ROOT / ".env")

REPO = "Muno459/fastconformer-quran"

PROFILES: dict[str, list[str]] = {
    "web-asr": [
        "onnx/model_with_encoder.onnx",
        "tokenizer.model",
        "tokens.txt",
        "model_config.yaml",
        "LICENSE",
        "README.md",
        "head/pronunciation_head.pt",
        "demo/01_alafasy_fatihah.wav",
        "demo/02_basfar_ikhlas.wav",
        "demo/03_alafasy_naba.wav",
        "tajweed/__init__.py",
        "tajweed/aligner.py",
        "tajweed/engine.py",
        "tajweed/full_scorer.py",
        "tajweed/gop_scorer.py",
        "tajweed/head_scorer.py",
        "tajweed/phonology.py",
        "tajweed/rules.py",
        "tajweed/text_analyzer.py",
        "tajweed/token_features.py",
    ],
    "web-asr-q8": [
        "onnx/model_with_encoder.q8.onnx",
        "tokenizer.model",
        "tokens.txt",
        "model_config.yaml",
        "LICENSE",
        "README.md",
        "head/pronunciation_head.pt",
        "demo/01_alafasy_fatihah.wav",
        "demo/02_basfar_ikhlas.wav",
        "demo/03_alafasy_naba.wav",
        "tajweed/__init__.py",
        "tajweed/aligner.py",
        "tajweed/engine.py",
        "tajweed/full_scorer.py",
        "tajweed/gop_scorer.py",
        "tajweed/head_scorer.py",
        "tajweed/phonology.py",
        "tajweed/rules.py",
        "tajweed/text_analyzer.py",
        "tajweed/token_features.py",
    ],
}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--profile", choices=sorted(PROFILES), default="web-asr")
    parser.add_argument("--repo", default=REPO)
    args = parser.parse_args()

    token = os.environ.get("HF_TOKEN") or os.environ.get("HUGGING_FACE_HUB_TOKEN")
    if not token:
        print("ERROR: set HF_TOKEN in tajweed-lab/.env or the environment", file=sys.stderr)
        return 1

    try:
        from huggingface_hub import hf_hub_download
    except ImportError:
        print("ERROR: install deps first (./scripts/setup_env.sh)", file=sys.stderr)
        return 1

    models = ROOT / "models"
    vendor = ROOT / "vendor"
    samples = ROOT / "samples"
    models.mkdir(parents=True, exist_ok=True)
    (vendor / "tajweed").mkdir(parents=True, exist_ok=True)
    samples.mkdir(parents=True, exist_ok=True)

    files = PROFILES[args.profile]
    print(f"Downloading profile={args.profile} from {args.repo} ({len(files)} files)…")

    for rel in files:
        print(f"  → {rel}")
        path = hf_hub_download(
            repo_id=args.repo,
            filename=rel,
            token=token,
            local_dir=models / "hf_cache_staging",
        )
        src = Path(path)
        # hf_hub_download with local_dir keeps relative structure under local_dir
        staged = models / "hf_cache_staging" / rel
        if not staged.exists():
            staged = src

        if rel.startswith("tajweed/"):
            dest = vendor / rel
        elif rel.startswith("demo/"):
            dest = samples / Path(rel).name
        elif rel.startswith("onnx/"):
            dest = models / "onnx" / Path(rel).name
        elif rel.startswith("head/"):
            dest = models / "head" / Path(rel).name
        else:
            dest = models / Path(rel).name

        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(staged, dest)
        print(f"     saved {dest.relative_to(ROOT)} ({dest.stat().st_size:,} bytes)")

    # Convenience pointer for the default ONNX used by the web app
    onnx_dir = models / "onnx"
    preferred = (
        onnx_dir / "model_with_encoder.q8.onnx"
        if args.profile.endswith("q8")
        else onnx_dir / "model_with_encoder.onnx"
    )
    pointer = models / "ACTIVE_ONNX.txt"
    pointer.write_text(str(preferred.resolve()) + "\n", encoding="utf-8")
    print(f"\nActive ONNX → {preferred}")
    print("Done.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
