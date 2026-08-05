"""M2.6 metrics, confusion matrices, acceptance gates."""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass, field
from typing import Any

from canonical_lexicon.legacy_evaluator import MATCH
from canonical_lexicon.m26_classify import ClassifiedMismatch
from canonical_lexicon.shadow_compare import AyahShadowResult


@dataclass
class RecordingEval:
    recording_id: str
    ref: str
    speaker_id: str
    speaker_tags: list[str]
    human_label: str | None
    hypothesis: str
    expected_arabic: str
    shadow: AyahShadowResult
    mismatches: list[ClassifiedMismatch] = field(default_factory=list)
    # Lexical-only rates relative to human_label when available
    legacy_fp: bool = False  # legacy penalized a correct recitation
    legacy_fn: bool = False  # legacy accepted an incorrect recitation
    canonical_fp: bool = False
    canonical_fn: bool = False
    asr_truncation: bool = False
    pronunciation_errors: int = 0  # reserved — not scored in M2.6 lexical path
    tajweed_errors: int = 0  # reserved — stub layer


@dataclass
class M26Metrics:
    n_recordings: int
    n_with_human_label: int
    legacy_mean_accuracy: float
    canonical_mean_accuracy: float
    mean_accuracy_delta: float
    false_positives_legacy: int
    false_positives_canonical: int
    false_negatives_legacy: int
    false_negatives_canonical: int
    fp_reduction: int
    fn_increase: int
    asr_truncation_rate: float
    cause_counts: dict[str, int]
    confusion_legacy_vs_truth: dict[str, int]
    confusion_canonical_vs_truth: dict[str, int]
    confusion_legacy_vs_canonical: dict[str, int]
    regression_gates: dict[str, Any]
    acceptance_pass: bool
    acceptance_notes: list[str]


def _label_bin(label: str | None) -> str | None:
    if label == "correct":
        return "correct"
    if label in {"incorrect", "partial"}:
        return "incorrect"
    return None


def _pred_bin(accuracy: float, threshold: float = 0.99) -> str:
    return "correct" if accuracy >= threshold else "incorrect"


def evaluate_recording_flags(ev: RecordingEval) -> None:
    truth = _label_bin(ev.human_label)
    if truth is None:
        return
    leg = _pred_bin(ev.shadow.legacy_accuracy)
    can = _pred_bin(ev.shadow.canonical_accuracy or 0.0)
    # FP = predicted incorrect when truth correct (false penalty)
    ev.legacy_fp = truth == "correct" and leg == "incorrect"
    ev.canonical_fp = truth == "correct" and can == "incorrect"
    # FN = predicted correct when truth incorrect (missed error)
    ev.legacy_fn = truth == "incorrect" and leg == "correct"
    ev.canonical_fn = truth == "incorrect" and can == "correct"
    # Truncation heuristic: legacy/canonical miss count high relative to expected
    misses = ev.shadow.legacy.misses + ev.shadow.legacy.extras
    ev.asr_truncation = misses >= 2 and (ev.shadow.legacy_accuracy < 0.7)


