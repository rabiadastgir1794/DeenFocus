# Investigation: Can `fastconformer-quran.nemo` replace the HF CoreML dependency?

**Date:** 2026-07-30  
**Scope:** Evidence only. No production code, Flutter/Swift/Kotlin, or production model assets modified.  
**Checkpoint examined:** `/Users/rabiadastgir/Downloads/fastconformer-quran.nemo` (438 MB, POSIX tar)  
**Scratch workspace:** `tajweed-lab/experiments/nemo_coreml_investigation/` (extract + isolated `.venv-nemo`; not wired into the app)

---

## Verdict

**No — this `.nemo` cannot, by itself, generate the production iOS CoreML encoder that replaces the Hugging Face CoreML dependency with Android parity.**

| Question | Answer |
| --- | --- |
| Same architecture family as Android ONNX / tokenizer / dims? | **Yes** (strong evidence) |
| Same weights family as production **ANE** CoreML? | **No** — ANE pack is a different fine-tune |
| Does NeMo export CoreML directly? | **No** — NeMo exports ONNX / TensorRT / vLLM only |
| Can a stock convert of *this* `.nemo` satisfy `OfflineAsrModel` + ANE? | **No** |
| Can we drop HF CoreML dependency using only this file? | **No** |

This checkpoint is an excellent **single source of truth for the Android/ONNX (full-attention) path**. It is **not** the source of the production iOS ANE package.

---

## 1. Load status (NVIDIA NeMo)

### What we did load successfully (without full `restore_from`)

The `.nemo` is a tar containing:

| Member | Size / role |
| --- | --- |
| `model_config.yaml` | Hybrid FastConformer config (`nemo_version: 2.0.0rc1`) |
| `model_weights.ckpt` | 438 MB state dict (707 tensors) |
| `*_tokenizer.model` / vocab / `.vocab` | SentencePiece BPE |

`torch.load(model_weights.ckpt)` succeeded. Observed:

- Prefixes: `preprocessor`, `encoder`, `ctc_decoder`, `decoder` (RNNT), `joint`
- `ctc_decoder.decoder_layers.0.weight` shape **`(1025, 512, 1)`** → 1024 BPE + blank = **1025** classes, encoder dim **512**
- Encoder `d_model` / pre-encode tensors consistent with FastConformer Large

### Full NeMo `EncDecHybridRNNTCTCBPEModel.restore_from(...)`

**Not completed in this environment.** An isolated venv (`experiments/nemo_coreml_investigation/.venv-nemo`) installed `nemo_toolkit==2.0.0` on Python 3.13, but importing `nemo.collections.asr` failed through a long dependency / version chain (`lhotse`, `einops`, then `NeptuneLogger` vs newer Lightning, then `pyannote`, …).  

That is an **environment blocker**, not evidence against the checkpoint. Architecture/tokenizer/I/O conclusions below do **not** depend on a successful `restore_from`.

---

## 2. Architecture parity vs Android ONNX / production tokenizer

### Tokenizer — exact match

SHA-256 of SentencePiece model inside `.nemo` equals every lab copy used by Android / CoreML staging:

```
1fcfa104fa448c979cc2537788947c6516827f403ecdc55c4895b77d28630ba4
```

Same for `tokens.txt` across `models/`, `models/onnx/`, `models/coreml/`  
(`7e6e2b04…`). Vocab lines = **1024** pieces (`<unk>` …); CTC blank is the extra class → **1025** logits (matches ONNX).

### Encoder / CTC config — identical to lab `model_config.yaml` encoder block

Both `.nemo` extract and `tajweed-lab/models/model_config.yaml`:

| Field | Value |
| --- | --- |
| Target class | `EncDecHybridRNNTCTCBPEModel` |
| NeMo version stamped | `2.0.0rc1` |
| Encoder | `ConformerEncoder`, `n_layers=17`, `d_model=512` |
| Subsampling | `dw_striding`, factor **8** |
| Attention | `rel_pos`, **`att_context_size: [-1, -1]`** (full / global) |
| `att_context_style` | `regular` |
| Mel | 80 feats, 16 kHz, 25 ms / 10 ms |
| CTC `num_classes` | 1024 (+ blank → 1025 outputs) |

