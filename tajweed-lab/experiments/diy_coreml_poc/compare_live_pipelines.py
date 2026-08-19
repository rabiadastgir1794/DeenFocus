#!/usr/bin/env python3
"""Cross-pipeline stage dump: Android ONNX vs iOS DIY CoreML (palette-8).

Feeds the *same* WAV into both host runtimes and dumps comparable stages:
  audio → mel → encoder/logprobs → CTC → lexical → pronunciation

Usage (from tajweed-lab, venv active):
  python experiments/diy_coreml_poc/compare_live_pipelines.py path/to/a.wav \\
      --expected 'مَالِكِ يَوْمِ الدِّينِ' --out /tmp/live_compare
  python experiments/diy_coreml_poc/compare_live_pipelines.py wav_a.wav wav_b.wav \\
      --expected '...' --out /tmp/live_compare

Does not modify production app code. Host mirrors of device pipelines only.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import time
from pathlib import Path

import coremltools as ct
import numpy as np
import onnxruntime as ort
import soundfile as sf

ROOT = Path(__file__).resolve().parents[2]
POC = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "web"))
sys.path.insert(0, str(ROOT / "scripts"))

from asr.decode import collapse_ctc  # noqa: E402
from asr.mel import log_mel  # noqa: E402
import parity_dump_onnx_e2e as e2e  # noqa: E402
import run_coreml_e2e as coreml_e2e  # noqa: E402

BLANK_ID = 1024
FIXED_T = 4800
# FastConformer 8x time reduction (NeMo / ONNX contract used by both packs).
SUBSAMPLE = 8

ONNX_ENC = ROOT / "models" / "onnx" / "model_with_encoder.onnx"
ONNX_HEAD = ROOT / "models" / "onnx" / "pronunciation_head.onnx"
TOKENS = ROOT / "models" / "tokens.txt"
if not TOKENS.exists():
    TOKENS = ROOT / "docs" / "tokens.txt"

# Prefer promoted palette-8; fall back to FP32 DIY artifacts.
PALETTE_ENC = POC / "artifacts" / "optimization" / "palette_8bit" / "encoder.mlpackage"
FP32_ENC = POC / "artifacts" / "encoder.mlpackage"
HEAD_ML = POC / "artifacts" / "pronunciation_head.mlpackage"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def audio_stats(wav: np.ndarray, sr: int) -> dict:
    wav = np.asarray(wav, dtype=np.float32).reshape(-1)
    return {
        "num_samples": int(wav.shape[0]),
        "sample_rate": int(sr),
        "duration_sec": float(wav.shape[0] / sr),
        "mean_abs": float(np.mean(np.abs(wav))),
        "peak_abs": float(np.max(np.abs(wav))),
        "rms": float(np.sqrt(np.mean(wav**2))),
        "pcm_sha256_f32": sha256_bytes(wav.astype(np.float32).tobytes()),
    }


def mel_stats(mel: np.ndarray) -> dict:
    # mel: (80, T)
    flat = mel.astype(np.float32).reshape(-1)
    return {
        "shape": list(mel.shape),
        "time": int(mel.shape[1]),
        "mean": float(flat.mean()),
        "std": float(flat.std()),
        "sha256": sha256_bytes(flat.tobytes()),
    }


def normalize_arabic_app(text: str) -> str:
    """Mirror production TajweedLexicalScoring.normalizeArabic (Kotlin/Swift)."""
    diac = set("\u064b\u064c\u064d\u064e\u064f\u0650\u0651\u0652\u0615\u0653\u0654\u06e1")
    heh_family = {0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3}

    def skippable(ch: str) -> bool:
        o = ord(ch)
        return ch in diac or o == 0x0640 or 0x06D6 <= o <= 0x06ED

    out: list[str] = []
    i = 0
    while i < len(text):
        ch = text[i]
        o = ord(ch)
        if o == 0x0670:
            j = i + 1
            while j < len(text) and skippable(text[j]):
                j += 1
            nxt = ord(text[j]) if j < len(text) else -1
            if nxt not in heh_family:
                out.append("\u0627")
            i += 1
            continue
        if o == 0x0671:
            out.append("\u0627")
            i += 1
            continue
        if skippable(ch):
            i += 1
            continue
        if o in heh_family:
            out.append("\u0647")
            i += 1
            continue
        out.append(ch)
        i += 1
    s = "".join(out)
    for a, b in (("أ", "ا"), ("إ", "ا"), ("آ", "ا"), ("ى", "ي"), ("ک", "ك"), ("ی", "ي")):
        s = s.replace(a, b)
    return s.strip()


def split_words(text: str) -> list[str]:
    return [w for w in text.split() if w]


def align_words(expected: list[str], hypothesis: list[str]) -> list[dict]:
    """Levenshtein word ops mirroring TajweedLexicalScoring.alignWords."""
    n, m = len(expected), len(hypothesis)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(n + 1):
        dp[i][0] = i
    for j in range(m + 1):
        dp[0][j] = j
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            cost = 0 if normalize_arabic_app(expected[i - 1]) == normalize_arabic_app(
                hypothesis[j - 1]
            ) else 1
            dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)
    ops: list[dict] = []
    i, j = n, m
    while i > 0 or j > 0:
        if i > 0 and j > 0 and dp[i][j] == dp[i - 1][j - 1] and normalize_arabic_app(
            expected[i - 1]
        ) == normalize_arabic_app(hypothesis[j - 1]):
            ops.append({"op": "match", "expected": expected[i - 1], "hyp": hypothesis[j - 1]})
            i -= 1
            j -= 1
        elif i > 0 and j > 0 and dp[i][j] == dp[i - 1][j - 1] + 1:
            ops.append({"op": "sub", "expected": expected[i - 1], "hyp": hypothesis[j - 1]})
            i -= 1
            j -= 1
        elif i > 0 and dp[i][j] == dp[i - 1][j] + 1:
            ops.append({"op": "del", "expected": expected[i - 1], "hyp": None})
            i -= 1
        else:
            ops.append({"op": "ins", "expected": None, "hyp": hypothesis[j - 1]})
            j -= 1
    ops.reverse()
    return ops


def encoder_stats(logprobs: np.ndarray, encoder: np.ndarray, true_mel_t: int) -> dict:
    argmax_full = logprobs.argmax(axis=-1)
    expected_tout = (true_mel_t + SUBSAMPLE - 1) // SUBSAMPLE  # ceil-ish; NeMo often floor
    # Prefer exact: if length masking works, trailing frames should be blank-dominated.
    non_blank_full = int(np.sum(argmax_full != BLANK_ID))
    # Heuristic slice: min(len, true_mel_t // SUBSAMPLE) used by many FC exports
    t_out = logprobs.shape[0]
    slice_t = min(t_out, max(1, true_mel_t // SUBSAMPLE))
    argmax_sliced = argmax_full[:slice_t]
    non_blank_sliced = int(np.sum(argmax_sliced != BLANK_ID))
    trailing = argmax_full[slice_t:] if slice_t < t_out else np.array([], dtype=np.int64)
    trailing_non_blank = int(np.sum(trailing != BLANK_ID)) if trailing.size else 0
    return {
        "logprobs_shape": list(logprobs.shape),
        "encoder_shape": list(encoder.shape),
        "true_mel_t": true_mel_t,
        "slice_t_heuristic": slice_t,
        "non_blank_argmax_full": non_blank_full,
        "non_blank_argmax_sliced": non_blank_sliced,
        "trailing_frames": int(trailing.size),
        "trailing_non_blank_argmax": trailing_non_blank,
        "logprobs_finite": bool(np.isfinite(logprobs).all()),
        "encoder_finite": bool(np.isfinite(encoder).all()),
        "logprobs_mean": float(np.mean(logprobs)),
        "encoder_mean": float(np.mean(encoder)),
        "encoder_sha256_first_64": sha256_bytes(encoder[: min(64, encoder.shape[0])].astype(np.float32).tobytes()),
    }


def predict_onnx(sess: ort.InferenceSession, mel: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    t = mel.shape[1]
    audio = mel[None, ...].astype(np.float32)
    length = np.array([t], dtype=np.int64)
    outs = sess.run(None, {"audio_signal": audio, "length": length})
    # Order: logprobs, encoder_output (per OnnxAsrModel)
    logprobs = np.asarray(outs[0])
    encoder = np.asarray(outs[1])
    if logprobs.ndim == 3:
        logprobs = logprobs[0]
    if encoder.ndim == 3:
        encoder = encoder[0]
    if encoder.shape[0] == 512 and encoder.shape[1] != 512:
        encoder = encoder.T
    return logprobs.astype(np.float32), encoder.astype(np.float32)


def score_pipeline(
    name: str,
    wav: np.ndarray,
    sr: int,
    mel: np.ndarray,
    logprobs: np.ndarray,
    encoder: np.ndarray,
    pieces: list[str],
    head_predict,
    expected: str,
) -> dict:
    stats = encoder_stats(logprobs, encoder, mel.shape[1])
    ids_full = collapse_ctc(logprobs.argmax(axis=-1).tolist(), blank_id=BLANK_ID)
    slice_t = stats["slice_t_heuristic"]
    ids_sliced = collapse_ctc(logprobs[:slice_t].argmax(axis=-1).tolist(), blank_id=BLANK_ID)
    hyp_full = e2e.decode_ids(pieces, ids_full)
    hyp_sliced = e2e.decode_ids(pieces, ids_sliced)

    # Device path uses full logprobs (iOS does not slice). Mirror that as primary.
    hypothesis = hyp_full
    ids = ids_full

    exp_words = split_words(expected)
    hyp_words = split_words(hypothesis)
    ops = align_words(exp_words, hyp_words)
    match_count = sum(1 for o in ops if o["op"] == "match")
    word_acc = match_count / max(len(exp_words), 1)

    # Pronunciation on forced-align of hypothesis tokens (lexical-first style).
    tokens = []
    if ids:
        intervals = e2e.ctc_forced_align(logprobs, ids)
        for token_id, start_f, end_f in intervals:
            s = max(0, min(start_f, encoder.shape[0] - 1))
            e = max(s + 1, min(end_f, encoder.shape[0]))
            pooled = encoder[s:e].mean(axis=0, keepdims=True).astype(np.float32)
            try:
                prob = float(head_predict(pooled, token_id))
            except Exception as exc:  # noqa: BLE001
                prob = float("nan")
                tokens.append({"tokenId": token_id, "error": str(exc)})
                continue
            piece = pieces[token_id] if 0 <= token_id < len(pieces) else "?"
            tokens.append(
                {
                    "tokenId": token_id,
                    "piece": piece,
                    "prob": prob,
                    "status": e2e.status_for_prob(prob),
                    "startFrame": start_f,
                    "endFrame": end_f,
                }
            )

    return {
        "pipeline": name,
        "audio": audio_stats(wav, sr),
        "mel": mel_stats(mel),
        "encoder": stats,
        "ctc": {
            "hypothesis_full": hyp_full,
            "hypothesis_sliced": hyp_sliced,
            "token_ids_full": ids_full,
            "token_ids_sliced": ids_sliced,
            "num_tokens_full": len(ids_full),
            "num_tokens_sliced": len(ids_sliced),
            "divergence_full_vs_sliced": hyp_full != hyp_sliced,
        },
        "lexical": {
            "expected": expected,
            "hypothesis": hypothesis,
            "expected_norm_words": [normalize_arabic_app(w) for w in exp_words],
            "hyp_norm_words": [normalize_arabic_app(w) for w in hyp_words],
            "ops": ops,
            "wordAccuracy": word_acc,
            "exactMatch": normalize_arabic_app(hypothesis) == normalize_arabic_app(expected)
            and bool(expected),
        },
        "pronunciation": {
            "num_scored_pieces": len(tokens),
            "mean_prob": float(np.nanmean([t["prob"] for t in tokens if "prob" in t])) if tokens else None,
            "tokens": tokens[:64],  # cap dump size
        },
    }


def first_divergence(a: dict, b: dict) -> dict:
    """Identify earliest stage where Android ONNX and iOS CoreML disagree."""
    stages = []

    def add(stage: str, ok: bool, detail: dict):
        stages.append({"stage": stage, "match": ok, "detail": detail})

    add(
        "recorded_audio",
        a["audio"]["pcm_sha256_f32"] == b["audio"]["pcm_sha256_f32"],
        {
            "a_sha": a["audio"]["pcm_sha256_f32"][:16],
            "b_sha": b["audio"]["pcm_sha256_f32"][:16],
            "a_dur": a["audio"]["duration_sec"],
            "b_dur": b["audio"]["duration_sec"],
        },
    )
    add(
        "mel_spectrogram",
        a["mel"]["sha256"] == b["mel"]["sha256"] and a["mel"]["time"] == b["mel"]["time"],
        {"a": a["mel"], "b": b["mel"]},
    )
    # Encoder: shapes often differ (dynamic T vs fixed padded T_out)
    enc_ok = (
        a["encoder"]["logprobs_shape"] == b["encoder"]["logprobs_shape"]
        and abs(a["encoder"]["encoder_mean"] - b["encoder"]["encoder_mean"]) < 1e-3
    )
    add(
        "encoder_output",
        enc_ok,
        {
            "a_shape": a["encoder"]["logprobs_shape"],
            "b_shape": b["encoder"]["logprobs_shape"],
            "a_trailing_non_blank": a["encoder"]["trailing_non_blank_argmax"],
            "b_trailing_non_blank": b["encoder"]["trailing_non_blank_argmax"],
            "a_mean": a["encoder"]["encoder_mean"],
            "b_mean": b["encoder"]["encoder_mean"],
        },
    )
    add(
        "ctc_decoding",
        a["ctc"]["hypothesis_full"] == b["ctc"]["hypothesis_full"],
        {
            "a_hyp": a["ctc"]["hypothesis_full"],
            "b_hyp": b["ctc"]["hypothesis_full"],
            "a_sliced": a["ctc"]["hypothesis_sliced"],
            "b_sliced": b["ctc"]["hypothesis_sliced"],
            "a_full_vs_sliced": a["ctc"]["divergence_full_vs_sliced"],
            "b_full_vs_sliced": b["ctc"]["divergence_full_vs_sliced"],
        },
    )
    add(
        "lexical_alignment",
        a["lexical"]["ops"] == b["lexical"]["ops"],
        {
            "a_ops": a["lexical"]["ops"],
            "b_ops": b["lexical"]["ops"],
            "a_acc": a["lexical"]["wordAccuracy"],
            "b_acc": b["lexical"]["wordAccuracy"],
        },
    )
    a_probs = [t.get("prob") for t in a["pronunciation"]["tokens"] if "prob" in t]
    b_probs = [t.get("prob") for t in b["pronunciation"]["tokens"] if "prob" in t]
    pron_ok = len(a_probs) == len(b_probs) and (
        not a_probs
        or float(np.mean(np.abs(np.asarray(a_probs) - np.asarray(b_probs)))) < 0.05
    )
    add(
        "pronunciation_scoring",
        pron_ok,
        {
            "a_mean": a["pronunciation"]["mean_prob"],
            "b_mean": b["pronunciation"]["mean_prob"],
            "a_n": len(a_probs),
            "b_n": len(b_probs),
        },
    )

    first = next((s for s in stages if not s["match"]), None)
    return {"stages": stages, "first_divergence": first}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("wavs", nargs="+", type=Path)
    ap.add_argument("--expected", required=True)
    ap.add_argument("--out", type=Path, default=Path("/tmp/live_compare"))
    ap.add_argument("--uthmani-expected", default=None, help="Optional second expected (app Uthmani text)")
    args = ap.parse_args()

    enc_path = PALETTE_ENC if PALETTE_ENC.exists() else FP32_ENC
    for p in (ONNX_ENC, ONNX_HEAD, TOKENS, enc_path, HEAD_ML):
        if not p.exists():
            print(f"ERROR: missing {p}", file=sys.stderr)
            return 1

    pieces = e2e.load_tokens(TOKENS)
    print(f"Loading ONNX {ONNX_ENC}…")
    onnx_sess = ort.InferenceSession(str(ONNX_ENC), providers=["CPUExecutionProvider"])
    onnx_head = ort.InferenceSession(str(ONNX_HEAD), providers=["CPUExecutionProvider"])

    def onnx_head_predict(pooled: np.ndarray, token_id: int) -> float:
        outs = onnx_head.run(
            None,
            {
                "enc_feature": pooled.astype(np.float32),
                "token_id": np.array([token_id], dtype=np.int64),
            },
        )
        return float(np.asarray(outs[0]).reshape(-1)[0])

    print(f"Loading CoreML {enc_path}…")
    cu = ct.ComputeUnit.CPU_AND_GPU
    cm_enc = ct.models.MLModel(str(enc_path), compute_units=cu)
    cm_head = ct.models.MLModel(str(HEAD_ML), compute_units=cu)

    def cm_head_predict(pooled: np.ndarray, token_id: int) -> float:
        return coreml_e2e._predict_head(cm_head, pooled, token_id)

    args.out.mkdir(parents=True, exist_ok=True)
    summary = {"expected": args.expected, "encoder_coreml": str(enc_path), "clips": []}

    for wav_path in args.wavs:
        wav, sr = sf.read(str(wav_path), dtype="float32")
        if wav.ndim > 1:
            wav = wav.mean(axis=1)
        if sr != 16000:
            # simple linear resample
            n = int(round(len(wav) * 16000 / sr))
            x_old = np.linspace(0, 1, num=len(wav), endpoint=False)
            x_new = np.linspace(0, 1, num=n, endpoint=False)
            wav = np.interp(x_new, x_old, wav).astype(np.float32)
            sr = 16000

        mel = log_mel(wav)  # (80, T) shared frontend

        t0 = time.time()
        lp_onnx, enc_onnx = predict_onnx(onnx_sess, mel)
        onnx_ms = (time.time() - t0) * 1000
        t0 = time.time()
        lp_cm, enc_cm = coreml_e2e._predict_encoder(cm_enc, mel)
        cm_ms = (time.time() - t0) * 1000

        android = score_pipeline(
            "android_onnx", wav, sr, mel, lp_onnx, enc_onnx, pieces, onnx_head_predict, args.expected
        )
        ios = score_pipeline(
            "ios_coreml_palette8", wav, sr, mel, lp_cm, enc_cm, pieces, cm_head_predict, args.expected
        )
        android["timing_ms"] = onnx_ms
        ios["timing_ms"] = cm_ms

        div = first_divergence(android, ios)
        clip = {
            "wav": str(wav_path),
            "android_onnx": android,
            "ios_coreml": ios,
            "divergence": div,
        }
        if args.uthmani_expected:
            # Re-score lexical only with Uthmani expected (app path).
            for side in (android, ios):
                exp_words = split_words(args.uthmani_expected)
                hyp_words = split_words(side["ctc"]["hypothesis_full"])
                ops = align_words(exp_words, hyp_words)
                side["lexical_uthmani"] = {
                    "expected": args.uthmani_expected,
                    "ops": ops,
                    "wordAccuracy": sum(1 for o in ops if o["op"] == "match") / max(len(exp_words), 1),
                }

        out_json = args.out / f"{wav_path.stem}_stages.json"
        out_json.write_text(json.dumps(clip, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        print(f"\n=== {wav_path.name} ===")
        print(f"  Android hyp: {android['ctc']['hypothesis_full']!r}  acc={android['lexical']['wordAccuracy']:.2f}")
        print(f"  iOS     hyp: {ios['ctc']['hypothesis_full']!r}  acc={ios['lexical']['wordAccuracy']:.2f}")
        print(f"  ONNX T_out={android['encoder']['logprobs_shape']} trailing_nb={android['encoder']['trailing_non_blank_argmax']}")
        print(f"  CM   T_out={ios['encoder']['logprobs_shape']} trailing_nb={ios['encoder']['trailing_non_blank_argmax']}")
        print(f"  CTC full≠sliced Android={android['ctc']['divergence_full_vs_sliced']} iOS={ios['ctc']['divergence_full_vs_sliced']}")
        fd = div["first_divergence"]
        if fd:
            print(f"  FIRST DIVERGENCE: {fd['stage']} → {json.dumps(fd['detail'], ensure_ascii=False)[:240]}")
        else:
            print("  No divergence across compared stages.")
        print(f"  Wrote {out_json}")
        summary["clips"].append(
            {
                "wav": str(wav_path),
                "first_divergence": fd["stage"] if fd else None,
                "android_hyp": android["ctc"]["hypothesis_full"],
                "ios_hyp": ios["ctc"]["hypothesis_full"],
                "android_acc": android["lexical"]["wordAccuracy"],
                "ios_acc": ios["lexical"]["wordAccuracy"],
                "ios_trailing_non_blank": ios["encoder"]["trailing_non_blank_argmax"],
                "ios_full_vs_sliced": ios["ctc"]["divergence_full_vs_sliced"],
            }
        )

    summary_path = args.out / "summary.json"
    summary_path.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"\nSummary → {summary_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
