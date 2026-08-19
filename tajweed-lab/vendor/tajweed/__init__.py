"""Tajweed scoring stack — Phase 2.

Builds on top of fine-tuned FastConformer for word-level highlighting and
adds phoneme-level pronunciation/tajweed scoring without requiring annotated
learner audio.

Layout:
    rules.py    — pure-DSP rule functions (madd, ghunnah, qalqalah, ...).
                  Each rule takes an audio slice and returns a measurement +
                  pass/fail flag based on Quranic acoustic norms.
    engine.py   — TajweedEngine: orchestrates rules over phoneme intervals.
    phonology.py — Arabic phoneme class tables (qalqalah letters, emphatics,
                   etc.) used by the engine to route rules per phoneme.
"""
from .engine import TajweedEngine, PhonemeInterval, RuleResult
from . import rules
from . import phonology

__all__ = ["TajweedEngine", "PhonemeInterval", "RuleResult", "rules", "phonology"]

# Heavier modules (depend on torch / onnxruntime) are imported on demand to
# keep `import tajweed` cheap for unit-test code paths.
def _lazy():
    from .aligner import CTCAligner
    from .wavlm_scorer import WavLMFeatureExtractor
    from .full_scorer import TajweedFullScorer
    return CTCAligner, WavLMFeatureExtractor, TajweedFullScorer
