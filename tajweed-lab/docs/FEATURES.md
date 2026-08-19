# Features

Product intent: **offline Quran tajweed coaching** inside DeenFocus Quran reader.

Status legend: `planned` · `lab` · `blocked` · `done`

## F1 — Recitation capture

| ID | Feature | Status |
| --- | --- | --- |
| F1.1 | Upload audio file (wav/flac/ogg/mp3) in lab web UI | lab |
| F1.2 | Browser mic recording in lab web UI | lab |
| F1.3 | Run bundled demo clips | lab |
| F1.4 | In-app mic capture from Quran reader (Flutter) | planned |

## F2 — Offline ASR (what was recited)

| ID | Feature | Status |
| --- | --- | --- |
| F2.1 | Local ONNX FastConformer CTC transcription | lab |
| F2.2 | Diacritized Arabic output (Hafs) | lab |
| F2.3 | CoreML offline ASR on device | planned |
| F2.4 | Optional streaming ASR while speaking | planned |

## F3 — Correction vs expected ayah

| ID | Feature | Status |
| --- | --- | --- |
| F3.1 | Select expected ayah / paste reference text in lab | planned |
| F3.2 | Align ASR ↔ canonical ayah (diacritic-insensitive where needed) | planned |
| F3.3 | Highlight substitutions / insertions / deletions | planned |
| F3.4 | Use DeenFocus `quran_paak.json` as reference source | planned |

## F4 — Mispronunciation detection

| ID | Feature | Status |
| --- | --- | --- |
| F4.1 | Pronunciation head scoring | planned |
| F4.2 | CTC GOP scoring | planned |
| F4.3 | Consensus (≥2 of 3 signals) | planned |
| F4.4 | Per-token confidence UI | planned |

## F5 — Tajweed teaching

| ID | Feature | Status |
| --- | --- | --- |
| F5.1 | 27-rule engine feedback | planned |
| F5.2 | Human-readable rule explanations (EN + AR + app locales) | planned |
| F5.3 | “Listen to correct example” using existing audio assets (if any) | planned |
| F5.4 | Practice loop: retry ayah until clean | planned |

## F6 — Offline packaging

| ID | Feature | Status |
| --- | --- | --- |
| F6.1 | Lab models stored under `tajweed-lab/models/` (gitignored) | lab |
| F6.2 | Ship CoreML + tokenizer in iOS bundle or on-demand download | planned |
| F6.3 | Works airplane-mode after assets present | planned |

## F7 — Product integration

| ID | Feature | Status |
| --- | --- | --- |
| F7.1 | Entry point from Quran surah/ayah screen | planned |
| F7.2 | Progress / streaks for tajweed practice (optional) | planned |
| F7.3 | Premium vs free gating — **blocked on NPL license review** | blocked |
