"""Canonical lexical evaluator (ADR-010 shadow path)."""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from canonical_lexicon.legacy_evaluator import (
    EXTRA,
    MATCH,
    MISS,
    SUB,
    WordAlignOp,
    split_words,
    word_accuracy_from_ops,
)
from canonical_lexicon.stage2 import stage2_word

REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_PACK = REPO_ROOT / "memory/features/tajweed/fixtures/canonical_lexicon_v1"


@dataclass(frozen=True)
class CanonicalWord:
    id: str
    canonical: str


@dataclass(frozen=True)
class CanonicalEvalResult:
    ref: str
    expected_word_ids: list[str]
    expected_canonical: list[str]
    hyp_canonical: list[str]
    ops: list[WordAlignOp]
    word_accuracy: float
    matches: int
    substitutions: int
    misses: int
    extras: int
    lexicon_version: str


class CanonicalLexiconStore:
    def __init__(self, pack_dir: Path = DEFAULT_PACK) -> None:
        self.pack_dir = pack_dir
        self._manifest: dict[str, Any] | None = None
        self._ayahs: dict[str, list[CanonicalWord]] | None = None

    def load(self) -> None:
        if self._ayahs is not None:
            return
        manifest_path = self.pack_dir / "manifest.json"
        ndjson_path = self.pack_dir / "ayahs.ndjson"
        self._manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
        ayahs: dict[str, list[CanonicalWord]] = {}
        for line in ndjson_path.read_text(encoding="utf-8").splitlines():
            if not line.strip():
                continue
            row = json.loads(line)
            ref = row["ref"]
            ayahs[ref] = [
                CanonicalWord(w["id"], w["canonical"]) for w in row["words"]
            ]
        self._ayahs = ayahs

    @property
    def lexicon_version(self) -> str:
        self.load()
        assert self._manifest is not None
        return str(self._manifest.get("lexiconVersion", ""))

    def ayah(self, ref: str) -> list[CanonicalWord] | None:
        self.load()
        assert self._ayahs is not None
        return self._ayahs.get(ref)


def peel_leading_clitic(word: str) -> tuple[str | None, str]:
    """Peel leading و or ف (with ignorable marks) for hyp rematerialization."""
    from canonical_lexicon.legacy_evaluator import is_ignorable_mark

    scalars = list(word)
    i = 0
    while i < len(scalars) and is_ignorable_mark(scalars[i]):
        i += 1
    if i >= len(scalars):
        return None, word
    cp = ord(scalars[i])
    if cp not in (0x0648, 0x0641):  # waw, fa
        return None, word
    j = i + 1
    while j < len(scalars) and is_ignorable_mark(scalars[j]):
        j += 1
    rest = "".join(scalars[j:])
    if not rest:
        return None, word
    return "".join(scalars[:j]), rest


def normalize_hypothesis_words(words: list[str]) -> list[str]:
    """Stage-2 fold hyp tokens; peel attached و/ف into separate provisional tokens."""
    out: list[str] = []
    for word in words:
        clitic, rest = peel_leading_clitic(word)
        if clitic and rest:
            out.append(stage2_word(clitic))
            out.append(stage2_word(rest))
        else:
            folded = stage2_word(word)
            if folded:
                out.append(folded)
    return out


def rematerialize_clitics(
    hyp_canonical: list[str], expected_canonical: list[str]
) -> list[str]:
    """Merge standalone و/ف + host when the merge equals an expected Uthmani word.

    Policy (M2.5): expected IDs follow attached Uthmani tokens; ASR may emit
    split clitics. Deterministic — no fuzzy matching.
    """
    expected_set = set(expected_canonical)
    out: list[str] = []
    j = 0
    while j < len(hyp_canonical):
        h = hyp_canonical[j]
        if h in ("و", "ف") and j + 1 < len(hyp_canonical):
            merged = h + hyp_canonical[j + 1]
            if merged in expected_set:
                out.append(merged)
                j += 2
                continue
        out.append(h)
        j += 1
    return out


