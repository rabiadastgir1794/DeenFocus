# Roadmap

## Phase 0 — Environment (this week)

- [x] Create `tajweed-lab` structure
- [x] Document model + architecture + features + ADRs
- [x] Authenticate + download slim ONNX kit
- [x] Run web UI on demo clips
- [ ] Rotate exposed HF token

## Phase 1 — Lab ASR (validate model)

- [ ] Reliable offline transcription in browser UI
- [ ] Expected-ayah picker (paste or surah:ayah)
- [ ] Side-by-side ASR vs reference + simple edit distance

## Phase 2 — Lab tajweed coaching

- [ ] Vendor `tajweed/` from HF
- [ ] Enable pronunciation head + GOP + consensus
- [ ] Surface 27-rule feedback in UI
- [ ] Collect failure cases (our voices / accents)

## Phase 3 — CoreML path

- [ ] Evaluate upstream `coreml-offline` accuracy/latency on device
- [ ] Evaluate streaming package if live feedback is required
- [ ] Port mel + CTC collapse + tokenizer usage to Swift
- [ ] Port or reimplement rule explanations for app locales

## Phase 4 — DeenFocus integration

- [ ] Flutter entry from Quran reader
- [ ] Airplane-mode QA
- [ ] Resolve NPL vs monetization (ADR-005) before release
- [ ] Attribution UX (“Quran-Lab / Muno459”)

## Non-goals (near term)

- Fine-tuning a new model
- Cloud-hosted scoring API
- Non-Hafs riwayat
