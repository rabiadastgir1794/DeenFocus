"""NeMo-compatible log-mel frontend for FastConformer-Quran."""

from __future__ import annotations

import numpy as np

SAMPLE_RATE = 16000
N_FFT = 512
HOP_LEN = 160
N_MELS = 80
PREEMPH = 0.97


def _mel_fb(sr: int = SAMPLE_RATE, n_fft: int = N_FFT, n_mels: int = N_MELS) -> np.ndarray:
    mel_max = 1127.0 * np.log(1.0 + (sr / 2) / 700.0)
    mel_pts = np.linspace(0.0, mel_max, n_mels + 2)
    hz_pts = 700.0 * (np.exp(mel_pts / 1127.0) - 1.0)
    bin_pts = np.floor((n_fft + 1) * hz_pts / sr).astype(int)
    fb = np.zeros((n_mels, n_fft // 2 + 1), dtype=np.float32)
    for m in range(1, n_mels + 1):
        left, center, right = bin_pts[m - 1], bin_pts[m], bin_pts[m + 1]
        for k in range(left, center):
            if center != left:
                fb[m - 1, k] = (k - left) / (center - left)
        for k in range(center, right):
            if right != center:
                fb[m - 1, k] = (right - k) / (right - center)
    return fb


MEL_FB = _mel_fb()


def log_mel(wav: np.ndarray) -> np.ndarray:
    """Return (n_mels, time) float32 features, per-bin mean/var normalized."""
    wav = np.asarray(wav, dtype=np.float32)
    wav = np.append(wav[0:1], wav[1:] - PREEMPH * wav[:-1]).astype(np.float32)
    wav = np.pad(wav, N_FFT // 2, mode="reflect")
    n = 1 + (len(wav) - N_FFT) // HOP_LEN
    if n <= 0:
        raise ValueError("audio too short for mel features")
    frames = np.lib.stride_tricks.as_strided(
        wav,
        shape=(n, N_FFT),
        strides=(HOP_LEN * wav.strides[0], wav.strides[0]),
    ).copy()
    frames *= np.hanning(N_FFT).astype(np.float32)
    spec = np.abs(np.fft.rfft(frames, n=N_FFT, axis=1)) ** 2
    mel = spec @ MEL_FB.T
    lm = np.log(mel + 1e-5).astype(np.float32).T
    return (lm - lm.mean(axis=1, keepdims=True)) / (lm.std(axis=1, keepdims=True) + 1e-5)