def align_canonical(
    expected: list[str], expected_ids: list[str], hypothesis: list[str]
) -> list[WordAlignOp]:
    n, m = len(expected), len(hypothesis)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        dp[i][0] = i
    for j in range(1, m + 1):
        dp[0][j] = j
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            cost = 0 if expected[i - 1] == hypothesis[j - 1] else 1
            dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)

    ops: list[WordAlignOp] = []
    i, j = n, m
    while i > 0 or j > 0:
        if (
            i > 0
            and j > 0
            and expected[i - 1] == hypothesis[j - 1]
            and dp[i][j] == dp[i - 1][j - 1]
        ):
            ops.append(
                WordAlignOp(
                    MATCH,
                    i - 1,
                    j - 1,
                    expected_ids[i - 1],
                    None,
                    expected[i - 1],
                    hypothesis[j - 1],
                )
            )
            i -= 1
            j -= 1
        elif i > 0 and j > 0 and dp[i][j] == dp[i - 1][j - 1] + 1:
            ops.append(
                WordAlignOp(
                    SUB,
                    i - 1,
                    j - 1,
                    expected_ids[i - 1],
                    "model",
                    expected[i - 1],
                    hypothesis[j - 1],
                )
            )
            i -= 1
            j -= 1
        elif i > 0 and dp[i][j] == dp[i - 1][j] + 1:
            ops.append(
                WordAlignOp(
                    MISS,
                    i - 1,
                    None,
                    expected_ids[i - 1],
                    "model",
                    expected[i - 1],
                    None,
                )
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
                    hypothesis[j - 1],
                )
            )
            j -= 1
        elif i > 0:
            ops.append(
                WordAlignOp(
                    MISS,
                    i - 1,
                    None,
                    expected_ids[i - 1],
                    "model",
                    expected[i - 1],
                    None,
                )
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
                    hypothesis[j - 1],
                )
            )
            j -= 1
    ops.reverse()
    return ops


def evaluate(
    ref: str,
    hypothesis: str,
    store: CanonicalLexiconStore | None = None,
) -> CanonicalEvalResult | None:
    lex = store or CanonicalLexiconStore()
    words = lex.ayah(ref)
    if not words:
        return None
    expected_canonical = [w.canonical for w in words]
    expected_ids = [w.id for w in words]
    hyp_canonical = rematerialize_clitics(
        normalize_hypothesis_words(split_words(hypothesis)),
        expected_canonical,
    )
    ops = align_canonical(expected_canonical, expected_ids, hyp_canonical)
    acc = word_accuracy_from_ops(ops, len(expected_canonical))
    return CanonicalEvalResult(
        ref=ref,
        expected_word_ids=expected_ids,
        expected_canonical=expected_canonical,
        hyp_canonical=hyp_canonical,
        ops=ops,
        word_accuracy=acc,
        matches=sum(1 for o in ops if o.op == MATCH),
        substitutions=sum(1 for o in ops if o.op == SUB),
        misses=sum(1 for o in ops if o.op == MISS),
        extras=sum(1 for o in ops if o.op == EXTRA),
        lexicon_version=lex.lexicon_version,
    )


def result_to_dict(result: CanonicalEvalResult) -> dict[str, Any]:
    return {
        "ref": result.ref,
        "lexiconVersion": result.lexicon_version,
        "wordAccuracy": result.word_accuracy,
        "matches": result.matches,
        "substitutions": result.substitutions,
        "misses": result.misses,
        "extras": result.extras,
        "expectedWordIds": result.expected_word_ids,
        "expectedCanonical": result.expected_canonical,
        "hypCanonical": result.hyp_canonical,
        "ops": [
            {
                "op": o.op,
                "expectedWordId": o.text if o.op != EXTRA else None,
                "hypIndex": o.hyp_index,
                "expectedCanonical": o.expected_norm,
                "hypCanonical": o.hyp_norm,
            }
            for o in result.ops
        ],
    }
