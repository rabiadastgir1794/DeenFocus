#!/usr/bin/env python3
"""Phase 4A parity: dump the Python-reference log-mel features for each golden
sample under tajweed-lab/samples/, so they can be diffed against the iOS
(Swift/vDSP) and Android (Kotlin/hand-rolled FFT) MelFrontend implementations
on the exact same real audio.

Usage (from tajweed-lab, with venv active):
    python scripts/parity_dump_mel_reference.py

Writes one JSON file per sample to tajweed-lab/parity/python/<name>.json:
    { "sample": "...", "n_mels": 80, "time": T, "features": [80*T floats, row-major mel,time] }
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np
import soundfile as sf

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "web"))

from asr.mel import log_mel  # noqa: E402

SAMPLES_DIR = ROOT / "samples"
OUT_DIR = ROOT / "parity" / "python"


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    wavs = sorted(SAMPLES_DIR.glob("*.wav"))
    if not wavs:
        print(f"No .wav files found in {SAMPLES_DIR}", file=sys.stderr)
        return 1

    for wav_path in wavs:
        wav, sr = sf.read(str(wav_path), dtype="float32")
        if wav.ndim > 1:
            wav = wav.mean(axis=1)
        if sr != 16000:
            print(f"WARNING: {wav_path.name} is {sr} Hz, expected 16000 Hz", file=sys.stderr)

        mel = log_mel(wav)  # (n_mels, time)
        n_mels, time = mel.shape
        out = {
            "sample": wav_path.name,
            "sample_rate": int(sr),
            "n_mels": int(n_mels),
            "time": int(time),
            "features": mel.astype(np.float64).flatten().tolist(),
        }
        out_path = OUT_DIR / f"{wav_path.stem}.json"
        out_path.write_text(json.dumps(out))
        print(f"{wav_path.name}: mel shape=({n_mels},{time}) -> {out_path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
