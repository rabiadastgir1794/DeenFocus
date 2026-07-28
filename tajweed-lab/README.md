# Tajweed Lab

Isolated research + prototype workspace for **offline Quran tajweed coaching** in DeenFocus.

This folder is intentionally separate from the Flutter app (`lib/`). Nothing here ships in the iOS build until we explicitly integrate a CoreML package.

## Goal

Give Quran reader users an **on-device** facility to:

1. Recite an ayah (mic / uploaded audio)
2. See what the model heard (diacritized Arabic ASR)
3. Get **mispronunciation flags** + **tajweed rule feedback** when something is wrong
4. Later: ship the same capability inside DeenFocus iOS via CoreML (Neural Engine)

## Upstream model

| Item | Value |
| --- | --- |
| Primary repo | [`Muno459/fastconformer-quran`](https://huggingface.co/Muno459/fastconformer-quran) |
| Task | Quranic ASR (Hafs) + mispronunciation detection + tajweed rules |
| Stack | NVIDIA NeMo FastConformer CTC → ONNX / CoreML |
| License | **Quran-Lab NPL-1.0 (no-profit)** — see [ADR-005](decisions/ADR-005-license-npl.md) |
| Access | **Gated** — you must accept terms on HF and authenticate |

Related repos we will use later:

- [`fastconformer-quran-coreml-offline`](https://huggingface.co/Muno459/fastconformer-quran-coreml-offline) — record-then-score on iPhone
- [`fastconformer-quran-coreml-streaming`](https://huggingface.co/Muno459/fastconformer-quran-coreml-streaming) — live/streaming path
- Demo Space: [`Muno459/fastconformer-quran-demo`](https://huggingface.co/spaces/Muno459/fastconformer-quran-demo)

## Quick start

```bash
cd tajweed-lab

# 1) Python env
./scripts/setup_env.sh

# 2) Request access on HF, then set a read token
export HF_TOKEN=hf_...   # or: huggingface-cli login

# 3) Download the slim offline kit (~450–500 MB, not the full 4+ GB repo)
./scripts/download_model.py --profile web-asr

# 4) Run the local web tester
source .venv/bin/activate
uvicorn web.app:app --reload --port 8765
# open http://127.0.0.1:8765
```

## Layout

```
tajweed-lab/
  README.md                 ← you are here
  docs/                     ← understanding, features, state, roadmap
  decisions/                ← architecture decision records (ADRs)
  web/                      ← local FastAPI + browser UI for testing
  scripts/                  ← env + download helpers
  models/                   ← downloaded weights (gitignored)
  vendor/                   ← vendored tajweed Python package from HF (gitignored)
  samples/                  ← demo wavs once downloaded
```

## Docs map

| Doc | Purpose |
| --- | --- |
| [docs/MODEL.md](docs/MODEL.md) | What the HF model is and how it works |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | How we wire ASR → scoring → UI → iOS |
| [docs/FEATURES.md](docs/FEATURES.md) | Product feature breakdown |
| [docs/CURRENT_STATE.md](docs/CURRENT_STATE.md) | What exists / what's blocked right now |
| [docs/PROGRESS.md](docs/PROGRESS.md) | Chronological progress log |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Phased plan to CoreML in DeenFocus |
| [docs/SETUP.md](docs/SETUP.md) | Environment + access setup |

## Status

See [docs/CURRENT_STATE.md](docs/CURRENT_STATE.md). **Blocked on Hugging Face gated access + `HF_TOKEN`** before weights can be downloaded.
