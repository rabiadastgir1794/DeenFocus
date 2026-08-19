"""Golden-vector tests for ADR-010 M1 lexicon generator."""

from __future__ import annotations

import json
import unittest
from pathlib import Path

from canonical_lexicon.generator import _load_ayah_maps, generate_ayah_record, generate_lexicon
from canonical_lexicon.models import AyahRecord, CanonicalWord
from canonical_lexicon.validate import assert_pack_valid, validate_record

FIXTURES = Path(__file__).resolve().parents[3] / "memory" / "features" / "tajweed" / "fixtures"
PACK_DIR = FIXTURES / "canonical_lexicon_v1"


def _record(ref: str) -> AyahRecord:
    uthmani, indopak, paak = _load_ayah_maps()
    return generate_ayah_record(ref, uthmani[ref], indopak[ref], paak[ref])


class GeneratorGoldenTests(unittest.TestCase):
    def test_golden_2_2_word0(self) -> None:
        r = _record("2:2")
        w = r.words[0]
        self.assertEqual(w.id, "2:2:0")
        self.assertEqual(w.canonical, "ذلك")
        self.assertEqual(w.surfaceForms.indopak, "ذٰلِکَ")
        self.assertEqual(w.surfaceForms.uthmani, "ذَٰلِكَ")

    def test_golden_2_3_salah_rzq(self) -> None:
        r = _record("2:3")
        by_canon = {w.canonical: w for w in r.words}
        self.assertEqual(by_canon["الصلاه"].surfaceForms.indopak, "الصَّلٰوۃَ")
        self.assertEqual(by_canon["رزقناهم"].surfaceForms.indopak, "رَزَقۡنٰہُمۡ")

    def test_golden_1_6_presentation_space(self) -> None:
        r = _record("1:6")
        w = r.words[0]
        self.assertEqual(w.canonical, "اهدنا")
        self.assertEqual(w.surfaceForms.indopak, "اِہۡدِ نَا")

    def test_full_lexicon_generates_6236(self) -> None:
        manifest, records = generate_lexicon()
        self.assertEqual(manifest.ayahCount, 6236)
        self.assertEqual(len(records), 6236)


class PackValidationTests(unittest.TestCase):
    @unittest.skipUnless(PACK_DIR.is_dir(), "pack not generated yet")
    def test_committed_pack_validates(self) -> None:
        assert_pack_valid(PACK_DIR)

    @unittest.skipUnless(PACK_DIR.is_dir(), "pack not generated yet")
    def test_committed_pack_golden_rows(self) -> None:
        rows = {}
        for line in (PACK_DIR / "ayahs.ndjson").read_text(encoding="utf-8").splitlines():
            raw = json.loads(line)
            rows[raw["ref"]] = raw
        self.assertEqual(rows["2:2"]["words"][0]["canonical"], "ذلك")
        self.assertEqual(rows["1:6"]["words"][0]["canonical"], "اهدنا")


class ValidateRecordTests(unittest.TestCase):
    def test_validate_record_rejects_bad_id(self) -> None:
        r = _record("2:2")
        bad = r.words[0]
        issues = validate_record(
            AyahRecord(
                ref=r.ref,
                surah=r.surah,
                ayah=r.ayah,
                schemaVersion=r.schemaVersion,
                wordCount=1,
                letterstream=bad.canonical,
                words=[
                    CanonicalWord(
                        id="bad",
                        canonical=bad.canonical,
                        surfaceForms=bad.surfaceForms,
                    )
                ],
            )
        )
        self.assertTrue(any("id mismatch" in str(i) or "invalid id" in str(i) for i in issues))


if __name__ == "__main__":
    unittest.main()
