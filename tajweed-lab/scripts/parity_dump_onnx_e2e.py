#!/usr/bin/env python3
"""Phase 4B AI validation: run the production ONNX pack (encoder + pronunciation
head) on the golden samples and dump ADR-006-shaped score JSON + timings.

Uses the *same* artifacts Android's OnnxAsrModel / PronunciationHeadModel load:
  models/onnx/model_with_encoder.onnx
  models/onnx/pronunciation_head.onnx
  models/tokens.txt

This is the host-side ground truth for Android parity before/alongside device runs.

Usage (from tajweed-lab, venv active):
  python scripts/parity_dump_onnx_e2e.py
"""

from __future__ import annotations

import json
import sys
import time
from pathlib import Path

import numpy as np
import onnxruntime as ort
import soundfile as sf

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "web"))
sys.path.insert(0, str(ROOT / "vendor"))

from asr.decode import collapse_ctc  # noqa: E402
from asr.mel import log_mel  # noqa: E402

SAMPLES = ROOT / "samples"
OUT = ROOT / "parity" / "reports" / "onnx_e2e_scores.json"
ENCODER = ROOT / "models" / "onnx" / "model_with_encoder.onnx"
HEAD = ROOT / "models" / "onnx" / "pronunciation_head.onnx"
TOKENS = ROOT / "models" / "tokens.txt"

# Expected Arabic for each golden clip (from Phase 4A Python ASR transcripts).
EXPECTED = {
    "01_alafasy_fatihah.wav": {
        "ref": "1:4",
        "surah": 1,
        "ayah": 4,
        "expected": "مَالِكِ يَوْمِ الدِّينِ",
    },
    "02_basfar_ikhlas.wav": {
        "ref": "112:1",
        "surah": 112,
        "ayah": 1,
        "expected": "قُلْ هُوَ اللَّهُ أَحَدٌ",
    },
    "03_alafasy_naba.wav": {
        "ref": "38:67",
        "surah": 38,
        "ayah": 67,
        "expected": "قُلْ هُوَ نَبَأٌ عَظِيمٌ",
    },
}

BLANK_ID = 1024
NEG_INF = -1e18
FRAME_HOP_S = 0.080


def ctc_forced_align(logprobs: np.ndarray, token_ids: list[int]) -> list[tuple[int, int, int]]:
    """Return list of (token_id, start_frame, end_frame). Matches Android CtcAligner."""
    t, v = logprobs.shape
    if t <= 0 or v <= BLANK_ID or not token_ids:
        return []
    seq: list[int] = [BLANK_ID]
    for tok in token_ids:
        seq.append(tok)
        seq.append(BLANK_ID)
    s = len(seq)
    if t < s // 2:
        return []

    alpha = np.full((t, s), NEG_INF, dtype=np.float64)
    back = np.zeros((t, s), dtype=np.int8)
    alpha[0, 0] = float(logprobs[0, seq[0]])
    if s > 1:
        alpha[0, 1] = float(logprobs[0, seq[1]])
        back[0, 1] = 1

    for ti in range(1, t):
        for si in range(s):
            candidates = [(alpha[ti - 1, si], 0)]  # stay
            if si > 0:
                candidates.append((alpha[ti - 1, si - 1], 1))  # advance
            if si > 1 and seq[si] != BLANK_ID and seq[si] != seq[si - 2]:
                candidates.append((alpha[ti - 1, si - 2], 2))  # skip blank
            best_prev, best_move = max(candidates, key=lambda x: x[0])
            alpha[ti, si] = best_prev + float(logprobs[ti, seq[si]])
            back[ti, si] = best_move

    # Prefer ending on last blank or last token state.
    end_state = s - 1 if alpha[t - 1, s - 1] >= alpha[t - 1, s - 2] else s - 2
    path = [0] * t
    state = end_state
    for ti in range(t - 1, -1, -1):
        path[ti] = state
        move = back[ti, state]
        if ti == 0:
            break
        if move == 1:
            state -= 1
        elif move == 2:
            state -= 2

    intervals: list[tuple[int, int, int]] = []
    start: int | None = None
    token_index = 0
    for t_idx, state in enumerate(path):
        is_token = state % 2 == 1
        if is_token:
            this_token = state // 2
            if start is None:
                start = t_idx
                token_index = this_token
            elif this_token != token_index:
                intervals.append((token_ids[token_index], start, t_idx))
                start = t_idx
                token_index = this_token
        elif start is not None:
            intervals.append((token_ids[token_index], start, t_idx))
            start = None
    if start is not None and token_index < len(token_ids):
        intervals.append((token_ids[token_index], start, t))
    return intervals


def load_tokens(path: Path) -> list[str]:
    pieces: list[str] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line:
            continue
        piece = line.split(" ", 1)[0]
        pieces.append(piece)
    return pieces


def decode_ids(pieces: list[str], ids: list[int]) -> str:
    text = "".join(pieces[i] for i in ids if 0 <= i < len(pieces))
    return text.replace("\u2581", " ").strip()


def encode_greedy(pieces: list[str], text: str) -> list[int]:
    """Longest-match greedy encode — mirrors Android SentencePieceTokenizer.encode."""
    by_len = sorted(pieces, key=len, reverse=True)
    piece_to_id = {p: i for i, p in enumerate(pieces)}
    normalized = text.strip()
    if normalized and not normalized.startswith("\u2581"):
        normalized = "\u2581" + normalized.replace(" ", "\u2581")
    ids: list[int] = []
    i = 0
    while i < len(normalized):
        matched = False
        for piece in by_len:
            if normalized.startswith(piece, i):
                ids.append(piece_to_id[piece])
                i += len(piece)
                matched = True
                break
        if not matched:
            i += 1
    return ids


