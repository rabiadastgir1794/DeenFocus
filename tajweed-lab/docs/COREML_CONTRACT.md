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

`predict_T80` … `predict_T4800` (padded mel length T = 80…4800 ≈ 0.8 s … 48 s).

| | Shape / value |
| --- | --- |
| Input `audio_signal` / mel | `(1, 80, T)` float |
| Output `logprobs` | `(1, T/8, 1025)` |
| Output `encoder_output` | encoder frames, 512-d |
| CTC blank id | **1024** |
| Frame hop (post-subsample) | **80 ms** (T/8 frames) |

Pad mel time `T` up to the nearest supported bucket. Reject audio that would
need T > 4800 (`AUDIO_TOO_LONG` / `ayah_too_long`).

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
