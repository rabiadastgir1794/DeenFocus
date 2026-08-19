# AI Readiness Report — Tajweed (post Phase 4A / pre–Flutter UI)

Date: 2026-07-29 · Branch: `feature/Quran` (uncommitted)

This report closes the AI-model blockers that were required **before** Flutter
Tajweed UI work. Flutter API / MethodChannel / JSON schema were **not** changed.

## Verdict

**Android ONNX production pipeline is ready for UI integration** (encoder +
pronunciation head + tokenizer, verified on emulator with golden clips).

**iOS CoreML production inference is still blocked** on Hugging Face gated-file
download access (metadata works; weight blobs still 403). Mel preprocessing
parity (TD-009) is already fixed. Do not treat iOS as production-ready until
real CoreML weights are installed and the same golden clips are scored on device.

**Recommendation:** proceed to Flutter full-screen UI only if you accept that
iOS will ship behind the same feature flag and show `MODEL_MISSING` until the
HF gate is opened; otherwise pause UI until CoreML packs are validated.

---

## 1. TD-010 — Pronunciation head PyTorch → ONNX (RESOLVED)

| Item | Detail |
| --- | --- |
| Source | `tajweed-lab/models/head/pronunciation_head.pt` |
| Export script | `tajweed-lab/scripts/export_pronunciation_head_onnx.py` |
| Output | `tajweed-lab/models/onnx/pronunciation_head.onnx` (~5.4 MB, self-contained) |
| I/O | `enc_feature` float32 `[B,512]` + `token_id` int64 `[B]` → `prob_correct` float32 `[B]` |
| Feature table | Baked into ONNX as Embedding (mobile needs no third input) |
| ORT vs PyTorch | max\|Δ\| ≈ 5.9e-8 on smoke input |

Android integration:
- `PronunciationHeadModel.kt` now feeds **int64** token ids (matches export)
- `OnnxAsrModel.kt` **transposes** `encoder_output` from ONNX `(512,T)` → time-major `(T,512)`
- `TajweedEngine.score` no longer pad-to-buckets for ONNX (dynamic T; padding caused trailing CTC junk)
- `ModelStore` uses external files dir + in-place rename activation (avoids doubling 458 MB on emulators)
- `TajweedDebugRunner.kt` + `TajweedOnDeviceParityTest` for device/emulator QA

---

## 2. End-to-end production-model results

### Host Python (same ONNX pack Android uses)

Script: `tajweed-lab/scripts/parity_dump_onnx_e2e.py`  
Artifact: `memory/features/tajweed/phase4a-artifacts/onnx_e2e_scores.json`

| Sample | Exact match | Word acc | Inference |
| --- | --- | --- | --- |
| 01_alafasy_fatihah | ✅ | 1.0 | ~78 ms |
| 02_basfar_ikhlas | ✅ | 1.0 | ~51 ms |
| 03_alafasy_naba | ✅ | 1.0 | ~64 ms |

Cold encoder load (host): ~790–890 ms · Head cold load: ~6–8 ms

### Android emulator (Pixel_7 AVD, `sdk_gphone64_arm64`)

Artifact: `memory/features/tajweed/phase4a-artifacts/tajweed_parity_android.json`

| Sample | Exact match | Word acc | Warm load | Inference |
| --- | --- | --- | --- | --- |
| 01_alafasy_fatihah | ✅ | 1.0 | ~1192 ms | ~275 ms |
| 02_basfar_ikhlas | ✅ | 1.0 | ~1006 ms* | ~130 ms |
| 03_alafasy_naba | ✅ | 1.0 | (reuse) | ~157 ms |

\*First sample pays cold→warm session creation; later samples reuse loaded models.

`ensureModel` install/verify (SHA-256 + rename activate): ~900–1100 ms  
ADR-006 JSON keys only (`ref`, `expected`, `hypothesis`, `durationSec`, `wordAccuracy`, `exactMatch`, `tokens`).

### iOS CoreML (real weights)

**Not run.** `download_coreml_offline.py` still 403s on `.mlpackage` blobs despite
`model_info` / LICENSE succeeding. Unblock: HF account must be on the gate’s
**download** allow-list for `Muno459/fastconformer-quran-coreml-offline`.

