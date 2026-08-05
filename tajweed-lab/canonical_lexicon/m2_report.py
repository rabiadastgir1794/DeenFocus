"""Generate ADR-010 M2 shadow evaluation report."""

from __future__ import annotations

import json
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from canonical_lexicon.shadow_compare import AyahShadowResult


@dataclass
class M2Summary:
    total_cases: int
    legacy_mean_accuracy: float
    canonical_mean_accuracy: float
    mean_accuracy_delta: float
    false_subs_removed: int
    true_subs_preserved: int
    regressions: int
    live_regressions: int
    canonical_worse_cases: int
    legacy_category_counts: dict[str, int]
    canonical_category_counts: dict[str, int]
    golden_improvements: int
    presentation_improvements: int
    live_improvements: int
    recommendation: str
    acceptance_pass: bool
    acceptance_notes: list[str]


def summarize(results: list[AyahShadowResult]) -> M2Summary:
    if not results:
        return M2Summary(
            total_cases=0,
            legacy_mean_accuracy=0.0,
            canonical_mean_accuracy=0.0,
            mean_accuracy_delta=0.0,
            false_subs_removed=0,
            true_subs_preserved=0,
            regressions=0,
            live_regressions=0,
            canonical_worse_cases=0,
            legacy_category_counts={},
            canonical_category_counts={},
            golden_improvements=0,
            presentation_improvements=0,
            live_improvements=0,
            recommendation="Needs more work before cutover",
            acceptance_pass=False,
            acceptance_notes=["No evaluation cases"],
        )

    legacy_acc = [r.legacy_accuracy for r in results]
    can_acc = [r.canonical_accuracy for r in results if r.canonical_accuracy is not None]
    deltas = [r.accuracy_delta for r in results if r.accuracy_delta is not None]

    leg_cat: Counter[str] = Counter()
    can_cat: Counter[str] = Counter()
    for r in results:
        leg_cat.update(r.legacy_categories)
        can_cat.update(r.canonical_categories)

    false_subs = sum(r.false_subs_removed for r in results)
    true_subs = sum(r.true_subs_preserved for r in results)
    regressions = sum(r.regressions for r in results)
    live_regressions = sum(r.regressions for r in results if r.corpus_kind == "live_capture")
    canonical_worse = sum(
        1
        for r in results
        if r.accuracy_delta is not None and r.accuracy_delta < -1e-9
    )

    def improvements(kind: str) -> int:
        return sum(
            1
            for r in results
            if r.corpus_kind == kind
            and r.accuracy_delta is not None
            and r.accuracy_delta > 1e-9
        )

    notes: list[str] = []
    pass_display = false_subs > 0
    if pass_display:
        notes.append(f"Canonical removed {false_subs} display-script false substitution(s)")
    else:
        notes.append("No display-script false subs removed in measured corpus")

    pass_regression = live_regressions == 0
    if pass_regression:
        notes.append("Zero live-capture canonical regressions")
    else:
        notes.append(f"{live_regressions} live-capture regression(s) — blocks M3")

    if regressions > live_regressions:
        notes.append(
            f"{regressions - live_regressions} non-live regression flag(s) suppressed "
            "(presentation/golden corpus — treated as improvements)"
        )

    if canonical_worse > 0:
        notes.append(
            f"{canonical_worse} case(s) where canonical accuracy < legacy — document for M3"
        )

    pass_accuracy = (
        len(can_acc) > 0
        and (sum(can_acc) / len(can_acc)) >= (sum(legacy_acc) / len(legacy_acc))
    )
    if pass_accuracy:
        notes.append("Canonical mean accuracy >= legacy mean accuracy across corpus")
    else:
        notes.append("Canonical mean accuracy below legacy — investigate before cutover")

    acceptance_pass = pass_display and pass_regression and pass_accuracy
    recommendation = (
        "Ready for M3"
        if acceptance_pass and canonical_worse == 0 and live_regressions == 0
        else "Needs more work before cutover"
    )

    return M2Summary(
        total_cases=len(results),
        legacy_mean_accuracy=sum(legacy_acc) / len(legacy_acc),
        canonical_mean_accuracy=sum(can_acc) / len(can_acc) if can_acc else 0.0,
        mean_accuracy_delta=sum(deltas) / len(deltas) if deltas else 0.0,
        false_subs_removed=false_subs,
        true_subs_preserved=true_subs,
        regressions=regressions,
        live_regressions=live_regressions,
        canonical_worse_cases=canonical_worse,
        legacy_category_counts=dict(leg_cat),
        canonical_category_counts=dict(can_cat),
        golden_improvements=improvements("golden_perfect"),
        presentation_improvements=improvements("presentation_space"),
        live_improvements=improvements("live_capture"),
        recommendation=recommendation,
        acceptance_pass=acceptance_pass,
        acceptance_notes=notes,
    )


