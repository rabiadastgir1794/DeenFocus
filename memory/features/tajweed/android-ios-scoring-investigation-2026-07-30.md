# Investigation: "wrong ayah still scores 40–60%" — root cause (2026-07-30)

> Investigation only, per explicit instruction. **No UI, download-infrastructure, or
> Flutter code was changed.** One new instrumented diagnostic test was added
> (`android/app/src/androidTest/kotlin/.../tajweed/TajweedMismatchDiagnosticTest.kt`)
> to reproduce the bug with real on-device audio + real production ONNX weights —
> it is not wired into CI, mirrors the existing `TajweedOnDeviceParityTest.kt` pattern.

## TL;DR

**This is not an Android-vs-iOS parity problem.** It's a scoring-architecture gap
that exists identically in the underlying model weights, and would reproduce
byte-for-byte on iOS once real CoreML weights are available there (they currently
are not — see "iOS baseline" below). Chasing "Android parity with iOS" would not
fix it, because there is no working iOS baseline that behaves any better, and the
one CoreML artifact we *can* run (same weights, re-exported) reproduces the exact
same behavior as Android.

**Root cause (two compounding gaps in the scoring layer, not the ASR/preprocessing):**
1. CTC forced-alignment always produces *some* alignment for the expected text,
   no matter how wrong — it has no reject/no-match option.
2. The pronunciation head was trained as a goodness-of-pronunciation (GOP)
   classifier — "given the right word was spoken, how well?" — never trained to
   detect "wrong word entirely." Fed acoustic frames that don't correspond to the
   token it's asked about, it defaults to near-ceiling "correct" probabilities.

The raw ASR transcription (`hypothesis`) is **not** the problem — it's accurate
in every test. The bug is 100% downstream, in forced-align + pronunciation-head
scoring.

## The direct answer to "what does Android output before scoring?"

Ran the real production ONNX pack (the exact files Android downloads/loads) against
the two golden recordings, on the Android emulator, through the real `TajweedEngine`
pipeline end-to-end (mic-capture code path skipped, real WAV → real mel → real ONNX
encoder → real CTC decode → real forced-align → real pronunciation head — nothing
mocked), each paired with the *other* recording's expected text (zero shared words):

| Recording (ground truth) | "Expected" text fed in (deliberately wrong) | Raw `hypothesis` (before scoring) | `wordAccuracy` after scoring |
|---|---|---|---|
| `01_alafasy_fatihah.wav` → really says **"مَالِكِ يَوْمِ الدِّينِ"** | "قُلْ هُوَ اللَّهُ أَحَدٌ" (Al-Ikhlas) | **"مَالِكِ يَوْمِ الدِّينِ"** ✅ correct | **0.75 (75%)** ❌ |
| `02_basfar_ikhlas.wav` → really says **"قُلْ هُوَ اللَّهُ أَحَدٌ"** | "مَالِكِ يَوْمِ الدِّينِ" (Al-Fatiha) | **"قُلْ هُوَ اللَّهُ أَحَدٌ"** ✅ correct | **1.00 (100%)** ❌ |

Per-word breakdown for case 1 (reciting Al-Fatiha 1:4, app "expected" Al-Ikhlas):

```
قُلْ    -> ok     (prob 0.996)
هُوَ    -> ok     (prob 0.999)
اللَّهُ  -> major  (prob 0.211)
أَحَدٌ   -> ok     (prob 0.982)
```

3 of 4 completely-absent words were scored "ok" with >98% confidence. This
directly answers the specific question asked:

> **The ASR model is not at fault.** `hypothesis` (raw, pre-scoring transcription)
> is accurate in both directions — it reflects exactly what was said, has zero
> knowledge of what was "expected," and matches the known ground truth exactly.
> The fault is entirely in the alignment/scoring stage that runs *after* this.

Raw evidence: `/sdcard/Android/data/com.rnr.deenfocus/files/tajweed_mismatch_diagnostic.json`
on the emulator (also logcat tag `TajweedMismatch`), from
`TajweedMismatchDiagnosticTest.mismatchedAyahProducesRawHypothesisAndScore`.

## Point-by-point (per the requested checklist)

### 1. Audio preprocessing — not the cause

- Sample rate 16kHz, PCM16 mono, hop 160 samples (10ms), FFT 512, 80 mel bins,
  Hann window, log(x+eps) + per-feature (per-mel-bin) mean/var normalization —
  same on both platforms (`MelFrontend.kt` / `MelFrontend.swift`), and both were
  already validated bit-close to each other in Phase 4A:
  `memory/features/tajweed/phase4a-artifacts/mel_parity_report.json` —
  iOS-vs-Android mel correlation **0.9998–0.99999** on all 3 golden clips (the
  python-reference-vs-{ios,android} gap is slightly larger, ~1-2% mean abs diff,
  attributable to FFT/window implementation differences vs numpy, not an
  Android/iOS divergence).
- Pre-emphasis (0.97) is applied identically on both platforms; confirmed by
  reading `MelFrontend.kt`/`.swift` side by side.
- **Conclusion: preprocessing is already at cross-platform parity and is not
  the source of this bug.**

