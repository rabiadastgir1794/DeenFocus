# DIY CoreML encoder — post-training optimization comparison (2026-07-30)

> Lab-only. Does **not** replace `artifacts/encoder.mlpackage`, the R2-hosted
> production candidate, or any iOS/Android inference code. Architecture
> unchanged (full-attention FastConformer, fixed `(1,80,4800)` + explicit `length`).

## TL;DR / recommendation

| Question | Answer |
|---|---|
| Best accuracy-safe size win? | **8-bit k-means palettization** (`palette_8bit`) |
| Close runner-up? | **INT8 linear weight quantization** (`linear_int8`) — nearly identical |
| Safe to ship to R2 today? | **No** — host-only; confirm on a real iPhone first |
| Replace current FP32 candidate? | **Not yet** — this report only ranks candidates |

**Recommended strategy:** apply `coremltools.optimize.coreml.palettize_weights`
(`mode=kmeans`, `nbits=8`) to a *copy* of the current FP32 DIY encoder, validate
on-device, then (only after approval) publish as a new immutable R2 version.
`linear_int8` is an equally viable alternative if palettization tooling is
undesirable (~3 MB larger, similar accuracy/latency).

**Do not use:** FP16 compute conversion (NaN), 50% magnitude pruning (empty
transcripts), 4-bit palettization (broken transcripts), or INT4 linear quant
on the current iOS16-targeted package (requires iOS 18 re-convert).

## Method

- **Baseline:** existing FP32 DIY encoder (`artifacts/encoder.mlpackage`, 587.2 MB).
  Copied to `artifacts/optimization/baseline_fp32/`; never overwritten.
- **Host runtime:** `coremltools` 9.0, `ComputeUnit.CPU_AND_GPU` (same constraint as
  prior DIY e2e — `ALL` fails to build a plan for this graph).
- **Pronunciation head:** unchanged existing `pronunciation_head.mlpackage`
  (isolates encoder effects).
- **Golden clips:** `01_alafasy_fatihah.wav`, `02_basfar_ikhlas.wav`,
  `03_alafasy_naba.wav`.
- **Harness:** `experiments/diy_coreml_poc/evaluate_encoder_optimizations.py`
- **Raw data:** `experiments/diy_coreml_poc/reports/encoder_optimization_comparison.json`

“CoreML weight compression” here means **magnitude pruning → sparse weight
storage** (`prune_weights`), i.e. Apple’s third weight-compression pillar
alongside quantization and palettization.

## Results summary

| Technique | Variant | Size | vs FP32 | Exact transcripts | Mean \|Δpron\| vs FP32 | Status mismatches | Mean host infer | Pipeline compatible? |
|---|---|---:|---:|:---:|---:|---:|---:|---|
| Baseline (FP32) | `baseline_fp32` | **587.2 MB** | 100% | **3/3** | 0 | 0/44 | ~1.0–2.1 s* | yes (current candidate) |
| FP16 weight/compute convert | `fp16_compute` | 294.3 MB | 50% | 0/0 (all NaN) | — | — | ~1.4 s | **no** |
| Weight compression (prune 50%) | `prune_sparsity_50` | 239.6 MB | 41% | **0/3** (empty hyp) | 0.098 | 10/44 | ~1.7 s | partial |
| Palettization 8-bit | `palette_8bit` | **146.0 MB** | **25%** | **3/3** | **0.0034** | **0/44** | **~0.77 s** | **yes** |
| Palettization 4-bit | `palette_4bit` | 74.1 MB | 13% | **0/3** (corrupt) | 0.019 | 0/44 | ~0.59 s | partial |
| Linear quant INT8 | `linear_int8` | **149.3 MB** | **25%** | **3/3** | **0.0036** | **0/44** | **~0.81 s** | **yes** |
| Linear quant INT4 | `linear_int4` | — | — | — | — | — | — | **build fail** (needs iOS 18) |

\*Host inference times vary across runs (cache/thermal). Relative ordering within
a single eval pass is more trustworthy than absolute ms.

## Per-technique evaluation

### 1. FP16 weight conversion

**What was done:** fresh `ct.convert(..., compute_precision=FLOAT16)` of the same
ONNX→torch.jit.trace graph into `artifacts/optimization/fp16_compute/` (does not
touch the FP32 production package).

| Metric | Result |
|---|---|
| Size | 294.3 MB (50% of FP32) |
| Pipeline compatibility | **No** — loads, but all logprobs are NaN/Inf |
| Transcription | Unusable (3/3 non-finite) |
| Pronunciation scoring | Cannot run (no finite encoder features) |
| Host latency | ~1.4 s mean (irrelevant given NaNs) |

**Verdict:** Rejected. Confirms the earlier DIY POC finding on this full-attention
graph: FP16 *compute* conversion overflows. Size win is useless.

### 2. CoreML weight compression (magnitude pruning)

**What was done:** `prune_weights` with `OpMagnitudePrunerConfig(target_sparsity=0.5)`
on the FP32 package (sparse storage).

| Metric | Result |
|---|---|
| Size | 239.6 MB (41% of FP32) |
| Pipeline compatibility | Partial — loads and runs; same I/O |
| Transcription | **0/3 exact**; hypothesis empty on all goldens |
| Pronunciation scoring | Mean \|Δprob\|=0.098 vs FP32; **10/44 status mismatches** |
| Host latency | ~1.7 s (no win vs FP32) |

