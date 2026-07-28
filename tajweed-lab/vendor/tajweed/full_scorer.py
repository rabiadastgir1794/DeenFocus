"""Composite Phase 3 scorer — the full Tarteel-class pipeline.

Given a learner's audio + the reference ayah text:
  1. CTC forced alignment from FastConformer → grapheme-level intervals
  2. Rule-based tajweed engine → madd / ghunnah / qalqalah / sukun / tafkheem / ikhfaa flags
  3. Trained pronunciation-scoring head → per-phoneme correctness probability
  4. Merge into a single per-phoneme report

The head replaces the older WavLM contrastive scorer (Phase 2c).
WavLM is no longer required at inference time.

For the head to work, the `model_with_encoder.onnx` (Phase 3a re-export) must
be the one passed in as `model_onnx`, so that encoder features are available
alongside CTC logprobs.
"""
from __future__ import annotations

import hashlib
from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import List, Optional

import numpy as np

from .aligner import CTCAligner
from .engine import TajweedEngine
from .text_analyzer import analyze_text


def _text_hash(text: str) -> str:
    return hashlib.sha1(text.encode("utf-8")).hexdigest()[:16]


@dataclass
class PhonemeReport:
    phoneme: str
    start_s: float
    end_s: float
    rule_flags: List[dict] = field(default_factory=list)
    head_prob: Optional[float] = None       # P(token correctly pronounced) ∈ [0, 1]
    head_deviation: Optional[str] = None    # "ok" / "minor" / "major"


@dataclass
class FullReport:
    text: str
    audio_seconds: float
    per_phoneme: List[PhonemeReport]
    summary: dict

    def to_dict(self) -> dict:
        return {
            "text": self.text,
            "audio_seconds": self.audio_seconds,
            "summary": self.summary,
            "per_phoneme": [asdict(p) for p in self.per_phoneme],
        }


class TajweedFullScorer:
    """Wraps the whole Phase 3 pipeline behind one stateful object.

    Heavy components (ONNX session, head checkpoint) load once at init.
    Inference is fast: forward pass through FastConformer + tiny head per clip.
    """
    def __init__(
        self,
        model_onnx: str | Path,
        tokenizer: str | Path,
        head_checkpoint: str | Path | None = None,
        device: str = "cuda",
    ):
        self.aligner = CTCAligner(model_onnx, tokenizer)
        if not self.aligner._has_encoder_output():
            raise ValueError(
                f"ONNX at {model_onnx} does not expose 'encoder_output'. "
                f"Re-run scripts/reexport_onnx_with_encoder.py and pass model_with_encoder.onnx."
            )
        self.engine = TajweedEngine(sample_rate=16000)
        self.head = None
        if head_checkpoint is not None:
            from .head_scorer import HeadPronunciationScorer
            try:
                self.head = HeadPronunciationScorer(head_checkpoint, device=device)
            except Exception as e:
                print(f"WARN: head init failed ({e}); head scoring disabled.")
                self.head = None

    def score(self, audio: np.ndarray, text: str) -> FullReport:
        # 1) Get logprobs + encoder features in one forward pass
        logprobs, encoder_features = self.aligner._run_model_with_encoder(audio)
        # 2) Force-align using logprobs against the expected token sequence
        from .aligner import ctc_forced_align, TokenInterval, _char_to_phoneme
        token_ids = self.aligner.tokenizer.encode(text, out_type=int)
        intervals = ctc_forced_align(logprobs, token_ids, blank_id=self.aligner.BLANK_ID)
        token_intervals = []
        for tok_id, (a, b) in zip(token_ids, intervals):
            token_intervals.append(TokenInterval(
                token_id=tok_id,
                token_str=self.aligner.tokenizer.id_to_piece(tok_id),
                start_s=a * self.aligner.OUTPUT_HOP_S,
                end_s=b * self.aligner.OUTPUT_HOP_S,
            ))
        # 2b) Build per-character timing list aligned to text_analyzer output.
        # We expand each token to its constituent Arabic letters and split the
        # token's audio interval **proportionally** across them, weighting
        # known long-vowel (madd) letters higher because they consume
        # disproportionate audio time. Without per-character CTC, this
        # linguistic-prior weighting is the best we can do.
        from .text_analyzer import ARABIC_LETTERS
        MADD_LETTERS = {"ا", "و", "ي", "ى", "آ"}
        MADD_WEIGHT = 2.5            # empirical optimum; higher values over-steal time from adjacent letters
        char_times: list[tuple[float, float]] = []
        for tok in token_intervals:
            piece = tok.token_str.replace("▁", "")
            if not piece:
                continue
            letters = [c for c in piece if c in ARABIC_LETTERS]
            if not letters:
                continue
            weights = [MADD_WEIGHT if c in MADD_LETTERS else 1.0 for c in letters]
            total_w = sum(weights)
            unit_dur = (tok.end_s - tok.start_s) / total_w
            cur = tok.start_s
            for w in weights:
                seg = unit_dur * w
                char_times.append((cur, cur + seg))
                cur += seg

        annotations = analyze_text(text)
        # Defensive: align by min(len) — if alignment count differs, run only
        # the overlapping prefix and let the rest carry no timing.
        n = min(len(annotations), len(char_times))
        rule_results = self.engine.score_with_annotations(
            audio, annotations[:n], char_times[:n]
        )
        rule_summary = self.engine.summarise(rule_results)

        # 4) Head scoring at token level
        head_scores = []
        if self.head is not None:
            head_scores = self.head.score(encoder_features, token_intervals,
                                          output_hop_s=self.aligner.OUTPUT_HOP_S)
        # Index head scores by start time so we can attach to phoneme rows
        head_by_start = {round(s.start_s, 3): s for s in head_scores}

        # 5) Merge into per-phoneme report
        per_phoneme: list[PhonemeReport] = []
        for r in rule_results:
            # Find token whose interval contains this phoneme's start
            head_match = None
            for ts, hs in head_by_start.items():
                # phoneme falls inside this token's interval
                if hs.start_s <= r.start_s < hs.end_s + 0.01:
                    head_match = hs
                    break
            per_phoneme.append(PhonemeReport(
                phoneme=r.phoneme,
                start_s=r.start_s,
                end_s=r.end_s,
                rule_flags=r.measurements,
                head_prob=(head_match.prob_correct if head_match else None),
                head_deviation=(head_match.deviation if head_match else None),
            ))

        head_summary = {"ok": 0, "minor": 0, "major": 0}
        for s in head_scores:
            head_summary[s.deviation] = head_summary.get(s.deviation, 0) + 1

        return FullReport(
            text=text,
            audio_seconds=len(audio) / 16000.0,
            per_phoneme=per_phoneme,
            summary={"rules": rule_summary, "head": head_summary},
        )
