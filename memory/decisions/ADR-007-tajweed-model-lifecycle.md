# ADR-007 — Tajweed on-device model lifecycle
**Date:** 2026-07-28   **Status:** Accepted   **Feature:** tajweed (iOS CoreML + Android ONNX)

## Problem
The tajweed engines download large offline model packs (encoder, pronunciation
head, tokenizer) into the app sandbox. Without a single lifecycle contract,
iOS `ModelStore` and Android `ModelStore` will diverge on versioning,
verification, rollback, and cache policy — breaking Flutter's assumption that
`ensureModel` / `prepareModel` behave identically.

## Decision
Centralize model lifecycle in native `ModelStore` on each platform, driven by
a versioned **model manifest**. Flutter never downloads bytes directly; it
only calls `ensureModel` / `prepareModel` / `isAvailable` and listens to
`tajweed_events` for progress.

### Manifest (`model_manifest.json`)

Stored beside active artifacts under Application Support (iOS) /
app files dir (Android):

```json
{
  "version": "1.0.0",
  "encoder": "<relative filename or package name>",
  "pronunciationHead": "<relative filename>",
  "tokenizer": "tokenizer.model",
  "sha256": {
    "encoder": "<hex>",
    "pronunciationHead": "<hex>",
    "tokenizer": "<hex>"
  },
  "minimumAppVersion": "1.0.0"
}
```

Platform-specific encoder/head filenames differ (CoreML `.mlpackage` vs ONNX
`.onnx`); `version` and semantic roles stay aligned.

### Lifecycle steps

1. **Discover** — read local manifest; if missing or below required version → needs download.
2. **Download** — fetch into a staging directory; support resume; emit progress on EventChannel (`type: "downloadProgress"`, `progress: 0.0–1.0`).
3. **Retry** — on failure, retry up to **3** times with backoff; then fail with `MODEL_DOWNLOAD_FAILED`.
4. **Verify** — SHA-256 each artifact against manifest; on mismatch delete staging and fail (`MODEL_DOWNLOAD_FAILED`).
5. **Activate** — atomic swap staging → active; write manifest last.
6. **Rollback** — if activation/verify fails and a previous active pack exists, keep previous; never leave a half-active pack as current.
7. **Prepare** — warm-load from active pack (`prepareModel`); failures → `MODEL_LOAD_FAILED`.
8. **Unload** — on memory pressure / idle, unload sessions; **do not** delete verified files.
9. **Update** — future: compare remote/bundle catalog version to local; download new pack to staging; activate only after verify; delete previous pack after successful prepare.
10. **Deletion** — user/debug clear or failed-verify cleanup only; never delete the sole verified pack under memory pressure.

### Cache policy

- One **active** version on disk; optional keep previous until next successful prepare (rollback window).
- No cloud inference; downloads are asset delivery only.
- Audio / recordings are never part of the model cache.

### Benchmark targets (QA)

| Metric | Target |
| --- | --- |
| Warm model load | < 500 ms |
| Inference (typical short ayah) | < 2 s |
| Cold load | measure & record baseline per platform in Phases 2–3 |
| Peak memory (warm) | no OOM on mid-tier QA devices |

## Consequences
- Phases 2–3 implement the same lifecycle behind different runtimes.
- ADR-006 owns the Flutter MethodChannel surface; this ADR owns what
  `ModelStore` must guarantee underneath `ensureModel` / `prepareModel`.
- Manifest format is append-compatible: new fields may be added; existing
  keys must not be renamed without a new major `version`.
