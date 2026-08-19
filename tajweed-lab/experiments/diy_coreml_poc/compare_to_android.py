#!/usr/bin/env python3
"""Compare DIY CoreML e2e scores against Android golden parity JSON.

Writes markdown + JSON parity report under experiments/diy_coreml_poc/reports/.
"""

from __future__ import annotations

import json
import math
import sys
from pathlib import Path

POC = Path(__file__).resolve().parent
REPO = POC.parents[2]
COREML = POC / "reports" / "diy_coreml_e2e_scores.json"
ANDROID = (
    REPO
    / "memory"
    / "features"
    / "tajweed"
    / "phase4a-artifacts"
    / "tajweed_parity_android.json"
)
OUT_MD = POC / "reports" / "diy_coreml_parity_report.md"
OUT_JSON = POC / "reports" / "diy_coreml_parity_report.json"

# Tolerances (same spirit as Phase 4A / ADR targets).
PROB_ABS_TOL = 0.05
ALIGN_SEC_TOL = 0.080 + 1e-6  # one encoder frame hop (+eps for float noise)
STATUS_MUST_MATCH = True


def normalize_arabic(text: str) -> str:
    diacritics = set("ًٌٍَُِّْٰٕٖٜٓٔٗ٘ٙٚٛٝٞٗ")
    return "".join(c for c in text if c not in diacritics).replace("ٱ", "ا").replace(" ", "")


def mean_prob(tokens: list[dict]) -> float | None:
    if not tokens:
        return None
    return sum(float(t["prob"]) for t in tokens) / len(tokens)


def compare_sample(android: dict, coreml: dict) -> dict:
    a_score = android["score"]
    c_score = coreml["score"]
    a_tok = a_score.get("tokens") or []
    c_tok = c_score.get("tokens") or []

    transcript_exact = normalize_arabic(a_score["hypothesis"]) == normalize_arabic(
        c_score["hypothesis"]
    )
    transcript_vs_expected = bool(c_score.get("exactMatch"))

    n = min(len(a_tok), len(c_tok))
    prob_deltas = []
    align_deltas = []
    status_mismatches = []
    for i in range(n):
        at, ct = a_tok[i], c_tok[i]
        prob_deltas.append(abs(float(at["prob"]) - float(ct["prob"])))
        align_deltas.append(
            max(
                abs(float(at["startSec"]) - float(ct["startSec"])),
                abs(float(at["endSec"]) - float(ct["endSec"])),
            )
        )
        if at.get("status") != ct.get("status") or at.get("text") != ct.get("text"):
            status_mismatches.append(
                {
                    "i": i,
                    "android": {"text": at.get("text"), "status": at.get("status"), "prob": at.get("prob")},
                    "coreml": {"text": ct.get("text"), "status": ct.get("status"), "prob": ct.get("prob")},
                }
            )

    max_prob_delta = max(prob_deltas) if prob_deltas else None
    mean_prob_delta = (sum(prob_deltas) / len(prob_deltas)) if prob_deltas else None
    max_align_delta = max(align_deltas) if align_deltas else None

    confidence_ok = (
        mean_prob_delta is not None and mean_prob_delta <= PROB_ABS_TOL and (max_prob_delta or 0) <= 0.15
    )
    alignment_ok = max_align_delta is not None and max_align_delta <= ALIGN_SEC_TOL
    score_ok = confidence_ok and (not STATUS_MUST_MATCH or not status_mismatches)
    token_count_ok = len(a_tok) == len(c_tok)

    return {
        "sample": coreml["sample"],
        "android_hypothesis": a_score["hypothesis"],
        "coreml_hypothesis": c_score["hypothesis"],
        "transcript_match_android": transcript_exact,
        "coreml_exact_match_expected": transcript_vs_expected,
        "android_word_accuracy": a_score.get("wordAccuracy"),
        "coreml_word_accuracy": c_score.get("wordAccuracy"),
        "android_mean_prob": mean_prob(a_tok),
        "coreml_mean_prob": mean_prob(c_tok),
        "token_count_android": len(a_tok),
        "token_count_coreml": len(c_tok),
        "token_count_ok": token_count_ok,
        "max_prob_delta": max_prob_delta,
        "mean_prob_delta": mean_prob_delta,
        "max_align_delta_sec": max_align_delta,
        "status_mismatches": status_mismatches,
        "confidence_ok": confidence_ok,
        "alignment_ok": alignment_ok,
        "pronunciation_ok": score_ok,
        "acceptable": transcript_exact
        and token_count_ok
        and confidence_ok
        and alignment_ok
        and score_ok,
    }