Mel preprocessing (TD-009) already matches Android/Python (corr ≥ 0.9998).

---

## 3. Real-device validation

| Target | Status |
| --- | --- |
| Android emulator (Pixel_7) | ✅ Full e2e with production ONNX pack |
| Physical Android | ❌ None attached (`adb devices` empty) |
| Physical iPhone | ⚠️ “Rabia Dastgir's iPhone” visible wirelessly, but no CoreML weights → cannot validate inference |
| iOS Simulator | Mel parity only (no CoreML pack) |

---

## 4. Benchmarks (ADR-007 targets: warm &lt;500 ms, inference &lt;2 s)

| Metric | Host Python | Android emulator | iOS device |
| --- | --- | --- | --- |
| Cold model load | encoder ~850 ms + head ~8 ms | ensureModel ~1 s; first warm path ~1.2 s | **N/A** |
| Warm model reuse | session already hot | subsequent warmOrReuse ~0.3–1 ms after first | **N/A** |
| Inference (≈4 s clip) | 50–80 ms | 130–275 ms | **N/A** |
| Peak memory | not instrumented | not instrumented (emulator disk was the constraint) | **N/A** |
| CPU usage | not instrumented | not instrumented | **N/A** |

Inference is well under the 2 s target on Android emulator. First warm path after
install is above 500 ms on the emulator (model mmap / ORT session create); later
calls are fine. Physical-device numbers still needed for NNAPI/thermal realism.

---

## 5. Remaining blockers before calling AI “fully ready”

1. **HF CoreML download access** — required for iOS production validation and
   cross-platform score/confidence parity.
2. **Physical Android + iPhone** — run the same golden pack once on real hardware;
   collect peak memory / CPU.
3. **Optional:** instrument peak RSS / CPU in `TajweedDebugRunner` on both platforms.

---

## 6. Files touched this session (no Flutter API / channel / JSON schema changes)

**New**
- `tajweed-lab/scripts/export_pronunciation_head_onnx.py`
- `tajweed-lab/scripts/parity_dump_onnx_e2e.py`
- `android/.../tajweed/TajweedDebugRunner.kt`
- `android/.../androidTest/.../TajweedOnDeviceParityTest.kt`
- `memory/features/tajweed/ai-readiness-report.md` (this file)
- artifacts under `memory/features/tajweed/phase4a-artifacts/`

**Modified**
- `android/.../PronunciationHeadModel.kt` (int64 token ids)
- `android/.../OnnxAsrModel.kt` (encoder transpose)
- `android/.../TajweedEngine.kt` (no mel bucket pad for ONNX)
- `android/.../ModelStore.kt` (external dir + rename activate)
- `android/app/build.gradle.kts` (androidTest runner/deps)

---

## 7. Stop gate

Per instructions: **do not start Flutter Tajweed UI** until you explicitly approve
proceeding given the iOS CoreML gap above.

## 8. Re-check (2026-07-29, same day, follow-up instruction)

Reviewer approved the Android AI pipeline and asked for iOS production validation
(steps 1–5: CoreML weights, e2e pipeline, cross-platform parity, physical iPhone,
final benchmarks), with an explicit fallback: if HF access is the only remaining
blocker, stop and mark the engine **"Implementation Complete – Pending Production
Model Validation."**

Re-ran `tajweed-lab/scripts/download_coreml_offline.py` to check for account access
changes: **still `403 Client Error`** on `Manifest.json` and both `.mlpackage`
weight blobs for `Muno459/fastconformer-quran-coreml-offline` (metadata/`LICENSE`
access unchanged/working). No other blocker exists — Android is approved, iOS mel
parity (TD-009) is fixed, all native code/ADRs/Flutter contracts are unchanged and
complete on both platforms.

**Verdict: AI engine status = "Implementation Complete – Pending Production Model
Validation."** Steps 1–5 above are all downstream of this single gate and cannot
proceed until it's opened. No code was changed this pass. Stopping here per
instruction; will resume iOS production validation as soon as HF grants download
access to the gated repo.
