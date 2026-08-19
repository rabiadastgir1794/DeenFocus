#!/usr/bin/env python3
"""Smoke-test transcription on the first demo wav."""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from web.asr.session import ENGINE


def main() -> int:
    samples = sorted((ROOT / "samples").glob("*.wav"))
    if not samples:
        print("No samples in samples/. Run download_model.py first.", file=sys.stderr)
        return 1
    if not ENGINE.ready:
        print("Model not ready.", file=sys.stderr)
        return 1
    path = samples[0]
    print(f"Transcribing {path.name} …")
    text, dur = ENGINE.transcribe_path(path)
    print(f"duration: {dur:.2f}s")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
