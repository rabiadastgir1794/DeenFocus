#!/usr/bin/env python3
"""Compare official HF CoreML offline-ANE pack vs production DIY palette-8.

Same golden WAVs, same lab mel/CTC/lexical/pronunciation pipeline.
Host-side (coremltools). Does not modify production R2 or Android.

Usage (from tajweed-lab, venv active):
  python experiments/diy_coreml_poc/compare_official_vs_diy.py
"""

from __future__ import annotations

import json
import resource
import sys
import time
import traceback
from pathlib import Path

import coremltools as ct
import numpy as np
import soundfile as sf

ROOT = Path(__file__).resolve().parents[2]
POC = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT / "web"))
sys.path.insert(0, str(ROOT / "scripts"))

from asr.decode import collapse_ctc  # noqa: E402
from asr.mel import log_mel  # noqa: E402
import parity_dump_onnx_e2e as e2e  # noqa: E402
import run_coreml_e2e as diy  # noqa: E402

SAMPLES = ROOT / "samples"
TOKENS = ROOT / "models" / "tokens.txt"
if not TOKENS.exists():
    TOKENS = ROOT / "docs" / "tokens.txt"

# Production DIY candidate (palette-8) + its pronunciation head.
DIY_ENC = POC / "artifacts" / "optimization" / "palette_8bit" / "encoder.mlpackage"
DIY_HEAD = POC / "artifacts" / "pronunciation_head.mlpackage"

# Official HF offline-ANE pack (downloaded via scripts/download_coreml_offline.py).
OFF_ENC = ROOT / "models" / "coreml" / "fastconformer-quran-offline-ane.mlpackage"
OFF_HEAD = ROOT / "models" / "coreml" / "pronunciation-head.mlpackage"

OUT_JSON = POC / "reports" / "official_vs_diy_comparison.json"
OUT_MD = POC / "reports" / "official_vs_diy_comparison.md"
MEMORY_MD = (
    ROOT.parent
    / "memory"
    / "features"
    / "tajweed"
    / "official-vs-diy-coreml-comparison-2026-07-30.md"
)

BLANK_ID = 1024
FRAME_HOP_S = 0.080
FIXED_T_DIY = 4800
# Actual functions present in the downloaded ANE package (NOT the old
# MelFrontend.swift list of 80/160/320/640/1280/2560/4800).
OFFICIAL_BUCKETS = [80, 200, 400, 800, 1600, 2400, 4800]

# Compute units to try (host). True ANE utilization needs a real iPhone.
COMPUTE_CANDIDATES = [
    ("CPU_AND_NE", getattr(ct.ComputeUnit, "CPU_AND_NE", None)),
    ("CPU_AND_GPU", ct.ComputeUnit.CPU_AND_GPU),
    ("CPU_ONLY", ct.ComputeUnit.CPU_ONLY),
]


def normalize_arabic_app(text: str) -> str:
    """Mirror production TajweedLexicalScoring.normalizeArabic (Kotlin/Swift)."""
    diac = set("\u064b\u064c\u064d\u064e\u064f\u0650\u0651\u0652\u0615\u0653\u0654\u06e1")
    heh_family = {0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3}

    def skippable(ch: str) -> bool:
        o = ord(ch)
        return ch in diac or o == 0x0640 or 0x06D6 <= o <= 0x06ED

    out: list[str] = []
    i = 0
    while i < len(text):
        ch = text[i]
        o = ord(ch)
        if o == 0x0670:
            j = i + 1
            while j < len(text) and skippable(text[j]):
                j += 1
            nxt = ord(text[j]) if j < len(text) else -1
            if nxt not in heh_family:
                out.append("\u0627")
            i += 1
            continue
        if o == 0x0671:
            out.append("\u0627")
            i += 1
            continue
        if skippable(ch):
            i += 1
            continue
        if o in heh_family:
            out.append("\u0647")
            i += 1
            continue
        out.append(ch)
        i += 1
    s = "".join(out)
    for a, b in (("أ", "ا"), ("إ", "ا"), ("آ", "ا"), ("ى", "ي"), ("ک", "ك"), ("ی", "ي")):
        s = s.replace(a, b)
    return s.strip()


def split_words(text: str) -> list[str]:
    return [w for w in text.split() if w and normalize_arabic_app(w)]


