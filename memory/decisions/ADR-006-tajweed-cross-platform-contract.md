# ADR-006 — Tajweed cross-platform Flutter ↔ native contract
**Date:** 2026-07-28   **Status:** Accepted (revised 2026-07-30)   **Feature:** tajweed

## Problem
AI Tajweed must ship on iOS (CoreML) and Android (ONNX Runtime) with one
Flutter UI and identical scoring UX. Without a frozen channel + JSON + error
contract, the two native engines will drift.

## Decision
Lock a single MethodChannel / EventChannel pair, native-only recording,
unified score JSON, standardized error codes, and shared Dart models.
Native runtimes differ; Flutter never branches on CoreML vs ONNX.

Companion: [`ADR-007-tajweed-model-lifecycle.md`](ADR-007-tajweed-model-lifecycle.md).

Design detail for scoring: [`../features/tajweed/lexical-first-scoring-design.md`](../features/tajweed/lexical-first-scoring-design.md).

### Channels

| Channel | Name |
| --- | --- |
| Method | `com.app.deenly.deenly/tajweed` |
| Event | `com.app.deenly.deenly/tajweed_events` |

### Methods

| Method | Returns |
| --- | --- |
| `isAvailable` | `bool` — verified model on disk |
| `ensureModel` | void when ready; progress via events |
| `prepareModel` | void when warm-loaded |
| `startRecording` | args: `surah`, `ayah`, `expectedArabic` |
| `stopRecordingAndScore` | score JSON (schema below) |
| `cancelRecording` | void |
| `getRecordingState` | `idle` \| `recording` \| `scoring` \| `cancelling` |
| `dispose` | void |

Recording is **native only** (iOS `AVAudioEngine`, Android `AudioRecord`).
Flutter never captures PCM.

### Scoring pipeline (lexical-first, 2026-07-30)

Identity and pronunciation are separated:

1. ASR → hypothesis text (greedy CTC decode).
2. Word-level edit alignment (Levenshtein) of hypothesis words vs expected ayah
   words → lexical ops: **match / sub / miss / extra**.
3. Forced-align **hypothesis** SentencePiece ids onto `logprobs` (spoken path).
4. Pronunciation head runs **only** for lexically matched words (worst-piece-wins
   per word). Unmatched words never call the head.
5. `wordAccuracy` = (number of lexically matched expected words) ÷
   (number of expected words). Pronunciation severity does **not** reduce this
   figure. Extra tokens are excluded from the denominator.

This prevents false high scores when a completely different ayah is recited
(ASR hyp is correct; forced-align-of-expected previously invented “ok” intervals).

### Score JSON

```json
{
  "ref": "1:4",
  "expected": "…",
  "hypothesis": "…",
  "durationSec": 4.68,
  "wordAccuracy": 1.0,
  "exactMatch": true,
  "tokens": [
    {
      "text": "…",
      "status": "ok|minor|major|sub|miss|extra",
      "lexical": "match|sub|miss|extra",
      "pronunciation": "ok|minor|major|null",
      "prob": 0.92,
      "startSec": 0.1,
      "endSec": 0.4
    }
  ]
}
```

#### Token fields

| Field | Meaning |
| --- | --- |
| `status` | Combined UI status (additive set). |
| `lexical` | Additive. Lexical identity from word DP. |
| `pronunciation` | Additive. Head quality for matches only; `null` otherwise. |
| `prob` | Head probability for matches; `0` for non-matches. |

#### `status` semantics

| `status` | Meaning | Typical UI |
| --- | --- | --- |
| `ok` | Lexical match + good pronunciation | Green |
| `minor` | Lexical match + mild pronunciation issue | Orange |
| `major` | Lexical match + severe pronunciation issue | Orange |
| `sub` | Substitution (wrong word spoken) | Red |
| `miss` | Expected word not spoken | Grey |
| `extra` | Extra spoken word | Purple |

`sub` is **distinct** from `major` — never overload `major` for substitutions.

### Error codes (stable; add-only)

`FEATURE_DISABLED`, `MIC_PERMISSION_DENIED`, `MIC_BUSY`, `NOT_RECORDING`,
`ALREADY_RECORDING`, `AUDIO_TOO_SHORT`, `AUDIO_TOO_LONG`, `AUDIO_QUALITY_POOR`,
`MODEL_MISSING`, `MODEL_DOWNLOAD_FAILED`, `MODEL_LOAD_FAILED`,
`INFERENCE_FAILED`, `INFERENCE_CANCELLED`, `INTERRUPTED`, `UNSUPPORTED`,
`INVALID_ARGS`.

### Feature flag

`StorageService` key `tajweed_enabled` (default `false`). Flutter short-circuits
native calls when disabled.

### Local history

`TajweedHistoryEntry` persisted locally after successful scores (no PCM).
Future optional cloud sync may upload summaries only — recordings stay on-device.

### UX entry

Surah detail hosts CTAs only; practice opens a **full-screen**
`TajweedPracticeScreen` (Phase 5).

### Symmetric native modules

`ios/Runner/Tajweed/` and
`android/app/src/main/kotlin/com/app/deenly/deenly/tajweed/` mirror each other
module-for-module (AudioRecorder, MelFrontend, CTC decode/align,
ASR model, pronunciation head, ModelStore, TajweedEngine / TajweedLexicalScoring,
TajweedChannelHandler).

## Consequences
- Phase 1 lands Dart contract + placeholder native handlers.
- Phases 2–3 implement engines against this ADR without changing Flutter APIs.
- 2026-07-30: additive JSON keys `lexical`, `pronunciation`; additive status `sub`;
  lexical-first scoring on both platforms. Older clients that ignore unknown
  keys remain compatible; clients must treat unknown `status` values safely
  (Dart maps unknown → `ok` by default — prefer explicit `sub` handling).
- Changing method names or removing JSON keys requires a new ADR revision.