**Verdict:** Rejected. Aggressive unstructured prune destroys CTC decoding on this
model. Milder sparsity was not needed once INT8/palette-8 already hit ~75% size
reduction with perfect transcripts.

### 3. CoreML palettization

**What was done:** `palettize_weights` with `OpPalettizerConfig(mode=kmeans, nbits=…)`.

#### 8-bit (recommended)

| Metric | Result |
|---|---|
| Size | **146.0 MB (25% of FP32)** |
| Pipeline compatibility | **Yes** — same single-function fixed-T I/O; no Swift changes |
| Transcription | **3/3 exact** match vs expected (same as Android goldens) |
| Pronunciation scoring | Mean \|Δprob\|=0.0034, max=0.105; **0 status mismatches** |
| Host latency | **~774 ms mean** (faster than FP32 in this pass) |

#### 4-bit

| Metric | Result |
|---|---|
| Size | 74.1 MB (13% of FP32) |
| Pipeline compatibility | Partial — loads; transcripts wrong |
| Transcription | **0/3 exact** (e.g. `مَالِكِْمِ الدِّينِ`, missing words) |
| Pronunciation scoring | Mean \|Δprob\|=0.019; statuses happen to match forced-align path but on wrong hyp |
| Host latency | ~594 ms |

**Verdict:** **8-bit palettization accepted as best strategy.** 4-bit rejected for
accuracy.

### 4. Linear quantization

**What was done:** `linear_quantize_weights` with
`OpLinearQuantizerConfig(mode=linear_symmetric, dtype=…)`.

#### INT8 (strong runner-up)

| Metric | Result |
|---|---|
| Size | **149.3 MB (25% of FP32)** |
| Pipeline compatibility | **Yes** — same I/O; no Swift changes |
| Transcription | **3/3 exact** |
| Pronunciation scoring | Mean \|Δprob\|=0.0036, max=0.103; **0 status mismatches** |
| Host latency | **~810 ms mean** |

#### INT4

| Metric | Result |
|---|---|
| Size | n/a |
| Build | **Failed:** “4-bit quantization is supported since iOS18” — current package was converted with `minimum_deployment_target=iOS16` |
| Pipeline note | Would raise the app’s CoreML floor to iOS 18 if pursued |

**Verdict:** INT8 accepted as near-equivalent alternative to palette-8. INT4 not
measured on this package without an iOS18 re-convert (out of scope for “no
architecture / no production replace”; flagged as future work if iOS 18+ is
acceptable).

## Compatibility with the current iOS inference pipeline

For **`palette_8bit`** and **`linear_int8`**:

- Still a single-function CoreML program with `audio_signal` `(1,80,4800)` +
  `length` + `logprobs` / `encoder_output`.
- Existing manifest fields (`encoderApi=single_function_fixed`, `encoderFixedT=4800`)
  still apply.
- `OfflineAsrModel` / `ModelStore` / scoring path need **no code changes**.
- Only distribution artifacts would change (new `.mlpackage` + new SHA-256 in
  `model_manifest.json`) if/when promoted.

Rejected variants either fail to produce finite tensors (FP16) or change
observable scoring behavior enough to break Tajweed feedback (prune / palette-4).

## Expected runtime performance

| | FP32 baseline | palette_8bit | linear_int8 |
|---|---:|---:|---:|
| On-disk encoder | 587 MB | 146 MB | 149 MB |
| Host cold load | ~1.4–3.7 s | ~3.4 s | ~2.5 s |
| Host mean infer (3 goldens) | ~1.0–2.1 s | ~0.77 s | ~0.81 s |
| Download time @ ~6 MB/s | ~98 s | ~24 s | ~25 s |

Caveats:

1. All variants still execute a **fixed 48s graph** — short clips pay full cost.
2. Host `CPU_AND_GPU` ≠ iPhone ANE/GPU scheduling. On-device Instruments timing is
   still required before calling latency “acceptable.”
3. Cold-load can be dominated by compile/weight unpack; first-inference numbers on
   device may differ.

## Recommendation (actionable)

1. **Keep** the current FP32 package as the production R2 candidate for now.
2. **Treat `palette_8bit` as the preferred optimization** to promote next (or
   `linear_int8` if you prefer a simpler, non-kmeans pipeline).
3. Before promoting: run the existing `TajweedDebugRunner` / practice flow on a
   real iPhone with the palettized pack side-loaded via `TajweedImport`, measure
   cold/warm/infer, and confirm Neural Engine vs CPU/GPU.
4. If on-device checks pass: publish as a **new** immutable version under
   `ios/tajweed/v1.1.0/` (do not overwrite `v1`), update `catalog.json` last.

## Artifacts (gitignored under `artifacts/optimization/`)

```
baseline_fp32/encoder.mlpackage     587 MB
fp16_compute/encoder.mlpackage      294 MB   (NaN — do not use)
prune_sparsity_50/encoder.mlpackage 240 MB   (broken transcripts)
palette_8bit/encoder.mlpackage      146 MB   ← recommended
palette_4bit/encoder.mlpackage       74 MB   (broken transcripts)
linear_int8/encoder.mlpackage       149 MB   ← runner-up
```

Production `artifacts/encoder.mlpackage` and R2 `ios/tajweed/v1/` were **not**
modified.