### 2. ONNX inference — matches the exported model exactly

Verified directly against the actual `.onnx` files (not docs/assumptions), via
`onnxruntime.InferenceSession.get_inputs()/get_outputs()`:

- `model_with_encoder.onnx`: inputs `audio_signal (B,80,T_in)` float32,
  `length (B,)` int64 → outputs `logprobs (B,T_out,1025)`,
  `encoder_output (B,512,T_out)` float32. Matches `OnnxAsrModel.kt`/
  `OfflineAsrModel.swift` exactly (including the `(512,T)`→`(T,512)` transpose
  Android/iOS both apply to `encoder_output`).
- `pronunciation_head.onnx`: inputs `enc_feature (batch,512)` float32,
  `token_id (batch,)` int64 → output `prob_correct (batch,)` float32. Matches
  `PronunciationHeadModel.kt`'s input/output name-matching heuristics
  (`.contains("enc")`, `.contains("token")`, `.contains("prob")`) — verified
  these heuristics correctly resolve to the real names, not just "happen to work."
- **Conclusion: ONNX contract matches on both ends; not the source of the bug.**

### 3. Token decoding — identical, and not a beam-search/threshold issue

- `tokens.txt`: 1024 lines (ids 0–1023); `logprobs` vocab dim is 1025 → blank
  id is 1024, consistent everywhere (`CtcAligner.BLANK_ID = 1024` Kotlin/Swift,
  `CtcDecoder.BLANK_ID = 1024` Kotlin/Swift, vendored Python reference).
- Decoding is **plain greedy CTC argmax + collapse-repeats-drop-blank**
  (`CtcDecoder.collapse`) — byte-for-byte identical on Kotlin/Swift/Python. No
  beam search, no confidence threshold, on either platform. There is nothing to
  mis-tune here — the decode step has no free parameters.
- **Conclusion: not the source of the bug; both platforms run the exact same
  degenerate (parameter-free) decode.**

### 4. Alignment — algorithm matches iOS exactly, but has a structural gap

- `CtcAligner.kt` / `CtcAligner.swift` / vendored `aligner.py::ctc_forced_align`
  are the same DP (same recurrence, same skip-blank rule, same backtrack) —
  confirmed by reading all three side by side.
- **The gap: standard CTC forced-alignment has no "reject" state.** Given any
  `T >= len(expected_tokens)`, the DP *always* finds *some* monotonic partition
  of the audio into the expected token count — it cannot say "this text doesn't
  appear in this audio at all," it can only say "here is the best-fitting
  placement, however bad."
- This DP **does** internally know when the fit is bad — I measured the
  average per-frame log-likelihood of the forced path vs. the free/unconstrained
  best-path (upper bound) on the same `logprobs`:

  | Recording | Expected text | forced/T | free/T (upper bound) | gap |
  |---|---|---|---|---|
  | Fatihah audio | own text (correct) | -1.75 | -0.03 | **1.72** |
  | Fatihah audio | Ikhlas text (wrong) | -6.98 | -0.03 | **6.95** |
  | Ikhlas audio | own text (correct) | -2.83 | -0.02 | **2.82** |
  | Ikhlas audio | Fatihah text (wrong) | -7.66 | -0.02 | **7.64** |

  The gap is **~4x larger** for wrong-ayah pairings, cleanly separable. **This
  signal exists today, costs nothing extra to compute (the DP already computes
  `alpha`), and is currently thrown away** — neither `TajweedEngine.kt` nor
  `TajweedEngine.swift` reads or surfaces the final alignment likelihood at all.
- **Conclusion: alignment algorithm itself is at parity and is not buggy — but
  the engine discards a cheap, already-computed, strongly discriminative
  "does this text even appear in this audio" signal that the DP produces for free.**

### 5. Pronunciation head — is real, is not a no-op, but was never trained to reject wrong content

- Verified the head is not a broken/constant stub: feeding it varied synthetic
  encoder vectors for the same `token_id` produces widely different probabilities
  (0.0000388 to 0.99999), so it's a live, input-sensitive classifier, not always-1.0.
- Architecture (`vendor/tajweed/head_scorer.py::PronunciationHead`): concatenates
  the pooled acoustic feature (512d), a learned per-token embedding (64d), and a
  fixed per-token "feature_table" row (16d) baked in at export time, then an MLP
  → sigmoid. This is a **goodness-of-pronunciation (GOP)** design: "assuming the
  right token was spoken, how well?" It has no architectural or (evidently)
  training-time exposure to "this interval is acoustically a totally different
  word than the token id it's being asked about."
- On real (not synthetic) audio, run through **both** the production ONNX
  weights and a from-the-same-checkpoint CoreML re-export (see "iOS baseline"
  below), 12 of 15 forced-aligned pieces across the two mismatched pairs scored
  ≥0.94 "ok" despite the audio containing none of those tokens at all.
- **Conclusion: the model is real and responsive, but its training objective
  (GOP on correctly-identified content) does not cover the "wrong word entirely"
  case, so it is not equipped to reject it — this is a training-data/objective
  gap, not an inference bug.**

### 6. Scoring — traced exactly