def recommend(per_sample: list[dict], conversion_notes: dict) -> dict:
    all_ok = all(s["acceptable"] for s in per_sample) if per_sample else False
    any_transcript_fail = any(not s["transcript_match_android"] for s in per_sample)
    empty_or_garbage = any(
        not s["coreml_hypothesis"].strip() or s["coreml_word_accuracy"] == 0 for s in per_sample
    )

    precision = str(
        (conversion_notes.get("encoder") or {}).get("compute_precision", "")
    )
    fp16_poisoned = "FLOAT16" in precision.upper() and empty_or_garbage

    if all_ok:
        verdict = "HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN"
        summary = (
            "DIY CoreML (FP32, fixed mel T=480, host coremltools) matches Android "
            "within tolerances on all three golden clips for transcript, "
            "pronunciation probs, statuses, and alignment. "
            "It does NOT yet replace the gated HF ANE CoreML pack in production: "
            "FP16 conversion yields NaN logprobs; the package is not multifunction "
            "`predict_T*`; and it is not wired into OfflineAsrModel."
        )
    elif fp16_poisoned or empty_or_garbage:
        verdict = "DO_NOT_REPLACE"
        summary = (
            "DIY CoreML diverges on transcript (and/or produces empty/garbage text). "
            "This matches the known full-attention / precision risk documented in ADR-004. "
            "Keep the official HF ANE packages."
        )
    elif any_transcript_fail:
        verdict = "DO_NOT_REPLACE"
        summary = (
            "Transcripts diverge from Android. Do not replace the gated HF CoreML model."
        )
    else:
        verdict = "DO_NOT_REPLACE_YET"
        summary = (
            "Transcripts may match but pronunciation/alignment/confidence diverge "
            "beyond tolerance. Do not replace the gated HF CoreML model until "
            "divergences are fixed or waived."
        )

    return {
        "verdict": verdict,
        "summary": summary,
        "all_samples_acceptable": all_ok,
        "conversion_notes": conversion_notes,
    }