def align_ops(expected: list[str], hypothesis: list[str]) -> list[str]:
    n, m = len(expected), len(hypothesis)
    exp_n = [normalize_arabic_app(w) for w in expected]
    hyp_n = [normalize_arabic_app(w) for w in hypothesis]
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(n + 1):
        dp[i][0] = i
    for j in range(m + 1):
        dp[0][j] = j
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            cost = 0 if exp_n[i - 1] == hyp_n[j - 1] else 1
            dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)
    ops: list[str] = []
    i, j = n, m
    while i > 0 or j > 0:
        if i > 0 and j > 0 and exp_n[i - 1] == hyp_n[j - 1] and dp[i][j] == dp[i - 1][j - 1]:
            ops.append("match")
            i -= 1
            j -= 1
        elif i > 0 and j > 0 and dp[i][j] == dp[i - 1][j - 1] + 1:
            ops.append("sub")
            i -= 1
            j -= 1
        elif i > 0 and dp[i][j] == dp[i - 1][j] + 1:
            ops.append("miss")
            i -= 1
        else:
            ops.append("extra")
            j -= 1
    ops.reverse()
    return ops


def package_size_bytes(path: Path) -> int:
    return sum(p.stat().st_size for p in path.rglob("*") if p.is_file())


def rss_mb() -> float:
    # macOS: ru_maxrss is bytes
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / (1024 * 1024)


def pad_to_bucket(mel: np.ndarray, buckets: list[int]) -> tuple[np.ndarray, int]:
    t = mel.shape[1]
    for b in buckets:
        if b >= t:
            if b == t:
                return mel.astype(np.float32), b
            out = np.zeros((80, b), dtype=np.float32)
            out[:, :t] = mel
            return out, b
    raise ValueError(f"mel T={t} exceeds max bucket {buckets[-1]}")


def load_model(path: Path, compute_units, function_name: str | None = None):
    kwargs = {"compute_units": compute_units}
    if function_name:
        kwargs["function_name"] = function_name
    return ct.models.MLModel(str(path), **kwargs)


def pick_compute_label() -> tuple[str, object]:
    for label, cu in COMPUTE_CANDIDATES:
        if cu is None:
            continue
        try:
            # Smoke: load DIY head (small) under this CU.
            load_model(DIY_HEAD, cu)
            return label, cu
        except Exception:
            continue
    return "CPU_ONLY", ct.ComputeUnit.CPU_ONLY


