# assets/quran/ — Mushaf structural metadata

Per-ayah `page` and `juz` numbers for standard printed Mushaf layouts, used by
the Quran Reading Engine (`lib/features/quran/reading_engine/`) to power
Page Mode and Juz Mode without any network access.

## Files

- `uthmani.json` — **Madani Mushaf layout** (King Fahd Complex, 604 pages,
  30 Juz): per-ayah `page` + `juz` for Page/Juz Mode.
- `text/uthmani.json` — Uthmani (Hafs) Arabic ayah text corpus (6236 ayahs)
  + font `assets/fonts/UthmanicHafs.otf`.
- `text/indopak.json` — IndoPak (Hafs) Arabic ayah text corpus (6236 ayahs)
  + font `assets/fonts/NooreHuda.ttf`.
- Layout `indopak.json` (printed IndoPak **page** boundaries) is still
  reserved — the IndoPak text files above do not include Mushaf page maps,
  so Page Mode continues to use Madani 604-page boundaries for both scripts.

## Schema (`uthmani.json`)

```json
{
  "mushaf": "uthmani",
  "source": "Tanzil Project quran-data.xml (CC BY 3.0), https://tanzil.net",
  "totalSurahs": 114,
  "totalAyahs": 6236,
  "totalPages": 604,
  "totalJuz": 30,
  "ayahs": [
    { "surah": 1, "ayah": 1, "page": 1, "juz": 1 }
  ]
}
```

`ayahs` is a flat, ordered array of all 6236 ayahs. It intentionally carries
no Arabic/English text — text still comes from `assets/raw/quran_paak.json`
and `assets/raw/english_translation.json`. This file only answers "which
page/juz is surah `s`, ayah `a` on?".

## Regenerating

This file is generated, not hand-written. See `tool/generate_quran_metadata.py`
for the source data and regeneration steps. It only needs to be re-run if the
bundled Quran text asset's surah/ayah numbering ever changes.

## License note

Structural metadata (page/juz boundaries) is derived from Tanzil Project's
`quran-data.xml`, © Tanzil.info, licensed CC BY 3.0 (https://tanzil.net).