`TajweedEngine.score()` (Kotlin) / equivalent Swift:

1. `hypothesis` = greedy CTC decode of the raw ASR output (accurate, per above).
2. `expectedIds` = tokenizer.encode(expectedArabic) (the text the app asked for).
3. `CtcAligner.forcedAlign(logprobs, expectedIds)` — forces the expected tokens
   onto the audio timeline (see #4 — always succeeds).
4. For each forced interval, `PronunciationHeadModel.score(pooledEncoderFrames,
   tokenId)` → probability → `statusForProb`: `<0.5` major, `<0.85` minor, else ok.
5. Per-piece statuses are grouped into per-*word* statuses (worst-piece-wins) —
   this is the recent word-level-grouping change, unrelated to this bug.
6. `wordAccuracy = TajweedLexicalScoring.wordAccuracyFromTokens` =
   `count(status ok|minor) / expectedWordCount`.
7. `exactMatch = normalize(hypothesis) == normalize(expectedArabic)` — computed
   but **never fed into `wordAccuracy`**.

**Why an obviously-wrong recitation still scores high:** step 3 always succeeds
(#4), step 4's classifier defaults to "ok" for content it was never trained to
reject (#5), and step 6 only reads the per-word statuses from steps 3–4 — it
never compares `hypothesis` to `expectedArabic` at the sentence level, so the one
signal that *would* catch this instantly (`exactMatch`, or a real text diff) is
computed but discarded before it can affect the percentage.

## 7. Android vs iOS comparison — is this an ONNX-export or conversion defect?

**No.** Two independent lines of evidence:

1. **Existing Phase 4A parity report** (`diy-coreml-poc-parity-report.md`) already
   showed the DIY CoreML re-export of these exact same weights (`onnx2torch` →
   `torch.jit.trace` → `coremltools`, FP32) is numerically faithful to the ONNX
   weights on *correct* recitations (mean |Δprob| 0.0000–0.0029, all 3 golden
   clips exact-match, 0 status mismatches vs Android).
2. **I re-ran the mismatch scenario through that same CoreML artifact** (not
   through Swift/production — this is the host-side `coremltools` harness, same
   one used for the parity report) and got the same result as ONNX/Android,
   piece for piece (e.g. `الَّ` piece: ONNX prob 0.2107 vs CoreML prob 0.2107;
   every other piece ≥0.94 "ok" on both runtimes). Full transcript in this
   session's tool output; not persisted as a repo artifact since it's throwaway
   diagnostic code (`/tmp/mismatch_diagnostic.py`, not committed).

So: **not an ONNX export error, not a model conversion difference, not missing
platform-specific post-processing.** Same weights → same behavior on both
runtimes. The alignment DP is also verified line-for-line identical in
`CtcAligner.kt`/`.swift`/vendored Python. The bug is in the model's training
objective + the engine's scoring logic (steps 3–6 above), which are themselves
already symmetric across `TajweedEngine.kt` and `TajweedEngine.swift`.

### iOS baseline caveat (important context for "achieve parity with iOS")

Per `memory/features/tajweed/overview.md`: **iOS has never run real-weight CoreML
inference in production.** The gated Hugging Face `.mlpackage` weights are still
403 (metadata/license access works, weight blobs don't), and iOS has no asset
catalog provisioned. So there is currently no working, real, on-device iOS
result to be "at parity with" — the only real CoreML numbers that exist are the
DIY POC host-side run above, which (being the same weights) has the identical bug.
**"Bring Android to iOS's level" is not an available fix path today** because iOS
is not currently ahead on this axis; when it is unblocked, it will need the same
fix.

## What this means for fixing it (not implemented — investigation only, per instruction)

Not prescribing a fix per the "only investigate" instruction, but for the record,
the evidence above points at the scoring layer, specifically:

- The forced-alignment total/normalized log-likelihood (already computed by the
  DP, currently discarded) cleanly separates correct vs. wrong-ayah pairings in
  this small sample (~4x gap) and would be cheap to surface as a gate/penalty.
- `exactMatch`/whole-utterance hypothesis-vs-expected agreement is already
  computed but not factored into `wordAccuracy` at all.
- The pronunciation head's training data/objective would need "wrong word
  entirely" negative examples (or a separate identity-verification signal) to
  ever learn to reject this case on its own — a data/retraining problem, not
  something fixable by threshold tuning in `PronunciationHeadModel.statusForProb`.

## Artifacts from this investigation

- `android/app/src/androidTest/kotlin/com/app/deenly/deenly/tajweed/TajweedMismatchDiagnosticTest.kt`
  (new, diagnostic-only, mirrors `TajweedOnDeviceParityTest.kt`, not in CI).
- Ran on Pixel_9 emulator (`emulator-5554`) with the real production ONNX pack
  (`tajweed-lab/models/onnx/`) and real golden recordings (`tajweed-lab/samples/`)
  pushed via `adb push` — same artifacts `TajweedOnDeviceParityTest` uses.
- Output: `/sdcard/Android/data/com.rnr.deenfocus/files/tajweed_mismatch_diagnostic.json`
  (device-local, not pulled into the repo — regenerate by rerunning the test).