def predict_diy(enc, mel: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    return diy._predict_encoder(enc, mel)


def predict_official(enc_by_fn: dict, mel: np.ndarray) -> tuple[np.ndarray, np.ndarray, int, str]:
    padded, bucket = pad_to_bucket(mel, OFFICIAL_BUCKETS)
    fn = f"predict_T{bucket}"
    model = enc_by_fn[fn]
    audio = padded[None, ...].astype(np.float32)
    # Official multifunction: audio_signal only (no length).
    try:
        out = model.predict({"audio_signal": audio})
    except Exception:
        # Some builds name the input differently.
        key = next(iter(model.get_spec().description.input)).name
        out = model.predict({key: audio})
    logprobs = np.asarray(out["logprobs"] if "logprobs" in out else diy._pick_logprobs(out))
    encoder = np.asarray(
        out["encoder_output"] if "encoder_output" in out else diy._pick_encoder(out)
    )
    if logprobs.ndim == 3:
        logprobs = logprobs[0]
    if encoder.ndim == 3:
        encoder = encoder[0]
    if encoder.ndim == 2 and encoder.shape[0] == 512 and encoder.shape[1] != 512:
        encoder = encoder.T
    return logprobs.astype(np.float32), encoder.astype(np.float32), bucket, fn


def predict_head(head, pooled: np.ndarray, token_id: int) -> float:
    """DIY head uses `enc_feature`; official HF head uses `encoder_feature`."""
    names = set(i.name for i in head.get_spec().description.input)
    enc_key = "encoder_feature" if "encoder_feature" in names else "enc_feature"
    for tid_dtype in (np.int32, np.int64):
        payload = {
            enc_key: pooled.astype(np.float32),
            "token_id": np.array([token_id], dtype=tid_dtype),
        }
        try:
            out = head.predict(payload)
            break
        except Exception:
            out = None
    if out is None:
        raise RuntimeError(f"head predict failed for inputs {names}")
    val = out["prob_correct"] if "prob_correct" in out else next(iter(out.values()))
    return float(np.asarray(val).reshape(-1)[0])


def score_side(
    name: str,
    logprobs: np.ndarray,
    encoder: np.ndarray,
    pieces: list[str],
    head,
    expected: str,
    infer_ms: float,
    extra: dict,
) -> dict:
    ids = collapse_ctc(logprobs.argmax(axis=-1).tolist(), blank_id=BLANK_ID)
    hypothesis = e2e.decode_ids(pieces, ids)
    exp_words = split_words(expected)
    hyp_words = split_words(hypothesis)
    ops = align_ops(exp_words, hyp_words)
    match_n = sum(1 for o in ops if o == "match")
    word_acc = match_n / max(len(exp_words), 1)

    tokens = []
    mean_prob = None
    if ids:
        intervals = e2e.ctc_forced_align(logprobs, ids)
        probs = []
        for token_id, start_f, end_f in intervals:
            s = max(0, min(start_f, encoder.shape[0] - 1))
            e = max(s + 1, min(end_f, encoder.shape[0]))
            pooled = encoder[s:e].mean(axis=0, keepdims=True).astype(np.float32)
            try:
                prob = float(predict_head(head, pooled, token_id))
            except Exception as exc:  # noqa: BLE001
                tokens.append({"tokenId": token_id, "error": str(exc)})
                continue
            probs.append(prob)
            piece = pieces[token_id] if 0 <= token_id < len(pieces) else "?"
            tokens.append(
                {
                    "tokenId": token_id,
                    "piece": piece,
                    "prob": prob,
                    "status": e2e.status_for_prob(prob),
                    "startFrame": start_f,
                    "endFrame": end_f,
                }
            )
        mean_prob = float(np.mean(probs)) if probs else None
    return {
        "pipeline": name,
        "hypothesis": hypothesis,
        "exactMatch": normalize_arabic_app(hypothesis) == normalize_arabic_app(expected)
        and bool(expected),
        "wordAccuracy": word_acc,
        "lexicalOps": ops,
        "expectedNormWords": [normalize_arabic_app(w) for w in exp_words],
        "hypNormWords": [normalize_arabic_app(w) for w in hyp_words],
        "meanPronProb": mean_prob,
        "pronunciationTokens": tokens[:64],
        "logprobsShape": list(logprobs.shape),
        "encoderShape": list(encoder.shape),
        "inferenceMs": infer_ms,
        "finiteLogprobs": bool(np.isfinite(logprobs).all()),
        **extra,
    }


def write_report(results: dict) -> None:
    samples = results["samples"]
    diy_exact = sum(1 for s in samples if s["diy"]["exactMatch"])
    off_exact = sum(1 for s in samples if s["official"]["exactMatch"])
    diy_acc = float(np.mean([s["diy"]["wordAccuracy"] for s in samples]))
    off_acc = float(np.mean([s["official"]["wordAccuracy"] for s in samples]))
    diy_lat = float(np.mean([s["diy"]["inferenceMs"] for s in samples]))
    off_lat = float(np.mean([s["official"]["inferenceMs"] for s in samples]))
    diy_pron = [
        s["diy"]["meanPronProb"] for s in samples if s["diy"]["meanPronProb"] is not None
    ]
    off_pron = [
        s["official"]["meanPronProb"]
        for s in samples
        if s["official"]["meanPronProb"] is not None
    ]

    # Decision heuristic (evidence-based, host only).
    reasons = []
    if off_exact >= diy_exact:
        reasons.append(f"exact transcripts official {off_exact}/{len(samples)} >= DIY {diy_exact}/{len(samples)}")
    else:
        reasons.append(f"exact transcripts official {off_exact}/{len(samples)} < DIY {diy_exact}/{len(samples)}")
    if off_acc + 1e-6 >= diy_acc:
        reasons.append(f"mean lexical acc official {off_acc:.3f} >= DIY {diy_acc:.3f}")
    else:
        reasons.append(f"mean lexical acc official {off_acc:.3f} < DIY {diy_acc:.3f}")
    if off_lat <= diy_lat * 1.25:
        reasons.append(f"host latency official {off_lat:.0f}ms within 1.25× DIY {diy_lat:.0f}ms")
    else:
        reasons.append(f"host latency official {off_lat:.0f}ms slower than DIY {diy_lat:.0f}ms")

    migrate = off_exact >= diy_exact and off_acc + 1e-6 >= diy_acc
    results["recommendation"] = {
        "migrate_ios_to_official": migrate,
        "reasons": reasons,
        "caveats": [
            "Host CPU/GPU ≠ iPhone Neural Engine; ANE utilization not measured on-device in this run.",
            "Official ANE pack uses windowed attention (att_context_size=[32,32]); DIY is full-attention palette-8.",
            "iOS MelFrontend.padToBucket currently uses [80,160,320,640,1280,2560,4800] but the official "
            f"package functions are {OFFICIAL_BUCKETS} — migration MUST update MelFrontend buckets.",
            "Android remains ONNX and must not be changed.",
            "No model may be bundled in the IPA; R2 catalog/manifest/SHA path stays.",
        ],
    }

    lines = [
        "# Official HF CoreML (ANE) vs DIY palette-8 — host comparison (2026-07-30)",
        "",
        "> Evidence only. Production R2 was **not** changed by this script.",
        "",
        "## Packages",
        "",
        f"| | Official ANE | DIY palette-8 (current iOS R2) |",
        f"|---|---:|---:|",
        f"| Encoder on-disk | {results['sizes']['official_encoder_mb']:.1f} MB | {results['sizes']['diy_encoder_mb']:.1f} MB |",
        f"| Head on-disk | {results['sizes']['official_head_mb']:.1f} MB | {results['sizes']['diy_head_mb']:.1f} MB |",
        f"| Pack total (enc+head+tok) | {results['sizes']['official_pack_mb']:.1f} MB | {results['sizes']['diy_pack_mb']:.1f} MB |",
        f"| API | multifunction `{OFFICIAL_BUCKETS}` | single-function fixed T=4800 + length |",
        f"| Host compute | {results['compute_units']} | {results['compute_units']} |",
        "",
        "## Golden-clip results",
        "",
        "| Sample | DIY hyp exact | Official hyp exact | DIY wordAcc | Official wordAcc | DIY ms | Official ms |",
        "|---|:---:|:---:|---:|---:|---:|---:|",
    ]
    for s in samples:
        lines.append(
            f"| {s['sample']} | {s['diy']['exactMatch']} | {s['official']['exactMatch']} | "
            f"{s['diy']['wordAccuracy']:.2f} | {s['official']['wordAccuracy']:.2f} | "
            f"{s['diy']['inferenceMs']:.0f} | {s['official']['inferenceMs']:.0f} |"
        )
    lines += [
        "",
        "## Summary",
        "",
        f"- Exact transcripts: DIY **{diy_exact}/{len(samples)}**, official **{off_exact}/{len(samples)}**",
        f"- Mean lexical wordAccuracy: DIY **{diy_acc:.3f}**, official **{off_acc:.3f}**",
        f"- Mean host inference: DIY **{diy_lat:.0f} ms**, official **{off_lat:.0f} ms**",
        f"- Mean pronunciation prob: DIY **{(np.mean(diy_pron) if diy_pron else float('nan')):.4f}**, "
        f"official **{(np.mean(off_pron) if off_pron else float('nan')):.4f}**",
        f"- Peak RSS during run (process): **{results['peak_rss_mb']:.0f} MB** (shared process; not per-model isolated)",
        "",
        "## Neural Engine",
        "",
        results.get("ane_note", "Not measured on-device."),
        "",
        "## Recommendation",
        "",
        f"**Migrate iOS to official:** `{migrate}`",
        "",
    ]
    for r in reasons:
        lines.append(f"- {r}")
    lines.append("")
    for c in results["recommendation"]["caveats"]:
        lines.append(f"- Caveat: {c}")
    lines.append("")

    text = "\n".join(lines) + "\n"
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(results, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    OUT_MD.write_text(text, encoding="utf-8")
    MEMORY_MD.parent.mkdir(parents=True, exist_ok=True)
    MEMORY_MD.write_text(text, encoding="utf-8")
    print(text)
    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_MD}")
    print(f"Wrote {MEMORY_MD}")


def main() -> int:
    for p in (DIY_ENC, DIY_HEAD, OFF_ENC, OFF_HEAD, TOKENS):
        if not p.exists():
            print(f"ERROR: missing {p}", file=sys.stderr)
            return 1

    pieces = e2e.load_tokens(TOKENS)
    compute_label, compute_units = pick_compute_label()
    print(f"Using compute units: {compute_label}")

    ane_note = (
        "Host run used "
        f"`{compute_label}`. CoreML `CPU_AND_NE` may or may not engage ANE on macOS; "
        "true Neural Engine utilization requires Instruments on a physical iPhone "
        "(Energy / Neural Engine gauges) after side-loading each pack."
    )

    print("Loading DIY palette-8 encoder + head…")
    t0 = time.time()
    diy_enc = load_model(DIY_ENC, compute_units)
    diy_head = load_model(DIY_HEAD, compute_units)
    diy_load_ms = (time.time() - t0) * 1000

    print("Loading official ANE multifunction functions…")
    t0 = time.time()
    off_by_fn = {}
    for b in OFFICIAL_BUCKETS:
        fn = f"predict_T{b}"
        off_by_fn[fn] = load_model(OFF_ENC, compute_units, function_name=fn)
        print(f"  loaded {fn}")
    off_head = load_model(OFF_HEAD, compute_units)
    off_load_ms = (time.time() - t0) * 1000

    sizes = {
        "diy_encoder_mb": package_size_bytes(DIY_ENC) / 1e6,
        "diy_head_mb": package_size_bytes(DIY_HEAD) / 1e6,
        "official_encoder_mb": package_size_bytes(OFF_ENC) / 1e6,
        "official_head_mb": package_size_bytes(OFF_HEAD) / 1e6,
    }
    # Approximate pack totals with shared tokenizer from each tree.
    diy_tok = package_size_bytes(ROOT / "models" / "tokenizer.model") if (ROOT / "models" / "tokenizer.model").exists() else 254806
    off_tok = package_size_bytes(ROOT / "models" / "coreml" / "tokenizer.model")
    sizes["diy_pack_mb"] = sizes["diy_encoder_mb"] + sizes["diy_head_mb"] + diy_tok / 1e6
    sizes["official_pack_mb"] = sizes["official_encoder_mb"] + sizes["official_head_mb"] + off_tok / 1e6

    results = {
        "generated_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "compute_units": compute_label,
        "diy_cold_load_ms": diy_load_ms,
        "official_cold_load_ms": off_load_ms,
        "official_buckets": OFFICIAL_BUCKETS,
        "ios_mel_frontend_buckets_today": [80, 160, 320, 640, 1280, 2560, 4800],
        "bucket_mismatch_with_ios_code": True,
        "sizes": sizes,
        "ane_note": ane_note,
        "samples": [],
    }

    peak = rss_mb()
    for wav_path in sorted(SAMPLES.glob("*.wav")):
        meta = e2e.EXPECTED.get(wav_path.name)
        if not meta:
            continue
        wav, sr = sf.read(str(wav_path), dtype="float32")
        if wav.ndim > 1:
            wav = wav.mean(axis=1)
        if sr != 16000:
            raise SystemExit(f"expected 16kHz, got {sr} for {wav_path}")
        mel = log_mel(wav)

        t1 = time.time()
        lp_d, enc_d = predict_diy(diy_enc, mel)
        diy_ms = (time.time() - t1) * 1000
        diy_side = score_side(
            "diy_palette8",
            lp_d,
            enc_d,
            pieces,
            diy_head,
            meta["expected"],
            diy_ms,
            {"bucketOrFixedT": FIXED_T_DIY, "api": "single_function_fixed"},
        )

        t1 = time.time()
        try:
            lp_o, enc_o, bucket, fn = predict_official(off_by_fn, mel)
            off_ms = (time.time() - t1) * 1000
            off_side = score_side(
                "official_ane",
                lp_o,
                enc_o,
                pieces,
                off_head,
                meta["expected"],
                off_ms,
                {"bucketOrFixedT": bucket, "api": fn},
            )
        except Exception as exc:  # noqa: BLE001
            off_ms = (time.time() - t1) * 1000
            off_side = {
                "pipeline": "official_ane",
                "error": str(exc),
                "traceback": traceback.format_exc(),
                "exactMatch": False,
                "wordAccuracy": 0.0,
                "inferenceMs": off_ms,
                "lexicalOps": [],
                "meanPronProb": None,
            }

        peak = max(peak, rss_mb())
        print(
            f"{wav_path.name}: DIY exact={diy_side['exactMatch']} acc={diy_side['wordAccuracy']:.2f} "
            f"{diy_ms:.0f}ms | OFF exact={off_side.get('exactMatch')} "
            f"acc={off_side.get('wordAccuracy', 0):.2f} {off_ms:.0f}ms "
            f"api={off_side.get('api')}"
        )
        print(f"  DIY hyp: {diy_side.get('hypothesis')!r}")
        print(f"  OFF hyp: {off_side.get('hypothesis')!r}")

        results["samples"].append(
            {
                "sample": wav_path.name,
                "ref": meta["ref"],
                "expected": meta["expected"],
                "diy": diy_side,
                "official": off_side,
            }
        )

    results["peak_rss_mb"] = peak
    write_report(results)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
