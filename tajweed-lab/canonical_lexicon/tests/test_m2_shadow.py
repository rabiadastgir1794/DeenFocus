"""M2 shadow evaluation tests."""

from __future__ import annotations

import unittest

from canonical_lexicon.canonical_evaluator import CanonicalLexiconStore
from canonical_lexicon.legacy_evaluator import evaluate as legacy_eval
from canonical_lexicon.m2_categories import is_false_sub_removed, is_regression
from canonical_lexicon.m2_corpus import _load_text_maps, iter_golden_perfect_recitation
from canonical_lexicon.shadow_compare import compare_ayah


class M2CategoryTests(unittest.TestCase):
    def test_display_script_not_regression(self) -> None:
        self.assertFalse(
            is_regression(
                "sub",
                "match",
                legacy_en="ذالك",
                legacy_hn="ذلك",
                canonical_en="ذلك",
                canonical_hn="ذلك",
                corpus_kind="live_capture",
                legacy_category="display_script_difference",
            )
        )

    def test_true_asr_miss_is_regression_on_live(self) -> None:
        self.assertTrue(
            is_regression(
                "miss",
                "match",
                legacy_en="يقيمون",
                legacy_hn=None,
                canonical_en="يقيمون",
                canonical_hn="يقيمون",
                corpus_kind="live_capture",
                legacy_category="asr_truncation",
            )
        )

    def test_false_sub_removed_display_script(self) -> None:
        self.assertTrue(
            is_false_sub_removed("sub", "match", "display_script_difference")
        )


class M2GoldenTests(unittest.TestCase):
    def test_2_2_perfect_recitation_both_match(self) -> None:
        indopak, uthmani, paak = _load_text_maps()
        store = CanonicalLexiconStore()
        store.load()
        r = compare_ayah(
            ref="2:2",
            expected_arabic=indopak["2:2"],
            hypothesis=paak["2:2"],
            lexical_reference_arabic=uthmani["2:2"],
            corpus_kind="golden_perfect",
            case_id="test:2:2",
            store=store,
        )
        self.assertEqual(r.legacy_accuracy, 1.0)
        self.assertEqual(r.canonical_accuracy, 1.0)

    def test_1_6_presentation_space_perfect(self) -> None:
        indopak, uthmani, paak = _load_text_maps()
        store = CanonicalLexiconStore()
        store.load()
        r = compare_ayah(
            ref="1:6",
            expected_arabic=indopak["1:6"],
            hypothesis=paak["1:6"],
            lexical_reference_arabic=uthmani["1:6"],
            corpus_kind="golden_perfect",
            case_id="test:1:6",
            store=store,
        )
        self.assertEqual(r.legacy_accuracy, 1.0)
        self.assertEqual(r.canonical_accuracy, 1.0)


class M2CorpusTests(unittest.TestCase):
    def test_golden_corpus_count(self) -> None:
        cases = list(iter_golden_perfect_recitation())
        self.assertEqual(len(cases), 13)  # Fatiha 1:1-1:7 + 2:2-2:7


if __name__ == "__main__":
    unittest.main()
