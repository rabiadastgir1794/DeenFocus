#!/usr/bin/env python3
"""Run golden WAVs through DIY CoreML packages (Python/coremltools host).

Reuses the same mel / CTC / alignment / scoring logic as
`scripts/parity_dump_onnx_e2e.py` so differences are attributable to the model
runtime, not frontend drift.

Does not call production Swift OfflineAsrModel.
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

import coremltools as ct
import numpy as np
import soundfile as sf

ROOT = Path(__file__).resolve().parents[2]
POC = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "web"))
sys.path.insert(0, str(ROOT / "scripts"))

from asr.decode import collapse_ctc  # noqa: E402
from asr.mel import log_mel  # noqa: E402

# Reuse helpers from the ONNX e2e dumper.
import parity_dump_onnx_e2e as e2e  # noqa: E402

SAMPLES = ROOT / "samples"
TOKENS = ROOT / "models" / "tokens.txt"
# Prefer lab tokens next to ONNX pack; fall back to docs copy if needed.
if not TOKENS.exists():
    TOKENS = ROOT / "docs" / "tokens.txt"

ENCODER_ML = POC / "artifacts" / "encoder.mlpackage"
HEAD_ML = POC / "artifacts" / "pronunciation_head.mlpackage"
OUT = POC / "reports" / "diy_coreml_e2e_scores.json"

BLANK_ID = 1024
FRAME_HOP_S = 0.080
FIXED_T = 4800  # used when the converted encoder is fixed-shape (matches 48s app cap)


def _predict_encoder(model: ct.models.MLModel, mel: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    """mel: (80, T) → logprobs (T_out, 1025), encoder (T_out, 512)."""
    t = mel.shape[1]
    meta_path = POC / "artifacts" / "encoder_conversion_meta.json"
    flexible = True
    if meta_path.exists():
        flexible = json.loads(meta_path.read_text()).get("flexible", True)

    if flexible:
        audio = mel[None, ...].astype(np.float32)
        length = np.array([t], dtype=np.int32)
    else:
        if t > FIXED_T:
            raise ValueError(f"mel T={t} exceeds fixed CoreML T={FIXED_T}")
        audio = np.zeros((1, 80, FIXED_T), dtype=np.float32)
        audio[0, :, :t] = mel
        length = np.array([t], dtype=np.int32)

    try:
        out = model.predict({"audio_signal": audio, "length": length})
    except Exception:
        # Some builds keep length as int64.
        out = model.predict(
            {"audio_signal": audio, "length": np.array([t], dtype=np.int64)}
        )
    # coremltools may return dict keyed by output name.
    logprobs = np.asarray(out["logprobs"] if "logprobs" in out else _pick_logprobs(out))
    encoder = np.asarray(
        out["encoder_output"] if "encoder_output" in out else _pick_encoder(out)
    )
    if logprobs.ndim == 3:
        logprobs = logprobs[0]
    if encoder.ndim == 3:
        encoder = encoder[0]
    # ONNX layout is (512, T_out); CoreML may preserve that.
    if encoder.ndim == 2 and encoder.shape[0] == 512 and encoder.shape[1] != 512:
        encoder = encoder.T
    return logprobs.astype(np.float32), encoder.astype(np.float32)


def _pick_logprobs(out: dict) -> np.ndarray:
    for v in out.values():
        a = np.asarray(v)
        if a.ndim >= 2 and a.shape[-1] == 1025:
            return a
    raise KeyError(f"no logprobs-like output in {list(out)}")


def _pick_encoder(out: dict) -> np.ndarray:
    for v in out.values():
        a = np.asarray(v)
        if a.ndim >= 2 and 512 in a.shape and a.shape[-1] != 1025:
            return a
    raise KeyError(f"no encoder-like output in {list(out)}")


def _predict_head(model: ct.models.MLModel, pooled: np.ndarray, token_id: int) -> float:
    # coremltools downcasts int64 token inputs to int32 at convert time.
    payload = {
        "enc_feature": pooled.astype(np.float32),
        "token_id": np.array([token_id], dtype=np.int32),
    }
    try:
        out = model.predict(payload)
    except Exception:
        payload["token_id"] = np.array([token_id], dtype=np.int64)
        out = model.predict(payload)
    if "prob_correct" in out:
        val = out["prob_correct"]
    else:
        val = next(iter(out.values()))
    arr = np.asarray(val).reshape(-1)
    return float(arr[0])


def main() -> int:
    for path in (ENCODER_ML, HEAD_ML, TOKENS):
        if not path.exists():
            print(f"ERROR: missing {path}", file=sys.stderr)
            return 1

    # NOTE: ComputeUnit.ALL fails to build an execution plan for this
    # non-ANE-optimized (full-attention) encoder on this host (error -6),
    # even though CPU_ONLY and CPU_AND_GPU individually succeed. Use
    # CPU_AND_GPU here for host verification; see report for iOS-side
    # compute unit handling.
    compute_units = ct.ComputeUnit.CPU_AND_GPU
    pieces = e2e.load_tokens(TOKENS)
    print("Loading CoreML encoder…")
    t0 = time.time()
    enc = ct.models.MLModel(str(ENCODER_ML), compute_units=compute_units)
    cold_enc_ms = (time.time() - t0) * 1000
    print(f"  encoder cold load {cold_enc_ms:.0f}ms")
    t0 = time.time()
    head = ct.models.MLModel(str(HEAD_ML), compute_units=compute_units)
    cold_head_ms = (time.time() - t0) * 1000
    print(f"  head cold load {cold_head_ms:.0f}ms")

    results = {
        "runtime": "coremltools-python",
        "compute_units": str(compute_units),
        "cold_encoder_load_ms": cold_enc_ms,
        "cold_head_load_ms": cold_head_ms,
        "samples": [],
    }

    for wav_path in sorted(SAMPLES.glob("*.wav")):
        meta = e2e.EXPECTED.get(wav_path.name)
        if not meta:
            continue
        wav, sr = sf.read(str(wav_path), dtype="float32")
        if wav.ndim > 1:
            wav = wav.mean(axis=1)
        duration = float(len(wav) / sr)

        t_inf = time.time()
        mel = log_mel(wav)  # (80, T)
        logprobs, encoder = _predict_encoder(enc, mel)
        ids = collapse_ctc(logprobs.argmax(axis=-1).tolist(), blank_id=BLANK_ID)
        hypothesis = e2e.decode_ids(pieces, ids)

        expected_ids = e2e.encode_greedy(pieces, meta["expected"])
        tokens = []
        if expected_ids:
            intervals = e2e.ctc_forced_align(logprobs, expected_ids)
            for token_id, start_f, end_f in intervals:
                s = max(0, min(start_f, encoder.shape[0] - 1))
                e = max(s + 1, min(end_f, encoder.shape[0]))
                pooled = encoder[s:e].mean(axis=0, keepdims=True).astype(np.float32)
                prob = _predict_head(head, pooled, token_id)
                piece = pieces[token_id] if 0 <= token_id < len(pieces) else "?"
                tokens.append(
                    {
                        "text": piece.replace("\u2581", ""),
                        "status": e2e.status_for_prob(prob),
                        "prob": prob,
                        "startSec": start_f * FRAME_HOP_S,
                        "endSec": end_f * FRAME_HOP_S,
                    }
                )

        expected_words = meta["expected"].split()
        hyp_words = hypothesis.split()
        report = {
            "ref": meta["ref"],
            "expected": meta["expected"],
            "hypothesis": hypothesis,
            "durationSec": duration,
            "wordAccuracy": e2e.word_accuracy(expected_words, hyp_words),
            "exactMatch": e2e.normalize_arabic(hypothesis)
            == e2e.normalize_arabic(meta["expected"]),
            "tokens": tokens,
        }
        infer_ms = (time.time() - t_inf) * 1000
        print(
            f"{wav_path.name}: hyp='{hypothesis}' exact={report['exactMatch']} "
            f"acc={report['wordAccuracy']:.2f} tokens={len(tokens)} infer={infer_ms:.0f}ms"
        )
        results["samples"].append(
            {"sample": wav_path.name, "inference_ms": infer_ms, "score": report}
        )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(results, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
