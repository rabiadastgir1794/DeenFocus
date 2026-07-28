# Model understanding — Muno459/fastconformer-quran

Source: [huggingface.co/Muno459/fastconformer-quran](https://huggingface.co/Muno459/fastconformer-quran)

## What it is

A **Quranic automatic speech recognition (ASR)** model specialized for **Hafs** recitation, with a **multi-signal mispronunciation detector** and a **pure-Python tajweed rule engine** on top.

It is **not** a general Arabic ASR. It expects Quranic recitation and emits **diacritized** (harakat) Arabic text.

| Field | Value |
| --- | --- |
| Base | `nvidia/stt_ar_fastconformer_hybrid_large_pcd_v1.0` |
| Architecture | FastConformer Large + **CTC** head |
| Library | NVIDIA NeMo (+ ONNX / CoreML exports) |
| Vocab | SentencePiece BPE, 1024 tokens + blank id `1024` |
| Audio | 16 kHz mono → 80-bin log-mel (25 ms / 10 ms hop) |
| License | Quran-Lab **NPL-1.0** (no-profit) — gated repo |
| Held-out WER | ~0.93% (unseen reciters), ~4.13% overall Quran benchmark |

## Repo layout (upstream)

| Path | Role | Approx size |
| --- | --- | --- |
| `nemo/fastconformer-quran.nemo` | Full NeMo checkpoint | ~459 MB |
| `onnx/model.onnx` | CTC-only ONNX fp32 | ~437 MB |
| `onnx/model.fp16.onnx` | CTC-only ONNX fp16 | ~219 MB |
| `onnx/model.q8.onnx` | CTC-only quantized | smaller |
| `onnx/model_with_encoder.onnx` | CTC + `encoder_output` (needed for pronunciation head) | ~437 MB |
| `onnx/model_with_encoder.q8.onnx` | Same, quantized | smaller |
| `head/pronunciation_head.pt` | Per-token P(correct) MLP (~1.33M params) | ~5.4 MB |
| `tajweed/*.py` | Aligner, GOP, head scorer, 27-rule engine, full scorer | small |
| `tokenizer.model` / `tokens.txt` | SentencePiece + id map | small |
| `demo/*.wav` | Sample recitations | small |

## Inference pipeline (what we run locally)

```
mic/file (wav)
  → resample 16 kHz mono
  → log-mel filterbank (80 × T)
  → ONNX FastConformer
       ├─ logprobs (T/8 × 1025)  → greedy CTC collapse → diacritized text
       └─ encoder_output (512-d × frames)  → optional pronunciation scoring
```

Official demo Space uses **`onnx/model_with_encoder.onnx`** + greedy CTC decode (deterministic, no LM). That is our Phase-1 web tester path.

## Mispronunciation detection (3 signals)

Consensus: flag a token when **≥ 2 of 3** agree (defaults):

| Signal | Meaning | Default threshold |
| --- | --- | --- |
| Pronunciation head | Learned P(token correct) from pooled encoder features | head &lt; 0.5 |
| Reference-anchor | Cosine distance to master-qari centroid bank | distance &gt; 0.20 |
| CTC GOP | log P(expected) − max log P(non-blank) over aligned frames | GOP &lt; −3.0 |

Held-out: ~80% true positive / ~9% false positive at the deployable operating point.

Code entrypoint upstream: `tajweed/full_scorer.py`.

## Tajweed rule engine (Stage 6)

Pure Python over expected diacritized text + alignment. **27 rules**, including:

- Noon / meem sakinah families  
- Madd typology  
- Qalqalah (sughra / kubra)  
- Ra tafkheem / tarqeeq  
- Allah lafdh, lam shamsiyyah, hamzat wasl  
- Idgham types, leen letters, …

This is the teaching layer: not only “wrong sound,” but **which tajweed rule** applies.

## Path to iOS (already exists upstream)

We do **not** need to invent CoreML from scratch:

| Repo | Use |
| --- | --- |
| [`fastconformer-quran-coreml-offline`](https://huggingface.co/Muno459/fastconformer-quran-coreml-offline) | Record-then-score (best accuracy tradeoff on ANE) |
| [`fastconformer-quran-coreml-streaming`](https://huggingface.co/Muno459/fastconformer-quran-coreml-streaming) | Live ASR + live head scoring |

Offline CoreML uses windowed attention for ANE/fp16 stability; streaming uses cache-aware limited context. Pronunciation quality stays strong even when ASR WER rises slightly in streaming.

## Implications for DeenFocus

1. **Offline**: ship CoreML + tokenizer + (later) Swift port of aligner / rules — no network at inference time.  
2. **Reference text**: for coaching, always compare against the **canonical ayah** from our local Quran JSON, not only free ASR.  
3. **License**: NPL-1.0 forbids using the model (or derivatives) for profit — see ADR-005 before product packaging.  
4. **Scope**: Hafs only; general Arabic / other riwayat are out of scope.
