# Setup

## Prerequisites

- Python 3.11+ (3.13 OK for lab deps we pin)
- ~1 GB free disk for the slim `web-asr` profile (more if you pull NeMo / all ONNX variants)
- Hugging Face account with **accepted access** to gated repos:
  - [Muno459/fastconformer-quran](https://huggingface.co/Muno459/fastconformer-quran)
  - Later: CoreML offline/streaming repos

## 1. Create env

```bash
cd tajweed-lab
./scripts/setup_env.sh
source .venv/bin/activate
```

## 2. Hugging Face token

1. Open the model page → accept access terms.  
2. Create a **read** token at https://huggingface.co/settings/tokens  
3. Put it in `tajweed-lab/.env` (never commit):

```
HF_TOKEN=hf_...
```

If a token was ever pasted into chat or a ticket, **revoke and recreate it**.

## 3. Download models

```bash
./scripts/download_model.py --profile web-asr
```

Profiles:

| Profile | Contents |
| --- | --- |
| `web-asr` | `model_with_encoder.onnx` (or q8), tokenizer, demos, `tajweed/` sources, pronunciation head |
| `web-asr-q8` | Prefer quantized ONNX when available |
| `full` | Everything (large — avoid on small disks) |

## 4. Run web tester

```bash
source .venv/bin/activate
uvicorn web.app:app --reload --host 127.0.0.1 --port 8765
```

Open http://127.0.0.1:8765

## 5. Sanity check

```bash
./scripts/smoke_transcribe.py
```

Should print diacritized Arabic for a demo wav under `samples/`.
