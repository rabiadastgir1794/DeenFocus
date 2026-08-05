"""Tests for M2.5 rematerialization + M2.6 dataset seeding."""

from __future__ import annotations

import unittest

from canonical_lexicon.canonical_evaluator import (
    CanonicalLexiconStore,
    evaluate,
    rematerialize_clitics,
)
from canonical_lexicon.m2_corpus import _load_text_maps
from canonical_lexicon.shadow_compare import compare_ayah


class RematerializeTests(unittest.TestCase):
    def test_merge_waw_host(self) -> None:
        expected = ["ويقيمون", "الصلاه"]
        hyp = ["و", "يقيمون", "الصلاه"]
        self.assertEqual(rematerialize_clitics(hyp, expected), ["ويقيمون", "الصلاه"])

    def test_no_fuzzy_merge(self) -> None:
        expected = ["والذين"]
        hyp = ["و", "يقيمون"]
        self.assertEqual(rematerialize_clitics(hyp, expected), ["و", "يقيمون"])

    def test_golden_2_3_perfect(self) -> None:
        indo, uth, paak = _load_text_maps()
        store = CanonicalLexiconStore()
        store.load()
        r = compare_ayah(
            ref="2:3",
            expected_arabic=indo["2:3"],
            hypothesis=paak["2:3"],
            lexical_reference_arabic=uth["2:3"],
            corpus_kind="golden_perfect",
            case_id="t",
            store=store,
        )
        self.assertEqual(r.canonical_accuracy, 1.0)
        self.assertGreaterEqual(r.canonical_accuracy or 0, r.legacy_accuracy)


if __name__ == "__main__":
    unittest.main()
