#!/usr/bin/env python3
"""Phase 4A: run the Python-reference ASR pipeline (the same ONNX encoder used by
Android's OnnxAsrModel.kt) on the golden samples, to serve as ground truth for
comparing native transcripts once both platforms can run real inference.

Usage (from tajweed-lab, with venv active):
    python scripts/parity_dump_reference_transcripts.py
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "web"))

from asr.session import AsrEngine  # noqa: E402

SAMPLES_DIR = ROOT / "samples"
OUT_PATH = ROOT / "parity" / "reports" / "python_reference_transcripts.json"


def main() -> int:
    wavs = sorted(SAMPLES_DIR.glob("*.wav"))
    if not wavs:
        print(f"No .wav files found in {SAMPLES_DIR}", file=sys.stderr)
        return 1

    print("Loading ASR session (real ONNX encoder)...")
    t0 = time.time()
    session = AsrEngine()
    load_ms = (time.time() - t0) * 1000
    print(f"Loaded in {load_ms:.0f}ms")

    results = {"encoder_load_ms": load_ms, "samples": []}
    for wav_path in wavs:
        t0 = time.time()
        text, duration_s = session.transcribe_path(wav_path)
        infer_ms = (time.time() - t0) * 1000
        print(f"{wav_path.name}: '{text}' (audio={duration_s:.2f}s, infer={infer_ms:.0f}ms)")
        results["samples"].append(
            {
                "sample": wav_path.name,
                "transcript": text,
                "audio_duration_s": duration_s,
                "inference_ms": infer_ms,
            }
        )

    OUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUT_PATH.write_text(json.dumps(results, indent=2, ensure_ascii=False))
    print(f"\nWrote {OUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
