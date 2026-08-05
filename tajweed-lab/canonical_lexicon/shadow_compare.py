"""Shadow comparison engine for ADR-010 M2 measurement."""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from canonical_lexicon.canonical_evaluator import (
    CanonicalEvalResult,
    CanonicalLexiconStore,
    evaluate as evaluate_canonical,
    result_to_dict as canonical_to_dict,
)
from canonical_lexicon.legacy_evaluator import (
    MATCH,
    LegacyEvalResult,
    WordAlignOp,
    evaluate as evaluate_legacy,
    result_to_dict as legacy_to_dict,
)
from canonical_lexicon.m2_categories import (
    classify_canonical_mismatch,
    classify_legacy_mismatch,
    is_false_sub_removed,
    is_regression,
)


@dataclass
class OpDiff:
    index: int
    legacy_op: str
    canonical_op: str
    legacy_reason: str | None
    expected_word_id: str | None
    legacy_expected_norm: str | None
    legacy_hyp_norm: str | None
    canonical_expected: str | None
    canonical_hyp: str | None
    note: str
    legacy_category: str | None = None
    canonical_category: str | None = None
    is_false_sub_removed: bool = False
    is_true_sub_preserved: bool = False
    is_regression: bool = False


@dataclass
class AyahShadowResult:
    ref: str
    corpus_kind: str
    case_id: str
    legacy: LegacyEvalResult
    canonical: CanonicalEvalResult | None
    legacy_accuracy: float
    canonical_accuracy: float | None
    accuracy_delta: float | None
    false_subs_removed: int = 0
    true_subs_preserved: int = 0
    regressions: int = 0
    identical: bool = False
    diffs: list[OpDiff] = field(default_factory=list)
    legacy_categories: dict[str, int] = field(default_factory=dict)
    canonical_categories: dict[str, int] = field(default_factory=dict)


def _op_signature_legacy(op: WordAlignOp) -> str:
    exp = op.expected_index if op.expected_index is not None else -1
    hyp = op.hyp_index if op.hyp_index is not None else -1
    return f"{op.op}:{exp}:{hyp}:{op.expected_norm}:{op.hyp_norm}"


def _op_signature_canonical(op: WordAlignOp) -> str:
    wid = op.text if op.op != "extra" else "-"
    hyp = op.hyp_index if op.hyp_index is not None else -1
    return f"{op.op}:{wid}:{hyp}:{op.expected_norm}:{op.hyp_norm}"


