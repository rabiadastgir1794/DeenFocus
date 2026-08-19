"""Production legacy lexical evaluator mirror (TajweedLexicalScoring).

Measurement-only — must stay aligned with ios/Runner/Tajweed/TajweedLexicalScoring.swift
and android/.../TajweedLexicalScoring.kt. Do not use for new scoring paths.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from typing import Any

DIACRITICS = set("\u064B\u064C\u064D\u064E\u064F\u0650\u0651\u0652\u0615\u0653\u0654\u0655\u0656\u0657\u0658\u0659\u065A\u065B\u065C\u065D\u065E\u065F\u06E1")
NON_LEXICAL_MARKS = {"\u066D"}
FORMAT_CONTROLS = {0x200B, 0x200C, 0x200D, 0xFEFF, 0x00A0, 0x202F, 0x2009, 0x200A, 0x2060, 0x061C}
HEH_FAMILY = {0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3}
YA_FAMILY = {0x064A, 0x0649, 0x06CC}
KAF_FAMILY = {0x0643, 0x06A9}

MATCH = "match"
SUB = "sub"
MISS = "miss"
EXTRA = "extra"


@dataclass(frozen=True)
class WordAlignOp:
    op: str
    expected_index: int | None
    hyp_index: int | None
    text: str
    reason: str | None = None
    expected_norm: str | None = None
    hyp_norm: str | None = None


@dataclass(frozen=True)
class LegacyEvalResult:
    ref: str
    expected_words: list[str]
    hyp_words: list[str]
    ops: list[WordAlignOp]
    word_accuracy: float
    matches: int
    substitutions: int
    misses: int
    extras: int


def is_ignorable_mark(ch: str) -> bool:
    cp = ord(ch)
    return (
        ch in DIACRITICS
        or cp == 0x0640
        or (0x06D6 <= cp <= 0x06ED)
        or ch in NON_LEXICAL_MARKS
        or cp in FORMAT_CONTROLS
    )


def is_format_control(ch: str) -> bool:
    return ord(ch) in FORMAT_CONTROLS


def is_heh_family(code: int) -> bool:
    return code in HEH_FAMILY


def is_ya_family(code: int) -> bool:
    return code in YA_FAMILY


def is_kaf(code: int) -> bool:
    return code in KAF_FAMILY


def previous_base_code(scalars: list[str], index: int) -> int:
    k = index - 1
    while k >= 0 and is_ignorable_mark(scalars[k]):
        k -= 1
    if k >= 0 and not scalars[k].isspace():
        return ord(scalars[k])
    return -1


def normalize_arabic(text: str) -> str:
    scalars = list(text)
    out: list[str] = []
    i = 0
    while i < len(scalars):
        ch = scalars[i]
        cp = ord(ch)
        if ch.isspace():
            i += 1
            continue
        if cp == 0x0670:
            j = i + 1
            while j < len(scalars) and is_ignorable_mark(scalars[j]):
                j += 1
            if j >= len(scalars) or scalars[j].isspace():
                next_cp = -1
            else:
                next_cp = ord(scalars[j])
            if next_cp >= 0:
                drop = is_heh_family(next_cp) or is_ya_family(next_cp) or is_kaf(next_cp)
            else:
                prev = previous_base_code(scalars, i)
                drop = prev >= 0 and is_ya_family(prev)
            if not drop:
                out.append("\u0627")
            i += 1
            continue
        if cp == 0x0671:
            out.append("\u0627")
            i += 1
            continue
        if is_ignorable_mark(ch):
            i += 1
            continue
        if is_heh_family(cp):
            out.append("\u0647")
            i += 1
            continue
        out.append(ch)
        i += 1
    s = "".join(out)
    for a, b in [
        ("أ", "ا"),
        ("إ", "ا"),
        ("آ", "ا"),
        ("ى", "ي"),
        ("ک", "ك"),
        ("ی", "ي"),
        ("الائك", "الئك"),
        ("اولائك", "اولئك"),
    ]:
        s = s.replace(a, b)
    return s.strip()


def split_words(text: str) -> list[str]:
    parts = re.split(r"[\s\t\n\r\u000b\u000c]+", text)
    return [p.strip() for p in parts if p.strip() and normalize_arabic(p)]


def lexical_words(text: str, reference_text: str | None = None) -> list[str]:
    reference = reference_text if reference_text is not None else text
    canonical = [normalize_arabic(w) for w in split_words(reference) if normalize_arabic(w)]
    stream = normalize_arabic(text)
    i = 0
    out: list[str] = []
    for word in canonical:
        if stream[i : i + len(word)] == word:
            out.append(word)
            i += len(word)
        else:
            return [normalize_arabic(w) for w in split_words(text) if normalize_arabic(w)]
    if i != len(stream):
        return [normalize_arabic(w) for w in split_words(text) if normalize_arabic(w)]
    return out


def is_non_lexical_annotation_token(text: str) -> bool:
    if not text:
        return True
    for ch in text:
        if ch.isspace() or is_format_control(ch):
            continue
        if is_ignorable_mark(ch):
            continue
        return False
    return True


def filter_lexical_expected_words(words: list[str]) -> list[str]:
    return [w for w in words if not is_non_lexical_annotation_token(w)]


def prepare_expected_words(text: str, reference_text: str | None = None) -> list[str]:
    reference = reference_text if reference_text is not None else text
    return filter_lexical_expected_words(lexical_words(text, reference_text=reference))


def peel_leading_waw(word: str) -> tuple[str | None, str]:
    scalars = list(word)
    i = 0
    while i < len(scalars) and is_ignorable_mark(scalars[i]):
        i += 1
    if i >= len(scalars) or ord(scalars[i]) != 0x0648:
        return None, word
    j = i + 1
    while j < len(scalars) and is_ignorable_mark(scalars[j]):
        j += 1
    rest = "".join(scalars[j:])
    if not rest:
        return None, word
    return "".join(scalars[:j]), rest


def split_attached_waw_hypothesis_words(words: list[str]) -> list[str]:
    out: list[str] = []
    for word in words:
        waw, rest = peel_leading_waw(word)
        if waw and rest:
            out.append(waw)
            out.append(rest)
        else:
            out.append(word)
    return out


def prepare_hypothesis_words(hypothesis: str) -> list[str]:
    return split_attached_waw_hypothesis_words(split_words(hypothesis))


def is_ulaaik_variant(expected_norm: str, hyp_norm: str) -> bool:
    pair = {expected_norm, hyp_norm}
    return pair == {"اولائك", "اولئك"} or pair == {"الائك", "الئك"}


def classify_mismatch_reason(
    op: str,
    expected_word: str,
    hyp_word: str | None,
    expected_norm: str,
    hyp_norm: str | None,
) -> str:
    if op == EXTRA:
        return "model"
    if op == MISS:
        if is_non_lexical_annotation_token(expected_word):
            return "quranic_mark"
        if expected_norm == "و":
            return "attached_waw"
        return "model"
    if op == SUB:
        if hyp_word is None:
            return "model"
        hyp_n = hyp_norm if hyp_norm is not None else normalize_arabic(hyp_word)
        if expected_norm == "و" or (hyp_n.startswith("و") and len(hyp_n) > 1):
            return "attached_waw"
        if "\u0670" in expected_word or (hyp_word and "\u0670" in hyp_word):
            return "dagger_alif"
        if is_ulaaik_variant(expected_norm, hyp_n):
            return "hamza_variant"
        if is_non_lexical_annotation_token(expected_word):
            return "quranic_mark"
        return "model"
    return "model"


def align_words(expected: list[str], hypothesis: list[str]) -> list[WordAlignOp]:
    n, m = len(expected), len(hypothesis)
    exp_n = [normalize_arabic(w) for w in expected]
    hyp_n = [normalize_arabic(w) for w in hypothesis]
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        dp[i][0] = i
    for j in range(1, m + 1):
        dp[0][j] = j
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            cost = 0 if exp_n[i - 1] == hyp_n[j - 1] else 1
            dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)

    ops: list[WordAlignOp] = []
    i, j = n, m
    while i > 0 or j > 0:
        if (
            i > 0
            and j > 0
            and exp_n[i - 1] == hyp_n[j - 1]
            and dp[i][j] == dp[i - 1][j - 1]
        ):
            ops.append(
                WordAlignOp(
                    MATCH,
                    i - 1,
                    j - 1,
                    expected[i - 1],
                    None,
                    exp_n[i - 1],
                    hyp_n[j - 1],
                )
            )
            i -= 1
            j -= 1
        elif i > 0 and j > 0 and dp[i][j] == dp[i - 1][j - 1] + 1:
            reason = classify_mismatch_reason(
                SUB, expected[i - 1], hypothesis[j - 1], exp_n[i - 1], hyp_n[j - 1]
            )
            ops.append(
                WordAlignOp(
                    SUB,
                    i - 1,
                    j - 1,
                    expected[i - 1],
                    reason,
                    exp_n[i - 1],
                    hyp_n[j - 1],
                )
            )
            i -= 1
            j -= 1
        elif i > 0 and dp[i][j] == dp[i - 1][j] + 1:
            reason = classify_mismatch_reason(MISS, expected[i - 1], None, exp_n[i - 1], None)
            ops.append(
                WordAlignOp(MISS, i - 1, None, expected[i - 1], reason, exp_n[i - 1], None)
            )
            i -= 1
        elif j > 0 and dp[i][j] == dp[i][j - 1] + 1:
            ops.append(
                WordAlignOp(
                    EXTRA,
                    None,
                    j - 1,
                    hypothesis[j - 1],
                    "model",
                    None,
                    hyp_n[j - 1],
                )
            )
            j -= 1
        elif i > 0:
            reason = classify_mismatch_reason(MISS, expected[i - 1], None, exp_n[i - 1], None)
            ops.append(
                WordAlignOp(MISS, i - 1, None, expected[i - 1], reason, exp_n[i - 1], None)
            )
            i -= 1
        else:
            ops.append(
                WordAlignOp(
                    EXTRA,
                    None,
                    j - 1,
                    hypothesis[j - 1],
                    "model",
                    None,
                    hyp_n[j - 1],
                )
            )
            j -= 1
    ops.reverse()
    return ops


def word_accuracy_from_ops(ops: list[WordAlignOp], expected_count: int) -> float:
    if expected_count <= 0:
        return 1.0 if not ops else 0.0
    matches = sum(1 for o in ops if o.op == MATCH)
    return matches / expected_count


def evaluate(
    ref: str,
    expected_arabic: str,
    hypothesis: str,
    lexical_reference_arabic: str | None = None,
) -> LegacyEvalResult:
    reference = lexical_reference_arabic or expected_arabic
    expected_words = prepare_expected_words(expected_arabic, reference_text=reference)
    hyp_words = prepare_hypothesis_words(hypothesis)
    ops = align_words(expected_words, hyp_words)
    acc = word_accuracy_from_ops(ops, len(expected_words))
    return LegacyEvalResult(
        ref=ref,
        expected_words=expected_words,
        hyp_words=hyp_words,
        ops=ops,
        word_accuracy=acc,
        matches=sum(1 for o in ops if o.op == MATCH),
        substitutions=sum(1 for o in ops if o.op == SUB),
        misses=sum(1 for o in ops if o.op == MISS),
        extras=sum(1 for o in ops if o.op == EXTRA),
    )


def result_to_dict(result: LegacyEvalResult) -> dict[str, Any]:
    return {
        "ref": result.ref,
        "wordAccuracy": result.word_accuracy,
        "matches": result.matches,
        "substitutions": result.substitutions,
        "misses": result.misses,
        "extras": result.extras,
        "expectedWords": result.expected_words,
        "hypWords": result.hyp_words,
        "ops": [
            {
                "op": o.op,
                "expectedIndex": o.expected_index,
                "hypIndex": o.hyp_index,
                "text": o.text,
                "reason": o.reason,
                "expectedNorm": o.expected_norm,
                "hypNorm": o.hyp_norm,
            }
            for o in result.ops
        ],
    }