def aggregate(
    evals: list[RecordingEval],
    *,
    golden_regression: dict[str, Any] | None = None,
    presentation_regression: dict[str, Any] | None = None,
    live_regression: dict[str, Any] | None = None,
) -> M26Metrics:
    for ev in evals:
        evaluate_recording_flags(ev)

    n = len(evals)
    labeled = [e for e in evals if _label_bin(e.human_label)]
    leg_acc = [e.shadow.legacy_accuracy for e in evals]
    can_acc = [e.shadow.canonical_accuracy or 0.0 for e in evals]
    deltas = [
        (e.shadow.canonical_accuracy or 0.0) - e.shadow.legacy_accuracy for e in evals
    ]

    fp_l = sum(1 for e in labeled if e.legacy_fp)
    fp_c = sum(1 for e in labeled if e.canonical_fp)
    fn_l = sum(1 for e in labeled if e.legacy_fn)
    fn_c = sum(1 for e in labeled if e.canonical_fn)

    causes: Counter[str] = Counter()
    for e in evals:
        for m in e.mismatches:
            causes[m.cause] += 1

    conf_leg: Counter[str] = Counter()
    conf_can: Counter[str] = Counter()
    conf_lc: Counter[str] = Counter()
    for e in labeled:
        t = _label_bin(e.human_label)
        assert t is not None
        leg = _pred_bin(e.shadow.legacy_accuracy)
        can = _pred_bin(e.shadow.canonical_accuracy or 0.0)
        conf_leg[f"truth={t}|legacy={leg}"] += 1
        conf_can[f"truth={t}|canonical={can}"] += 1
        conf_lc[f"legacy={leg}|canonical={can}"] += 1

    trunc = sum(1 for e in evals if e.asr_truncation) / n if n else 0.0

    notes: list[str] = []
    # Acceptance: canonical must not increase FN; must reduce FP
    fn_ok = fn_c <= fn_l
    fp_ok = fp_c <= fp_l
    if labeled:
        notes.append(
            f"Labeled n={len(labeled)}: legacy FP={fp_l} FN={fn_l}; "
            f"canonical FP={fp_c} FN={fn_c}"
        )
    else:
        notes.append("No human-labeled incorrect recordings yet — FP/FN gates partial")
        fn_ok = True  # cannot fail without labels
        fp_ok = True

    if fn_ok:
        notes.append("Gate: canonical FN did not increase vs legacy")
    else:
        notes.append("FAIL: canonical increased false negatives")
    if fp_ok and (fp_c < fp_l or not labeled):
        notes.append(
            f"Gate: canonical FP reduced or equal (ΔFP={fp_l - fp_c})"
        )
    elif fp_ok:
        notes.append("Gate: FP equal (need more labeled correct takes to show reduction)")
    else:
        notes.append("FAIL: canonical increased false positives")

    gates = {
        "golden": golden_regression or {},
        "presentation_space": presentation_regression or {},
        "live_capture": live_regression or {},
        "fp_ok": fp_ok,
        "fn_ok": fn_ok,
    }
    for name, g in (
        ("golden", golden_regression),
        ("presentation_space", presentation_regression),
        ("live_capture", live_regression),
    ):
        if not g:
            notes.append(f"Gate {name}: not run / missing")
            continue
        if g.get("pass"):
            notes.append(f"Gate {name}: PASS — {g.get('summary')}")
        else:
            notes.append(f"Gate {name}: FAIL — {g.get('summary')}")

    corpus_ok = all(
        (g or {}).get("pass", False)
        for g in (golden_regression, presentation_regression, live_regression)
        if g is not None
    )
    # If regression dicts provided empty pass key, require them
    if golden_regression is None:
        corpus_ok = False
        notes.append("Golden regression suite required")

    acceptance = fn_ok and fp_ok and corpus_ok and (fp_c < fp_l or len(labeled) == 0)
    # Stricter: if we have labeled correct takes, require FP reduction when legacy had FP
    if labeled and fp_l > 0 and fp_c >= fp_l:
        acceptance = False

    return M26Metrics(
        n_recordings=n,
        n_with_human_label=len(labeled),
        legacy_mean_accuracy=sum(leg_acc) / n if n else 0.0,
        canonical_mean_accuracy=sum(can_acc) / n if n else 0.0,
        mean_accuracy_delta=sum(deltas) / n if n else 0.0,
        false_positives_legacy=fp_l,
        false_positives_canonical=fp_c,
        false_negatives_legacy=fn_l,
        false_negatives_canonical=fn_c,
        fp_reduction=fp_l - fp_c,
        fn_increase=fn_c - fn_l,
        asr_truncation_rate=trunc,
        cause_counts=dict(causes),
        confusion_legacy_vs_truth=dict(conf_leg),
        confusion_canonical_vs_truth=dict(conf_can),
        confusion_legacy_vs_canonical=dict(conf_lc),
        regression_gates=gates,
        acceptance_pass=acceptance,
        acceptance_notes=notes,
    )


def metrics_to_dict(m: M26Metrics) -> dict[str, Any]:
    return {
        "nRecordings": m.n_recordings,
        "nWithHumanLabel": m.n_with_human_label,
        "legacyMeanAccuracy": m.legacy_mean_accuracy,
        "canonicalMeanAccuracy": m.canonical_mean_accuracy,
        "meanAccuracyDelta": m.mean_accuracy_delta,
        "falsePositivesLegacy": m.false_positives_legacy,
        "falsePositivesCanonical": m.false_positives_canonical,
        "falseNegativesLegacy": m.false_negatives_legacy,
        "falseNegativesCanonical": m.false_negatives_canonical,
        "fpReduction": m.fp_reduction,
        "fnIncrease": m.fn_increase,
        "asrTruncationRate": m.asr_truncation_rate,
        "causeCounts": m.cause_counts,
        "confusionLegacyVsTruth": m.confusion_legacy_vs_truth,
        "confusionCanonicalVsTruth": m.confusion_canonical_vs_truth,
        "confusionLegacyVsCanonical": m.confusion_legacy_vs_canonical,
        "regressionGates": m.regression_gates,
        "acceptancePass": m.acceptance_pass,
        "acceptanceNotes": m.acceptance_notes,
        "pronunciationErrorsNote": "Not scored in M2.6 (lexical-only); reserved field=0",
        "tajweedErrorsNote": "Stub layer; reserved field=0",
    }