def main() -> int:
    if not COREML.exists():
        print(f"ERROR: missing {COREML} — run run_coreml_e2e.py first", file=sys.stderr)
        return 1
    if not ANDROID.exists():
        print(f"ERROR: missing {ANDROID}", file=sys.stderr)
        return 1

    coreml = json.loads(COREML.read_text(encoding="utf-8"))
    android = json.loads(ANDROID.read_text(encoding="utf-8"))
    a_by = {s["sample"] if "sample" in s else _infer_sample_name(s): s for s in android["samples"]}
    # Android dump may nest sample name differently.
    a_by = {}
    for s in android["samples"]:
        name = s.get("sample")
        if not name:
            # Infer from score.ref mapping used in e2e EXPECTED.
            ref = s["score"]["ref"]
            name = {
                "1:4": "01_alafasy_fatihah.wav",
                "112:1": "02_basfar_ikhlas.wav",
                "38:67": "03_alafasy_naba.wav",
            }.get(ref, ref)
        a_by[name] = s
        s["sample"] = name

    comparisons = []
    for c in coreml["samples"]:
        a = a_by.get(c["sample"])
        if not a:
            comparisons.append({"sample": c["sample"], "error": "missing android counterpart"})
            continue
        comparisons.append(compare_sample(a, c))

    meta_path = POC / "artifacts" / "encoder_conversion_meta.json"
    conversion_notes = {}
    if meta_path.exists():
        conversion_notes["encoder"] = json.loads(meta_path.read_text())
    status_path = POC / "artifacts" / "conversion_status.json"
    if status_path.exists():
        conversion_notes["status"] = json.loads(status_path.read_text())

    rec = recommend(
        [c for c in comparisons if "error" not in c],
        conversion_notes,
    )

    report = {
        "tolerances": {
            "mean_prob_abs": PROB_ABS_TOL,
            "max_prob_abs_soft": 0.15,
            "align_sec": ALIGN_SEC_TOL,
        },
        "android_source": str(ANDROID),
        "coreml_source": str(COREML),
        "samples": comparisons,
        "recommendation": rec,
    }
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    lines = [
        "# DIY CoreML ↔ Android parity report",
        "",
        "> Isolated research experiment. Production iOS/Flutter untouched.",
        "",
        f"**Verdict:** `{rec['verdict']}`",
        "",
        rec["summary"],
        "",
        "## Tolerances",
        "",
        f"- Mean |Δprob| ≤ {PROB_ABS_TOL}",
        f"- Max |Δprob| ≤ 0.15 (soft)",
        f"- Max alignment |Δ| ≤ {ALIGN_SEC_TOL}s",
        "- Transcript: diacritic-insensitive exact match vs Android hypothesis",
        "- Token status strings must match when comparing overlapping tokens",
        "",
        "## Conversion findings (this POC)",
        "",
        "- Pipeline: ONNX → `onnx2torch` → `torch.jit.trace` → `coremltools` 9.0 "
        "(direct `source=\"onnx\"` was removed in CT≥8).",
        "- Pronunciation head converts cleanly (small MLP).",
        "- Encoder requires registering `aten::less`→`lt` aliases for CT torch frontend.",
        "- **FLOAT16 encoder is unusable**: all-NaN `logprobs` on golden clip 01 "
        "(MIL warning: `overflow encountered in cast`). Hypothesis collapses to `<unk>`.",
        "- **FLOAT32 encoder is numerically faithful** to ONNX on CPU: logprob "
        "correlation ≈ 1.0, top-1 argmax agree 100%, CTC token ids identical to ONNX "
        "on sample 01.",
        "- Shape: fixed mel `T=480` (covers all three golden clips; not the official "
        "multifunction bucket API).",
        "- Runtime for this report: Python `coremltools` host (`ComputeUnit.ALL`), "
        "**not** production Swift `OfflineAsrModel`.",
        "",
        "## Per-sample",
        "",
    ]
    for s in comparisons:
        if "error" in s:
            lines.append(f"### {s['sample']}\n\n- ERROR: {s['error']}\n")
            continue
        lines.extend(
            [
                f"### {s['sample']}",
                "",
                f"- Acceptable: **{s['acceptable']}**",
                f"- Transcript match Android: {s['transcript_match_android']}",
                f"- CoreML exactMatch(expected): {s['coreml_exact_match_expected']}",
                f"- Android hyp: `{s['android_hypothesis']}`",
                f"- CoreML hyp: `{s['coreml_hypothesis']}`",
                f"- Token counts: android={s['token_count_android']} coreml={s['token_count_coreml']}",
                f"- Mean |Δprob|: {_fmt(s['mean_prob_delta'])} (max {_fmt(s['max_prob_delta'])})",
                f"- Max |Δalign|: {_fmt(s['max_align_delta_sec'])}s",
                f"- Status mismatches: {len(s['status_mismatches'])}",
                "",
            ]
        )
        if s["status_mismatches"]:
            lines.append("Status / text mismatches (first 8):")
            lines.append("")
            for m in s["status_mismatches"][:8]:
                lines.append(
                    f"- i={m['i']}: android={m['android']} coreml={m['coreml']}"
                )
            lines.append("")

    lines.extend(
        [
            "## Recommendation detail",
            "",
            f"- `all_samples_acceptable`: {rec['all_samples_acceptable']}",
            f"- Conversion notes: `{json.dumps(conversion_notes)[:500]}…`"
            if conversion_notes
            else "- Conversion notes: (none)",
            "",
            "## Can this replace the gated HF CoreML model?",
            "",
        ]
    )
    if rec["verdict"] == "HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN":
        lines.append(
            "**Host-side numeric parity: yes. Production drop-in replacement for the "
            "gated HF ANE packages: no (not yet).**"
        )
        lines.append("")
        lines.append("Reasons it cannot replace HF ANE packs yet:")
        lines.append("")
        lines.append(
            "1. **FP16 conversion is broken** — default `compute_precision=FLOAT16` "
            "produces all-NaN `logprobs` (observed during this POC; MIL pipeline also "
            "emitted `overflow encountered in cast`). Only FLOAT32 works."
        )
        lines.append(
            "2. **Not the production API** — official packages expose multifunction "
            "`predict_T80…T4800` buckets expected by `OfflineAsrModel.swift`. This DIY "
            "artifact is a single fixed `T=480` graph."
        )
        lines.append(
            "3. **ANE / size / latency unproven** — FP32 full-attention FastConformer "
            "is unlikely to match upstream ANE windowed-attention packages on device."
        )
        lines.append(
            "4. **Tracer freezing risk** — onnx2torch+jit.trace emitted many "
            "TracerWarnings; dynamic length behavior beyond the traced T=480 shape is "
            "not guaranteed."
        )
        lines.append("")
        lines.append(
            "Recommendation: keep ADR-004 (prefer upstream CoreML). Treat this DIY "
            "path as a lab unblocker for host-side experiments only. If HF access "
            "never arrives, a *separate* productionization project would be required "
            "(FP32 or carefully quantized ANE graph, multifunction wrappers, on-device "
            "QA) — not a swap of these POC artifacts into `ModelStore`."
        )
    elif rec["verdict"] == "REPLACE_CANDIDATE":
        lines.append(
            "**Conditionally yes** for research parity — still require on-device ANE "
            "validation, App Store size/latency checks, and multifunction bucket "
            "parity with the production Swift loader before any production swap."
        )
    else:
        lines.append(
            "**No.** Keep waiting for / hosting the official "
            "`Muno459/fastconformer-quran-coreml-offline` ANE packages. The DIY "
            "path does not meet the parity bar for replacing them."
        )
        lines.append("")
        lines.append("### Where outputs diverge")
        lines.append("")
        for s in comparisons:
            if s.get("acceptable"):
                continue
            if "error" in s:
                lines.append(f"- **{s['sample']}**: {s['error']}")
                continue
            reasons = []
            if not s["transcript_match_android"]:
                reasons.append(
                    f"transcript (android=`{s['android_hypothesis']}` vs "
                    f"coreml=`{s['coreml_hypothesis']}`)"
                )
            if not s["token_count_ok"]:
                reasons.append(
                    f"token count ({s['token_count_android']} vs {s['token_count_coreml']})"
                )
            if not s["confidence_ok"]:
                reasons.append(
                    f"confidence/probs (meanΔ={_fmt(s['mean_prob_delta'])}, "
                    f"maxΔ={_fmt(s['max_prob_delta'])})"
                )
            if not s["alignment_ok"]:
                reasons.append(f"alignment (maxΔ={_fmt(s['max_align_delta_sec'])}s)")
            if s["status_mismatches"]:
                reasons.append(f"{len(s['status_mismatches'])} token status/text mismatches")
            lines.append(f"- **{s['sample']}**: " + "; ".join(reasons))

    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"Wrote {OUT_MD}")
    print(f"Wrote {OUT_JSON}")
    print("VERDICT:", rec["verdict"])
    return 0


def _fmt(v) -> str:
    if v is None or (isinstance(v, float) and math.isnan(v)):
        return "n/a"
    return f"{v:.4f}"


def _infer_sample_name(s: dict) -> str:
    return s.get("sample") or s["score"]["ref"]


if __name__ == "__main__":
    raise SystemExit(main())
