# Diagnosis: lexical-first all-`sub` on correct recitation (2026-07-30)

> Investigation only. **No production code changes. No fixes proposed.**
> Evidence from one real correct recitation path: golden `01_alafasy_fatihah.wav`
> (ASR hyp = Al-Fatiha 1:4) vs the **exact expected text the app passes**
> (`ayah.arabicText` from `assets/quran/text/uthmani.json` for 1:4).

## How expected text reaches the engine

```
Surah/Juz UI
  → TajweedEntryPoint.open(..., arabicText: ayah.arabicText)
  → TajweedPracticeViewModel → TajweedService.startRecording(expectedArabic: args.arabicText)
  → TajweedEngine.expectedArabic
  → TajweedLexicalScoring.splitWords + normalizeArabic + alignWords
```

`ayah.arabicText` is **not** the lab/imlaei string used in Phase 4B golden tests.
It is the user’s selected Quran script overlay (`QuranScriptTexts` →
`assets/quran/text/uthmani.json` or `indopak.json`) via
`QuranLocalRepository._applySelectedScript`.

## Stage 1 — Expected ayah (Uthmani 1:4)

| Step | Value |
| --- | --- |
| Original (`uthmani.json` 1:4) | `مَٰلِكِ يَوۡمِ ٱلدِّينِ` |
| Word array passed to alignment | `['مَٰلِكِ', 'يَوۡمِ', 'ٱلدِّينِ']` |

Per-word Unicode (raw):

| i | Raw | Code points |
| --- | --- | --- |
| 0 | `مَٰلِكِ` | U+0645 U+064E **U+0670** U+0644 U+0650 U+0643 U+0650 |
| 1 | `يَوۡمِ` | U+064A U+064E U+0648 **U+06E1** U+0645 U+0650 |
| 2 | `ٱلدِّينِ` | **U+0671** U+0644 U+062F U+0651 U+0650 U+064A U+0646 U+0650 |

After `normalizeArabic` (Kotlin `TajweedLexicalScoring.kt` lines 39–49):

| i | Normalized | Notes |
| --- | --- | --- |
| 0 | `ملك` | U+0670 dagger alif **is** in DIACRITICS → stripped → **alef disappears** |
| 1 | `يوۡم` | U+06E1 **not** in DIACRITICS → **survives** |
| 2 | `ٱلدين` | U+0671 alef wasla **not** mapped to U+0627 → **survives** |

DIACRITICS constant (exact):

```11:12:android/app/src/main/kotlin/com/app/deenly/deenly/tajweed/TajweedLexicalScoring.kt
    private const val DIACRITICS =
        "\u064B\u064C\u064D\u064E\u064F\u0650\u0651\u0652\u0670\u0615\u0653\u0654"
```

Alef maps applied (أ/إ/آ → ا, ى → ي only) — **no** `ٱ` → `ا`.

## Stage 2 — ASR output (same ayah, correct audio)

| Step | Value |
| --- | --- |
| Raw hypothesis (`01_alafasy_fatihah.wav`) | `مَالِكِ يَوْمِ الدِّينِ` |
| Word array | `['مَالِكِ', 'يَوْمِ', 'الدِّينِ']` |

After same `normalizeArabic`:

| i | Normalized |
| --- | --- |
| 0 | `مالك` |
| 1 | `يوم` |
| 2 | `الدين` |

ASR uses ordinary sukun U+0652 (stripped) and ordinary alef U+0627 — imlaei-style orthography matching the model’s training domain, **not** Uthmani mushaf marks.

## Stage 3 — Word comparison (evidence of first failures)

| i | Expected norm | Hyp norm | Equal? | First differing code point |
| --- | --- | --- | --- | --- |
| 0 | `ملك` | `مالك` | **False** | index 1: expected has no char; hyp has **U+0627 (ا)** — caused by stripping dagger alif U+0670 from expected while hyp keeps a full alef |
| 1 | `يوۡم` | `يوم` | **False** | index 2: expected **U+06E1 (ۡ)** Quranic sukun vs hyp end / hyp already stripped U+0652 |
| 2 | `ٱلدين` | `الدين` | **False** | index 0: expected **U+0671 (ٱ)** vs hyp **U+0627 (ا)** |

So **every** expected word fails `normalizeArabic` equality against the corresponding recognized word.

## Stage 4 — Levenshtein (`alignWords`)

Inputs:

- expected norms: `['ملك', 'يوۡم', 'ٱلدين']`
- hyp norms: `['مالك', 'يوم', 'الدين']`

