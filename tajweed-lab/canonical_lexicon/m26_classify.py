"""M2.6 failure classification — exactly one cause per mismatch."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from canonical_lexicon.legacy_evaluator import MATCH, WordAlignOp
from canonical_lexicon.m2_categories import (
    DISPLAY_SCRIPT,
    ORTHOGRAPHY,
    PRESENTATION_SPACE,
    ATTACHED_CONJUNCTION,
    TRUE_ASR_ERROR,
    ASR_TRUNCATION,
    DIFFERENT_LEMMA,
    classify_legacy_mismatch,
)

ASR = "asr"
CANONICAL_LEXICAL = "canonical_lexical"
PRONUNCIATION = "pronunciation"
TAJWEED = "tajweed"
POLICY = "policy"
UNKNOWN = "unknown"


@dataclass
class ClassifiedMismatch:
    recording_id: str
    ref: str
    side: str  # legacy | canonical | disagreement
    op: str
    expected: str | None
    hypothesis: str | None
    cause: str
    detail: str


def classify_legacy_op(
    op: WordAlignOp,
    *,
    recording_id: str,
    ref: str,
    corpus_kind: str = "live_capture",
) -> ClassifiedMismatch | None:
    if op.op == MATCH:
        return None
    cat = classify_legacy_mismatch(op, ref=ref, corpus_kind=corpus_kind)
    if cat in {DISPLAY_SCRIPT, ORTHOGRAPHY, PRESENTATION_SPACE}:
        cause = CANONICAL_LEXICAL  # legacy false penalty; canonical should fix
        detail = f"legacy category={cat} — display/orthography, not spoken-word error"
    elif cat == ATTACHED_CONJUNCTION:
        cause = POLICY
        detail = "clitic boundary / conjunction tokenization"
    elif cat in {TRUE_ASR_ERROR, ASR_TRUNCATION, DIFFERENT_LEMMA}:
        cause = ASR
        detail = f"legacy category={cat}"
    else:
        cause = UNKNOWN
        detail = f"legacy category={cat}"
    return ClassifiedMismatch(
        recording_id=recording_id,
        ref=ref,
        side="legacy",
        op=op.op,
        expected=op.expected_norm,
        hypothesis=op.hyp_norm,
        cause=cause,
        detail=detail,
    )


def classify_disagreement(
    *,
    recording_id: str,
    ref: str,
    legacy_op: str,
    canonical_op: str,
    legacy_en: str | None,
    legacy_hn: str | None,
    legacy_category: str | None,
    human_label: str | None,
) -> ClassifiedMismatch:
    """Exactly one cause for a legacy≠canonical op pair."""
    if legacy_op != MATCH and canonical_op == MATCH:
        if legacy_category in {DISPLAY_SCRIPT, ORTHOGRAPHY, PRESENTATION_SPACE}:
            cause = CANONICAL_LEXICAL
            detail = "canonical correctly matches; legacy false sub from display script"
        elif legacy_category == ATTACHED_CONJUNCTION:
            cause = POLICY
            detail = "canonical rematerialized clitic; legacy boundary mismatch"
        elif human_label == "correct":
            cause = CANONICAL_LEXICAL
            detail = "human says correct; canonical match removes false penalty"
        else:
            cause = UNKNOWN
            detail = "canonical match where legacy erred — verify human review"
    elif legacy_op == MATCH and canonical_op != MATCH:
        cause = POLICY
        detail = "canonical stricter than legacy — possible rematerialization/ID bug"
    elif legacy_op != MATCH and canonical_op != MATCH:
        cause = ASR
        detail = "both paths disagree with expected — treat as ASR/content error"
    else:
        cause = UNKNOWN
        detail = "unexpected disagreement shape"
    return ClassifiedMismatch(
        recording_id=recording_id,
        ref=ref,
        side="disagreement",
        op=f"{legacy_op}->{canonical_op}",
        expected=legacy_en,
        hypothesis=legacy_hn,
        cause=cause,
        detail=detail,
    )


def to_dict(m: ClassifiedMismatch) -> dict[str, Any]:
    return {
        "recordingId": m.recording_id,
        "ref": m.ref,
        "side": m.side,
        "op": m.op,
        "expected": m.expected,
        "hypothesis": m.hypothesis,
        "cause": m.cause,
        "detail": m.detail,
    }
