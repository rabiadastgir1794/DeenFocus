# Progress log

## 2026-07-24

- Inspected [`Muno459/fastconformer-quran`](https://huggingface.co/Muno459/fastconformer-quran): NeMo FastConformer CTC, ONNX exports, pronunciation head, `tajweed/` package, gated + NPL-1.0.
- Noted official CoreML repos: `fastconformer-quran-coreml-offline` and `…-coreml-streaming`.
- Created `tajweed-lab/` workspace (docs, decisions, web, scripts).
- Added HF token to `tajweed-lab/.env` (gitignored); extended root `.gitignore`.
- Scaffolded local FastAPI web tester modeled on the public demo Space (mel → ONNX → CTC decode).
- Downloaded `web-asr` profile successfully (ONNX encoder+CTC, tokenizer, pronunciation head, tajweed sources, 3 demos).
- Smoke transcription OK: `01_alafasy_fatihah.wav` → `مَالِكِ يَوْمِ الدِّينِ` (4.68s).
- Web lab UI available via FastAPI (`web/app.py` + `web/static/index.html`).
- Practice UX: surah + ayah dropdowns (from `quran_paak.json`), show reference ayah, mic record, expected-vs-heard word compare.
