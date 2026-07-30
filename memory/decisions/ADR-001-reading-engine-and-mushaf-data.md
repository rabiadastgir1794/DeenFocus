# ADR-001 — Reading Engine + real Madani Mushaf page/juz data
**Date:** 2026-07-28   **Status:** Accepted   **Feature:** quran-reader (Phase 1)

## Problem
Quran 2.0 Phase 1 requires three reading modes (Surah, Juz, Mushaf Page) that
all need Continue Reading, Reading Progress, and consistent navigation. Two
sub-problems had to be solved before writing any UI:

1. `assets/raw/quran_paak.json` / `english_translation.json` (the app's only
   Quran data today) carry no `juz` or `page` metadata — Juz Mode and Page
   Mode have nothing to group by.
2. Without a shared abstraction, Surah/Juz/Page would each reinvent
   navigation, position-persistence, and progress-tracking, and Page Mode
   specifically risked becoming fixed-line "pseudo-pagination" (reflowed text
   split every N lines) instead of matching a real printed Mushaf.

## Decision

### 1. Real page/juz numbers, sourced once, bundled as a static asset
Page and Juz numbers **must** match a printed Madani Mushaf — not app-invented
pseudo-pagination. `tool/generate_quran_metadata.py` downloads Tanzil
Project's official structural metadata (`quran-data.xml`, CC BY 3.0) and
expands its page/juz *start markers* into a flat per-ayah record
`{surah, ayah, page, juz}` for all 6236 ayahs, written to
`assets/quran/uthmani.json` (604 pages / 30 juz, verified against the app's
own ayah counts). See `assets/quran/README.md`.

The mapping is namespaced by Mushaf standard (`uthmani.json` today,
`indopak.json` reserved) specifically so a future script/layout doesn't
require touching `lib/features/quran/reading_engine/mushaf_metadata.dart` or
any screen — only a new data file plus one `MushafStandard` enum value.

Page rendering is **text reflow** using the app's existing typography
(`AyahCard`), not scanned page images — this keeps font size, dark mode,
translation toggle, search, bookmarks, highlighting, and future AI Tajweed
all working unmodified across every reading mode.

### 2. A Reading Engine shared by all three modes
```
Reading Engine (lib/features/quran/reading_engine/reading_engine.dart)
├── Surah Mode  — openSurah(surahNumber)
├── Juz Mode    — openJuz(juzNumber)
└── Page Mode   — openPage(pageNumber) / trackPageVisit(page, ayah)
```
`ReadingEngine` resolves "what ayahs am I reading" from
`QuranLocalRepository` (text) + `MushafMetadata` (page/juz boundaries), and
owns Continue Reading + Reading Progress persistence (debounced writes to
`StorageService`) for every mode. It deliberately owns neither audio nor
widget rendering, so it can sit under the pre-existing Surah screen as well
as the new Juz/Page screens.

## Options Considered
1. Fixed-line pseudo-pagination for Page Mode (split ayahs every N lines) —
   rejected: page numbers wouldn't match a printed Mushaf, breaking the
   explicit requirement and any future feature that references "page 42."
2. Store page/juz directly on the Hive `AyahRecord` (schema change + seed
   version bump + migration). Rejected in favor of...
3. **Chosen:** keep `AyahRecord`/Hive completely unchanged; add
   `QuranLocalRepository.getAyahsByKeys()` / `getAllAyahs()` and look up
   page/juz purely from the new `assets/quran/*.json` asset via
   `MushafMetadata`. No seed bump, no migration, zero risk to existing Surah
   data.
4. Give each reading mode its own independent controller (no shared engine)
   — rejected per explicit instruction to build one Reading Engine; also
   would have duplicated Continue Reading/progress logic three times.
5. Refactor the existing Surah screen to render through a new shared
   "reading surface" widget — rejected for Phase 1: higher risk to a
   working screen for cosmetic reuse. Instead, Surah Mode's rendering/audio
   stayed untouched; it only gained a `ReadingEngine` instance for
   persistence, and reuses the new shared `QuranAudioBar` for the
   speed/volume/repeat controls (a mechanical, behavior-preserving swap of
   its existing bottom bar markup, not a rewrite).

## Consequences
**Positive:** Page numbers are trustworthy or "printed Mushaf" (supports
Page Bookmarks / Quran Journey later without renumbering); Juz/Page reuse
one persistence path instead of three; adding IndoPak (or any other Mushaf
standard) later is data-only.

**Negative:** Page Mode preloads the whole Quran's ayah text once (6236
small records, all already in Hive) to group by page for jank-free
swiping — a deliberate memory-for-smoothness tradeoff; it bypasses
`ReadingEngine.openPage()` for rendering and instead calls
`trackPageVisit()` purely for persistence, which is a slightly unusual
split worth remembering if Page Mode is refactored later.

## Related
- `assets/quran/README.md`, `tool/generate_quran_metadata.py`
- `lib/features/quran/reading_engine/`
- `memory/features/quran-reader/overview.md`
- `test/features/quran/mushaf_metadata_test.dart`
