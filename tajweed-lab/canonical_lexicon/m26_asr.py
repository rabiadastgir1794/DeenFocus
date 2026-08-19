"""Optional host ONNX ASR for M2.6 when hypothesis is missing."""

from __future__ import annotations

import sys
from pathlib import Path

import numpy as np

REPO_ROOT = Path(__file__).resolve().parents[2]
LAB = REPO_ROOT / "tajweed-lab"
ENCODER = LAB / "models" / "onnx" / "model_with_encoder.onnx"
TOKENS = LAB / "models" / "tokens.txt"
BLANK_ID = 1024

_session = None
_pieces: list[str] | None = None


def asr_available() -> bool:
    return ENCODER.is_file() and TOKENS.is_file()


def _load_tokens(path: Path) -> list[str]:
    pieces: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line:
            continue
        pieces.append(line.split(" ", 1)[0])
    return pieces


def _ensure_loaded() -> None:
    global _session, _pieces
    if _session is not None:
        return
    import onnxruntime as ort

    _session = ort.InferenceSession(str(ENCODER), providers=["CPUExecutionProvider"])
    _pieces = _load_tokens(TOKENS)


def transcribe_wav(path: Path) -> str:
    """Greedy CTC decode via production ONNX encoder (lab host)."""
    import soundfile as sf

    sys.path.insert(0, str(LAB / "web"))
    from asr.decode import collapse_ctc
    from asr.mel import log_mel

    _ensure_loaded()
    assert _session is not None and _pieces is not None
    wav, sr = sf.read(str(path), dtype="float32", always_2d=False)
    if wav.ndim > 1:
        wav = wav.mean(axis=1)
    if int(sr) != 16000:
        duration = len(wav) / float(sr)
        new_len = max(1, int(duration * 16000))
        wav = np.interp(
            np.linspace(0, len(wav) - 1, new_len),
            np.arange(len(wav)),
            wav,
        ).astype(np.float32)

    mel = log_mel(wav)[None, ...].astype(np.float32)
    length = np.array([mel.shape[2]], dtype=np.int64)
    outs = _session.run(
        ["logprobs", "encoder_output"],
        {"audio_signal": mel, "length": length},
    )
    logprobs = outs[0][0]
    ids = collapse_ctc(logprobs.argmax(axis=-1).tolist(), blank_id=BLANK_ID)
    text = "".join(_pieces[i] for i in ids if 0 <= i < len(_pieces))
    return text.replace("\u2581", " ").strip()
