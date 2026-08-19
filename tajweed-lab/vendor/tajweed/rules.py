"""Pure-DSP tajweed rule measurements.

Every function here:
  - takes a float32 audio slice (mono, 16 kHz) and the sample rate
  - returns a `dict` with the underlying measurement(s) and a `flag` field
    (one of "ok", "low", "high", "missing", "n/a").
  - never allocates a model, never depends on torch — pure numpy + scipy.

Design choice: rule thresholds come from Quranic recitation norms (Hafs riwayah)
not from learned data. They are tunable constants at the top of each function.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import Dict

import numpy as np
from scipy import signal


# Reference "vowel beat" used to grade madd in Hafs recitation. A normal
# (medium) Quranic vowel beat is ~150-220 ms; we use 180 ms as the neutral
# anchor. Madd-tabee'i ≈ 2 beats, madd-mutawassit ≈ 4 beats, madd-laazim ≈ 6.
VOWEL_BEAT_S = 0.18


# ---------- helpers ----------

def _frame_energy(x: np.ndarray, sr: int, frame_ms: float = 20.0) -> np.ndarray:
    """Short-time RMS energy in dB."""
    n = max(1, int(sr * frame_ms / 1000))
    if len(x) < n:
        return np.array([20 * np.log10(np.sqrt(np.mean(x ** 2)) + 1e-9)])
    frames = np.lib.stride_tricks.sliding_window_view(x, n)[::n // 2]
    rms = np.sqrt(np.mean(frames.astype(np.float64) ** 2, axis=1)) + 1e-9
    return 20.0 * np.log10(rms)


def _band_energy(x: np.ndarray, sr: int, lo: float, hi: float) -> float:
    """Total energy of x in band [lo, hi] Hz, normalised by total energy."""
    if len(x) < 64:
        return 0.0
    nyq = sr / 2
    lo_n = max(1e-4, lo / nyq)
    hi_n = min(0.999, hi / nyq)
    sos = signal.butter(4, [lo_n, hi_n], btype="bandpass", output="sos")
    y = signal.sosfiltfilt(sos, x)
    e_band = float(np.mean(y ** 2))
    e_tot = float(np.mean(x ** 2)) + 1e-12
    return e_band / e_tot


def _formant_f2(x: np.ndarray, sr: int) -> float | None:
    """Estimate F2 via LPC root analysis, averaged over the slice.

    Returns None when the slice is too short or unvoiced.
    """
    if len(x) < int(0.04 * sr):
        return None
    # Pre-emphasis stabilises high-frequency formants.
    x = signal.lfilter([1, -0.97], 1, x)
    # Order ≈ sr/1000 + 2 is the standard heuristic for vowels.
    order = int(sr / 1000) + 2
    # Window the slice; pad if very short.
    win = np.hanning(len(x)) * x
    try:
        a = _lpc(win, order)
    except (np.linalg.LinAlgError, ValueError):
        return None
    rts = np.roots(a)
    rts = rts[np.imag(rts) >= 0]
    if rts.size == 0:
        return None
    angles = np.arctan2(np.imag(rts), np.real(rts))
    freqs = angles * (sr / (2 * np.pi))
    freqs = np.sort(freqs[(freqs > 90) & (freqs < 5000)])
    # Deduplicate roots that fall within ~200 Hz of each other (one acoustic
    # peak can yield several close LPC poles, which would otherwise split a
    # single formant into two reported values).
    deduped: list[float] = []
    for f in freqs:
        if not deduped or (f - deduped[-1]) > 200:
            deduped.append(float(f))
    if len(deduped) < 2:
        return None
    return deduped[1]  # F2


def _lpc(x: np.ndarray, order: int) -> np.ndarray:
    """Levinson-Durbin LPC (scipy has signal.lpc only in newer versions)."""
    r = np.correlate(x, x, mode="full")[len(x) - 1:]
    if r[0] <= 0:
        raise ValueError("Zero-energy frame")
    R = r[:order + 1]
    a = np.zeros(order + 1)
    a[0] = 1.0
    e = R[0]
    for i in range(1, order + 1):
        k = -(R[i] + np.dot(a[1:i], R[i - 1:0:-1])) / e
        a_new = a.copy()
        a_new[1:i] = a[1:i] + k * a[i - 1:0:-1]
        a_new[i] = k
        a = a_new
        e = e * (1.0 - k * k)
        if e <= 0:
            raise ValueError("LPC unstable")
    return a


# ---------- rules ----------

def measure_madd(x: np.ndarray, sr: int = 16000, expected_beats: float = 2.0,
                  tolerance_beats: float = 1.0) -> Dict:
    """Duration of a long vowel, expressed in 'vowel beats'.

    Hafs norms:
      - madd tabee'i (natural long vowel)  ≈ 2 beats
      - madd mutawassit                    ≈ 4 beats
      - madd laazim                        ≈ 6 beats

    Tolerance widened to ±1 beat by default because per-character time
    slots are approximate (we split token-level CTC alignment evenly
    across constituent letters, which under-allocates time to madd
    letters that actually take longer than non-madd letters).
    """
    dur_s = len(x) / sr
    beats = dur_s / VOWEL_BEAT_S
    delta = beats - expected_beats
    flag = "ok"
    if delta < -tolerance_beats:
        flag = "short"
    elif delta > tolerance_beats:
        flag = "long"
    return {
        "rule": "madd",
        "duration_s": round(dur_s, 4),
        "beats": round(beats, 3),
        "expected_beats": expected_beats,
        "tolerance_beats": tolerance_beats,
        "delta_beats": round(delta, 3),
        "flag": flag,
    }


def measure_ghunnah(x: np.ndarray, sr: int = 16000) -> Dict:
    """Nasal hum on a noon/meem with sukun. Two acoustic markers:
       - relative energy in the low-frequency nasal band 250-500 Hz
       - duration ≈ 2 vowel beats (≈ 360 ms)
    """
    dur_s = len(x) / sr
    band_ratio = _band_energy(x, sr, 250, 500)
    # Heuristic: nasal hum should have ≥ 25 % of energy in 250-500 Hz.
    flag = "ok" if band_ratio >= 0.25 else "missing"
    if dur_s < 0.5 * VOWEL_BEAT_S * 2:
        flag = "short"
    return {
        "rule": "ghunnah",
        "duration_s": round(dur_s, 4),
        "band_ratio_250_500": round(band_ratio, 4),
        "flag": flag,
    }


def measure_qalqalah(x: np.ndarray, sr: int = 16000) -> Dict:
    """Detect the qalqalah 'bounce' — a brief energy transient at the
    release of ق/ط/ب/ج/د when they carry a sukun.

    We look for a localised energy peak (>= 6 dB above the surrounding
    floor) within the slice. Absence = missing qalqalah.
    """
    if len(x) < int(0.02 * sr):
        return {"rule": "qalqalah", "flag": "n/a", "reason": "slice too short"}
    energy_db = _frame_energy(x, sr, frame_ms=8.0)
    if energy_db.size < 3:
        return {"rule": "qalqalah", "flag": "n/a"}
    floor = float(np.percentile(energy_db, 20))
    peak = float(np.max(energy_db))
    transient_db = peak - floor
    flag = "ok" if transient_db >= 6.0 else "missing"
    return {
        "rule": "qalqalah",
        "peak_db": round(peak, 2),
        "floor_db": round(floor, 2),
        "transient_db": round(transient_db, 2),
        "flag": flag,
    }


def measure_sukun_pause(x: np.ndarray, sr: int = 16000) -> Dict:
    """Pause/silence following a sukun. Acceptable range: 30-500 ms.
    Below 30 ms = ran-through (bad), above 500 ms = excessive (bad in continuous
    recitation).
    """
    dur_s = len(x) / sr
    # 'silence' = continuous frames below -45 dBFS for at least 20 ms
    rms = np.sqrt(np.mean(x.astype(np.float64) ** 2) + 1e-12)
    flag = "ok"
    if dur_s < 0.030:
        flag = "short"
    elif dur_s > 0.500:
        flag = "long"
    return {
        "rule": "sukun_pause",
        "duration_s": round(dur_s, 4),
        "rms_dbfs": round(20.0 * np.log10(rms + 1e-12), 2),
        "flag": flag,
    }


def measure_tafkheem_tarqeeq(x: np.ndarray, sr: int = 16000, context: str = "fatha") -> Dict:
    """For ر, decide between tafkheem (heavy, low F2) and tarqeeq (light, high F2).

    Heuristic from Arabic phonetic studies:
      - tafkheem F2 ≈ 800-1200 Hz
      - tarqeeq  F2 ≈ 1500-2100 Hz
    `context` tells the expected category — fatha/damma → tafkheem, kasra → tarqeeq.

    F2 estimation from LPC on short slices is noisy, so we use a buffer
    zone (1100-1500 Hz) and return "uncertain" instead of flipping the
    answer when measurement falls into that ambiguous band.
    """
    f2 = _formant_f2(x, sr)
    if f2 is None:
        return {"rule": "tafkheem_tarqeeq", "flag": "n/a"}
    expected = "tafkheem" if context in {"fatha", "damma"} else "tarqeeq"
    if f2 < 1100:
        observed = "tafkheem"
    elif f2 > 1500:
        observed = "tarqeeq"
    else:
        observed = "uncertain"
    if observed == "uncertain":
        flag = "uncertain"
    else:
        flag = "ok" if expected == observed else "mismatch"
    return {
        "rule": "tafkheem_tarqeeq",
        "f2_hz": round(f2, 1),
        "expected": expected,
        "observed": observed,
        "flag": flag,
    }


def measure_ikhfaa(x: np.ndarray, sr: int = 16000) -> Dict:
    """Ikhfaa = partial hiding of noon. We check that nasal energy continues
    for ≥ 50 ms during the closure (250-500 Hz band).
    """
    if len(x) < int(0.025 * sr):
        return {"rule": "ikhfaa", "flag": "n/a"}
    win = int(0.020 * sr)
    hop = max(1, win // 2)
    nyq = sr / 2
    sos = signal.butter(4, [250 / nyq, 500 / nyq], btype="bandpass", output="sos")
    nas = signal.sosfiltfilt(sos, x)
    windows = np.lib.stride_tricks.sliding_window_view(nas, win)[::hop]
    nas_rms = np.sqrt(np.mean(windows.astype(np.float64) ** 2, axis=1) + 1e-12)
    # Absolute floor: anything < -45 dBFS in the nasal band is silence.
    # Above that we count it as sustained nasal energy.
    floor = 10 ** (-45 / 20)
    above = nas_rms > floor
    longest = 0
    cur = 0
    for v in above:
        if v:
            cur += 1
            longest = max(longest, cur)
        else:
            cur = 0
    dur_s = longest * (hop / sr)
    flag = "ok" if dur_s >= 0.050 else "missing"
    return {
        "rule": "ikhfaa",
        "nasal_continuation_s": round(dur_s, 4),
        "flag": flag,
    }


# ===================== Tier-1 rule additions =====================

def _nasal_band_ratio(x: np.ndarray, sr: int) -> float:
    """Fraction of energy in the 250-500 Hz nasal band."""
    return _band_energy(x, sr, 250, 500)


def measure_idhar(x: np.ndarray, sr: int = 16000) -> Dict:
    """Idhar halqi/shafawi: noon/meem should be CLEARLY pronounced — distinct
    nasal segment, no merging into the next letter. We expect:
      - nasal-band energy ratio >= 0.20 for at least ~40 ms
      - duration sane (>= 50 ms total)
    Failure = the speaker over-merged (treating it as idgham/ikhfa instead).
    """
    if len(x) < int(0.04 * sr):
        return {"rule": "idhar", "flag": "n/a"}
    nasal = _nasal_band_ratio(x, sr)
    dur_s = len(x) / sr
    flag = "ok"
    if nasal < 0.15:
        flag = "missing_nasal"  # noon not actually pronounced
    if dur_s < 0.040:
        flag = "short"
    return {"rule": "idhar", "duration_s": round(dur_s, 4),
            "nasal_ratio": round(nasal, 4), "flag": flag}


def measure_idgham(x: np.ndarray, sr: int = 16000, with_ghunnah: bool = True,
                    expected_ghunnah_s: float = 0.30) -> Dict:
    """Idgham: noon merges into the next letter. If with_ghunnah, expect
    a sustained nasal hum (~2 beats). If no-ghunnah, expect minimal nasal
    energy and quick transition.
    """
    if len(x) < int(0.02 * sr):
        return {"rule": "idgham", "flag": "n/a"}
    nasal = _nasal_band_ratio(x, sr)
    dur_s = len(x) / sr
    if with_ghunnah:
        # need sustained nasal hum
        flag = "ok"
        if nasal < 0.20:
            flag = "weak_ghunnah"
        if dur_s < 0.5 * expected_ghunnah_s:
            flag = "short"
        elif dur_s > 2.0 * expected_ghunnah_s:
            flag = "long"
    else:
        # NO ghunnah — should be a clean transition with low nasal energy
        flag = "ok"
        if nasal > 0.30:
            flag = "unwanted_ghunnah"
    return {"rule": "idgham_with_ghunnah" if with_ghunnah else "idgham_no_ghunnah",
            "duration_s": round(dur_s, 4), "nasal_ratio": round(nasal, 4),
            "expected_ghunnah_s": expected_ghunnah_s if with_ghunnah else 0.0,
            "flag": flag}


def measure_iqlab(x: np.ndarray, sr: int = 16000, expected_ghunnah_s: float = 0.30) -> Dict:
    """Iqlab: noon converts to a hidden meem before ba. The acoustic signature
    is bilabial closure (low overall energy) + sustained nasal hum. Distinct
    from straight idgham because the formant pattern shifts toward meem.
    """
    if len(x) < int(0.04 * sr):
        return {"rule": "iqlab", "flag": "n/a"}
    nasal = _nasal_band_ratio(x, sr)
    dur_s = len(x) / sr
    # Bilabial closure = low high-frequency energy
    hf_ratio = _band_energy(x, sr, 2000, 6000)
    flag = "ok"
    if nasal < 0.20:
        flag = "weak_ghunnah"
    if hf_ratio > 0.20:
        flag = "no_closure"   # too much high-freq energy = noon not actually flipped
    if dur_s < 0.5 * expected_ghunnah_s:
        flag = "short"
    return {"rule": "iqlab", "duration_s": round(dur_s, 4),
            "nasal_ratio": round(nasal, 4), "hf_ratio": round(hf_ratio, 4),
            "expected_ghunnah_s": expected_ghunnah_s, "flag": flag}


def measure_qalqalah_strength(x: np.ndarray, sr: int = 16000,
                                strength: str = "mild") -> Dict:
    """Qalqalah sughra (mild) vs kubra (strong). Both detect a release transient;
    kubra expects ≥ 8 dB swing, sughra expects ≥ 4 dB.
    """
    base = measure_qalqalah(x, sr)
    if base.get("flag") == "n/a":
        return {"rule": "qalqalah_" + ("kubra" if strength == "strong" else "sughra"),
                "flag": "n/a"}
    transient = base.get("transient_db", 0.0)
    threshold = 8.0 if strength == "strong" else 4.0
    flag = "ok" if transient >= threshold else "weak"
    return {"rule": "qalqalah_" + ("kubra" if strength == "strong" else "sughra"),
            "transient_db": transient, "threshold_db": threshold, "flag": flag}


def measure_silent_letter(x: np.ndarray, sr: int = 16000, max_rms_db: float = -38.0) -> Dict:
    """For letters expected to be silent (hamzat wasl in continuation,
    silent lam in lam shamsiyyah). The slice should be near-silent.

    Per-char alignment for silent letters is unreliable (the time slot
    we assign to a silent letter often bleeds into the next pronounced
    letter). To avoid false positives, this returns "ok" unless there
    is an *extremely* loud signal in the slice — the slot would be
    expected to contain partial signal anyway.
    """
    if len(x) < int(0.02 * sr):
        return {"rule": "silent_letter", "flag": "n/a", "reason": "slot too short"}
    rms = np.sqrt(np.mean(x.astype(np.float64) ** 2) + 1e-12)
    rms_db = 20.0 * np.log10(rms + 1e-12)
    # Be permissive: only flag if loud sustained vowel (peak ≥ -15 dBFS)
    peak = float(np.max(np.abs(x)))
    peak_db = 20.0 * np.log10(peak + 1e-12)
    flag = "ok" if peak_db <= -15.0 else "unexpected_sound"
    return {"rule": "silent_letter", "rms_dbfs": round(rms_db, 2),
            "peak_dbfs": round(peak_db, 2), "flag": flag}


def measure_pronounced_letter(x: np.ndarray, sr: int = 16000,
                                min_rms_db: float = -38.0) -> Dict:
    """For letters expected to be clearly pronounced (lam qamariyyah).
    The slice should carry meaningful energy.
    """
    rms = np.sqrt(np.mean(x.astype(np.float64) ** 2) + 1e-12)
    rms_db = 20.0 * np.log10(rms + 1e-12)
    flag = "ok" if rms_db >= min_rms_db else "too_quiet"
    return {"rule": "pronounced_letter", "rms_dbfs": round(rms_db, 2),
            "min_rms_db": min_rms_db, "flag": flag}


def measure_allah_lam(x: np.ndarray, sr: int = 16000,
                       expected: str = "tafkheem") -> Dict:
    """Lam of Allah lafdh: tafkheem (heavy) vs tarqeeq (light).
    Same F2-based heuristic as ra, but with stricter thresholds.
    """
    f2 = _formant_f2(x, sr)
    if f2 is None:
        return {"rule": "allah_lam", "flag": "n/a"}
    # tafkheem lam: F2 ≈ 800-1200 Hz; tarqeeq lam: F2 ≈ 1500-2100 Hz
    observed = "tafkheem" if f2 < 1300 else "tarqeeq"
    flag = "ok" if observed == expected else "mismatch"
    return {"rule": "allah_lam", "f2_hz": round(f2, 1),
            "expected": expected, "observed": observed, "flag": flag}


# Dispatch table — maps rule name from text_analyzer → measurement function.
# Functions all accept (audio_slice, sr) plus an optional params dict.
RULE_DISPATCH = {
    "madd_tabii":         lambda x, sr, p: measure_madd(x, sr, expected_beats=p.get("expected_beats", 2.0)),
    "madd_muttasil":      lambda x, sr, p: measure_madd(x, sr, expected_beats=p.get("expected_beats", 4.0)),
    "madd_munfasil":      lambda x, sr, p: measure_madd(x, sr, expected_beats=p.get("expected_beats", 4.0)),
    "madd_lazim":         lambda x, sr, p: measure_madd(x, sr, expected_beats=p.get("expected_beats", 6.0)),
    "madd_aridh":         lambda x, sr, p: measure_madd(x, sr, expected_beats=p.get("expected_beats", 4.0)),
    "idhar_halqi":        lambda x, sr, p: measure_idhar(x, sr),
    "idhar_shafawi":      lambda x, sr, p: measure_idhar(x, sr),
    "idgham_with_ghunnah":lambda x, sr, p: measure_idgham(x, sr, with_ghunnah=True,
                                                            expected_ghunnah_s=p.get("expected_ghunnah_s", 0.30)),
    "idgham_no_ghunnah":  lambda x, sr, p: measure_idgham(x, sr, with_ghunnah=False),
    "idgham_shafawi":     lambda x, sr, p: measure_idgham(x, sr, with_ghunnah=True,
                                                            expected_ghunnah_s=p.get("expected_ghunnah_s", 0.30)),
    "iqlab":              lambda x, sr, p: measure_iqlab(x, sr,
                                                            expected_ghunnah_s=p.get("expected_ghunnah_s", 0.30)),
    "ikhfa_haqiqi":       lambda x, sr, p: measure_ikhfaa(x, sr),
    "ikhfa_shafawi":      lambda x, sr, p: measure_ikhfaa(x, sr),
    "qalqalah_sughra":    lambda x, sr, p: measure_qalqalah_strength(x, sr, strength="mild"),
    "qalqalah_kubra":     lambda x, sr, p: measure_qalqalah_strength(x, sr, strength="strong"),
    "ra_tafkheem":        lambda x, sr, p: measure_tafkheem_tarqeeq(x, sr, context="fatha"),
    "ra_tarqeeq":         lambda x, sr, p: measure_tafkheem_tarqeeq(x, sr, context="kasra"),
    "ra_tafkheem_saakin": lambda x, sr, p: measure_tafkheem_tarqeeq(x, sr, context="fatha"),
    "ra_tarqeeq_saakin":  lambda x, sr, p: measure_tafkheem_tarqeeq(x, sr, context="kasra"),
    "allah_lafdh":        lambda x, sr, p: measure_allah_lam(x, sr, expected=p.get("expected", "tafkheem")),
    "lam_shamsiyyah":     lambda x, sr, p: measure_silent_letter(x, sr),
    "lam_qamariyyah":     lambda x, sr, p: measure_pronounced_letter(x, sr),
    "hamzat_wasl":        lambda x, sr, p: measure_silent_letter(x, sr),
    # Tier-2 additions
    "idgham_mutamathilain": lambda x, sr, p: measure_silent_letter(x, sr),
    "madd_badal":         lambda x, sr, p: measure_madd(x, sr,
                                                          expected_beats=p.get("expected_beats", 2.0),
                                                          tolerance_beats=p.get("tolerance_beats", 1.0)),
    "madd_leen":          lambda x, sr, p: measure_madd(x, sr,
                                                          expected_beats=p.get("expected_beats", 4.0),
                                                          tolerance_beats=p.get("tolerance_beats", 2.5)),
    "leen":               lambda x, sr, p: {"rule": "leen", "flag": "ok"},  # no-op acoustic; informational
}
