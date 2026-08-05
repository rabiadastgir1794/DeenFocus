#!/usr/bin/env python3
"""ADR-010 M2.6 — real-world shadow evaluation (lab only, no production changes)."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from canonical_lexicon.canonical_evaluator import CanonicalLexiconStore  # noqa: E402
from canonical_lexicon.m26_asr import asr_available, transcribe_wav  # noqa: E402
from canonical_lexicon.m26_classify import (  # noqa: E402
    classify_disagreement,
    classify_legacy_op,
)
from canonical_lexicon.m26_dataset import (  # noqa: E402
    DEFAULT_DATASET,
    audio_path,
    iter_evaluable,
    load_manifest,
    seed_dataset,
)
from canonical_lexicon.m26_metrics import RecordingEval, aggregate  # noqa: E402
from canonical_lexicon.m26_report import (  # noqa: E402
    render_markdown,
    write_detail_json,
    write_failure_breakdown,
    write_human_review_csv,
    write_metrics_json,
)
from canonical_lexicon.m2_corpus import (  # noqa: E402
    iter_golden_perfect_recitation,
    iter_live_captures,
    iter_presentation_space_cases,
)
from canonical_lexicon.shadow_compare import compare_ayah  # noqa: E402


def _regression_suite(
    store: CanonicalLexiconStore,
    kind: str,
    cases,
) -> dict:
    worse = 0
    better = 0
    total = 0
    for case in cases:
        total += 1
        r = compare_ayah(
            ref=case.ref,
            expected_arabic=case.expected_arabic,
            hypothesis=case.hypothesis,
            lexical_reference_arabic=case.lexical_reference_arabic,
            corpus_kind=case.corpus_kind,
            case_id=case.case_id,
            store=store,
        )
        if r.accuracy_delta is not None and r.accuracy_delta < -1e-9:
            worse += 1
        if r.accuracy_delta is not None and r.accuracy_delta > 1e-9:
            better += 1
    # No regression = zero cases where canonical < legacy
    passed = worse == 0
    return {
        "pass": passed,
        "total": total,
        "canonicalWorse": worse,
        "canonicalBetter": better,
        "summary": f"{kind}: worse={worse} better={better} / {total}",
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="ADR-010 M2.6 real-world evaluation")
    parser.add_argument("--dataset", type=Path, default=DEFAULT_DATASET)
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "experiments" / "canonical_shadow" / "reports" / "m26",
    )
    parser.add_argument("--seed", action="store_true", help="(Re)seed dataset from goldens+live")
    parser.add_argument("--skip-asr", action="store_true")
    parser.add_argument("--skip-regression-suites", action="store_true")
    parser.add_argument("--review-sample", type=int, default=20)
    args = parser.parse_args()

    if args.seed or not (args.dataset / "manifest.json").is_file():
        manifest = seed_dataset(args.dataset)
        print(f"Seeded dataset at {args.dataset} ({len(manifest.recordings)} records)")
    else:
        manifest = load_manifest(args.dataset)

    store = CanonicalLexiconStore()
    store.load()

    evals: list[RecordingEval] = []
    for meta in iter_evaluable(manifest, args.dataset):
        hyp = meta.hypothesis
        wav = audio_path(args.dataset, meta)
        if not hyp:
            if args.skip_asr or not wav.is_file() or wav.name.endswith(".missing.wav"):
                print(f"SKIP {meta.recording_id}: no hypothesis/audio")
                continue
            if not asr_available():
                print(f"SKIP {meta.recording_id}: ONNX ASR unavailable")
                continue
            print(f"ASR {meta.recording_id} …")
            hyp = transcribe_wav(wav)
            meta.hypothesis = hyp

        shadow = compare_ayah(
            ref=meta.ref,
            expected_arabic=meta.expected_arabic,
            hypothesis=hyp,
            lexical_reference_arabic=meta.lexical_reference_arabic,
            corpus_kind="live_capture",
            case_id=meta.recording_id,
            store=store,
        )

        mismatches = []
        for op in shadow.legacy.ops:
            m = classify_legacy_op(
                op, recording_id=meta.recording_id, ref=meta.ref
            )
            if m:
                mismatches.append(m)
        for d in shadow.diffs:
            if d.legacy_op == d.canonical_op and d.legacy_op == "match":
                continue
            if d.note in {"legacy_false_sub", "shadow_regression", "op_sequence_diff", "regression", "op_count_mismatch"}:
                mismatches.append(
                    classify_disagreement(
                        recording_id=meta.recording_id,
                        ref=meta.ref,
                        legacy_op=d.legacy_op,
                        canonical_op=d.canonical_op,
                        legacy_en=d.legacy_expected_norm,
                        legacy_hn=d.legacy_hyp_norm,
                        legacy_category=d.legacy_category,
                        human_label=meta.human_label,
                    )
                )

        evals.append(
            RecordingEval(
                recording_id=meta.recording_id,
                ref=meta.ref,
                speaker_id=meta.speaker_id,
                speaker_tags=meta.speaker_tags,
                human_label=meta.human_label,
                hypothesis=hyp,
                expected_arabic=meta.expected_arabic,
                shadow=shadow,
                mismatches=mismatches,
            )
        )
        print(
            f"OK {meta.recording_id} ref={meta.ref} "
            f"legacy={shadow.legacy_accuracy:.3f} "
            f"canonical={shadow.canonical_accuracy}"
        )

    golden_reg = presentation_reg = live_reg = None
    if not args.skip_regression_suites:
        print("Running regression suites (golden / presentation / live)…")
        golden_reg = _regression_suite(
            store, "golden_perfect", list(iter_golden_perfect_recitation())
        )
        # Presentation: sample for speed if huge — still full suite for gate
        presentation_reg = _regression_suite(
            store, "presentation_space", list(iter_presentation_space_cases())
        )
        live_reg = _regression_suite(store, "live_capture", list(iter_live_captures()))

    metrics = aggregate(
        evals,
        golden_regression=golden_reg,
        presentation_regression=presentation_reg,
        live_regression=live_reg,
    )

    out = args.output
    out.mkdir(parents=True, exist_ok=True)
    # Also mirror under dataset/reports
    ds_reports = args.dataset / "reports"
    ds_reports.mkdir(parents=True, exist_ok=True)

    md = render_markdown(evals, metrics)
    for dest in (out, ds_reports):
        (dest / "m26_real_world_report.md").write_text(md, encoding="utf-8")
        write_metrics_json(metrics, dest / "m26_metrics.json")
        write_failure_breakdown(evals, dest / "m26_failure_breakdown.json")
        write_detail_json(evals, dest / "m26_detail.json")
        rows = write_human_review_csv(
            evals, dest / "m26_human_review.csv", sample_size=args.review_sample
        )
        # fill audio paths
        if rows:
            id_to_audio = {
                m.recording_id: m.audio_relpath for m in manifest.recordings
            }
            import csv

            for row in rows:
                row["audio_relpath"] = id_to_audio.get(row["recording_id"], "")
            with (dest / "m26_human_review.csv").open("w", encoding="utf-8", newline="") as f:
                w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
                w.writeheader()
                w.writerows(rows)

    # Memory feature reports copy
    mem = (
        Path(__file__).resolve().parents[2]
        / "memory"
        / "features"
        / "tajweed"
        / "reports"
    )
    mem.mkdir(parents=True, exist_ok=True)
    (mem / "m26-real-world-2026-07-31.md").write_text(md, encoding="utf-8")
    write_metrics_json(metrics, mem / "m26-metrics-2026-07-31.json")

    print(
        f"M2.6 done: n={metrics.n_recordings} "
        f"legacy={metrics.legacy_mean_accuracy:.4f} "
        f"canonical={metrics.canonical_mean_accuracy:.4f} "
        f"Δ={metrics.mean_accuracy_delta:+.4f} "
        f"accept={'PASS' if metrics.acceptance_pass else 'FAIL'}"
    )
    print(f"Report: {out / 'm26_real_world_report.md'}")
    return 0 if metrics.acceptance_pass else 1


if __name__ == "__main__":
    raise SystemExit(main())