def compare_ayah(
    *,
    ref: str,
    expected_arabic: str,
    hypothesis: str,
    lexical_reference_arabic: str | None,
    corpus_kind: str,
    case_id: str,
    store: CanonicalLexiconStore,
) -> AyahShadowResult:
    legacy = evaluate_legacy(ref, expected_arabic, hypothesis, lexical_reference_arabic)
    canonical = evaluate_canonical(ref, hypothesis, store=store)

    result = AyahShadowResult(
        ref=ref,
        corpus_kind=corpus_kind,
        case_id=case_id,
        legacy=legacy,
        canonical=canonical,
        legacy_accuracy=legacy.word_accuracy,
        canonical_accuracy=canonical.word_accuracy if canonical else None,
        accuracy_delta=(
            (canonical.word_accuracy - legacy.word_accuracy) if canonical else None
        ),
    )

    if canonical is None:
        result.diffs.append(
            OpDiff(
                index=0,
                legacy_op="n/a",
                canonical_op="n/a",
                legacy_reason=None,
                expected_word_id=None,
                legacy_expected_norm=None,
                legacy_hyp_norm=None,
                canonical_expected=None,
                canonical_hyp=None,
                note="lexicon_miss",
            )
        )
        return result

    leg_sig = [_op_signature_legacy(o) for o in legacy.ops]
    can_sig = [_op_signature_canonical(o) for o in canonical.ops]
    result.identical = leg_sig == can_sig

    # Pairwise diff walk (position-aligned — same DP length may differ; use index)
    limit = max(len(legacy.ops), len(canonical.ops))
    for idx in range(limit):
        lo = legacy.ops[idx] if idx < len(legacy.ops) else None
        co = canonical.ops[idx] if idx < len(canonical.ops) else None
        if lo is None and co is None:
            continue
        legacy_op = lo.op if lo else "none"
        canonical_op = co.op if co else "none"
        if lo and co and legacy_op == canonical_op:
            if legacy_op == MATCH:
                continue
            if (
                lo.expected_index == co.expected_index
                and lo.hyp_index == co.hyp_index
                and lo.expected_norm == co.expected_norm
                and lo.hyp_norm == co.hyp_norm
            ):
                continue

        note = "op_sequence_diff"
        if legacy_op == "sub" and canonical_op == MATCH:
            note = "legacy_false_sub"
        elif legacy_op == MATCH and canonical_op == "sub":
            note = "shadow_regression"
        elif len(legacy.ops) != len(canonical.ops):
            note = "op_count_mismatch"

        leg_cat = None
        can_cat = None
        if lo and lo.op != MATCH:
            next_norm = None
            if lo.hyp_index is not None and lo.hyp_index + 1 < len(legacy.hyp_words):
                from canonical_lexicon.legacy_evaluator import normalize_arabic

                next_norm = normalize_arabic(legacy.hyp_words[lo.hyp_index + 1])
            leg_cat = classify_legacy_mismatch(
                lo,
                ref=ref,
                corpus_kind=corpus_kind,
                next_hyp_norm=next_norm,
            )
            result.legacy_categories[leg_cat] = result.legacy_categories.get(leg_cat, 0) + 1
        if co and co.op != MATCH:
            can_cat = classify_canonical_mismatch(co, corpus_kind=corpus_kind)
            result.canonical_categories[can_cat] = result.canonical_categories.get(can_cat, 0) + 1

        false_sub_removed = is_false_sub_removed(legacy_op, canonical_op, leg_cat)
        true_sub_preserved = (
            legacy_op in {"sub", "miss", "extra"}
            and canonical_op in {"sub", "miss", "extra"}
            and legacy_op == canonical_op
        )
        regression = is_regression(
            legacy_op,
            canonical_op,
            legacy_en=lo.expected_norm if lo else None,
            legacy_hn=lo.hyp_norm if lo else None,
            canonical_en=co.expected_norm if co else None,
            canonical_hn=co.hyp_norm if co else None,
            corpus_kind=corpus_kind,
            legacy_category=leg_cat,
        )

        if false_sub_removed:
            result.false_subs_removed += 1
        if true_sub_preserved:
            result.true_subs_preserved += 1
        if regression:
            result.regressions += 1
            note = "regression"

        result.diffs.append(
            OpDiff(
                index=idx,
                legacy_op=legacy_op,
                canonical_op=canonical_op,
                legacy_reason=lo.reason if lo else None,
                expected_word_id=co.text if co and co.op != "extra" else None,
                legacy_expected_norm=lo.expected_norm if lo else None,
                legacy_hyp_norm=lo.hyp_norm if lo else None,
                canonical_expected=co.expected_norm if co else None,
                canonical_hyp=co.hyp_norm if co else None,
                note=note,
                legacy_category=leg_cat,
                canonical_category=can_cat,
                is_false_sub_removed=false_sub_removed,
                is_true_sub_preserved=true_sub_preserved,
                is_regression=regression,
            )
        )

    return result


def ayah_result_to_dict(r: AyahShadowResult) -> dict[str, Any]:
    return {
        "ref": r.ref,
        "corpusKind": r.corpus_kind,
        "caseId": r.case_id,
        "legacyAccuracy": r.legacy_accuracy,
        "canonicalAccuracy": r.canonical_accuracy,
        "accuracyDelta": r.accuracy_delta,
        "falseSubsRemoved": r.false_subs_removed,
        "trueSubsPreserved": r.true_subs_preserved,
        "regressions": r.regressions,
        "identical": r.identical,
        "legacy": legacy_to_dict(r.legacy),
        "canonical": canonical_to_dict(r.canonical) if r.canonical else None,
        "legacyCategories": r.legacy_categories,
        "canonicalCategories": r.canonical_categories,
        "diffs": [
            {
                "index": d.index,
                "legacyOp": d.legacy_op,
                "canonicalOp": d.canonical_op,
                "legacyReason": d.legacy_reason,
                "expectedWordId": d.expected_word_id,
                "legacyExpectedNorm": d.legacy_expected_norm,
                "legacyHypNorm": d.legacy_hyp_norm,
                "canonicalExpected": d.canonical_expected,
                "canonicalHyp": d.canonical_hyp,
                "note": d.note,
                "legacyCategory": d.legacy_category,
                "canonicalCategory": d.canonical_category,
                "isFalseSubRemoved": d.is_false_sub_removed,
                "isTrueSubPreserved": d.is_true_sub_preserved,
                "isRegression": d.is_regression,
            }
            for d in r.diffs
        ],
    }
