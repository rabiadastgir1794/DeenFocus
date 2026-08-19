"""Lazy-loaded ONNX ASR session."""

from __future__ import annotations

from pathlib import Path

import numpy as np
import onnxruntime as ort
import sentencepiece as spm
from scipy import signal as sps
import soundfile as sf

from .decode import collapse_ctc
from .mel import SAMPLE_RATE, log_mel

ROOT = Path(__file__).resolve().parents[2]
MODELS = ROOT / "models"


class AsrEngine:
    def __init__(self) -> None:
        self._session: ort.InferenceSession | None = None
        self._tokenizer: spm.SentencePieceProcessor | None = None
        self.onnx_path: Path | None = None

    def _resolve_onnx(self) -> Path:
        pointer = MODELS / "ACTIVE_ONNX.txt"
        if pointer.exists():
            p = Path(pointer.read_text(encoding="utf-8").strip())
            if p.exists():
                return p
        for name in (
            "model_with_encoder.onnx",
            "model_with_encoder.q8.onnx",
            "model.onnx",
            "model.fp16.onnx",
            "model.q8.onnx",
        ):
            candidate = MODELS / "onnx" / name
            if candidate.exists():
                return candidate
        raise FileNotFoundError(
            "No ONNX model found. Run: ./scripts/download_model.py --profile web-asr"
        )

    def load(self) -> None:
        if self._session is not None:
            return
        onnx_path = self._resolve_onnx()
        tok_path = MODELS / "tokenizer.model"
        if not tok_path.exists():
            raise FileNotFoundError(f"Missing tokenizer at {tok_path}")
        self._session = ort.InferenceSession(
            str(onnx_path), providers=["CPUExecutionProvider"]
        )
        self._tokenizer = spm.SentencePieceProcessor(model_file=str(tok_path))
        self.onnx_path = onnx_path

    @property
    def ready(self) -> bool:
        try:
            self._resolve_onnx()
            return (MODELS / "tokenizer.model").exists()
        except FileNotFoundError:
            return False

    def transcribe_wav_array(self, wav: np.ndarray, sr: int) -> tuple[str, float]:
        self.load()
        assert self._session is not None and self._tokenizer is not None

        if wav.ndim > 1:
            wav = wav.mean(axis=1)
        wav = wav.astype(np.float32)
        if sr != SAMPLE_RATE:
            wav = sps.resample(wav, int(len(wav) * SAMPLE_RATE / sr)).astype(np.float32)

        feats = log_mel(wav)[None, ...]
        length = np.array([feats.shape[2]], dtype=np.int64)

        outputs = self._session.get_outputs()
        output_names = [o.name for o in outputs]
        # Prefer known names from the official demo; fall back to first outputs.
        run_outs = ["logprobs"]
        if "encoder_output" in output_names:
            run_outs.append("encoder_output")

        result = self._session.run(
            run_outs,
            {"audio_signal": feats, "length": length},
        )
        logprobs = result[0]
        ids = collapse_ctc(logprobs[0].argmax(axis=-1).tolist())
        text = self._tokenizer.decode(ids)
        duration = float(len(wav) / SAMPLE_RATE)
        return text, duration

    def transcribe_path(self, path: Path | str) -> tuple[str, float]:
        wav, sr = sf.read(str(path))
        return self.transcribe_wav_array(np.asarray(wav), int(sr))

    def transcribe_bytes(self, data: bytes, filename: str | None = None) -> tuple[str, float]:
        from .audio_io import load_audio_bytes

        wav, sr = load_audio_bytes(data, filename=filename)
        return self.transcribe_wav_array(wav, sr)


ENGINE = AsrEngine()
