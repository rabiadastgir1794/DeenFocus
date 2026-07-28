"""High-level tajweed engine.

Orchestrates the rule functions over a sequence of phoneme-level intervals,
where each interval is `{phoneme: str, start_s: float, end_s: float}`.

The engine is dependency-free at runtime apart from numpy + scipy; the
phoneme intervals come from MMS-FA (Phase 2b) — when that's not wired yet
you can hand-build them for testing.
"""
from __future__ import annotations

from dataclasses import dataclass, field, asdict
from typing import Iterable, List, Sequence

import numpy as np

from . import rules
from . import phonology as ph


@dataclass
class PhonemeInterval:
    phoneme: str
    start_s: float
    end_s: float
    expected: dict = field(default_factory=dict)  # e.g. {'beats': 2}, {'vowel_context': 'fatha'}

    @property
    def duration_s(self) -> float:
        return self.end_s - self.start_s


@dataclass
class RuleResult:
    phoneme: str
    start_s: float
    end_s: float
    measurements: List[dict]

    def to_dict(self) -> dict:
        return asdict(self)


class TajweedEngine:
    """Score a single recitation utterance.

    Usage:
        engine = TajweedEngine(sample_rate=16000)
        results = engine.score(audio_np_array, intervals)
        for r in results:
            print(r.phoneme, r.measurements)
    """

    def __init__(self, sample_rate: int = 16000):
        self.sr = sample_rate

    def _slice(self, audio: np.ndarray, start_s: float, end_s: float) -> np.ndarray:
        a = max(0, int(start_s * self.sr))
        b = min(len(audio), int(end_s * self.sr))
        return audio[a:b].astype(np.float32, copy=False)

    def score(self, audio: np.ndarray, intervals: Sequence[PhonemeInterval]) -> List[RuleResult]:
        if audio.ndim > 1:
            raise ValueError("audio must be mono float32")
        out: List[RuleResult] = []
        for i, iv in enumerate(intervals):
            slice_ = self._slice(audio, iv.start_s, iv.end_s)
            measurements: List[dict] = []
            p = iv.phoneme

            # ----- madd (long vowels) -----
            if ph.is_long_vowel(p):
                expected = float(iv.expected.get("beats", 2.0))
                measurements.append(rules.measure_madd(slice_, self.sr, expected_beats=expected))

            # ----- ghunnah (sukun nasal hum) -----
            if ph.is_nasal(p) and iv.expected.get("sukun", False):
                measurements.append(rules.measure_ghunnah(slice_, self.sr))

            # ----- qalqalah (bounce on sukun-qalqalah letter) -----
            if ph.is_qalqalah_letter(p) and iv.expected.get("sukun", False):
                measurements.append(rules.measure_qalqalah(slice_, self.sr))

            # ----- tafkheem / tarqeeq on ر -----
            if ph.is_context_emphatic(p):
                ctx = iv.expected.get("vowel_context", "fatha")
                measurements.append(rules.measure_tafkheem_tarqeeq(slice_, self.sr, context=ctx))

            # ----- ikhfaa (partial nasal closure) -----
            if iv.expected.get("rule_hint") == "ikhfaa":
                measurements.append(rules.measure_ikhfaa(slice_, self.sr))

            # ----- sukun pause (silence interval explicitly tagged) -----
            if iv.expected.get("is_pause", False) or p in {"<sil>", "sp", "spn"}:
                measurements.append(rules.measure_sukun_pause(slice_, self.sr))

            out.append(RuleResult(
                phoneme=p,
                start_s=iv.start_s,
                end_s=iv.end_s,
                measurements=measurements,
            ))
        return out

    def summarise(self, results: Iterable[RuleResult]) -> dict:
        """Aggregate flag counts across an utterance for quick QA."""
        counts: dict[str, dict[str, int]] = {}
        for r in results:
            for m in r.measurements:
                rule = m["rule"]
                flag = m.get("flag", "n/a")
                counts.setdefault(rule, {}).setdefault(flag, 0)
                counts[rule][flag] += 1
        return counts

    # ===================== Tier-1 entry point =====================
    def score_with_annotations(self, audio: np.ndarray, annotations, times) -> List[RuleResult]:
        """Apply Tier-1 tajweed rules using CharAnnotation list + per-char timings.

        Args:
          audio:       mono float32 16 kHz
          annotations: list of CharAnnotation (from text_analyzer.analyze_text)
          times:       list of (start_s, end_s) tuples — same length as annotations,
                        produced by aligning the char sequence against audio.

        Returns a RuleResult per annotation. RuleResult.measurements aggregates
        all rule-dispatch outputs (could be 0, 1, or more per char).
        """
        if audio.ndim > 1:
            raise ValueError("audio must be mono float32")
        if len(times) != len(annotations):
            raise ValueError(f"times ({len(times)}) and annotations ({len(annotations)}) length mismatch")
        out: List[RuleResult] = []
        for a, (start_s, end_s) in zip(annotations, times):
            slice_ = self._slice(audio, start_s, end_s)
            measurements: List[dict] = []
            for r in a.rules:
                name = r["rule"]
                fn = rules.RULE_DISPATCH.get(name)
                if fn is None:
                    continue
                try:
                    m = fn(slice_, self.sr, r.get("params", {}))
                except Exception as e:
                    m = {"rule": name, "flag": "n/a", "error": str(e)}
                # Annotate with user-facing message
                m["msg_en"] = r.get("msg_en", "")
                m["msg_ar"] = r.get("msg_ar", "")
                measurements.append(m)
            out.append(RuleResult(
                phoneme=a.char,
                start_s=start_s,
                end_s=end_s,
                measurements=measurements,
            ))
        return out
