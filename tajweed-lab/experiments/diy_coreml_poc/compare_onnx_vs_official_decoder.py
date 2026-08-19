#!/usr/bin/env python3
"""Investigate Android ONNX vs Official CoreML *decoder* divergence.

Same WAV → shared mel → Android ONNX encoder + Official HF CoreML encoder.
Dumps (no model edits, no lexical scoring changes):
  - encoder output statistics (+ overlapping-frame numerical compare)
  - CTC logits / greedy argmax
  - collapsed token IDs
  - SentencePiece piece strings (pre ▁→space join)
  - final decoded transcript

Finds the earliest stage where the two sides disagree.

Usage (from tajweed-lab, venv active):
  python experiments/diy_coreml_poc/compare_onnx_vs_official_decoder.py \\
      samples/01_alafasy_fatihah.wav --out /tmp/onnx_vs_official
  python experiments/diy_coreml_poc/compare_onnx_vs_official_decoder.py \\
      samples/01_alafasy_fatihah.wav samples/02_basfar_ikhlas.wav \\
      samples/03_alafasy_naba.wav --out /tmp/onnx_vs_official
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
import run_coreml_e2e as diy  # noqa: E402

BLANK_ID = 1024
SUBSAMPLE = 8
OFFICIAL_BUCKETS = [80, 200, 400, 800, 1600, 2400, 4800]

ONNX_ENC = ROOT / "models" / "onnx" / "model_with_encoder.onnx"
OFF_ENC = ROOT / "models" / "coreml" / "fastconformer-quran-offline-ane.mlpackage"
TOKENS = ROOT / "models" / "tokens.txt"
if not TOKENS.exists():
    TOKENS = ROOT / "docs" / "tokens.txt"
OFF_TOKENS = ROOT / "models" / "coreml" / "tokens.txt"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def tensor_stats(name: str, arr: np.ndarray) -> dict:
    flat = np.asarray(arr, dtype=np.float32).reshape(-1)
    finite = bool(np.isfinite(flat).all())
    return {
        "name": name,
        "shape": list(arr.shape),
        "dtype": str(arr.dtype),
        "finite": finite,
        "mean": float(np.mean(flat)) if flat.size else None,
        "std": float(np.std(flat)) if flat.size else None,
        "min": float(np.min(flat)) if flat.size else None,
        "max": float(np.max(flat)) if flat.size else None,
        "l2": float(np.linalg.norm(flat)) if flat.size else None,
        "sha256": sha256_bytes(flat.tobytes()) if flat.size else None,
    }


def pad_to_bucket(mel: np.ndarray, buckets: list[int]) -> tuple[np.ndarray, int]:
    t = mel.shape[1]
    for b in buckets:
        if b >= t:
            if b == t:
                return mel.astype(np.float32), b
            out = np.zeros((80, b), dtype=np.float32)
            out[:, :t] = mel
            return out, b
    raise ValueError(f"mel T={t} exceeds max bucket {buckets[-1]}")


def predict_onnx(sess: ort.InferenceSession, mel: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    t = mel.shape[1]
    outs = sess.run(
        None,
        {
            "audio_signal": mel[None, ...].astype(np.float32),
            "length": np.array([t], dtype=np.int64),
        },
    )
    logprobs = np.asarray(outs[0])
    encoder = np.asarray(outs[1])
    if logprobs.ndim == 3:
        logprobs = logprobs[0]
    if encoder.ndim == 3:
        encoder = encoder[0]
    if encoder.ndim == 2 and encoder.shape[0] == 512 and encoder.shape[1] != 512:
        encoder = encoder.T
    return logprobs.astype(np.float32), encoder.astype(np.float32)


def predict_official(enc_by_fn: dict, mel: np.ndarray) -> tuple[np.ndarray, np.ndarray, int, str]:
    padded, bucket = pad_to_bucket(mel, OFFICIAL_BUCKETS)
    fn = f"predict_T{bucket}"
    model = enc_by_fn[fn]
    audio = padded[None, ...].astype(np.float32)
    try:
        out = model.predict({"audio_signal": audio})
    except Exception:
        key = next(iter(model.get_spec().description.input)).name
        out = model.predict({key: audio})
    logprobs = np.asarray(out["logprobs"] if "logprobs" in out else diy._pick_logprobs(out))
    encoder = np.asarray(
        out["encoder_output"] if "encoder_output" in out else diy._pick_encoder(out)
    )
    if logprobs.ndim == 3:
        logprobs = logprobs[0]
    if encoder.ndim == 3:
        encoder = encoder[0]
    if encoder.ndim == 2 and encoder.shape[0] == 512 and encoder.shape[1] != 512:
        encoder = encoder.T
    return logprobs.astype(np.float32), encoder.astype(np.float32), bucket, fn


def pieces_before_space_join(pieces: list[str], ids: list[int]) -> list[str]:
    """Raw SentencePiece pieces for each collapsed id (before ▁ → space)."""
    out: list[str] = []
    for i in ids:
        if 0 <= i < len(pieces):
            out.append(pieces[i])
        else:
            out.append(f"<OOV:{i}>")
    return out


def decode_dump(pieces: list[str], logprobs: np.ndarray, true_mel_t: int) -> dict:
    """Full CTC decode dump: argmax → collapse → pieces → transcript."""
    argmax_full = logprobs.argmax(axis=-1).astype(np.int64)
    t_out = int(argmax_full.shape[0])
    # Device path uses full logprobs. Also dump true-length slice (mel_t // 8).
    slice_t = min(t_out, max(1, true_mel_t // SUBSAMPLE))
    argmax_sliced = argmax_full[:slice_t]

    ids_full = collapse_ctc(argmax_full.tolist(), blank_id=BLANK_ID)
    ids_sliced = collapse_ctc(argmax_sliced.tolist(), blank_id=BLANK_ID)

    piece_strs_full = pieces_before_space_join(pieces, ids_full)
    piece_strs_sliced = pieces_before_space_join(pieces, ids_sliced)
    # Concatenation *before* ▁→space (tokenizer decode step 1).
    raw_concat_full = "".join(piece_strs_full)
    raw_concat_sliced = "".join(piece_strs_sliced)
    transcript_full = e2e.decode_ids(pieces, ids_full)
    transcript_sliced = e2e.decode_ids(pieces, ids_sliced)

    trailing = argmax_full[slice_t:]
    return {
        "logprobs": tensor_stats("logprobs", logprobs),
        "argmax_full": {
            "length": t_out,
            "non_blank": int(np.sum(argmax_full != BLANK_ID)),
            "sha256": sha256_bytes(argmax_full.astype(np.int32).tobytes()),
            "first_32": argmax_full[:32].tolist(),
            "last_32": argmax_full[-32:].tolist() if t_out >= 32 else argmax_full.tolist(),
        },
        "argmax_sliced_to_true_t": {
            "slice_t": slice_t,
            "true_mel_t": true_mel_t,
            "non_blank": int(np.sum(argmax_sliced != BLANK_ID)),
            "sha256": sha256_bytes(argmax_sliced.astype(np.int32).tobytes()),
            "ids": argmax_sliced.tolist(),
        },
        "trailing_after_true_t": {
            "frames": int(trailing.size),
            "non_blank": int(np.sum(trailing != BLANK_ID)) if trailing.size else 0,
            "blank_fraction": float(np.mean(trailing == BLANK_ID)) if trailing.size else None,
            "unique_ids_sample": sorted({int(x) for x in trailing[:200].tolist()}) if trailing.size else [],
        },
        "greedy_token_ids_full": ids_full,
        "greedy_token_ids_sliced": ids_sliced,
        "piece_strings_before_norm_full": piece_strs_full,
        "piece_strings_before_norm_sliced": piece_strs_sliced,
        "raw_concat_before_space_join_full": raw_concat_full,
        "raw_concat_before_space_join_sliced": raw_concat_sliced,
        "final_transcript_full": transcript_full,
        "final_transcript_sliced": transcript_sliced,
        # Device uses full path:
        "device_path_transcript": transcript_full,
        "device_path_token_ids": ids_full,
    }


def overlap_compare(
    onnx_enc: np.ndarray,
    off_enc: np.ndarray,
    onnx_lp: np.ndarray,
    off_lp: np.ndarray,
) -> dict:
    """Compare overlapping time frames (min T_out) numerically."""
    t = min(onnx_enc.shape[0], off_enc.shape[0])
    d = min(onnx_enc.shape[1], off_enc.shape[1])
    a = onnx_enc[:t, :d]
    b = off_enc[:t, :d]
    diff = a - b
    absdiff = np.abs(diff)
    # Cosine over flattened overlap
    af = a.reshape(-1)
    bf = b.reshape(-1)
    denom = float(np.linalg.norm(af) * np.linalg.norm(bf)) + 1e-12
    cos = float(np.dot(af, bf) / denom)

    t_lp = min(onnx_lp.shape[0], off_lp.shape[0])
    v = min(onnx_lp.shape[1], off_lp.shape[1])
    la = onnx_lp[:t_lp, :v]
    lb = off_lp[:t_lp, :v]
    arg_a = la.argmax(axis=-1)
    arg_b = lb.argmax(axis=-1)
    arg_match = arg_a == arg_b
    first_arg_mismatch = int(np.argmax(~arg_match)) if not bool(arg_match.all()) else None
    if first_arg_mismatch is not None and bool(arg_match.all()):
        first_arg_mismatch = None

    return {
        "overlap_frames_encoder": t,
        "overlap_dim_encoder": d,
        "encoder_mae": float(absdiff.mean()),
        "encoder_max_abs": float(absdiff.max()),
        "encoder_rmse": float(np.sqrt(np.mean(diff**2))),
        "encoder_cosine": cos,
        "encoder_close_atol1e2": bool(np.allclose(a, b, atol=1e-2, rtol=1e-2)),
        "encoder_close_atol1e1": bool(np.allclose(a, b, atol=1e-1, rtol=1e-1)),
        "overlap_frames_logprobs": t_lp,
        "argmax_match_fraction": float(arg_match.mean()) if arg_match.size else None,
        "argmax_mismatch_count": int(np.sum(~arg_match)),
        "first_argmax_mismatch_frame": first_arg_mismatch,
        "first_mismatch_onnx_id": int(arg_a[first_arg_mismatch]) if first_arg_mismatch is not None else None,
        "first_mismatch_official_id": int(arg_b[first_arg_mismatch]) if first_arg_mismatch is not None else None,
        "logprobs_mae_overlap": float(np.mean(np.abs(la - lb))),
    }


def find_first_divergence(onnx: dict, official: dict, overlap: dict) -> dict:
    """Walk the pipeline and return the earliest disagreeing stage."""
    stages: list[dict] = []

    def add(stage: str, match: bool, detail: dict):
        stages.append({"stage": stage, "match": match, "detail": detail})

    add(
        "tokens_vocabulary",
        onnx["tokens_sha256"] == official["tokens_sha256"],
        {"onnx": onnx["tokens_sha256"][:16], "official": official["tokens_sha256"][:16]},
    )
    add(
        "mel_frontend",
        onnx["mel_sha256"] == official["mel_sha256"],
        {"onnx": onnx["mel_sha256"][:16], "official": official["mel_sha256"][:16]},
    )

    # Shape mismatch is expected (dynamic vs bucket). Still record it, but also
    # compute the first *content* divergence that can change the transcript.
    shape_match = onnx["encoder_stats"]["shape"] == official["encoder_stats"]["shape"]
    add(
        "encoder_output_shape",
        shape_match,
        {
            "onnx": onnx["encoder_stats"]["shape"],
            "official": official["encoder_stats"]["shape"],
            "official_bucket_t": official.get("bucket_t"),
            "note": "Android ONNX is dynamic T_out; Official is bucketT/8 (padded, no length).",
            "expected_difference": True,
        },
    )

    # Numerical closeness on overlap — "close" if mae < 0.05 AND cosine > 0.99
    # (tight: enough that greedy argmax usually matches).
    enc_close = overlap["encoder_cosine"] > 0.99 and overlap["encoder_mae"] < 0.05
    add(
        "encoder_output_overlap_numerics",
        enc_close,
        {
            "cosine": overlap["encoder_cosine"],
            "mae": overlap["encoder_mae"],
            "rmse": overlap["encoder_rmse"],
            "max_abs": overlap["encoder_max_abs"],
            "interpretation": (
                "close" if enc_close else "not_close_enough_for_identical_argmax"
            ),
        },
    )

    argmax_overlap_ok = overlap["argmax_mismatch_count"] == 0
    add(
        "ctc_greedy_argmax_overlap_frames",
        argmax_overlap_ok,
        {
            "match_fraction": overlap["argmax_match_fraction"],
            "mismatch_count": overlap["argmax_mismatch_count"],
            "first_mismatch_frame": overlap["first_argmax_mismatch_frame"],
            "onnx_id": overlap["first_mismatch_onnx_id"],
            "official_id": overlap["first_mismatch_official_id"],
            "logprobs_mae": overlap["logprobs_mae_overlap"],
        },
    )

    add(
        "ctc_collapsed_token_ids_full",
        onnx["decode"]["greedy_token_ids_full"] == official["decode"]["greedy_token_ids_full"],
        {
            "onnx": onnx["decode"]["greedy_token_ids_full"],
            "official": official["decode"]["greedy_token_ids_full"],
        },
    )
    add(
        "ctc_collapsed_token_ids_sliced_to_true_t",
        onnx["decode"]["greedy_token_ids_sliced"]
        == official["decode"]["greedy_token_ids_sliced"],
        {
            "onnx": onnx["decode"]["greedy_token_ids_sliced"],
            "official": official["decode"]["greedy_token_ids_sliced"],
        },
    )
    add(
        "piece_strings_before_text_normalization",
        onnx["decode"]["piece_strings_before_norm_full"]
        == official["decode"]["piece_strings_before_norm_full"],
        {
            "onnx": onnx["decode"]["piece_strings_before_norm_full"],
            "official": official["decode"]["piece_strings_before_norm_full"],
        },
    )
    add(
        "final_decoded_transcript_full",
        onnx["decode"]["final_transcript_full"] == official["decode"]["final_transcript_full"],
        {
            "onnx": onnx["decode"]["final_transcript_full"],
            "official": official["decode"]["final_transcript_full"],
        },
    )
    add(
        "final_decoded_transcript_sliced",
        onnx["decode"]["final_transcript_sliced"]
        == official["decode"]["final_transcript_sliced"],
        {
            "onnx": onnx["decode"]["final_transcript_sliced"],
            "official": official["decode"]["final_transcript_sliced"],
        },
    )

    first = next((s for s in stages if not s["match"]), None)
    # Skip expected structural shape-only mismatch when naming "content" first cause.
    first_content = next(
        (
            s
            for s in stages
            if not s["match"] and not s["detail"].get("expected_difference")
        ),
        None,
    )
    return {
        "first_divergence": first,
        "first_content_divergence": first_content,
        "stages": stages,
    }


def run_one(
    wav_path: Path,
    onnx_sess: ort.InferenceSession,
    off_models: dict,
    pieces: list[str],
    tokens_sha: str,
) -> dict:
    wav, sr = sf.read(str(wav_path), dtype="float32")
    if wav.ndim > 1:
        wav = wav.mean(axis=1)
    if sr != 16000:
        raise SystemExit(f"{wav_path}: expected 16 kHz, got {sr}")

    mel = log_mel(wav)  # (80, T)
    mel_sha = sha256_bytes(mel.astype(np.float32).tobytes())
    true_t = int(mel.shape[1])

    t0 = time.perf_counter()
    onnx_lp, onnx_enc = predict_onnx(onnx_sess, mel)
    onnx_ms = (time.perf_counter() - t0) * 1000

    t1 = time.perf_counter()
    off_lp, off_enc, bucket, fn = predict_official(off_models, mel)
    off_ms = (time.perf_counter() - t1) * 1000

    onnx_side = {
        "runtime": "android_onnx",
        "infer_ms": onnx_ms,
        "tokens_sha256": tokens_sha,
        "mel_sha256": mel_sha,
        "mel_time": true_t,
        "encoder_stats": tensor_stats("encoder_output", onnx_enc),
        "logprobs_stats": tensor_stats("logprobs", onnx_lp),
        "decode": decode_dump(pieces, onnx_lp, true_t),
        "has_length_input": True,
        "bucket_t": None,
        "function_name": None,
    }
    off_side = {
        "runtime": "official_coreml",
        "infer_ms": off_ms,
        "tokens_sha256": tokens_sha,
        "mel_sha256": mel_sha,
        "mel_time": true_t,
        "encoder_stats": tensor_stats("encoder_output", off_enc),
        "logprobs_stats": tensor_stats("logprobs", off_lp),
        "decode": decode_dump(pieces, off_lp, true_t),
        "has_length_input": False,
        "bucket_t": bucket,
        "function_name": fn,
    }
    overlap = overlap_compare(onnx_enc, off_enc, onnx_lp, off_lp)
    divergence = find_first_divergence(onnx_side, off_side, overlap)

    return {
        "wav": str(wav_path),
        "duration_sec": float(len(wav) / sr),
        "mel_time": true_t,
        "tokens_file": str(TOKENS),
        "tokens_sha256": tokens_sha,
        "android_onnx": onnx_side,
        "official_coreml": off_side,
        "overlap_compare": overlap,
        "divergence": divergence,
    }


def pick_compute_units():
    """Official ANE pack emits NaN on host CPU/GPU; prefer CPU_AND_NE."""
    candidates = [
        ("CPU_AND_NE", getattr(ct.ComputeUnit, "CPU_AND_NE", None)),
        ("CPU_AND_GPU", ct.ComputeUnit.CPU_AND_GPU),
        ("CPU_ONLY", ct.ComputeUnit.CPU_ONLY),
    ]
    for label, cu in candidates:
        if cu is None:
            continue
        try:
            fn = "predict_T80"
            m = ct.models.MLModel(str(OFF_ENC), compute_units=cu, function_name=fn)
            mel = np.zeros((1, 80, 80), dtype=np.float32)
            out = m.predict({"audio_signal": mel})
            lp = np.asarray(out["logprobs"] if "logprobs" in out else next(iter(out.values())))
            if np.isfinite(lp).all():
                return label, cu
            print(f"  {label}: loads but logprobs non-finite — skip")
        except Exception as exc:  # noqa: BLE001
            print(f"  {label}: {exc}")
    raise SystemExit("No usable CoreML compute unit for Official pack")


def load_official_models(compute_units) -> dict[str, object]:
    out = {}
    for b in OFFICIAL_BUCKETS:
        fn = f"predict_T{b}"
        out[fn] = ct.models.MLModel(
            str(OFF_ENC), compute_units=compute_units, function_name=fn
        )
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("wavs", nargs="+", type=Path, help="16 kHz mono WAV(s)")
    ap.add_argument("--out", type=Path, default=POC / "reports" / "onnx_vs_official_decoder")
    args = ap.parse_args()

    if not ONNX_ENC.exists():
        raise SystemExit(f"missing ONNX encoder: {ONNX_ENC}")
    if not OFF_ENC.exists():
        raise SystemExit(f"missing Official CoreML: {OFF_ENC}")
    if not TOKENS.exists():
        raise SystemExit(f"missing tokens: {TOKENS}")

    pieces = e2e.load_tokens(TOKENS)
    tokens_sha = sha256_file(TOKENS)
    off_tokens_sha = sha256_file(OFF_TOKENS) if OFF_TOKENS.exists() else None
    print(f"tokens.txt sha256={tokens_sha}")
    if off_tokens_sha and off_tokens_sha != tokens_sha:
        print(f"WARNING: coreml/tokens.txt differs: {off_tokens_sha}")
    else:
        print("tokens vocabulary: ONNX pack ≡ Official pack (byte-identical)")

    print("Loading Android ONNX…")
    onnx_sess = ort.InferenceSession(str(ONNX_ENC), providers=["CPUExecutionProvider"])
    print("Loading Official CoreML specialized functions…")
    print("Picking compute units (Official ANE pack often NaNs on CPU/GPU)…")
    cu_label, cu = pick_compute_units()
    off_models = load_official_models(cu)
    print(f"Official compute_units={cu_label}")

    args.out.mkdir(parents=True, exist_ok=True)
    summary = {
        "compute_units": cu_label,
        "tokens_sha256": tokens_sha,
        "ctc_impl_note": (
            "collapse_ctc / CtcDecoder identical on Android Kotlin, iOS Swift, and "
            "Python (blank=1024, blank resets prev)."
        ),
        "results": [],
    }

    for wav in args.wavs:
        print(f"\n=== {wav.name} ===")
        result = run_one(wav, onnx_sess, off_models, pieces, tokens_sha)
        out_path = args.out / f"{wav.stem}_decoder_dump.json"
        out_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
        first = result["divergence"]["first_divergence"]
        first_content = result["divergence"]["first_content_divergence"]
        onnx_hyp = result["android_onnx"]["decode"]["device_path_transcript"]
        off_hyp = result["official_coreml"]["decode"]["device_path_transcript"]
        off_sliced = result["official_coreml"]["decode"]["final_transcript_sliced"]
        print(f"  ONNX hyp:      {onnx_hyp!r}")
        print(f"  Official hyp:  {off_hyp!r}")
        print(f"  Official slice:{off_sliced!r}")
        print(f"  encoder shapes: ONNX {result['android_onnx']['encoder_stats']['shape']}  "
              f"Official {result['official_coreml']['encoder_stats']['shape']} "
              f"(bucket={result['official_coreml']['bucket_t']})")
        print(f"  overlap cosine={result['overlap_compare']['encoder_cosine']:.6f} "
              f"mae={result['overlap_compare']['encoder_mae']:.4f} "
              f"argmax_match={result['overlap_compare']['argmax_match_fraction']}")
        if first:
            print(f"  FIRST DIVERGENCE (incl. expected shape): {first['stage']}")
        if first_content:
            print(f"  FIRST CONTENT DIVERGENCE: {first_content['stage']}")
        else:
            print("  All content stages match.")
        summary["results"].append(
            {
                "wav": wav.name,
                "first_divergence_stage": first["stage"] if first else None,
                "first_content_divergence_stage": first_content["stage"]
                if first_content
                else None,
                "onnx_transcript": onnx_hyp,
                "official_transcript_full": off_hyp,
                "official_transcript_sliced": off_sliced,
                "transcripts_match_full": onnx_hyp == off_hyp,
                "transcripts_match_sliced": onnx_hyp
                == result["android_onnx"]["decode"]["final_transcript_sliced"]
                == off_sliced,
                "dump": str(out_path),
            }
        )

    summary_path = args.out / "summary.json"
    summary_path.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"\nWrote {summary_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
