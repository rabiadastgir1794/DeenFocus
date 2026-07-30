#!/usr/bin/env python3
"""Post-training CoreML encoder optimization comparison (lab-only).

Applies architecture-preserving compressions to a *copy* of the existing FP32
DIY encoder.mlpackage. Never overwrites artifacts/encoder.mlpackage (the
production candidate) or the R2-uploaded device_pack.

Techniques evaluated:
  1. FP16 compute-precision re-convert (weights + compute cast at convert time)
  2. Magnitude pruning ("weight compression" / sparse storage)
  3. Palettization (k-means LUT, nbits=8 and nbits=4)
  4. Linear weight quantization (int8 and int4 where supported)

For each variant measures: .mlpackage size, loadability under CPU_AND_GPU,
golden-clip transcription, pronunciation-head scores (same head as baseline),
and host inference latency.

Usage (from tajweed-lab, venv active):
  python experiments/diy_coreml_poc/evaluate_encoder_optimizations.py
  python experiments/diy_coreml_poc/evaluate_encoder_optimizations.py --skip-fp16-convert
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
import time
import traceback
from pathlib import Path

import coremltools as ct
import numpy as np
import soundfile as sf
from coremltools.optimize.coreml import (
    OpLinearQuantizerConfig,
    OpMagnitudePrunerConfig,
    OpPalettizerConfig,
    OptimizationConfig,
    linear_quantize_weights,
    palettize_weights,
    prune_weights,
)

ROOT = Path(__file__).resolve().parents[2]
POC = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "web"))
sys.path.insert(0, str(ROOT / "scripts"))

from asr.decode import collapse_ctc  # noqa: E402
from asr.mel import log_mel  # noqa: E402
import parity_dump_onnx_e2e as e2e  # noqa: E402

# Reuse predict helpers from the existing e2e harness.
import run_coreml_e2e as e2e_runner  # noqa: E402

BASELINE_ENCODER = POC / "artifacts" / "encoder.mlpackage"
HEAD_ML = POC / "artifacts" / "pronunciation_head.mlpackage"
SAMPLES = ROOT / "samples"
TOKENS = ROOT / "models" / "tokens.txt"
if not TOKENS.exists():
    TOKENS = ROOT / "docs" / "tokens.txt"

OPT_DIR = POC / "artifacts" / "optimization"
REPORT_JSON = POC / "reports" / "encoder_optimization_comparison.json"
REPORT_MD = POC / "reports" / "encoder_optimization_comparison.md"
REPO_ROOT = ROOT.parent  # DeenFocus/
MEMORY_MD = (
    REPO_ROOT
    / "memory"
    / "features"
    / "tajweed"
    / "diy-coreml-encoder-optimization-2026-07-30.md"
)

BLANK_ID = 1024
FRAME_HOP_S = 0.080
COMPUTE_UNITS = ct.ComputeUnit.CPU_AND_GPU


def _package_size_bytes(path: Path) -> int:
    total = 0
    for p in path.rglob("*"):
        if p.is_file():
            total += p.stat().st_size
    return total


def _fmt_mb(n: int) -> str:
    return f"{n / (1024 * 1024):.1f} MB"


def _copy_baseline() -> Path:
    dst = OPT_DIR / "baseline_fp32" / "encoder.mlpackage"
    if dst.exists():
        # Already copied — reuse unless the source is newer.
        src_weight = BASELINE_ENCODER / "Data" / "com.apple.CoreML" / "weights" / "weight.bin"
        dst_weight = dst / "Data" / "com.apple.CoreML" / "weights" / "weight.bin"
        if (
            src_weight.exists()
            and dst_weight.exists()
            and src_weight.stat().st_size == dst_weight.stat().st_size
            and src_weight.stat().st_mtime <= dst_weight.stat().st_mtime + 1
        ):
            return dst
        shutil.rmtree(dst)
    dst.parent.mkdir(parents=True, exist_ok=True)
    print(f"Copying baseline FP32 → {dst}")
    shutil.copytree(BASELINE_ENCODER, dst)
    return dst


def _save_variant(model: ct.models.MLModel, name: str) -> Path:
    out = OPT_DIR / name / "encoder.mlpackage"
    if out.exists():
        shutil.rmtree(out)
    out.parent.mkdir(parents=True, exist_ok=True)
    model.save(str(out))
    return out


def build_fp16_convert() -> tuple[Path | None, str | None]:
    """Re-convert ONNX→CoreML with FLOAT16 compute precision into a separate dir.

    Does not touch artifacts/encoder.mlpackage.
    """
    out = OPT_DIR / "fp16_compute" / "encoder.mlpackage"
    if out.exists():
        # Allow reuse if a prior run already produced it.
        print(f"Reusing existing FP16 convert at {out}")
        return out, None

    print("Building FP16 compute-precision convert (does not overwrite FP32 baseline)…")
    # Import convert helpers and call convert_encoder, then move result aside.
    sys.path.insert(0, str(POC))
    import convert_onnx_to_coreml as conv  # noqa: WPS433

    # Temporarily redirect OUT_DIR so convert_encoder never writes over baseline.
    original_out = conv.OUT_DIR
    staging = OPT_DIR / "_fp16_staging"
    if staging.exists():
        shutil.rmtree(staging)
    staging.mkdir(parents=True)
    conv.OUT_DIR = staging
    try:
        produced = conv.convert_encoder(
            flexible=False, precision=ct.precision.FLOAT16, fixed_t=4800
        )
        out.parent.mkdir(parents=True, exist_ok=True)
        if out.exists():
            shutil.rmtree(out)
        shutil.move(str(produced), str(out))
        # Also move meta if present.
        meta = staging / "encoder_conversion_meta.json"
        if meta.exists():
            shutil.copy2(meta, out.parent / "encoder_conversion_meta.json")
        return out, None
    except Exception as e:
        return None, f"{type(e).__name__}: {e}"
    finally:
        conv.OUT_DIR = original_out
        if staging.exists():
            shutil.rmtree(staging, ignore_errors=True)


def build_prune(baseline: Path, sparsity: float) -> tuple[Path | None, str | None]:
    name = f"prune_sparsity_{int(sparsity * 100)}"
    print(f"Building {name}…")
    try:
        model = ct.models.MLModel(str(baseline))
        config = OptimizationConfig(
            global_config=OpMagnitudePrunerConfig(target_sparsity=sparsity)
        )
        compressed = prune_weights(model, config)
        return _save_variant(compressed, name), None
    except Exception as e:
        traceback.print_exc()
        return None, f"{type(e).__name__}: {e}"


def build_palettize(baseline: Path, nbits: int) -> tuple[Path | None, str | None]:
    name = f"palette_{nbits}bit"
    print(f"Building {name}…")
    try:
        model = ct.models.MLModel(str(baseline))
        config = OptimizationConfig(
            global_config=OpPalettizerConfig(mode="kmeans", nbits=nbits, num_kmeans_workers=4)
        )
        compressed = palettize_weights(model, config)
        return _save_variant(compressed, name), None
    except Exception as e:
        traceback.print_exc()
        return None, f"{type(e).__name__}: {e}"


def build_linear_quant(baseline: Path, dtype) -> tuple[Path | None, str | None]:
    dtype_name = "int8" if dtype == np.int8 else ("int4" if str(dtype).endswith("int4") else str(dtype))
    # coremltools accepts np.int8 or mil types; for int4 use string "int4".
    name = f"linear_{dtype_name}"
    print(f"Building {name}…")
    try:
        model = ct.models.MLModel(str(baseline))
        config = OptimizationConfig(
            global_config=OpLinearQuantizerConfig(
                mode="linear_symmetric",
                dtype=dtype,
            )
        )
        compressed = linear_quantize_weights(model, config)
        return _save_variant(compressed, name), None
    except Exception as e:
        traceback.print_exc()
        return None, f"{type(e).__name__}: {e}"


def evaluate_encoder(encoder_path: Path, pieces: list[str], head: ct.models.MLModel) -> dict:
    """Run golden clips through one encoder variant; return metrics dict."""
    result: dict = {
        "path": str(encoder_path),
        "size_bytes": _package_size_bytes(encoder_path),
        "size_mb": round(_package_size_bytes(encoder_path) / (1024 * 1024), 2),
        "load_ok": False,
        "load_error": None,
        "cold_load_ms": None,
        "samples": [],
        "summary": {},
    }

    try:
        t0 = time.time()
        enc = ct.models.MLModel(str(encoder_path), compute_units=COMPUTE_UNITS)
        result["cold_load_ms"] = round((time.time() - t0) * 1000, 1)
        result["load_ok"] = True
    except Exception as e:
        result["load_error"] = f"{type(e).__name__}: {e}"
        return result

    exact_count = 0
    nan_count = 0
    all_prob_deltas_vs_baseline: list[float] = []  # filled by caller if needed
    infer_ms_list: list[float] = []

    for wav_path in sorted(SAMPLES.glob("*.wav")):
        meta = e2e.EXPECTED.get(wav_path.name)
        if not meta:
            continue
        sample_rec: dict = {"sample": wav_path.name}
        try:
            wav, sr = sf.read(str(wav_path), dtype="float32")
            if wav.ndim > 1:
                wav = wav.mean(axis=1)

            t_inf = time.time()
            mel = log_mel(wav)
            logprobs, encoder = e2e_runner._predict_encoder(enc, mel)
            infer_ms = (time.time() - t_inf) * 1000
            infer_ms_list.append(infer_ms)

            if not np.isfinite(logprobs).all():
                nan_count += 1
                sample_rec["finite_logprobs"] = False
                sample_rec["inference_ms"] = round(infer_ms, 1)
                sample_rec["error"] = "non-finite logprobs (NaN/Inf)"
                result["samples"].append(sample_rec)
                continue

            sample_rec["finite_logprobs"] = True
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
                    if not np.isfinite(pooled).all():
                        sample_rec["error"] = "non-finite encoder features"
                        break
                    prob = e2e_runner._predict_head(head, pooled, token_id)
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
            exact = e2e.normalize_arabic(hypothesis) == e2e.normalize_arabic(meta["expected"])
            if exact:
                exact_count += 1
            sample_rec.update(
                {
                    "hypothesis": hypothesis,
                    "expected": meta["expected"],
                    "exactMatch": exact,
                    "wordAccuracy": e2e.word_accuracy(expected_words, hyp_words),
                    "inference_ms": round(infer_ms, 1),
                    "token_count": len(tokens),
                    "mean_pron_prob": (
                        round(sum(t["prob"] for t in tokens) / len(tokens), 6) if tokens else None
                    ),
                    "tokens": tokens,
                }
            )
        except Exception as e:
            sample_rec["error"] = f"{type(e).__name__}: {e}"
            traceback.print_exc()
        result["samples"].append(sample_rec)

    n = len([s for s in result["samples"] if "exactMatch" in s or s.get("error")])
    scored = [s for s in result["samples"] if s.get("exactMatch") is not None]
    result["summary"] = {
        "exact_match_count": exact_count,
        "scored_samples": len(scored),
        "nan_or_nonfinite_samples": nan_count,
        "mean_inference_ms": round(sum(infer_ms_list) / len(infer_ms_list), 1) if infer_ms_list else None,
        "all_exact": exact_count == len(scored) and len(scored) > 0 and nan_count == 0,
    }
    # Silence unused.
    _ = all_prob_deltas_vs_baseline
    _ = n
    return result


def compare_pronunciation(baseline_eval: dict, variant_eval: dict) -> dict:
    """Per-token |Δprob| and status-match vs baseline FP32."""
    out = {
        "mean_abs_prob_delta": None,
        "max_abs_prob_delta": None,
        "status_mismatch_count": 0,
        "token_pairs_compared": 0,
    }
    deltas: list[float] = []
    mismatches = 0
    pairs = 0
    base_by_name = {s["sample"]: s for s in baseline_eval.get("samples", [])}
    for vs in variant_eval.get("samples", []):
        bs = base_by_name.get(vs["sample"])
        if not bs or not bs.get("tokens") or not vs.get("tokens"):
            continue
        for bt, vt in zip(bs["tokens"], vs["tokens"]):
            pairs += 1
            deltas.append(abs(float(bt["prob"]) - float(vt["prob"])))
            if bt.get("status") != vt.get("status") or bt.get("text") != vt.get("text"):
                mismatches += 1
    if deltas:
        out["mean_abs_prob_delta"] = round(sum(deltas) / len(deltas), 6)
        out["max_abs_prob_delta"] = round(max(deltas), 6)
    out["status_mismatch_count"] = mismatches
    out["token_pairs_compared"] = pairs
    return out


def pipeline_compatibility(eval_result: dict) -> dict:
    """Heuristic compatibility with the current iOS OfflineAsrModel DIY path.

    Compatible if: loads, produces finite logprobs+encoder features, same I/O
    names/shapes conceptually (single-function fixed T=4800 + length), and
    transcription succeeds on goldens. We do not re-compile Swift here.
    """
    if not eval_result.get("load_ok"):
        return {
            "compatible": False,
            "reason": f"MLModel load failed: {eval_result.get('load_error')}",
        }
    if eval_result["summary"].get("nan_or_nonfinite_samples", 0) > 0:
        return {
            "compatible": False,
            "reason": "Non-finite logprobs/encoder features — would break CTC decode and pronunciation head.",
        }
    if any(s.get("error") for s in eval_result.get("samples", [])):
        errors = [s.get("error") for s in eval_result["samples"] if s.get("error")]
        return {"compatible": False, "reason": f"Inference errors: {errors[:2]}"}
    if not eval_result["summary"].get("all_exact"):
        return {
            "compatible": "partial",
            "reason": "Loads and runs, but transcription accuracy regresses vs baseline on golden clips.",
        }
    return {
        "compatible": True,
        "reason": (
            "Same single-function fixed-T I/O; finite outputs; golden transcripts exact. "
            "Manifest encoderApi=single_function_fixed still applies; no Swift changes required."
        ),
    }


def write_markdown(report: dict, path: Path) -> None:
    baseline_size = report["variants"]["baseline_fp32"]["eval"]["size_bytes"]
    lines = [
        "# DIY CoreML encoder — post-training optimization comparison (2026-07-30)",
        "",
        "> Lab-only. Does **not** replace `artifacts/encoder.mlpackage` or the R2-hosted",
        "> production candidate. Architecture unchanged (full-attention FastConformer,",
        "> fixed `(1,80,4800)` + explicit `length`).",
        "",
        "## TL;DR / recommendation",
        "",
        report["recommendation"]["summary"],
        "",
        f"**Recommended strategy:** `{report['recommendation']['choice']}`",
        "",
        report["recommendation"]["rationale"],
        "",
        "## Method",
        "",
        "- Baseline: existing FP32 DIY encoder (`artifacts/encoder.mlpackage`, ~"
        f"{_fmt_mb(baseline_size)}).",
        "- Host runtime: `coremltools` 9.0, `ComputeUnit.CPU_AND_GPU` (same as prior DIY e2e;",
        "  `ALL` still fails to build a plan for this graph).",
        "- Pronunciation head: **unchanged** FP32/existing `pronunciation_head.mlpackage`",
        "  (isolates encoder effects).",
        "- Golden clips: `samples/01_alafasy_fatihah.wav`, `02_basfar_ikhlas.wav`,",
        "  `03_alafasy_naba.wav`.",
        "- Techniques applied via `coremltools.optimize.coreml` (except FP16, which is a",
        "  fresh `ct.convert(..., compute_precision=FLOAT16)` into a separate directory).",
        "",
        "## Results",
        "",
        "| Variant | Size | vs FP32 | Load | Exact transcripts | Mean |Δpron| vs FP32 | Mean infer (ms) | Pipeline compatible? |",
        "|---|---:|---:|:---:|:---:|---:|---:|---|",
    ]

    for name, v in report["variants"].items():
        ev = v["eval"]
        size = _fmt_mb(ev["size_bytes"]) if ev.get("size_bytes") else "—"
        ratio = (
            f"{100.0 * ev['size_bytes'] / baseline_size:.0f}%"
            if ev.get("size_bytes") and baseline_size
            else "—"
        )
        load = "ok" if ev.get("load_ok") else "FAIL"
        summary = ev.get("summary") or {}
        exact = (
            f"{summary.get('exact_match_count', 0)}/{summary.get('scored_samples', 0)}"
            if ev.get("load_ok")
            else "—"
        )
        if summary.get("nan_or_nonfinite_samples"):
            exact += " (NaN)"
        pron = v.get("vs_baseline_pronunciation") or {}
        dprob = pron.get("mean_abs_prob_delta")
        dprob_s = f"{dprob:.4f}" if dprob is not None else "—"
        infer = summary.get("mean_inference_ms")
        infer_s = f"{infer:.0f}" if infer is not None else "—"
        compat = v.get("pipeline_compatibility", {}).get("compatible")
        compat_s = {True: "yes", False: "no", "partial": "partial"}.get(compat, str(compat))
        build_err = v.get("build_error")
        if build_err:
            lines.append(
                f"| `{name}` | — | — | build FAIL | — | — | — | no ({build_err[:60]}) |"
            )
        else:
            lines.append(
                f"| `{name}` | {size} | {ratio} | {load} | {exact} | {dprob_s} | {infer_s} | {compat_s} |"
            )

    lines += ["", "## Per-technique detail", ""]
    for name, v in report["variants"].items():
        lines.append(f"### `{name}`")
        lines.append("")
        lines.append(f"- **Technique:** {v.get('technique', '')}")
        if v.get("build_error"):
            lines.append(f"- **Build failed:** `{v['build_error']}`")
            lines.append("")
            continue
        ev = v["eval"]
        lines.append(f"- **Size:** {_fmt_mb(ev['size_bytes'])} (`{ev['size_bytes']}` bytes)")
        lines.append(f"- **Cold load:** {ev.get('cold_load_ms')} ms")
        lines.append(
            f"- **Pipeline compatibility:** {v.get('pipeline_compatibility', {}).get('compatible')} — "
            f"{v.get('pipeline_compatibility', {}).get('reason')}"
        )
        lines.append(f"- **Summary:** `{json.dumps(ev.get('summary', {}), ensure_ascii=False)}`")
        pron = v.get("vs_baseline_pronunciation")
        if pron:
            lines.append(f"- **Pronunciation vs FP32 baseline:** `{json.dumps(pron)}`")
        for s in ev.get("samples", []):
            if s.get("error"):
                lines.append(
                    f"  - `{s['sample']}`: ERROR `{s['error']}`"
                )
            else:
                lines.append(
                    f"  - `{s['sample']}`: exact={s.get('exactMatch')} "
                    f"acc={s.get('wordAccuracy')} infer={s.get('inference_ms')}ms "
                    f"hyp={s.get('hypothesis')!r}"
                )
        lines.append("")

    lines += [
        "## Notes / caveats",
        "",
        "- Host latency is **not** a substitute for real-iPhone timing. All variants still",
        "  run a fixed 48s graph, so short clips pay full cost regardless of compression.",
        "- Size reduction from pruning depends on CoreML storing sparse tensors efficiently;",
        "  a high `target_sparsity` that does not meet the sparse-format threshold may not",
        "  shrink the on-disk package much.",
        "- FP16 *compute* conversion is known from the prior DIY POC to produce NaN",
        "  logprobs on this full-attention graph; re-measured here on the T=4800 export.",
        "- No variant was uploaded to R2 or pointed at by `catalog.json`.",
        "",
        f"Raw JSON: `{REPORT_JSON.relative_to(ROOT)}`",
        "",
    ]
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def recommend(report: dict) -> dict:
    """Pick best strategy from measured results without replacing production."""
    variants = report["variants"]
    baseline = variants["baseline_fp32"]["eval"]
    baseline_size = baseline["size_bytes"]

    candidates = []
    for name, v in variants.items():
        if name == "baseline_fp32":
            continue
        if v.get("build_error"):
            continue
        ev = v["eval"]
        compat = v.get("pipeline_compatibility", {}).get("compatible")
        if compat is not True:
            continue
        if not ev.get("summary", {}).get("all_exact"):
            continue
        pron = v.get("vs_baseline_pronunciation") or {}
        mean_d = pron.get("mean_abs_prob_delta")
        if mean_d is not None and mean_d > 0.05:
            continue
        size = ev["size_bytes"]
        reduction = 1.0 - (size / baseline_size)
        infer = ev.get("summary", {}).get("mean_inference_ms") or 1e9
        base_infer = baseline.get("summary", {}).get("mean_inference_ms") or infer
        # Prefer larger size reduction; break ties by not slowing down much.
        speed_ratio = infer / base_infer if base_infer else 1.0
        score = reduction - 0.1 * max(0.0, speed_ratio - 1.0)
        candidates.append((score, reduction, name, size, infer, mean_d))

    if not candidates:
        # Fall back: if nothing is accuracy-safe, recommend keeping FP32.
        return {
            "choice": "baseline_fp32 (no optimization)",
            "summary": (
                "**No architecture-preserving compression passed the accuracy + "
                "compatibility gate on the golden clips.** Keep the current FP32 "
                "production candidate."
            ),
            "rationale": (
                "Every attempted optimization either failed to build/load, produced "
                "non-finite outputs, or regressed transcription / pronunciation beyond "
                "tolerance. Size wins are irrelevant if the model cannot score Tajweed."
            ),
        }

    candidates.sort(reverse=True)
    best = candidates[0]
    _, reduction, name, size, infer, mean_d = best
    return {
        "choice": name,
        "summary": (
            f"**Best measured optimization: `{name}`** — "
            f"{_fmt_mb(size)} ({100 * (1 - reduction):.0f}% of FP32), "
            f"3/3 exact golden transcripts, mean |Δpron|="
            f"{mean_d if mean_d is not None else 'n/a'}, "
            f"mean host infer ≈ {infer:.0f} ms."
        ),
        "rationale": (
            f"`{name}` is the only (or best) variant that preserves exact golden "
            f"transcription and pronunciation parity within tolerance while reducing "
            f"on-disk size by ~{100 * reduction:.0f}%. It keeps the same single-function "
            f"fixed-T I/O, so the current iOS DIY pipeline (`encoderApi=single_function_fixed`) "
            f"needs no inference/scoring changes. **Do not auto-promote to R2** — confirm "
            f"on-device latency/ANE behavior before replacing the FP32 candidate."
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--skip-fp16-convert",
        action="store_true",
        help="Skip the slow ONNX→FLOAT16 re-convert (still records prior known NaN finding if artifact absent).",
    )
    parser.add_argument(
        "--reuse-existing",
        action="store_true",
        help="If a variant directory already exists, skip rebuilding it.",
    )
    parser.add_argument(
        "--only",
        nargs="+",
        default=None,
        help="Only build/evaluate these variant names (always includes baseline_fp32 for comparison).",
    )
    parser.add_argument(
        "--merge-report",
        action="store_true",
        help="Merge new variant results into an existing comparison JSON instead of replacing it.",
    )
    args = parser.parse_args()
    only = set(args.only) if args.only else None
    if only is not None:
        only.add("baseline_fp32")

    if not BASELINE_ENCODER.exists():
        print(f"ERROR: missing baseline {BASELINE_ENCODER}", file=sys.stderr)
        return 1
    if not HEAD_ML.exists():
        print(f"ERROR: missing head {HEAD_ML}", file=sys.stderr)
        return 1

    OPT_DIR.mkdir(parents=True, exist_ok=True)
    baseline = _copy_baseline()
    pieces = e2e.load_tokens(TOKENS)

    print("Loading pronunciation head (shared across variants)…")
    head = ct.models.MLModel(str(HEAD_ML), compute_units=COMPUTE_UNITS)

    variants: dict[str, dict] = {}

    def register(name: str, technique: str, path: Path | None, build_error: str | None):
        entry: dict = {"technique": technique, "build_error": build_error, "path": str(path) if path else None}
        if path and path.exists() and not build_error:
            print(f"\n=== Evaluating {name} ({_fmt_mb(_package_size_bytes(path))}) ===")
            entry["eval"] = evaluate_encoder(path, pieces, head)
        else:
            entry["eval"] = {
                "path": str(path) if path else None,
                "size_bytes": 0,
                "load_ok": False,
                "load_error": build_error or "missing artifact",
                "samples": [],
                "summary": {},
            }
        variants[name] = entry

    # 1. Baseline
    register(
        "baseline_fp32",
        "Uncompressed FP32 DIY encoder (production candidate; not modified).",
        baseline,
        None,
    )

    # 2. FP16 compute convert
    if only is not None and "fp16_compute" not in only:
        pass
    elif args.skip_fp16_convert:
        existing = OPT_DIR / "fp16_compute" / "encoder.mlpackage"
        if existing.exists():
            register(
                "fp16_compute",
                "ct.convert(..., compute_precision=FLOAT16), fixed T=4800 (separate dir).",
                existing,
                None,
            )
        else:
            register(
                "fp16_compute",
                "ct.convert(..., compute_precision=FLOAT16) — skipped this run (--skip-fp16-convert).",
                None,
                "skipped; prior DIY POC found FLOAT16 → all-NaN logprobs on this graph",
            )
    else:
        path, err = build_fp16_convert()
        register(
            "fp16_compute",
            "ct.convert(..., compute_precision=FLOAT16), fixed T=4800 (separate dir).",
            path,
            err,
        )

    # 3. Weight compression via magnitude pruning (sparse storage)
    for sparsity in (0.5,):
        name = f"prune_sparsity_{int(sparsity * 100)}"
        if only is not None and name not in only:
            continue
        existing = OPT_DIR / name / "encoder.mlpackage"
        if args.reuse_existing and existing.exists():
            path, err = existing, None
        else:
            path, err = build_prune(baseline, sparsity)
        register(
            name,
            f"coremltools.optimize.coreml.prune_weights, target_sparsity={sparsity} (magnitude).",
            path,
            err,
        )

    # 4. Palettization
    for nbits in (8, 4):
        name = f"palette_{nbits}bit"
        if only is not None and name not in only:
            continue
        existing = OPT_DIR / name / "encoder.mlpackage"
        if args.reuse_existing and existing.exists():
            path, err = existing, None
        else:
            path, err = build_palettize(baseline, nbits)
        register(
            name,
            f"coremltools.optimize.coreml.palettize_weights, mode=kmeans, nbits={nbits}.",
            path,
            err,
        )

    # 5. Linear quantization
    for dtype, label in ((np.int8, "int8"), ("int4", "int4")):
        name = f"linear_{label}"
        if only is not None and name not in only:
            continue
        existing = OPT_DIR / name / "encoder.mlpackage"
        if args.reuse_existing and existing.exists():
            path, err = existing, None
        else:
            path, err = build_linear_quant(baseline, dtype)
        register(
            name,
            f"coremltools.optimize.coreml.linear_quantize_weights, mode=linear_symmetric, dtype={label}.",
            path,
            err,
        )

    # Cross-compare pronunciation + compatibility
    baseline_eval = variants["baseline_fp32"]["eval"]
    for name, v in variants.items():
        if name == "baseline_fp32":
            v["vs_baseline_pronunciation"] = {
                "mean_abs_prob_delta": 0.0,
                "max_abs_prob_delta": 0.0,
                "status_mismatch_count": 0,
                "token_pairs_compared": sum(
                    len(s.get("tokens") or []) for s in baseline_eval.get("samples", [])
                ),
            }
            v["pipeline_compatibility"] = {
                "compatible": True,
                "reason": "Current production DIY candidate.",
            }
            continue
        if v["eval"].get("load_ok"):
            v["vs_baseline_pronunciation"] = compare_pronunciation(baseline_eval, v["eval"])
        else:
            v["vs_baseline_pronunciation"] = {}
        v["pipeline_compatibility"] = pipeline_compatibility(v["eval"])

    if args.merge_report and REPORT_JSON.exists():
        prior = json.loads(REPORT_JSON.read_text(encoding="utf-8"))
        merged = dict(prior.get("variants") or {})
        merged.update(variants)
        variants = merged

    report = {
        "generated_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "baseline": str(BASELINE_ENCODER),
        "compute_units": str(COMPUTE_UNITS),
        "coremltools": ct.__version__,
        "note": "Production candidate artifacts/encoder.mlpackage was not modified or replaced.",
        "variants": variants,
        "recommendation": {},
    }
    report["recommendation"] = recommend(report)

    # Strip bulky per-token dumps from the top-level JSON for readability — keep
    # mean stats; full tokens already measured for pronunciation compare.
    slim = json.loads(json.dumps(report))
    for name, v in slim["variants"].items():
        for s in v.get("eval", {}).get("samples", []):
            if "tokens" in s:
                s["token_count"] = len(s["tokens"])
                del s["tokens"]

    REPORT_JSON.parent.mkdir(parents=True, exist_ok=True)
    REPORT_JSON.write_text(json.dumps(slim, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    write_markdown(slim, REPORT_MD)

    # Mirror into memory/ for the agent memory system.
    if MEMORY_MD.parent.exists():
        shutil.copy2(REPORT_MD, MEMORY_MD)
        print(f"Mirrored report → {MEMORY_MD}")

    print("\n=== RECOMMENDATION ===")
    print(report["recommendation"]["summary"])
    print(report["recommendation"]["rationale"])
    print(f"\nWrote {REPORT_JSON}")
    print(f"Wrote {REPORT_MD}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
