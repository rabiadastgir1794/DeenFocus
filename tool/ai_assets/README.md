# AI Asset Manager release tooling (ADR-009)

Generates the two JSON files an AI Asset Manager release needs — a per-asset
`model_manifest.json` and the shared `catalog.json` — without a human ever
hand-typing a SHA-256 hash or a file size. Both scripts are asset-kind-agnostic:
they don't know or care whether they're describing a Tajweed model pack, a Qari
audio pack, a translation pack, or a tafsir pack. Full design/rationale:
`memory/decisions/ADR-009-ai-asset-manager.md`.

Stdlib-only (`argparse`, `hashlib`, `json`, `pathlib`, `datetime`) — no venv or
extra dependencies needed, unlike `tajweed-lab/`.

## Release workflow

```bash
# 1. Stage the new version's artifacts locally, e.g.:
#      /tmp/release/tajweed/packs/hafs-en-v1/1.0.0/android/model_with_encoder.onnx
#      /tmp/release/tajweed/packs/hafs-en-v1/1.0.0/android/pronunciation_head.onnx
#      /tmp/release/tajweed/packs/hafs-en-v1/1.0.0/android/tokenizer.model
#      /tmp/release/tajweed/packs/hafs-en-v1/1.0.0/android/tokens.txt

# 2. Generate that platform's model_manifest.json (repeat per platform).
python3 tool/ai_assets/generate_manifest.py \
  --spec tool/ai_assets/specs/hafs-en-v1-1.0.0-android.example.json \
  --out /tmp/release/tajweed/packs/hafs-en-v1/1.0.0/android/model_manifest.json

# 3. Upload artifacts + the manifest to Cloudflare R2 (bucket
#    `deenfocus-ai-assets`, public host pub-…r2.dev):
./tool/ai_assets/upload_to_r2.sh \
  translations/en-saheeh/1.0.0 \
  tool/ai_assets/staging/quran-translation-en/1.0.0

# 4. Merge the new pack into the live catalog.json and upload LAST
#    (ADR-009 atomic go-live). Tajweed / other packs are preserved.
python3 tool/ai_assets/merge_catalog.py \
  --add tool/ai_assets/specs/catalog-pack-quran-translation-en.json \
  --out /tmp/release/catalog.json \
  --upload
```

### Adding another translation language (no app code change)

1. Stage JSON under `tool/ai_assets/staging/quran-translation-<lang>/<version>/translation.json`
2. Copy/adapt `specs/quran-translation-en-1.0.0.json` → generate manifest
3. Copy/adapt `specs/catalog-pack-quran-translation-en.json` (set `language`, `packId`, URLs, size)
4. Upload staging dir + merge catalog:

```bash
./tool/ai_assets/upload_to_r2.sh translations/<slug>/<version> tool/ai_assets/staging/...
python3 tool/ai_assets/merge_catalog.py --add tool/ai_assets/specs/catalog-pack-….json \
  --out /tmp/release/catalog.json --upload
```

## Files

- `generate_manifest.py` — one asset's `model_manifest.json` / `manifest.json`.
  Spec = friendly name → local filename map + pass-through metadata
  (`version`, `packId`, `kind`, `artifactBaseUrl`, `minimumAppVersion`, plus
  any `extra` fields). Computes SHA-256 for every named file.
- `generate_catalog.py` — rebuild the shared `catalog.json` from a full spec.
  Validates required fields (`packId`, `latestVersion`, `manifestUrl`), rejects
  duplicate `packId`s, stamps `updatedAt`, and can auto-compute
  `approxSizeBytes` from a local directory instead of a hand-typed number.
- `merge_catalog.py` — fetch live catalog, upsert pack entries by `packId`,
  optionally upload `catalog.json` (preferred for additive releases).
- `upload_to_r2.sh` — wrangler upload of a file or directory to
  `deenfocus-ai-assets` with ADR-009 Cache-Control conventions.
- `specs/*.example.json` — copy one of these per real release; don't edit the
  `.example.json` files in place (keep them as living documentation of the
  expected shape).
- `specs/catalog-pack-*.json` — single-pack snippets for `merge_catalog.py`.
- `staging/` — local release staging (not required in git; regenerate via
  `generate_manifest.py` before upload).

## iOS `.mlpackage` bundles are directories, not single files (resolved 2026-07-30)

`generate_manifest.py` still hashes each named entry as one regular file, but
iOS Core ML packs (e.g. `diy-fastconformer-encoder.mlpackage`,
`diy-pronunciation-head.mlpackage`) are actually **directories** containing
several files (`Manifest.json`, `Data/com.apple.CoreML/model.mlmodel`,
`Data/com.apple.CoreML/weights/weight.bin`). Resolved via option (b) from the
original note here: `ios/Runner/Tajweed/TajweedAssetSync.swift`'s
`fileSpecs()` supports an opt-in `"<name>Files"` manifest array (e.g.
`"encoderFiles": ["Manifest.json", "Data/com.apple.CoreML/model.mlmodel",
"Data/com.apple.CoreML/weights/weight.bin"]`) that expands one named artifact
into N downloaded member files with nested `relativePath`s — no changes
needed to the generic `AssetDownloadManager` (already nested-path-aware) or to
`ModelStore.verifySHA` (already hashes `weight.bin` inside a directory
artifact). This tool (`generate_manifest.py`) does not yet auto-populate
`"<name>Files"` or hash `weight.bin` specifically for directory-shaped named
entries — the first real iOS release manifest was hand-written instead (see
`memory/features/tajweed/ios-asset-distribution-migration-2026-07-30.md`).
Extending `generate_manifest.py` to detect directory entries and emit this
shape automatically is still a nice-to-have, not a blocker.
