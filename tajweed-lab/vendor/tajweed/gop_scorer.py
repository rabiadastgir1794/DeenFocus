"""Goodness of Pronunciation (GOP) scoring using our own FastConformer.

The textbook GOP idea (Witt & Young, 2000; Hu et al., 2015 for neural variants):

  For each phoneme (or token, in our case) the learner is *supposed* to say,
  in time interval [t_a, t_b]:

      GOP(p) = mean_{t in [t_a, t_b]} log P(p | frame_t)

  P(p | frame_t) comes from a trained acoustic model's softmax output over
  its phoneme/token vocabulary. A high GOP (near 0) means the model is
  confident the learner produced the expected phoneme. A low GOP (very
  negative) means the model is uncertain or thought a different phoneme
  was uttered → likely mispronunciation.

Why this is the right tool for Quranic recitation scoring:

  1. Our FastConformer was trained on 556 h of diacritized Quranic Arabic.
     Its 1024-token SentencePiece vocab captures Quran-specific phonetic
     contrasts (madd, ghunnah, qalqalah letters, emphatics) better than
     any general-purpose model.
  2. The CTC training objective forces speaker-invariance by construction
     — the same Quranic ayah from different qaris must produce the same
     token sequence, so the encoder learns features that abstract away
     speaker identity.
  3. Zero new parameters, zero training, zero reference bank needed —
     just our existing model.

vs WavLM-Large contrastive scoring:

  - WavLM-Large is generic multilingual self-supervised pretraining; not
    Quran-aware. Its features carry significant speaker timbre (we measured
    median cosine distance 0.30 for two correct qaris on the same ayah).
  - GOP via our FastConformer leverages the supervised, Quran-domain
    objective directly. No reference qari needed — the model itself is
    "the reference."

Output: a `GOPResult` per phoneme with `log_p_expected` (the GOP), `log_p_top`
(the best alternative's log-prob), and `gop_normalized = log_p_expected -
log_p_top` ∈ (-∞, 0]. Closer to 0 = more correct.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import List, Sequence

import numpy as np

from .aligner import CTCAligner, TokenInterval, _char_to_phoneme
from .engine import PhonemeInterval


@dataclass
class GOPResult:
    phoneme: str
    start_s: float
    end_s: float
    log_p_expected: float       # mean log-prob of the expected token in this interval
    log_p_top: float            # mean log-prob of whichever token was most likely
    gop_normalized: float       # log_p_expected - log_p_top, in (-inf, 0]
    confidence: str             # "ok", "weak", "wrong"


def gop_from_logprobs(
    logprobs: np.ndarray, token_intervals: Sequence[TokenInterval],
    output_hop_s: float = 0.080,
    blank_id: int = 1024,
    weak_threshold: float = -0.5,
    wrong_threshold: float = -2.0,
) -> List[GOPResult]:
    """Compute GOP per token from CTC logprobs + the forced alignment.

    logprobs: (T, V) log-softmax CTC outputs.
    token_intervals: per-token (token_id, start_s, end_s) from the aligner.

    CTC-aware definition: CTC outputs are peaky — most frames within a token's
    aligned interval emit the BLANK token, with the expected non-blank token
    spiking in ~1-2 frames. Averaging across the whole interval drowns the
    signal in blank-frame noise. We instead use the **peak frame** for each
    token: the frame where the expected token reaches its maximum log-prob
    in the interval, then compare to the top prediction at that same frame.

      gop_normalized = max_t log P(expected|t) - log P(top|t at that t)

    This is 0 when the model peaks on the expected token (i.e. would have
    predicted it via greedy decode), and increasingly negative as the model's
    peak shifts to a different token.
    """
    T, _V = logprobs.shape
    out: list[GOPResult] = []
    for tok in token_intervals:
        a = max(0, int(round(tok.start_s / output_hop_s)))
        b = min(T, int(round(tok.end_s / output_hop_s)))
        if b <= a:
            b = min(T, a + 1)
        window = logprobs[a:b]  # (frames, V)
        # Peak frame for the expected token within the interval
        expected_per_frame = window[:, tok.token_id]
        peak_idx = int(np.argmax(expected_per_frame))
        expected = float(expected_per_frame[peak_idx])
        # Compare against best NON-BLANK alternative at the same frame.
        frame = window[peak_idx].copy()
        frame[blank_id] = -np.inf  # don't let blank dominate the comparison
        top_lp = float(frame.max())
        gop_norm = expected - top_lp  # ≤ 0 by construction
        if gop_norm > weak_threshold:
            conf = "ok"
        elif gop_norm > wrong_threshold:
            conf = "weak"
        else:
            conf = "wrong"
        out.append(GOPResult(
            phoneme=tok.token_str.replace("▁", "") or "_",
            start_s=tok.start_s,
            end_s=tok.end_s,
            log_p_expected=round(expected, 4),
            log_p_top=round(top_lp, 4),
            gop_normalized=round(gop_norm, 4),
            confidence=conf,
        ))
    return out


class GOPScorer:
    """End-to-end GOP scoring on top of `CTCAligner`.

    Usage:
        scorer = GOPScorer(model_path, tokenizer_path)
        results = scorer.score(audio, reference_text)
        # results = List[GOPResult], one per token (or per phoneme if you call
        # score_per_phoneme).
    """
    def __init__(self, model_path: str, tokenizer_path: str, **kwargs):
        self.aligner = CTCAligner(model_path, tokenizer_path, **kwargs)

    def _logprobs(self, audio: np.ndarray) -> np.ndarray:
        return self.aligner._run_model(audio)

    def score_per_token(self, audio: np.ndarray, text: str) -> List[GOPResult]:
        token_intervals = self.aligner.align_tokens(audio, text)
        logprobs = self._logprobs(audio)
        return gop_from_logprobs(logprobs, token_intervals)

    def score_per_phoneme(self, audio: np.ndarray, text: str) -> List[GOPResult]:
        """Token-level GOP split across characters inside each token, mapped
        to phoneme labels via the simple Arabic G2P table in `aligner`."""
        token_intervals = self.aligner.align_tokens(audio, text)
        logprobs = self._logprobs(audio)
        token_scores = gop_from_logprobs(logprobs, token_intervals)
        out: list[GOPResult] = []
        for tok, gop in zip(token_intervals, token_scores):
            piece = tok.token_str.replace("▁", "")
            if not piece:
                continue
            chars = list(piece)
            dur = (tok.end_s - tok.start_s) / max(1, len(chars))
            # Distribute the same GOP value across each character — finer
            # per-character GOP would need character-level alignment which
            # CTC doesn't give us directly. For Quranic SP tokens that mostly
            # split per-character anyway, the loss is minimal.
            for i, ch in enumerate(chars):
                phoneme, _expected = _char_to_phoneme(ch)
                if phoneme is None:
                    continue
                out.append(GOPResult(
                    phoneme=phoneme,
                    start_s=tok.start_s + i * dur,
                    end_s=tok.start_s + (i + 1) * dur,
                    log_p_expected=gop.log_p_expected,
                    log_p_top=gop.log_p_top,
                    gop_normalized=gop.gop_normalized,
                    confidence=gop.confidence,
                ))
        return out


def summarise(results: Sequence[GOPResult]) -> dict:
    out = {"ok": 0, "weak": 0, "wrong": 0}
    for r in results:
        out[r.confidence] += 1
    out["n"] = len(results)
    out["mean_gop"] = round(float(np.mean([r.gop_normalized for r in results])), 4) if results else 0.0
    return out
