"""M2.6 report + human-review CSV generation."""

from __future__ import annotations

import csv
import json
import random
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from canonical_lexicon.m26_classify import to_dict as mismatch_to_dict
from canonical_lexicon.m26_metrics import M26Metrics, RecordingEval, metrics_to_dict
from canonical_lexicon.shadow_compare import ayah_result_to_dict


def write_human_review_csv(
    evals: list[RecordingEval],
    path: Path,
    *,
    sample_size: int = 20,
    seed: int = 26,
) -> list[dict[str, Any]]:
    """Sample disagreements for human labeling."""
    disagreements = [
        e
        for e in evals
        if e.shadow.accuracy_delta is not None
        and abs(e.shadow.accuracy_delta) > 1e-9
        or (not e.shadow.identical)
    ]
    rng = random.Random(seed)
    sample = disagreements if len(disagreements) <= sample_size else rng.sample(
        disagreements, sample_size
    )
    # Always include all disagreements if few
    if len(disagreements) <= sample_size:
        sample = disagreements

    rows: list[dict[str, Any]] = []
    for e in sample:
        rows.append(
            {
                "recording_id": e.recording_id,
                "ref": e.ref,
                "speaker_id": e.speaker_id,
                "speaker_tags": "|".join(e.speaker_tags),
                "audio_relpath": "",  # filled by caller if needed
                "expected_words": " ".join(e.shadow.legacy.expected_words),
                "hypothesis": e.hypothesis,
                "legacy_accuracy": f"{e.shadow.legacy_accuracy:.4f}",
                "canonical_accuracy": (
                    f"{e.shadow.canonical_accuracy:.4f}"
                    if e.shadow.canonical_accuracy is not None
                    else ""
                ),
                "accuracy_delta": (
                    f"{e.shadow.accuracy_delta:+.4f}"
                    if e.shadow.accuracy_delta is not None
                    else ""
                ),
                "legacy_ops": " ".join(
                    f"{o.op}:{o.expected_norm or '-'}/{o.hyp_norm or '-'}"
                    for o in e.shadow.legacy.ops
                    if o.op != "match"
                ),
                "canonical_ops": " ".join(
                    f"{o.op}:{o.expected_norm or '-'}/{o.hyp_norm or '-'}"
                    for o in (e.shadow.canonical.ops if e.shadow.canonical else [])
                    if o.op != "match"
                ),
                "human_label_existing": e.human_label or "",
                "review_status": "pending",
                "reviewer_mark": "",  # Correct | Legacy correct | Canonical correct | Neither correct
                "reviewer_notes": "",
            }
        )

    path.parent.mkdir(parents=True, exist_ok=True)
    if rows:
        with path.open("w", encoding="utf-8", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    else:
        path.write_text(
            "recording_id,ref,review_status,reviewer_mark,reviewer_notes\n",
            encoding="utf-8",
        )
    return rows


def write_failure_breakdown(evals: list[RecordingEval], path: Path) -> dict[str, Any]:
    items = []
    for e in evals:
        for m in e.mismatches:
            items.append(mismatch_to_dict(m))
    by_cause: dict[str, int] = {}
    for it in items:
        by_cause[it["cause"]] = by_cause.get(it["cause"], 0) + 1
    payload = {
        "generatedAt": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "totalMismatches": len(items),
        "byCause": by_cause,
        "items": items,
    }
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return payload


def write_metrics_json(metrics: M26Metrics, path: Path) -> None:
    path.write_text(
        json.dumps(metrics_to_dict(metrics), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def write_detail_json(evals: list[RecordingEval], path: Path) -> None:
    rows = []
    for e in evals:
        rows.append(
            {
                "recordingId": e.recording_id,
                "ref": e.ref,
                "speakerId": e.speaker_id,
                "speakerTags": e.speaker_tags,
                "humanLabel": e.human_label,
                "hypothesis": e.hypothesis,
                "expectedArabic": e.expected_arabic,
                "legacyFp": e.legacy_fp,
                "canonicalFp": e.canonical_fp,
                "legacyFn": e.legacy_fn,
                "canonicalFn": e.canonical_fn,
                "asrTruncation": e.asr_truncation,
                "pronunciationErrors": e.pronunciation_errors,
                "tajweedErrors": e.tajweed_errors,
                "shadow": ayah_result_to_dict(e.shadow),
                "mismatches": [mismatch_to_dict(m) for m in e.mismatches],
            }
        )
    path.write_text(json.dumps(rows, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def render_markdown(
    evals: list[RecordingEval],
    metrics: M26Metrics,
) -> str:
    lines = [
        "# ADR-010 M2.6 — Real-World Recitation Shadow Report",
        "",
        f"**Generated:** {datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
        "",
        "Lab-only evidence. **No production scoring changes. No M3 cutover.**",
        "",
        "## Executive summary",
        "",
        "| Metric | Value |",
        "| --- | --- |",
        f"| Recordings evaluated | {metrics.n_recordings} |",
        f"| With human label | {metrics.n_with_human_label} |",
        f"| Legacy mean word accuracy | {metrics.legacy_mean_accuracy:.4f} |",
        f"| Canonical mean word accuracy | {metrics.canonical_mean_accuracy:.4f} |",
        f"| Mean Δ (canonical − legacy) | {metrics.mean_accuracy_delta:+.4f} |",
        f"| Legacy FP / Canonical FP | {metrics.false_positives_legacy} / {metrics.false_positives_canonical} |",
        f"| Legacy FN / Canonical FN | {metrics.false_negatives_legacy} / {metrics.false_negatives_canonical} |",
        f"| FP reduction | {metrics.fp_reduction} |",
        f"| FN increase | {metrics.fn_increase} |",
        f"| ASR truncation rate | {metrics.asr_truncation_rate:.4f} |",
        f"| **Acceptance** | **{'PASS' if metrics.acceptance_pass else 'FAIL'}** |",
        "",
        "## Acceptance notes",
        "",
    ]
    for n in metrics.acceptance_notes:
        lines.append(f"- {n}")

    lines.extend(["", "## Failure causes (exactly one per mismatch)", ""])
    for cause, n in sorted(metrics.cause_counts.items(), key=lambda x: -x[1]):
        lines.append(f"- **{cause}**: {n}")

    lines.extend(["", "## Confusion matrices", ""])
    lines.append("### Legacy vs human truth")
    for k, v in sorted(metrics.confusion_legacy_vs_truth.items()):
        lines.append(f"- `{k}`: {v}")
    lines.append("")
    lines.append("### Canonical vs human truth")
    for k, v in sorted(metrics.confusion_canonical_vs_truth.items()):
        lines.append(f"- `{k}`: {v}")
    lines.append("")
    lines.append("### Legacy vs canonical (binary correct@0.99)")
    for k, v in sorted(metrics.confusion_legacy_vs_canonical.items()):
        lines.append(f"- `{k}`: {v}")

    lines.extend(["", "## Per-recording results", ""])
    lines.append(
        "| ID | Ref | Tags | Human | Legacy | Canonical | Δ | FP L/C | Trunc |"
    )
    lines.append("| --- | --- | --- | --- | ---: | ---: | ---: | --- | --- |")
    for e in sorted(evals, key=lambda x: x.recording_id):
        ca = (
            f"{e.shadow.canonical_accuracy:.4f}"
            if e.shadow.canonical_accuracy is not None
            else "—"
        )
        da = (
            f"{e.shadow.accuracy_delta:+.4f}"
            if e.shadow.accuracy_delta is not None
            else "—"
        )
        lines.append(
            f"| {e.recording_id} | {e.ref} | {','.join(e.speaker_tags[:2])} | "
            f"{e.human_label or '—'} | {e.shadow.legacy_accuracy:.4f} | {ca} | {da} | "
            f"{int(e.legacy_fp)}/{int(e.canonical_fp)} | {int(e.asr_truncation)} |"
        )

    lines.extend(
        [
            "",
            "## Lexical / pronunciation / tajweed",
            "",
            "- **Lexical errors:** counted via legacy/canonical ops (see failure breakdown).",
            "- **Pronunciation errors:** not scored in M2.6 (layer reserved; count=0).",
            "- **Tajweed errors:** stub layer (count=0).",
            "",
            "## Diversity coverage",
            "",
        ]
    )
    tag_counts: dict[str, int] = {}
    for e in evals:
        for t in e.speaker_tags:
            tag_counts[t] = tag_counts.get(t, 0) + 1
    for t, n in sorted(tag_counts.items()):
        lines.append(f"- **{t}**: {n}")

    lines.extend(
        [
            "",
            "## Dataset gaps",
            "",
            "Placeholder speaker slots (pakistani, indian, turkish, indonesian, african,",
            "american_convert, child) must be filled with real WAVs before claiming",
            "worldwide coverage. Current evidence is strongest for Arab professional",
            "goldens + unlabeled live captures.",
            "",
            "## Next",
            "",
            "- Complete human review CSV (`m26_human_review.csv`).",
            "- Add diverse speaker recordings to `m26_real_world/`.",
            "- Re-run after each batch; M3 still blocked until policy-spec G1–G7 + this report PASS.",
            "",
        ]
    )
    return "\n".join(lines)