def render_markdown(results: list[AyahShadowResult], summary: M2Summary) -> str:
    lines = [
        "# ADR-010 M2 — Canonical Shadow Evaluation Report",
        "",
        f"**Generated:** {datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
        "",
        "## Executive summary",
        "",
        f"| Metric | Value |",
        f"| --- | --- |",
        f"| Total cases | {summary.total_cases} |",
        f"| Legacy mean accuracy | {summary.legacy_mean_accuracy:.4f} |",
        f"| Canonical mean accuracy | {summary.canonical_mean_accuracy:.4f} |",
        f"| Mean accuracy delta (canonical − legacy) | {summary.mean_accuracy_delta:+.4f} |",
        f"| False subs removed | {summary.false_subs_removed} |",
        f"| True subs preserved | {summary.true_subs_preserved} |",
        f"| Regressions (all corpora) | {summary.regressions} |",
        f"| Regressions (live capture) | {summary.live_regressions} |",
        f"| Cases canonical worse than legacy | {summary.canonical_worse_cases} |",
        f"| **Recommendation** | **{summary.recommendation}** |",
        "",
        "## Acceptance criteria (M2)",
        "",
    ]
    for note in summary.acceptance_notes:
        lines.append(f"- {note}")
    lines.append("")
    lines.append(
        f"**M2 gate:** {'PASS' if summary.acceptance_pass else 'FAIL'} "
        f"(measurement only — no production changes)"
    )
    lines.extend(["", "## Category counts (legacy mismatches)", ""])
    for cat, n in sorted(summary.legacy_category_counts.items(), key=lambda x: -x[1]):
        lines.append(f"- **{cat}**: {n}")
    lines.extend(["", "## Category counts (canonical mismatches)", ""])
    for cat, n in sorted(summary.canonical_category_counts.items(), key=lambda x: -x[1]):
        lines.append(f"- **{cat}**: {n}")

    lines.extend(["", "## Corpus breakdown", ""])
    lines.append(f"- Golden perfect-recitation improvements: {summary.golden_improvements}")
    lines.append(f"- Presentation-space improvements: {summary.presentation_improvements}")
    lines.append(f"- Live-capture improvements: {summary.live_improvements}")

    # Per-ayah table for golden + live (skip 763 presentation rows in main table)
    lines.extend(["", "## Per-ayah results (golden + live)", ""])
    lines.append(
        "| Ref | Corpus | Legacy acc | Canonical acc | Δ | False subs removed | Regressions |"
    )
    lines.append("| --- | --- | ---: | ---: | ---: | ---: | ---: |")
    for r in sorted(
        (x for x in results if x.corpus_kind != "presentation_space"),
        key=lambda x: (int(x.ref.split(":")[0]), int(x.ref.split(":")[1]), x.corpus_kind),
    ):
        ca = f"{r.canonical_accuracy:.4f}" if r.canonical_accuracy is not None else "—"
        da = f"{r.accuracy_delta:+.4f}" if r.accuracy_delta is not None else "—"
        lines.append(
            f"| {r.ref} | {r.corpus_kind} | {r.legacy_accuracy:.4f} | {ca} | {da} | "
            f"{r.false_subs_removed} | {r.regressions} |"
        )

    # Presentation space aggregate
    pres = [r for r in results if r.corpus_kind == "presentation_space"]
    if pres:
        leg = sum(r.legacy_accuracy for r in pres) / len(pres)
        can = sum(r.canonical_accuracy or 0 for r in pres) / len(pres)
        lines.extend(
            [
                "",
                "## Presentation-space corpus (aggregate)",
                "",
                f"- Cases: **{len(pres)}**",
                f"- Legacy mean accuracy: **{leg:.4f}**",
                f"- Canonical mean accuracy: **{can:.4f}**",
                f"- Mean delta: **{can - leg:+.4f}**",
                f"- False subs removed (total): **{sum(r.false_subs_removed for r in pres)}**",
                f"- Regressions (total): **{sum(r.regressions for r in pres)}**",
            ]
        )

    regressions = [d for r in results for d in r.diffs if d.is_regression]
    if regressions:
        lines.extend(["", "## Regressions (document only — do not fix in M2)", ""])
        for d in regressions[:50]:
            lines.append(
                f"- idx={d.index} legacy={d.legacy_op} canonical={d.canonical_op} "
                f"legacy `{d.legacy_expected_norm}` vs `{d.legacy_hyp_norm}` "
                f"({d.legacy_category})"
            )
        if len(regressions) > 50:
            lines.append(f"- … and {len(regressions) - 50} more")

    false_subs = [d for r in results for d in r.diffs if d.is_false_sub_removed]
    if false_subs:
        lines.extend(["", "## False substitutions removed by canonical", ""])
        seen: set[str] = set()
        for d in false_subs:
            key = f"{d.legacy_expected_norm}|{d.legacy_hyp_norm}"
            if key in seen:
                continue
            seen.add(key)
            lines.append(
                f"- `{d.legacy_expected_norm}` → `{d.legacy_hyp_norm}` "
                f"({d.legacy_category or 'unknown'})"
            )

    worse = [r for r in results if r.accuracy_delta is not None and r.accuracy_delta < -1e-9]
    if worse:
        lines.extend(["", "## Canonical worse than legacy (document for M3)", ""])
        for r in sorted(worse, key=lambda x: x.accuracy_delta or 0):
            lines.append(
                f"- **{r.ref}** ({r.corpus_kind}): legacy={r.legacy_accuracy:.4f} "
                f"canonical={r.canonical_accuracy:.4f} Δ={r.accuracy_delta:+.4f} — {r.case_id}"
            )

    lines.extend(["", "## Rollback / next steps", ""])
    lines.append("- Production scoring unchanged — legacy path remains authoritative.")
    lines.append("- M3 cutover only if this report recommendation is accepted after review.")
    lines.append("- Any regression listed above blocks M3 until understood.")

    return "\n".join(lines) + "\n"


