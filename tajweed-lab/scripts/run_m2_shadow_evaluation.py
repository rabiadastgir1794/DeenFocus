#!/usr/bin/env python3
"""ADR-010 M2 — run canonical shadow evaluation (measurement only)."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from canonical_lexicon.canonical_evaluator import CanonicalLexiconStore  # noqa: E402
from canonical_lexicon.m2_corpus import import_live_captures_to_fixtures, load_all_cases  # noqa: E402
from canonical_lexicon.m2_report import write_report  # noqa: E402
from canonical_lexicon.shadow_compare import ayah_result_to_dict, compare_ayah  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(description="ADR-010 M2 shadow evaluation")
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT / "experiments" / "canonical_shadow" / "reports" / "m2",
    )
    parser.add_argument("--skip-presentation", action="store_true")
    parser.add_argument("--import-live", action="store_true", help="Copy Downloads last_stages into fixtures")
    parser.add_argument("--live-path", type=Path, action="append", default=[])
    args = parser.parse_args()

    if args.import_live:
        paths = import_live_captures_to_fixtures(args.live_path or None)
        print(f"Imported {len(paths)} live capture fixture(s)")

    cases = load_all_cases(
        include_golden=True,
        include_presentation=not args.skip_presentation,
        include_live=True,
        extra_live_paths=args.live_path or None,
    )
    store = CanonicalLexiconStore()
    store.load()

    results = []
    detail = []
    for case in cases:
        r = compare_ayah(
            ref=case.ref,
            expected_arabic=case.expected_arabic,
            hypothesis=case.hypothesis,
            lexical_reference_arabic=case.lexical_reference_arabic,
            corpus_kind=case.corpus_kind,
            case_id=case.case_id,
            store=store,
        )
        results.append(r)
        row = ayah_result_to_dict(r)
        row["caseId"] = case.case_id
        row["source"] = case.source
        row["notes"] = case.notes
        detail.append(row)

    summary = write_report(results, args.output, detail_json=detail)
    print(
        f"M2 complete: cases={summary.total_cases} "
        f"legacy={summary.legacy_mean_accuracy:.4f} "
        f"canonical={summary.canonical_mean_accuracy:.4f} "
        f"delta={summary.mean_accuracy_delta:+.4f} "
        f"false_subs_removed={summary.false_subs_removed} "
        f"regressions={summary.regressions} "
        f"recommendation={summary.recommendation}"
    )
    print(f"Report: {args.output / 'm2_shadow_evaluation_report.md'}")
    return 0 if summary.recommendation == "Ready for M3" else 1


if __name__ == "__main__":
    raise SystemExit(main())
