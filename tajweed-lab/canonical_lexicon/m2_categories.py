"""M2 mismatch category taxonomy (ADR-010 measurement)."""

from __future__ import annotations

from typing import Any

from canonical_lexicon.legacy_evaluator import (
    EXTRA,
    MATCH,
    MISS,
    SUB,
    WordAlignOp,
    normalize_arabic,
)

# Exactly one category per non-match diff row.
DISPLAY_SCRIPT = "display_script_difference"
ATTACHED_CONJUNCTION = "attached_conjunction"
PRESENTATION_SPACE = "presentation_space"
ORTHOGRAPHY = "orthography"
TRUE_ASR_ERROR = "true_asr_error"
ASR_TRUNCATION = "asr_truncation"
DIFFERENT_LEMMA = "different_lemma"
UNKNOWN = "unknown"


def classify_legacy_mismatch(
    op: WordAlignOp,
    *,
    ref: str,
    corpus_kind: str,
    next_hyp_norm: str | None = None,
    prev_hyp_norm: str | None = None,
) -> str:
    if op.op == MATCH:
        raise ValueError("classify_legacy_mismatch called on match")

    en = op.expected_norm or ""
    hn = op.hyp_norm or ""

    if op.reason == "attached_waw":
        return ATTACHED_CONJUNCTION
    if op.reason == "dagger_alif":
        return DISPLAY_SCRIPT
    if op.reason == "hamza_variant":
        return ORTHOGRAPHY
    if op.reason == "quranic_mark":
        return DISPLAY_SCRIPT

    if op.op == MISS:
        if en == "و" and next_hyp_norm and next_hyp_norm.startswith("و") and next_hyp_norm != "و":
            return ATTACHED_CONJUNCTION
        if corpus_kind == "presentation_space":
            return PRESENTATION_SPACE
        return ASR_TRUNCATION

    if op.op == EXTRA:
        return TRUE_ASR_ERROR

    if op.op == SUB:
        if en == hn:
            return ORTHOGRAPHY
        if en == "ذالك" and hn == "ذلك":
            return DISPLAY_SCRIPT
        if en == "اولائك" and hn == "اولئك":
            return ORTHOGRAPHY
        if en == "علاي" and hn == "علي":
            return DISPLAY_SCRIPT
        if en in {"الصلاوه", "الصلاه"} and hn in {"الصلاوه", "الصلاه"}:
            return DISPLAY_SCRIPT
        if en == "رزقنهم" and hn == "رزقناهم":
            return DISPLAY_SCRIPT
        if en.startswith("و") and hn.startswith("و") and hn[1:] == en:
            return ATTACHED_CONJUNCTION
        if en == "و" or (hn.startswith("و") and len(hn) > 1):
            return ATTACHED_CONJUNCTION
        if "اخر" in en and "اخر" in hn and en != hn:
            return DIFFERENT_LEMMA
        if corpus_kind == "presentation_space":
            return PRESENTATION_SPACE
        return TRUE_ASR_ERROR

    return UNKNOWN


def classify_canonical_mismatch(op: WordAlignOp, *, corpus_kind: str) -> str:
    if op.op == MATCH:
        raise ValueError("classify_canonical_mismatch called on match")
    if op.op == MISS:
        return ASR_TRUNCATION
    if op.op == EXTRA:
        return TRUE_ASR_ERROR
    if op.op == SUB:
        en = op.expected_norm or ""
        hn = op.hyp_norm or ""
        if en == hn:
            return ORTHOGRAPHY
        if corpus_kind == "presentation_space":
            return PRESENTATION_SPACE
        return TRUE_ASR_ERROR
    return UNKNOWN


def is_likely_orthographic_false_sub(en: str, hn: str) -> bool:
    """Heuristic: legacy sub that canonical fold would treat as same spoken word."""
    pairs = {
        ("ذالك", "ذلك"),
        ("اولائك", "اولئك"),
        ("علاي", "علي"),
        ("الصلاوه", "الصلاه"),
        ("رزقنهم", "رزقناهم"),
    }
    return (en, hn) in pairs or en == hn


def is_regression(
    legacy_op: str,
    canonical_op: str,
    *,
    legacy_en: str | None,
    legacy_hn: str | None,
    canonical_en: str | None,
    canonical_hn: str | None,
    corpus_kind: str,
    legacy_category: str | None,
) -> bool:
    """Canonical must not increase score for genuine ASR errors."""
    if canonical_op != MATCH:
        return False
    if legacy_op == MATCH:
        return False
    if legacy_category in {
        DISPLAY_SCRIPT,
        ORTHOGRAPHY,
        ATTACHED_CONJUNCTION,
        PRESENTATION_SPACE,
    }:
        return False
    if legacy_op == SUB and legacy_en and legacy_hn and is_likely_orthographic_false_sub(legacy_en, legacy_hn):
        return False
    if corpus_kind in {"golden_perfect", "presentation_space"}:
        return False
    if legacy_op in {SUB, MISS, EXTRA} and legacy_category in {
        TRUE_ASR_ERROR,
        ASR_TRUNCATION,
        DIFFERENT_LEMMA,
        UNKNOWN,
    }:
        return True
    if legacy_op == EXTRA:
        return True
    if legacy_op == MISS and corpus_kind == "live_capture":
        return True
    return False


def is_false_sub_removed(
    legacy_op: str,
    canonical_op: str,
    legacy_category: str | None,
) -> bool:
    if legacy_op != SUB or canonical_op != MATCH:
        return False
    return legacy_category in {
        DISPLAY_SCRIPT,
        ORTHOGRAPHY,
        ATTACHED_CONJUNCTION,
        PRESENTATION_SPACE,
    }