def write_report(
    results: list[AyahShadowResult],
    output_dir: Path,
    *,
    detail_json: list[dict[str, Any]],
) -> M2Summary:
    output_dir.mkdir(parents=True, exist_ok=True)
    summary = summarize(results)
    md = render_markdown(results, summary)
    (output_dir / "m2_shadow_evaluation_report.md").write_text(md, encoding="utf-8")
    (output_dir / "m2_summary.json").write_text(
        json.dumps(
            {
                "generatedAt": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                "totalCases": summary.total_cases,
                "legacyMeanAccuracy": summary.legacy_mean_accuracy,
                "canonicalMeanAccuracy": summary.canonical_mean_accuracy,
                "meanAccuracyDelta": summary.mean_accuracy_delta,
                "falseSubsRemoved": summary.false_subs_removed,
                "trueSubsPreserved": summary.true_subs_preserved,
                "regressions": summary.regressions,
                "liveRegressions": summary.live_regressions,
                "canonicalWorseCases": summary.canonical_worse_cases,
                "legacyCategoryCounts": summary.legacy_category_counts,
                "canonicalCategoryCounts": summary.canonical_category_counts,
                "recommendation": summary.recommendation,
                "acceptancePass": summary.acceptance_pass,
                "acceptanceNotes": summary.acceptance_notes,
            },
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    (output_dir / "m2_detail.json").write_text(
        json.dumps(detail_json, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return summary
