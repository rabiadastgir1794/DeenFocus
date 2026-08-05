# CoreML Contract — FastConformer-Quran Offline (ANE)

Source of truth for on-device I/O. Aligns with
[`Muno459/fastconformer-quran-coreml-offline`](https://huggingface.co/Muno459/fastconformer-quran-coreml-offline)
and ADR-007. **CoreML package wins** over lab ONNX mel if they diverge.

## Packages (Phase 2)

| Role | Artifact |
| --- | --- |
| ASR encoder + CTC (ANE) | `fastconformer-quran-offline-ane.mlpackage` |
| Pronunciation head | `pronunciation-head.mlpackage` |
| Tokenizer | `tokenizer.model` + `tokens.txt` |

## ASR multifunction entry points

`predict_T80`, `predict_T200`, `predict_T400`, `predict_T800`, `predict_T1600`,
`predict_T2400`, `predict_T4800` (padded mel length T ≈ 0.8 s … 48 s).

These are the **actual** function names in
`fastconformer-quran-offline-ane.mlpackage` (verified 2026-07-30). Do **not**
assume the older speculative list `[80,160,320,640,1280,2560,4800]`.

| | Shape / value |
| --- | --- |
| Input `audio_signal` / mel | `(1, 80, T)` float |
| Output `logprobs` | `(1, T/8, 1025)` |
| Output `encoder_output` | encoder frames, 512-d |
| CTC blank id | **1024** |
| Frame hop (post-subsample) | **80 ms** (T/8 frames) |

Pad mel time `T` up to the nearest supported bucket from the **active
manifest's `encoderBuckets`** (not a hard-coded Swift list). Reject audio that
would need T > max bucket (`AUDIO_TOO_LONG` / `ayah_too_long`).

### Manifest keys (iOS dual-model)

| Key | DIY | Official |
| --- | --- | --- |
| `encoderApi` | `single_function_fixed` | `multifunction` (or omit) |
| `encoderFixedT` | e.g. `4800` | — |
| `encoderBuckets` | — | `[80,200,400,800,1600,2400,4800]` |
| `encoderFunctionPrefix` | — | `predict_T` (default) |

Switching between packs is a Cloudflare `catalog.json` / `model_manifest.json`
change only — see `memory/features/tajweed/ios-dual-coreml-architecture-2026-07-30.md`.

Compute units: prefer `.cpuAndNeuralEngine` for the ANE package.

## Mel frontend (must match package training)

| Param | Value |
| --- | --- |
| Sample rate | 16_000 Hz mono |
| Pre-emphasis | 0.97 |
| Window | 25 ms Hann (512), hop 10 ms (160) |
| FFT | 512 |
| Mels | 80 (Slaney) |
| Log | `log(mel + 1e-5)` then per-bin mean/var normalize |

Lab reference: `tajweed-lab/web/asr/mel.py`. Validate against golden clips before
shipping UI.

## Pronunciation head

Pooled encoder features over aligned token intervals + token id → `prob_correct`.

Thresholds (match lab / ADR-006 token statuses):

| Status | Condition |
| --- | --- |
| `major` | prob &lt; 0.5 |
| `minor` | 0.5 ≤ prob &lt; 0.85 |
| `ok` | prob ≥ 0.85 |
| `miss` / `extra` | from lexical/CTC alignment, not head |

Always pair **offline ANE encoder ↔ offline head** (never streaming head).

## Audio capture

PCM float32 or int16, 16 kHz mono, via `AVAudioEngine`. No Flutter mic path.

## Golden vectors (lab)

Clips under `tajweed-lab/samples/` / demo WAVs:

1. `01_alafasy_fatihah`
2. `02_basfar_ikhlas`
3. Basmala (1:1)

Store expected greedy transcripts (diacritic-insensitive compare) in
`tajweed-lab/models/coreml/golden_transcripts.json` once measured.

## Flutter report

Identical to ADR-006 score JSON. Native never returns platform-specific keys.
