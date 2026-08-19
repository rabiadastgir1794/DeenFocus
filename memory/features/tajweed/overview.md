# Feature: Tajweed Coaching

## Purpose

Give DeenFocus Quran reader users a **fully offline** way to practice
recitation and get corrected when they read something wrong — an ASR +
mispronunciation-detection + tajweed-rule-explanation loop, running entirely
on-device (no network at inference time).

## Status
**Phase 5 (Flutter product UI) started 2026-07-29 per explicit instruction**,
overriding the prior FROZEN-for-UI gate below. Android production ONNX pack
(encoder + pronunciation head) is already validated end-to-end (Pixel_7 emulator,
3/3 golden clips exact-match) and Android's AI Asset Manager downloader is live
against real Cloudflare R2 — the new UI is real/usable on Android today via
Settings → "AI Tajweed Practice (Beta)". See `memory/current-state.md` "Flutter
Tajweed practice UI — Phase 5 started" for exactly what was built.

iOS CoreML real-weight inference is still blocked **solely** on Hugging Face
gated-download access (re-confirmed 2026-07-29: metadata/LICENSE access works,
`.mlpackage` weight blobs still 403), and iOS has no catalog provisioned yet, so
the new UI's download screen will not succeed there until both are resolved —
this is a data/access gap, not a UI gap. Mel preprocessing is already equivalent
across platforms (TD-009).

**Next action:** manual on-device QA of the new Android UI (see current-state.md),
then wait for HF CoreML download access to unblock iOS e2e inference, iOS/Android
parity comparison, physical-device QA, and final iOS benchmarks.

## Architecture

Three stages:

1. **Lab (done, Python)** — `tajweed-lab/web/app.py`: FastAPI server, ONNX
   Runtime ASR (`Muno459/fastconformer-quran`), surah/ayah picker over the
   app's own Quran JSON, mic record → transcribe → lexical compare.
2. **Shared Flutter contract (Phase 1, done)** — `TajweedService` + models +
   history store + `tajweed_enabled` flag; MethodChannel placeholders on iOS
   and Android. Contracts: ADR-006, ADR-007.
3. **Native engines (Phases 2–3, done) + UI (planned)** — iOS CoreML
   (`ios/Runner/Tajweed/`) and Android ONNX Runtime
   (`android/app/src/main/kotlin/com/app/deenly/deenly/tajweed/`) are
   symmetric module-for-module (AudioRecorder, MelFrontend, CTC decode/align,
   ASR model, pronunciation head, ModelStore, engine, channel handler).
   Remaining: parity validation (Phase 4A), full-screen practice UI
   (Phase 5). iOS detail: [`coreml-ios-integration-plan.md`](coreml-ios-integration-plan.md).

See `memory/project/architecture.md` for how both pieces fit into the wider
repo, and `tajweed-lab/docs/ARCHITECTURE.md` for the lab's own internal detail.

## Key design decisions (do NOT change without re-reading the ADR)

- **Ship upstream CoreML, don't DIY-convert ONNX→CoreML.** A naive
  full-attention fp16 export on ANE produces empty transcripts on some clips
  (e.g. the Basmala) — this is architectural, not a tuning problem. See
  `tajweed-lab/decisions/ADR-004-coreml-path.md` and Phase A of the
  integration plan.
- **Record-then-score for v1, not live streaming.** Simpler audio session,
  better accuracy, matches the lab UX already validated.
- **Compare against the app's own canonical ayah text**
  (`assets/raw/quran_paak.json`, loaded via `QuranLocalRepository` /
  `tajweed-lab/web/quran_data.py`), not free-form ASR alone. ASR is acoustic
  evidence; the reference text is the source of truth for what's expected.
- **License is NPL-1.0 (no-profit).** This feature cannot be gated behind a
  paywall. See `memory/known-risks.md` RISK-001.

## Dependencies

- Model: `Muno459/fastconformer-quran` (gated on Hugging Face) + its CoreML
  siblings (`fastconformer-quran-coreml-offline`).
- `tajweed-lab/vendor/tajweed/` — upstream scoring package (aligner, GOP,
  pronunciation head loader, 27-rule engine). Vendored source only; not yet
  called from `web/app.py` (see `memory/technical-debt.md` TD-001).
- Existing DeenFocus Quran data layer (`QuranLocalRepository`,
  `assets/raw/quran_paak.json`) as the reference-text source.

## Known issues

See `memory/technical-debt.md` (TD-001, TD-002) and `memory/known-risks.md`
(RISK-001, RISK-002, RISK-003) for everything currently open in this feature area.

## Roadmap

`tajweed-lab/docs/ROADMAP.md` has the lab-side phase breakdown.
[`coreml-ios-integration-plan.md`](coreml-ios-integration-plan.md) has the
iOS-side phase breakdown (A–F). Both are living documents — update their
checkboxes/status as work lands, don't let them go stale.