YAML files differ only in training manifest paths / minor metadata — **encoder blocks are byte-identical**.

### Android ONNX I/O (live inspection of `model_with_encoder.onnx`)

| | Shape / name |
| --- | --- |
| Inputs | `audio_signal` `['B', 80, 'T_in']` f32, `length` `['B']` i64 |
| Outputs | `logprobs` `['B', 'T_out', 1025]`, `encoder_output` `['B', 512, 'T_out']` |
| Graph | ~3830 nodes, **17 Softmax** (one per layer), **0** window-named nodes |

This matches the `.nemo` full-attention design. It does **not** match the ANE CoreML design documented upstream.

---

## 3. Correct NeMo → CoreML export path (what actually exists)

### Official NeMo path

From NVIDIA docs (Hybrid RNNT-CTC):

1. `EncDecHybridRNNTCTCBPEModel.restore_from("….nemo")`
2. `model.set_export_config({'decoder_type': 'ctc'})` (default export is RNNT)
3. Export to **ONNX** (`model.export(...)` / `scripts/export.py`)

NeMo 2.0.0 wheel contents under `nemo/export/` cover **TensorRT-LLM / vLLM / multimodal** — **no CoreML exporter**.

### Practical CoreML path (community / DIY)

`.nemo` → (NeMo) ONNX CTC+encoder → `onnx2torch` → `torch.jit.trace` → `coremltools`  

Already exercised in `tajweed-lab/experiments/diy_coreml_poc/` from the **existing** ONNX (same architecture as this `.nemo`). Result: **HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN** (FP32 fixed-T only).

### Production iOS contract (`OfflineAsrModel.swift` / `docs/COREML_CONTRACT.md`)

| Requirement | Produced by NeMo CTC export? | Produced by DIY convert of this graph? |
| --- | --- | --- |
| Multifunction `predict_T80…predict_T4800` | No | No (single `main`; merge is separate CT packaging) |
| Input mel-only `(1,80,T)` (no `length`) | No (ONNX uses `audio_signal`+`length`) | No without graph surgery |
| ANE + FP16 stable | No | **Failed** (all-NaN logprobs) |
| Windowed attention + pos-enc clamp | No — this ckpt is full attn | Absent from ONNX |

---

## 4. Why this checkpoint cannot become the ANE production encoder

Upstream CoreML README (`tajweed-lab/models/coreml/README.md`) states explicitly:

> The Neural Engine is **fp16-only**, and the **full-attention** encoder blanks on ANE in fp16 … The fix is architectural: the **ANE variant uses limited windowed attention `att_context_size=[32,32]`** … **fine-tuned at that window** … pos_enc clamp baked in.

| Artifact | `att_context_size` | Role |
| --- | --- | --- |
| This `.nemo` + Android ONNX | `[-1, -1]` full | Max-accuracy offline / ORT |
| `fastconformer-quran-offline-ane.mlpackage` (HF) | `[32, 32]` windowed + fine-tune | Production iOS ANE |

Therefore:

- Re-exporting **this** `.nemo` (even perfectly) yields a **full-attention** encoder — the same class as Android ONNX / DIY CoreML FP32.
- It does **not** contain the windowed fine-tune weights that HF ships as the ANE pack.
- FP16 + full attention on ANE is documented as **physically unusable** (empty transcripts / blank CTC), matching our DIY NaN failure.

**Additional ANE/API transforms that would be required (precise list — none implemented here):**

1. **Change attention to limited context `[32, 32]`** (and matching masks) — architectural, not a converter flag.  
2. **Fine-tune** (or obtain) weights at that window — not present in this `.nemo`.  
3. **Bake pos-enc clamps** for FP16 ANE stability.  
4. **Specialize / merge** seven fixed-length functions `predict_T{80,160,320,640,1280,2560,4800}`.  
5. **Drop `length` input**; pad-only mel contract for Swift.  
6. Validate FP16 on-device vs Android ONNX (expect systematic WER gap vs full-attn; ANE pack quotes ~6% vs ~3% fp32).

