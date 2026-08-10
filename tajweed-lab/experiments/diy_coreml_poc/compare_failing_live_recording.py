#!/usr/bin/env python3
"""Cross-feed a *failing* live iOS export through HF ONNX, DIY CoreML, Official CoreML.

Use ONLY when the user recited correctly but ASR returned incorrect words.
Do not use on golden clips or exports already proven successful (e.g. 2:5).

Usage (from tajweed-lab, venv active):
  python experiments/diy_coreml_poc/compare_failing_live_recording.py \\
      /path/to/last.wav \\
      --stages /path/to/last_stages.json \\
      --out experiments/diy_coreml_poc/reports/failing_live
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

from asr.mel import log_mel  # noqa: E402
import parity_dump_onnx_e2e as e2e  # noqa: E402
import run_coreml_e2e as diy_mod  # noqa: E402

from compare_onnx_vs_official_decoder import (  # noqa: E402
    OFF_ENC,
    TOKENS,
    decode_dump,
    find_first_divergence,
    load_official_models,
    overlap_compare,
    pick_compute_units,
    predict_official,
    predict_onnx,
    tensor_stats,
)

DIY_ENC = POC / "artifacts" / "optimization" / "palette_8bit" / "encoder.mlpackage"
ONNX_ENC = ROOT / "models" / "onnx" / "model_with_encoder.onnx"
FIXED_T_DIY = 4800

# Proven successful exports — skip unless --force.
SKIP_REFS = frozenset({"2:5"})


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def audio_stats(wav: np.ndarray, sr: int) -> dict:
    wav = np.asarray(wav, dtype=np.float32).reshape(-1)
    return {
        "num_samples": int(wav.shape[0]),
        "sample_rate": int(sr),
        "duration_sec": float(wav.shape[0] / sr),
        "peak_abs": float(np.max(np.abs(wav))),
        "mean_abs": float(np.mean(np.abs(wav))),
        "rms": float(np.sqrt(np.mean(wav**2))),
    }


def predict_diy(model: ct.models.MLModel, mel: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    t = mel.shape[1]
    audio = np.zeros((1, 80, FIXED_T_DIY), dtype=np.float32)
    audio[0, :, :t] = mel
    length = np.array([t], dtype=np.int32)
    try:
        out = model.predict({"audio_signal": audio, "length": length})
    except Exception:
        out = model.predict({"audio_signal": audio, "length": np.array([t], dtype=np.int64)})
    logprobs = np.asarray(out["logprobs"] if "logprobs" in out else diy_mod._pick_logprobs(out))
    encoder = np.asarray(
        out["encoder_output"] if "encoder_output" in out else diy_mod._pick_encoder(out)
    )
    if logprobs.ndim == 3:
        logprobs = logprobs[0]
    if encoder.ndim == 3:
        encoder = encoder[0]
    if encoder.ndim == 2 and encoder.shape[0] == 512 and encoder.shape[1] != 512:
        encoder = encoder.T
    return logprobs.astype(np.float32), encoder.astype(np.float32)


def side_dict(
    runtime: str,
    infer_ms: float,
    tokens_sha: str,
    mel_sha: str,
    true_t: int,
    logprobs: np.ndarray,
    encoder: np.ndarray,
    pieces: list[str],
    *,
    bucket_t: int | None = None,
    function_name: str | None = None,
    has_length: bool = False,
) -> dict:
    return {
        "runtime": runtime,
        "infer_ms": infer_ms,
        "tokens_sha256": tokens_sha,
        "mel_sha256": mel_sha,
        "mel_time": true_t,
        "encoder_stats": tensor_stats("encoder_output", encoder),
        "logprobs_stats": tensor_stats("logprobs", logprobs),
        "decode": decode_dump(pieces, logprobs, true_t),
        "has_length_input": has_length,
        "bucket_t": bucket_t,
        "function_name": function_name,
    }


def first_differing_frame(onnx_lp: np.ndarray, other_lp: np.ndarray) -> dict | None:
    t = min(onnx_lp.shape[0], other_lp.shape[0])
    a = onnx_lp[:t].argmax(axis=-1)
    b = other_lp[:t].argmax(axis=-1)
    mism = np.where(a != b)[0]
    if mism.size == 0:
        return None
    f = int(mism[0])
    return {
        "frame": f,
        "onnx_argmax_id": int(a[f]),
        "other_argmax_id": int(b[f]),
        "onnx_logprob_at_onnx_pick": float(onnx_lp[f, a[f]]),
        "other_logprob_at_onnx_pick": float(other_lp[f, a[f]]),
    }


def audio_capture_evidence(audio: dict) -> tuple[bool, str]:
    """Evidence-based poor capture (matches iOS validateAudioQuality thresholds)."""
    reasons: list[str] = []
    if audio["mean_abs"] < 0.005:
        reasons.append(f"mean_abs={audio['mean_abs']:.4f} < 0.005 (mostly silence)")
    if audio["peak_abs"] > 0.99:
        reasons.append(f"peak={audio['peak_abs']:.4f} > 0.99 (clipping)")
    if audio["peak_abs"] < 0.02:
        reasons.append(f"peak={audio['peak_abs']:.4f} < 0.02 (very quiet capture)")
    if reasons:
        return True, "; ".join(reasons)
    return False, ""


def classify_root_cause(
    *,
    expected: str,
    onnx_hyp: str,
    diy_hyp: str,
    off_hyp: str | None,
    ios_hyp: str | None,
    audio: dict,
    diy_matches_onnx: bool,
    off_matches_onnx: bool | None,
    ios_matches_onnx: bool | None,
    diy_divergence: dict,
    off_divergence: dict | None,
) -> dict:
    """Exactly one of: audio_capture_issue | coreml_inference_issue | model_limitation."""
    all_coreml_wrong_vs_onnx = not diy_matches_onnx or (
        off_matches_onnx is False if off_hyp is not None else False
    ) or (ios_matches_onnx is False if ios_hyp is not None else False)

    onnx_matches_expected = onnx_hyp.strip() == expected.strip()

    # HF ONNX succeeds (matches app expected ayah) but CoreML path differs.
    if onnx_matches_expected and all_coreml_wrong_vs_onnx:
        div = diy_divergence if not diy_matches_onnx else (off_divergence or {})
        first_stage = (div.get("first_content_divergence") or div.get("first_divergence") or {}).get(
            "stage"
        )
        return {
            "category": "coreml_inference_issue",
            "rationale": "HF ONNX transcript matches expected; at least one CoreML path differs.",
            "fixable_in_app_code": True,
            "fix_notes": "Model pack selection, bucket/length handling, compute units, or CoreML export path.",
            "first_diverging_stage": first_stage,
        }

    all_same_wrong = (
        diy_matches_onnx
        and (off_matches_onnx is not False if off_hyp is not None else True)
        and (ios_matches_onnx is not False if ios_hyp is not None else True)
        and not onnx_matches_expected
    )

    if all_same_wrong:
        bad_audio, audio_reason = audio_capture_evidence(audio)
        if bad_audio:
            return {
                "category": "audio_capture_issue",
                "rationale": f"All runtimes agree on incorrect transcript; audio metrics: {audio_reason}",
                "fixable_in_app_code": True,
                "fix_notes": "Microphone session, gain, AVAudioConverter streaming resample, Bluetooth HFP.",
                "first_diverging_stage": "recorded_pcm (before model — all models see same mel)",
            }
        return {
            "category": "model_limitation",
            "rationale": "HF ONNX, DIY, and Official produce the same incorrect transcript on this WAV.",
            "fixable_in_app_code": False,
            "fix_notes": "Requires different model, training data, or user guidance (closer mic, slower recitation).",
            "first_diverging_stage": "none_all_runtimes_agree",
        }

    if all_coreml_wrong_vs_onnx:
        div = diy_divergence if not diy_matches_onnx else (off_divergence or {})
        first_stage = (div.get("first_content_divergence") or div.get("first_divergence") or {}).get(
            "stage"
        )
        return {
            "category": "coreml_inference_issue",
            "rationale": "CoreML transcript or token IDs differ from HF ONNX on the same WAV.",
            "fixable_in_app_code": True,
            "fix_notes": "See first_diverging_stage in DIY vs Official dumps.",
            "first_diverging_stage": first_stage,
        }

    return {
        "category": "needs_manual_review",
        "rationale": "Could not classify automatically from exported evidence.",
        "fixable_in_app_code": None,
        "fix_notes": "Inspect full crossfeed JSON.",
        "first_diverging_stage": None,
    }


def write_concise_report(path: Path, report: dict) -> None:
    r = report
    c = r["classification"]
    lines = [
        f"# Failing live recitation report — {r['ref']}",
        "",
        f"**WAV:** `{r['wav']}`  ",
        f"**Duration:** {r['audio']['duration_sec']:.2f}s | **peak:** {r['audio']['peak_abs']:.4f} | **mean_abs:** {r['audio']['mean_abs']:.4f}",
        "",
        "## Transcripts",
        "",
        f"- **Expected (app):** {r['expected_transcript']!r}",
        f"- **HF ONNX:** {r['hf_onnx_transcript']!r}",
        f"- **DIY CoreML:** {r['diy_transcript']!r}",
        f"- **Official CoreML:** {r['official_transcript']!r}",
        f"- **iOS device:** {r['ios_transcript']!r}",
        "",
        "## Collapsed token IDs",
        "",
        f"- **HF ONNX:** `{r['onnx_token_ids']}`",
        f"- **DIY:** `{r['diy_token_ids']}`",
        f"- **Official:** `{r['official_token_ids']}`",
        "",
        "## First differing frame (vs HF ONNX)",
        "",
        f"- **DIY:** {r['first_differing_frame_diy']}",
        f"- **Official:** {r['first_differing_frame_official']}",
        "",
        "## Divergence",
        "",
        f"- **First diverging stage:** {c['first_diverging_stage']}",
        f"- **DIY content stage:** {r.get('diy_first_content_stage')}",
        f"- **Official content stage:** {r.get('official_first_content_stage')}",
        "",
        "## Root cause",
        "",
        f"- **Category:** `{c['category']}`",
        f"- **Rationale:** {c['rationale']}",
        f"- **Fixable in app code:** {c['fixable_in_app_code']}",
        f"- **Notes:** {c['fix_notes']}",
        "",
    ]
    path.write_text("\n".join(lines), encoding="utf-8")


def run(wav_path: Path, stages_path: Path, out_dir: Path, *, force: bool = False) -> dict:
    if not wav_path.exists():
        raise SystemExit(f"Missing WAV: {wav_path}")
    if not stages_path or not stages_path.exists():
        raise SystemExit("--stages last_stages.json is required for failing-recitation reports.")
    for p in (ONNX_ENC, TOKENS, DIY_ENC):
        if not p.exists():
            raise SystemExit(f"Missing dependency: {p}")

    stages = json.loads(stages_path.read_text(encoding="utf-8"))
    ref = stages.get("ref", "?")
    if ref in SKIP_REFS and not force:
        raise SystemExit(
            f"ref={ref} is a proven successful export. Use --force to override, or export a failing take (e.g. 2:3)."
        )

    expected = stages.get("originalExpectedAyah") or stages.get("expected") or ""
    ios_hyp = stages.get("originalAsrHypothesis") or stages.get("hypothesis") or ""

    wav, sr = sf.read(str(wav_path), dtype="float32")
    if wav.ndim > 1:
        wav = wav.mean(axis=1)
    if sr != 16000:
        raise SystemExit(f"Expected 16 kHz mono WAV, got sr={sr}")

    audio = audio_stats(wav, sr)
    mel = log_mel(wav.astype(np.float32))
    mel_sha = sha256_bytes(mel.astype(np.float32).tobytes())
    true_t = int(mel.shape[1])
    pieces = e2e.load_tokens(TOKENS)
    tokens_sha = sha256_bytes(TOKENS.read_bytes())

    onnx_sess = ort.InferenceSession(str(ONNX_ENC), providers=["CPUExecutionProvider"])

    t0 = time.perf_counter()
    onnx_lp, onnx_enc = predict_onnx(onnx_sess, mel)
    onnx_ms = (time.perf_counter() - t0) * 1000
    onnx_side = side_dict(
        "hf_onnx", onnx_ms, tokens_sha, mel_sha, true_t, onnx_lp, onnx_enc, pieces, has_length=True
    )

    t0 = time.perf_counter()
    diy_model = ct.models.MLModel(str(DIY_ENC), compute_units=ct.ComputeUnit.CPU_ONLY)
    diy_lp, diy_enc = predict_diy(diy_model, mel)
    diy_ms = (time.perf_counter() - t0) * 1000
    diy_side = side_dict(
        "diy_coreml_palette8",
        diy_ms,
        tokens_sha,
        mel_sha,
        true_t,
        diy_lp,
        diy_enc,
        pieces,
        bucket_t=FIXED_T_DIY,
        function_name="__single__",
        has_length=True,
    )

    official_side = None
    official_err = None
    off_lp = off_enc = None
    off_overlap = off_divergence = None
    try:
        _label, cu = pick_compute_units()
        off_models = load_official_models(cu)
        t0 = time.perf_counter()
        off_lp, off_enc, bucket, fn = predict_official(off_models, mel)
        off_ms = (time.perf_counter() - t0) * 1000
        official_side = side_dict(
            "official_coreml",
            off_ms,
            tokens_sha,
            mel_sha,
            true_t,
            off_lp,
            off_enc,
            pieces,
            bucket_t=bucket,
            function_name=fn,
            has_length=False,
        )
        off_overlap = overlap_compare(onnx_enc, off_enc, onnx_lp, off_lp)
        off_divergence = find_first_divergence(onnx_side, official_side, off_overlap)
    except (SystemExit, Exception) as exc:  # noqa: BLE001
        official_err = str(exc)

    diy_overlap = overlap_compare(onnx_enc, diy_enc, onnx_lp, diy_lp)
    diy_divergence = find_first_divergence(onnx_side, diy_side, diy_overlap)

    onnx_hyp = onnx_side["decode"]["final_transcript_full"]
    diy_hyp = diy_side["decode"]["final_transcript_full"]
    off_hyp = official_side["decode"]["final_transcript_full"] if official_side else None

    diy_matches = diy_hyp == onnx_hyp
    off_matches = off_hyp == onnx_hyp if off_hyp is not None else None
    ios_matches = ios_hyp == onnx_hyp if ios_hyp else None

    classification = classify_root_cause(
        expected=expected,
        onnx_hyp=onnx_hyp,
        diy_hyp=diy_hyp,
        off_hyp=off_hyp,
        ios_hyp=ios_hyp,
        audio=audio,
        diy_matches_onnx=diy_matches,
        off_matches_onnx=off_matches,
        ios_matches_onnx=ios_matches,
        diy_divergence=diy_divergence,
        off_divergence=off_divergence,
    )

    concise = {
        "ref": ref,
        "wav": str(wav_path),
        "stages_json": str(stages_path),
        "audio": audio,
        "expected_transcript": expected,
        "hf_onnx_transcript": onnx_hyp,
        "diy_transcript": diy_hyp,
        "official_transcript": off_hyp,
        "official_host_error": official_err,
        "ios_transcript": ios_hyp,
        "onnx_token_ids": onnx_side["decode"]["greedy_token_ids_full"],
        "diy_token_ids": diy_side["decode"]["greedy_token_ids_full"],
        "official_token_ids": (
            official_side["decode"]["greedy_token_ids_full"] if official_side else None
        ),
        "first_differing_frame_diy": first_differing_frame(onnx_lp, diy_lp),
        "first_differing_frame_official": (
            first_differing_frame(onnx_lp, off_lp) if off_lp is not None else None
        ),
        "diy_first_content_stage": (diy_divergence.get("first_content_divergence") or {}).get("stage"),
        "official_first_content_stage": (
            (off_divergence.get("first_content_divergence") or {}).get("stage") if off_divergence else None
        ),
        "classification": classification,
        "full_crossfeed": {
            "hf_onnx": onnx_side,
            "diy_coreml": diy_side,
            "official_coreml": official_side,
            "divergence_vs_onnx": {"diy": diy_divergence, "official": off_divergence},
            "overlap_vs_onnx": {"diy": diy_overlap, "official": off_overlap},
        },
    }

    out_dir.mkdir(parents=True, exist_ok=True)
    tag = ref.replace(":", "_")
    json_path = out_dir / f"{tag}_crossfeed.json"
    md_path = out_dir / f"{tag}_report.md"
    json_path.write_text(json.dumps(concise, indent=2, ensure_ascii=False), encoding="utf-8")
    write_concise_report(md_path, concise)

    print(f"Wrote {md_path}")
    print(f"Wrote {json_path}")
    print(f"\nCategory: {classification['category']}")
    print(f"First diverging stage: {classification['first_diverging_stage']}")

    return concise


def main() -> int:
    ap = argparse.ArgumentParser(description="Report on failing live last.wav only.")
    ap.add_argument("wav", type=Path)
    ap.add_argument("--stages", type=Path, required=True)
    ap.add_argument("--out", type=Path, default=POC / "reports" / "failing_live")
    ap.add_argument("--force", action="store_true", help="Allow proven-success refs like 2:5")
    args = ap.parse_args()
    run(args.wav, args.stages, args.out, force=args.force)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
