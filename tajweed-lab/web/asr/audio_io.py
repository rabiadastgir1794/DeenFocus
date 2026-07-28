"""Audio decode helpers (wav/flac + browser webm/ogg via ffmpeg)."""

from __future__ import annotations

import io
import shutil
import subprocess
import tempfile
from pathlib import Path

import numpy as np
import soundfile as sf


def load_audio_bytes(data: bytes, filename: str | None = None) -> tuple[np.ndarray, int]:
    """Return mono float32 wav array + sample rate."""
    name = (filename or "").lower()
    # Prefer soundfile for container formats it understands.
    try:
        wav, sr = sf.read(io.BytesIO(data))
        return _to_mono(wav), int(sr)
    except Exception:
        pass

    if not shutil.which("ffmpeg"):
        raise RuntimeError(
            "Could not decode audio. Install ffmpeg or upload a WAV/FLAC file."
        )

    suffix = ".webm"
    for ext in (".webm", ".ogg", ".mp3", ".m4a", ".mp4", ".wav"):
        if name.endswith(ext):
            suffix = ext
            break

    with tempfile.TemporaryDirectory() as tmp:
        src = Path(tmp) / f"in{suffix}"
        dst = Path(tmp) / "out.wav"
        src.write_bytes(data)
        proc = subprocess.run(
            [
                "ffmpeg",
                "-y",
                "-i",
                str(src),
                "-ac",
                "1",
                "-ar",
                "16000",
                str(dst),
            ],
            capture_output=True,
            text=True,
        )
        if proc.returncode != 0 or not dst.exists():
            raise RuntimeError(f"ffmpeg failed: {proc.stderr[-400:]}")
        wav, sr = sf.read(str(dst))
        return _to_mono(wav), int(sr)


def _to_mono(wav: np.ndarray) -> np.ndarray:
    if getattr(wav, "ndim", 1) > 1:
        wav = wav.mean(axis=1)
    return np.asarray(wav, dtype=np.float32)