Without (1)–(2), steps (3)–(6) cannot produce the production ANE pack from this file.

---

## 5. Parity / performance evidence (golden clips)

### Android ONNX / lab Python (existing Phase 4A)

Reference transcripts (`memory/features/tajweed/phase4a-artifacts/python_reference_transcripts.json`):

| Sample | Hypothesis | Lab infer (approx) |
| --- | --- | --- |
| `01_alafasy_fatihah.wav` | `مَالِكِ يَوْمِ الدِّينِ` | ~1.1 s |
| `02_basfar_ikhlas.wav` | `قُلْ هُوَ اللَّهُ أَحَدٌ` | ~0.14 s |
| `03_alafasy_naba.wav` | `قُلْ هُوَ نَبَأٌ عَظِيمٌ` | ~0.11 s |

### DIY CoreML from ONNX (= same architecture as this `.nemo`)

From `diy_coreml_parity_report.md`:

| Metric | FP32 fixed T=480 (host) | FP16 |
| --- | --- | --- |
| Transcript vs Android | Exact match (3/3) | Broken (NaN → `<unk>`) |
| Mean \|Δprob\| vs Android head | ≤ 0.003 | N/A |
| Encoder feature / logit parity | Correlation ≈ 1.0 vs ONNX (sample 01) | Unusable |
| `predict_T*` / ANE | Not present | Not present |

### NeMo runtime vs ONNX on goldens

**Not measured** — `restore_from` did not complete (env deps). Structural identity (tokenizer SHA, encoder YAML, CTC `1025×512`) makes weight-family identity with Android ONNX the justified working assumption; a numeric NeMo↔ONNX dump remains a follow-up once NeMo ASR imports cleanly (recommend Python 3.10/3.11 + matching NeMo 2.0.0rc1 toolchain).

### Official ANE CoreML vs Android ONNX

**Not measured here** — weight blobs still missing locally (empty `models/coreml/fastconformer-quran-offline-ane.mlpackage`). Upstream itself documents **different WER** (~6% ANE windowed vs ~3% full-attn fp32), so **numerical encoder/logit equivalence to Android ONNX is not expected** even when HF packs are available.

---

## 6. Unsupported / blocking operations for “`.nemo` → production iOS”

| Blocker | Kind |
| --- | --- |
| No NeMo→CoreML exporter | Tooling |
| Full-attention Softmax stack unstable in FP16/ANE | Numerics / hardware |
| Missing windowed `[32,32]` fine-tuned weights in this `.nemo` | Artifact gap |
| Missing multifunction `predict_T*` packaging | API packaging |
| ONNX `length` tensor vs Swift mel-only | API mismatch |
| Rel-pos attention / dynamic shapes fragile under `jit.trace` | Conversion |

---

## 7. Recommendation

1. **Treat this `.nemo` as SoT for Android ONNX** (and for any future re-export of `model_with_encoder.onnx`). Tokenizer and architecture already match.  
2. **Do not expect this file to replace HF `fastconformer-quran-coreml-offline` ANE packs.** Those packs are a **separate windowed fine-tune + CoreML packaging**.  
3. To eliminate HF CoreML dependency you still need one of:  
   - Host/mirror the **official ANE `.mlpackage`s** yourself (ADR-008), or  
   - Obtain the **windowed `[32,32]` fine-tune recipe + checkpoint** and rebuild ANE packaging (not a stock NeMo export).  
4. Keep ADR-004: DIY full-attn ONNX→CoreML is not a production ANE path.

---

## Artifacts touched this session (investigation only)

- Extracted metadata/weights under `tajweed-lab/experiments/nemo_coreml_investigation/nemo_extract/`  
- Isolated `.venv-nemo` (local; not used by the app)  
- This report  
- **No** changes to `ios/`, `android/`, `lib/`, or production packs under `models/onnx` / shipped assets