def status_for_prob(p: float) -> str:
    # ADR-006 / COREML_CONTRACT / native PronunciationHeadModel thresholds.
    if p < 0.5:
        return "major"
    if p < 0.85:
        return "minor"
    return "ok"


def normalize_arabic(text: str) -> str:
    diacritics = set("ًٌٍَُِّْٰٕٖٜٓٔٗ٘ٙٚٛٝٞٗ")
    return "".join(c for c in text if c not in diacritics).replace("ٱ", "ا").replace(" ", "")


def word_accuracy(expected: list[str], hypothesis: list[str]) -> float:
    if not expected and not hypothesis:
        return 1.0
    if not expected:
        return 0.0
    # Simple normalized LCS ratio (same spirit as TajweedLexicalScoring).
    a = [normalize_arabic(w) for w in expected]
    b = [normalize_arabic(w) for w in hypothesis]
    n, m = len(a), len(b)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if a[i - 1] == b[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
    return dp[n][m] / max(n, m, 1)


def main() -> int:
    for path in (ENCODER, HEAD, TOKENS):
        if not path.exists():
            print(f"ERROR: missing {path}", file=sys.stderr)
            return 1

    pieces = load_tokens(TOKENS)
    print("Loading ONNX encoder…")
    t0 = time.time()
    enc_sess = ort.InferenceSession(str(ENCODER), providers=["CPUExecutionProvider"])
    cold_enc_ms = (time.time() - t0) * 1000
    print(f"  encoder cold load {cold_enc_ms:.0f}ms")
    t0 = time.time()
    head_sess = ort.InferenceSession(str(HEAD), providers=["CPUExecutionProvider"])
    cold_head_ms = (time.time() - t0) * 1000
    print(f"  head cold load {cold_head_ms:.0f}ms")

    # Warm reuse timing
    t0 = time.time()
    _ = ort.InferenceSession(str(ENCODER), providers=["CPUExecutionProvider"])
    warm_enc_ms = (time.time() - t0) * 1000

    results = {
        "cold_encoder_load_ms": cold_enc_ms,
        "cold_head_load_ms": cold_head_ms,
        "recreate_encoder_session_ms": warm_enc_ms,
        "samples": [],
    }

    for wav_path in sorted(SAMPLES.glob("*.wav")):
        meta = EXPECTED.get(wav_path.name)
        if not meta:
            print(f"skip {wav_path.name} (no expected mapping)")
            continue
        wav, sr = sf.read(str(wav_path), dtype="float32")
        if wav.ndim > 1:
            wav = wav.mean(axis=1)
        duration = float(len(wav) / sr)

        t_inf = time.time()
        mel = log_mel(wav)[None, ...]  # (1, 80, T)
        length = np.array([mel.shape[2]], dtype=np.int64)
        outs = enc_sess.run(
            ["logprobs", "encoder_output"],
            {"audio_signal": mel.astype(np.float32), "length": length},
        )
        logprobs, encoder_bt = outs[0][0], outs[1][0]  # drop batch
        # ONNX layout is (512, T_out); convert to time-major (T, 512).
        if encoder_bt.ndim == 2 and encoder_bt.shape[0] == 512 and encoder_bt.shape[1] != 512:
            encoder = encoder_bt.T
        else:
            encoder = encoder_bt
        ids = collapse_ctc(logprobs.argmax(axis=-1).tolist(), blank_id=BLANK_ID)
        hypothesis = decode_ids(pieces, ids)

        expected_ids = encode_greedy(pieces, meta["expected"])
        tokens = []
        if expected_ids:
            intervals = ctc_forced_align(logprobs, expected_ids)
            for token_id, start_f, end_f in intervals:
                s = max(0, min(start_f, encoder.shape[0] - 1))
                e = max(s + 1, min(end_f, encoder.shape[0]))
                pooled = encoder[s:e].mean(axis=0, keepdims=True).astype(np.float32)
                tok = np.array([token_id], dtype=np.int64)
                prob = float(
                    head_sess.run(None, {"enc_feature": pooled, "token_id": tok})[0][0]
                )
                piece = pieces[token_id] if 0 <= token_id < len(pieces) else "?"
                tokens.append(
                    {
                        "text": piece.replace("\u2581", ""),
                        "status": status_for_prob(prob),
                        "prob": prob,
                        "startSec": start_f * FRAME_HOP_S,
                        "endSec": end_f * FRAME_HOP_S,
                    }
                )

        expected_words = meta["expected"].split()
        hyp_words = hypothesis.split()
        report = {
            "ref": meta["ref"],
            "expected": meta["expected"],
            "hypothesis": hypothesis,
            "durationSec": duration,
            "wordAccuracy": word_accuracy(expected_words, hyp_words),
            "exactMatch": normalize_arabic(hypothesis) == normalize_arabic(meta["expected"]),
            "tokens": tokens,
        }
        infer_ms = (time.time() - t_inf) * 1000
        print(
            f"{wav_path.name}: hyp='{hypothesis}' exact={report['exactMatch']} "
            f"acc={report['wordAccuracy']:.2f} tokens={len(tokens)} infer={infer_ms:.0f}ms"
        )
        results["samples"].append(
            {
                "sample": wav_path.name,
                "inference_ms": infer_ms,
                "score": report,
            }
        )

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(results, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"Wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