DP end distance = 3 (all replacements). Final ops (same algorithm as
`TajweedLexicalScoring.alignWords`):

| Op | Expected word | Status wire |
| --- | --- | --- |
| SUB | `مَٰلِكِ` | `sub` |
| SUB | `يَوۡمِ` | `sub` |
| SUB | `ٱلدِّينِ` | `sub` |

This matches the observed UI: **every word red (`sub`)** on a correct Fatiha 1:4 recitation when the app uses Uthmani script text.

## Stage 5 — Pronunciation head

**Zero words reach the pronunciation head** for this recitation.

Reason (code, not speculation):

```kotlin
// TajweedEngine.buildLexicalFirstTokens
val matchHypIndices = ops.mapNotNull { op ->
    if (op.op == LexicalOp.MATCH) op.hypIndex else null
}.toSet()
// ...
if (matchHypIndices.isNotEmpty() && hypIds.isNotEmpty() && ...) {
    // only then: CtcAligner.forcedAlign + head.score(...)
}
```

With zero `MATCH` ops, `matchHypIndices` is empty → no FA-for-head, no `head.score` calls.
Every token is emitted as `status=sub` / `lexical=sub` / `pronunciation=null`.

## Cross-check: Ikhlas 112:1 (Uthmani) — not all sub, but same root cause

Correct audio `02_basfar_ikhlas.wav` vs Uthmani 112:1 `قُلۡ هُوَ ٱللَّهُ أَحَدٌ`:

| Word | Result | First mismatch |
| --- | --- | --- |
| 0 | SUB | U+06E1 vs stripped U+0652 → `قلۡ` ≠ `قل` |
| 1 | MATCH | — |
| 2 | SUB | U+0671 `ٱ` ≠ U+0627 `ا` |
| 3 | MATCH | — |

So even when *some* words match, Uthmani-only marks still force `sub` on others.

## Cross-check: Indopak 112:1 — worse

Indopak text includes U+06C1 (ہ), pause mark U+06DA as its own “word”, and U+06E1.
Against ASR hyp, word count is 5 vs 4 and almost all norms differ → nearly all red / extras.

## FIRST failure point in the pipeline

**Matching first fails inside `TajweedLexicalScoring.normalizeArabic` when comparing
script-orthography expected words to ASR (imlaei) hypothesis words — before / at the
equality test used by `alignWords`.**

Exact transformation site:

```39:49:android/app/src/main/kotlin/com/app/deenly/deenly/tajweed/TajweedLexicalScoring.kt
    fun normalizeArabic(text: String): String {
        val sb = StringBuilder()
        for (ch in text) {
            if (DIACRITICS.indexOf(ch) < 0) sb.append(ch)
        }
        return sb.toString()
            .replace('\u0623', '\u0627')
            .replace('\u0625', '\u0627')
            .replace('\u0622', '\u0627')
            .replace('\u0649', '\u064A')
            .trim()
    }
```

Concrete transformations that turn a correct recitation into inequality (Fatiha 1:4):

1. **U+0670 dagger alif** is stripped from expected → `مَٰلِكِ` → `ملك`, while ASR keeps **U+0627** → `مالك`.
2. **U+06E1 Quranic annotation sukun** is **not** stripped → remains in expected `يوۡم`, while ASR’s U+0652 **is** stripped → `يوم`.
3. **U+0671 alef wasla** is **not** folded to U+0627 → expected `ٱلدين` vs hyp `الدين`.

Upstream source of the expected orthography (not ASR):

```184:198:lib/features/quran/data/quran_local_repository.dart
  /// Overlays the user's selected script orthography onto Hive-backed ayahs
  ...
          final text = texts.textFor(a.surahNumber, a.ayahNumber);
          return text == null ? a : a.copyWith(arabicText: text);
```

ASR itself is **correct** for the audio (hyp matches the ayah content in imlaei form).
Levenshtein is behaving correctly on the **already-mismatched** normalized strings.
The pronunciation head is never the failure site here — it never runs when all ops are `SUB`.

## What this is *not*

- Not a broken Levenshtein backtrace (DP is consistent with unequal norms).
- Not SentencePiece reconstruction for lexical compare (compare is on decoded hyp words vs expected words).
- Not mel/ONNX/model failure for this sample (hyp text is the right ayah).

## Artifacts

- Repro script (host, not in repo production path): `/tmp/lexical_match_diagnosis.py`
- Inputs: `assets/quran/text/uthmani.json` 1:4 / 112:1; `tajweed-lab/samples/01_*.wav`, `02_*.wav`; production ONNX encoder + `tokens.txt`
