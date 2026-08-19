# Architecture — DeenFocus Tajweed Lab → iOS

## Principles

1. **Lab first, app later** — all experimentation lives under `tajweed-lab/`, isolated from Flutter `lib/`.
2. **Offline by design** — no cloud ASR at runtime for the product feature.
3. **Reuse upstream exports** — prefer official ONNX (lab) and CoreML (iOS) over custom conversion until we must diverge.
4. **Canonical text is source of truth** — score against DeenFocus ayah text; ASR is the acoustic evidence.

## Layers

```
┌─────────────────────────────────────────────────────────────┐
│  UI                                                         │
│  Lab: browser (web/)   →   Product: Flutter Quran reader    │
└───────────────────────────────┬─────────────────────────────┘
                                │ audio + expected ayah
┌───────────────────────────────▼─────────────────────────────┐
│  Feature pipeline                                           │
│  1. Mel frontend (16 kHz, 80 mel)                           │
│  2. ASR encoder+CTC → transcript + encoder frames           │
│  3. Align transcript ↔ expected ayah                        │
│  4. Score tokens (head + GOP + optional anchor)             │
│  5. Tajweed rule engine → per-letter teaching feedback      │
└───────────────────────────────┬─────────────────────────────┘
                                │
        Phase 1 (now)           │           Phase 3 (iOS)
        Python + ONNX           │           Swift + CoreML
```

## Phase 1 — Web lab (this repo)

| Component | Implementation |
| --- | --- |
| Server | FastAPI (`web/app.py`) |
| Model | `onnx/model_with_encoder.onnx` via ONNX Runtime |
| Tokenizer | SentencePiece `tokenizer.model` |
| Mel | Pure NumPy (NeMo-compatible), same as HF demo |
| UI | Single-page `web/static/index.html` — upload / mic / demo |
| Output v1 | Diacritized ASR text + timing |
| Output v2 | Mispronunciation + tajweed (after `vendor/tajweed` wired) |

## Phase 2 — Full scoring in lab

Wire vendored `tajweed/` package:

- Forced CTC alignment (`aligner.py`)
- `head_scorer.py` + `gop_scorer.py` + `full_scorer.py`
- Rule feedback (`rules.py`, `text_analyzer.py`)

UI highlights wrong tokens against the selected ayah.

## Phase 3 — DeenFocus iOS

| Piece | Plan |
| --- | --- |
| Runtime | CoreML on Neural Engine (`coreml-offline` first) |
| Mel / CTC decode | Swift (Accelerate) — upstream documents ~200-line mel path |
| Tokenizer | SentencePiece (native / WASM port / pre-token map) |
| Tajweed rules | Port pure-Python rules to Dart or Swift (deterministic) |
| Flutter bridge | Method channel / FFI from Quran reader screen |
| Assets | `.mlpackage` + tokenizer bundled; download-on-first-launch optional if size is an issue |

## Data flow in product (target)

```
User opens ayah in Quran reader
  → taps "Practice tajweed"
  → records audio (local only)
  → CoreML ASR + scorer
  → UI paints:
       green  = matched
       amber  = weak / style-sensitive
       red    = mispronounced / missing
  → tap token → show rule name + short explanation (localized)
```

## What we deliberately do not do in lab

- No Flutter changes yet  
- No Superwall / monetization wiring until license ADR is resolved  
- No training / fine-tuning unless accuracy gaps appear on our users
