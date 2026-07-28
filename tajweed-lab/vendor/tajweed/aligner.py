"""CTC forced alignment using our fine-tuned FastConformer ONNX export.

Pipeline:
    audio (16 kHz mono float32)
      → log-mel (80-dim, matches NeMo AudioToMelSpectrogramPreprocessor)
      → ONNX FastConformer encoder + CTC head → logprobs[T, V=1025]
      → CTC forced alignment against reference token sequence
      → per-token (start_frame, end_frame) → per-token (start_s, end_s)
      → per-character intervals (split equal-width inside each token)
      → grapheme→phoneme mapping → PhonemeInterval list

The output PhonemeIntervals plug directly into TajweedEngine.score().
"""
from __future__ import annotations

import math
import os
import sys
import wave
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Sequence

import numpy as np

# CRITICAL ordering: import torch BEFORE _register_cuda_dll_dirs runs.
# torch ships its own CUDA 11.8 cuDNN 9.1; onnxruntime-gpu wants CUDA 12 +
# cuDNN 9.2. If we register CUDA 12 paths first, torch fails to load its
# own DLLs. Importing torch first binds its bundled DLLs into the process
# (Windows caches DLL handles per name), so later PATH changes don't break
# torch.
try:
    import torch as _torch_eager  # noqa: F401
except ImportError:
    # OK if torch isn't installed — caller doesn't have to use CUDA log-mel.
    pass


def _register_cuda_dll_dirs() -> None:
    """Make pip-installed nvidia-* runtime DLLs visible to onnxruntime-gpu.

    Without this, ort fails to load cublasLt64_12.dll / cudnn_*.dll because
    the wheel directories aren't on PATH. Python 3.8+ on Windows requires
    explicit `os.add_dll_directory` for DLL discovery in non-PATH dirs.
    """
    if sys.platform != "win32":
        return
    try:
        import importlib.util
        bases = []
        for pkg in ("nvidia.cuda_runtime", "nvidia.cublas",
                    "nvidia.cudnn", "nvidia.cuda_nvrtc", "nvidia.cufft",
                    "nvidia.curand", "nvidia.cusolver", "nvidia.cusparse",
                    "nvidia.nvjitlink"):
            try:
                spec = importlib.util.find_spec(pkg)
                if spec and spec.submodule_search_locations:
                    bases.append(Path(spec.submodule_search_locations[0]))
            except Exception:
                continue
        added_paths: list[str] = []
        for base in bases:
            for sub in ("bin", base):
                d = (base / sub) if isinstance(sub, str) else sub
                if d.is_dir():
                    sd = str(d)
                    added_paths.append(sd)
                    try:
                        os.add_dll_directory(sd)
                    except OSError:
                        pass
        # CRITICAL: Windows LoadLibrary searches PATH for *transitive*
        # DLL loads (i.e. when onnxruntime_providers_cuda.dll resolves
        # cublasLt64_12.dll). os.add_dll_directory does NOT propagate
        # to those secondary loads. So we also prepend to PATH.
        if added_paths:
            os.environ["PATH"] = os.pathsep.join(added_paths) + os.pathsep + os.environ.get("PATH", "")
    except Exception:
        pass


_register_cuda_dll_dirs()

try:
    import onnxruntime as ort
except ImportError as e:  # pragma: no cover
    raise ImportError("onnxruntime required: pip install onnxruntime") from e

try:
    import sentencepiece as spm
except ImportError as e:  # pragma: no cover
    raise ImportError("sentencepiece required: pip install sentencepiece") from e

from .engine import PhonemeInterval


# ---------- audio loading ----------

def load_wav_mono_16k(path: str | Path) -> np.ndarray:
    """Load WAV → float32 mono @ 16 kHz. Linear-resample if needed."""
    with wave.open(str(path), "rb") as w:
        sr = w.getframerate()
        n = w.getnframes()
        ch = w.getnchannels()
        sw = w.getsampwidth()
        raw = w.readframes(n)
    if sw == 2:
        x = np.frombuffer(raw, dtype=np.int16).astype(np.float32) / 32768.0
    elif sw == 4:
        x = np.frombuffer(raw, dtype=np.int32).astype(np.float32) / 2147483648.0
    else:
        raise ValueError(f"Unsupported sample width {sw}")
    if ch > 1:
        x = x.reshape(-1, ch).mean(axis=1)
    if sr != 16000:
        idx = np.linspace(0, len(x) - 1, num=int(len(x) * 16000 / sr))
        x = np.interp(idx, np.arange(len(x)), x).astype(np.float32)
    return x


# ---------- log-mel matching NeMo AudioToMelSpectrogramPreprocessor ----------

class LogMelExtractor:
    """80-dim log-mel matching the FastConformer preprocessor config:
        sample_rate=16000, window=0.025, hop=0.010, n_fft=512, n_mels=80,
        log=True, normalize='per_feature', dither=1e-5.

    NeMo uses the Slaney mel filterbank convention. We replicate it with numpy
    so we don't pull in torchaudio here.

    Performance note: this CPU implementation is the dominant bottleneck for
    the bank builder (~150 ms/clip). For batched workloads use
    `CudaLogMelExtractor` which moves STFT + matmul to GPU (10x faster).
    """
    def __init__(
        self,
        sample_rate: int = 16000,
        window_s: float = 0.025,
        hop_s: float = 0.010,
        n_fft: int = 512,
        n_mels: int = 80,
        dither: float = 1e-5,
    ):
        self.sr = sample_rate
        self.win_n = int(round(sample_rate * window_s))
        self.hop_n = int(round(sample_rate * hop_s))
        self.n_fft = n_fft
        self.n_mels = n_mels
        self.dither = dither
        self.window = np.hanning(self.win_n).astype(np.float32)
        # Slaney mel filterbank: linear up to 1 kHz, log above
        self.mel_fb = _slaney_mel_filterbank(
            sample_rate=sample_rate, n_fft=n_fft, n_mels=n_mels, fmin=0.0, fmax=sample_rate / 2
        )

    def __call__(self, audio: np.ndarray) -> np.ndarray:
        """Returns (80, T_frames) float32, per-feature normalised."""
        x = audio.astype(np.float32, copy=True)
        if self.dither > 0:
            x = x + self.dither * np.random.RandomState(0).randn(len(x)).astype(np.float32)
        # Pre-emphasis is NOT applied in NeMo's preprocessor by default.
        # Pad to ensure last frame fits
        pad = self.win_n - 1
        x = np.pad(x, (0, max(0, pad)), mode="constant")
        n_frames = max(1, 1 + (len(x) - self.win_n) // self.hop_n)
        # STFT
        frames = np.lib.stride_tricks.as_strided(
            x,
            shape=(n_frames, self.win_n),
            strides=(x.strides[0] * self.hop_n, x.strides[0]),
        ).copy()
        frames = frames * self.window
        # FFT magnitude squared (power spectrogram)
        spec = np.fft.rfft(frames, n=self.n_fft, axis=1)
        power = np.real(spec * np.conj(spec)).astype(np.float32)  # (T, n_fft/2+1)
        # Mel projection
        mel = power @ self.mel_fb.T  # (T, n_mels)
        # log: NeMo uses log(x + epsilon) with eps=2^-24
        mel = np.log(mel + 2 ** -24)
        # Transpose to (n_mels, T)
        feats = mel.T
        # per_feature normalisation
        mean = feats.mean(axis=1, keepdims=True)
        std = feats.std(axis=1, keepdims=True) + 1e-5
        feats = (feats - mean) / std
        return feats.astype(np.float32)


class CudaLogMelExtractor:
    """GPU-resident version of LogMelExtractor.

    Pre-computes the Slaney mel filterbank and Hann window on GPU once at
    init. Per call: STFT (cuFFT) + matmul + log + per-feature norm — all on
    the GPU. Accepts a batch of variable-length audio tensors.

    Validated to match CPU LogMelExtractor at < 1e-4 absolute max-diff
    (any larger diff would break our 0.00 % TER alignment, so see
    scripts/validate_cuda_logmel.py for the safety check).
    """
    def __init__(
        self,
        sample_rate: int = 16000,
        window_s: float = 0.025,
        hop_s: float = 0.010,
        n_fft: int = 512,
        n_mels: int = 80,
        device: str = "cuda",
        dtype: "torch.dtype" = None,
    ):
        import torch
        self.torch = torch
        self.sr = sample_rate
        self.win_n = int(round(sample_rate * window_s))
        self.hop_n = int(round(sample_rate * hop_s))
        self.n_fft = n_fft
        self.n_mels = n_mels
        self.device = device
        self.dtype = dtype if dtype is not None else torch.float32
        # Use the SAME Slaney filterbank as the numpy version → same outputs.
        mel_fb_np = _slaney_mel_filterbank(sample_rate, n_fft, n_mels, 0.0, sample_rate / 2)
        self.mel_fb = torch.from_numpy(mel_fb_np).to(device=device, dtype=self.dtype)
        self.window = torch.hann_window(self.win_n, periodic=False, device=device, dtype=self.dtype)

    @staticmethod
    def from_cpu_template(cpu: "LogMelExtractor", device: str = "cuda") -> "CudaLogMelExtractor":
        return CudaLogMelExtractor(
            sample_rate=cpu.sr,
            window_s=cpu.win_n / cpu.sr,
            hop_s=cpu.hop_n / cpu.sr,
            n_fft=cpu.n_fft,
            n_mels=cpu.n_mels,
            device=device,
        )

    def __call__(self, audio_batch: List[np.ndarray]) -> List[np.ndarray]:
        """Returns a list of (n_mels, T_frames) float32 arrays, per-feature
        normalised, ready to be padded into a single ONNX batch."""
        import torch
        if not audio_batch:
            return []
        # Pad audio to max length so we can run one big STFT.
        max_len = max(a.shape[0] for a in audio_batch)
        # Right-pad each to (max_len + win_n - 1) so the trailing frame fits,
        # matching the CPU implementation's `np.pad(x, (0, win_n - 1))`.
        padded = np.zeros((len(audio_batch), max_len + self.win_n - 1), dtype=np.float32)
        true_lens = np.zeros(len(audio_batch), dtype=np.int64)
        for i, a in enumerate(audio_batch):
            padded[i, : a.shape[0]] = a
            true_lens[i] = a.shape[0]
        x = torch.from_numpy(padded).to(device=self.device, dtype=self.dtype)
        # STFT: shape (B, n_fft/2+1, T_frames_max), complex
        spec = torch.stft(
            x, n_fft=self.n_fft, win_length=self.win_n, hop_length=self.hop_n,
            window=self.window, center=False, return_complex=True, normalized=False,
        )
        power = spec.real ** 2 + spec.imag ** 2  # (B, F, T)
        # Mel projection: mel_fb (n_mels, F) @ power (B, F, T) → (B, n_mels, T)
        mel = torch.einsum("mf,bft->bmt", self.mel_fb, power)
        # log(mel + 2^-24) — same epsilon as CPU version
        log_mel = torch.log(mel + (2.0 ** -24))  # (B, M, T_max)

        # Batched per-feature normalisation (single CUDA sync at the end).
        # Per-clip valid frame count: 1 + (true_len - 1) / hop after right-pad.
        B, M, T_max = log_mel.shape
        valid_lens = [
            int(1 + max(0, int(tl) + self.win_n - 1 - self.win_n) // self.hop_n)
            for tl in true_lens
        ]
        # Mask: (B, 1, T_max), 1 where frame is valid, 0 in padding
        mask = torch.zeros((B, 1, T_max), device=self.device, dtype=self.dtype)
        for i, v in enumerate(valid_lens):
            mask[i, 0, :v] = 1.0
        counts = mask.sum(dim=2, keepdim=True)  # (B, 1, 1)
        mean = (log_mel * mask).sum(dim=2, keepdim=True) / counts  # (B, M, 1)
        var = ((log_mel - mean) ** 2 * mask).sum(dim=2, keepdim=True) / counts
        std = var.sqrt() + 1e-5
        normalized = (log_mel - mean) / std  # (B, M, T_max)
        # Single host transfer
        arr = normalized.cpu().numpy().astype(np.float32)
        return [arr[i, :, : valid_lens[i]] for i in range(B)]


def _slaney_mel_filterbank(sample_rate: int, n_fft: int, n_mels: int, fmin: float, fmax: float) -> np.ndarray:
    """Reproduces librosa/slaney-style mel filterbank in numpy."""
    def hz_to_mel(f):
        f_min = 0.0
        f_sp = 200.0 / 3
        min_log_hz = 1000.0
        min_log_mel = (min_log_hz - f_min) / f_sp
        logstep = np.log(6.4) / 27.0
        f_safe = np.maximum(f, 1e-3)  # avoid log(0) at DC bin
        return np.where(
            f_safe < min_log_hz,
            (f_safe - f_min) / f_sp,
            min_log_mel + np.log(f_safe / min_log_hz) / logstep,
        )

    def mel_to_hz(m: float) -> float:
        f_min = 0.0
        f_sp = 200.0 / 3
        min_log_hz = 1000.0
        min_log_mel = (min_log_hz - f_min) / f_sp
        logstep = np.log(6.4) / 27.0
        return np.where(
            m < min_log_mel,
            f_min + f_sp * m,
            min_log_hz * np.exp(logstep * (m - min_log_mel)),
        )

    mel_min = hz_to_mel(fmin)
    mel_max = hz_to_mel(fmax)
    mel_points = np.linspace(mel_min, mel_max, n_mels + 2)
    hz_points = mel_to_hz(mel_points)
    bin_freqs = np.linspace(0, sample_rate / 2, n_fft // 2 + 1)
    fb = np.zeros((n_mels, n_fft // 2 + 1), dtype=np.float32)
    for i in range(n_mels):
        lo, ctr, hi = hz_points[i], hz_points[i + 1], hz_points[i + 2]
        left = (bin_freqs - lo) / (ctr - lo + 1e-12)
        right = (hi - bin_freqs) / (hi - ctr + 1e-12)
        fb[i] = np.maximum(0, np.minimum(left, right))
        # Slaney normalisation: 2/(hi-lo)
        enorm = 2.0 / (hi - lo + 1e-12)
        fb[i] *= enorm
    return fb


# ---------- CTC forced alignment ----------

@dataclass
class TokenInterval:
    token_id: int
    token_str: str  # e.g. "▁ال" or "ر"
    start_s: float
    end_s: float


def ctc_forced_align(
    logprobs: np.ndarray,
    token_ids: Sequence[int],
    blank_id: int,
) -> List[tuple[int, int]]:
    """Trellis-based forced alignment.

    logprobs: (T, V) numpy array of log-softmaxed CTC outputs.
    token_ids: target token sequence (must be reachable; no consecutive
      same-token collapse — caller handles repeats by separating with blanks).

    Returns list of (start_frame, end_frame) per token (half-open).
    """
    T, _V = logprobs.shape
    # Insert blanks between every token to allow standard CTC alignment.
    # Sequence becomes: B t0 B t1 B t2 ... B tN B
    seq = [blank_id]
    for t in token_ids:
        seq.append(int(t))
        seq.append(blank_id)
    S = len(seq)
    if T < S // 2:
        raise ValueError(f"Audio too short: T={T} frames, but need >= {S // 2} for {len(token_ids)} tokens")

    NEG_INF = -1e18
    seq_arr = np.asarray(seq, dtype=np.int64)
    # emit[t, s] = logprob of producing token seq[s] at time t (gather across V)
    emit = logprobs[:, seq_arr]  # (T, S)
    alpha = np.full((T, S), NEG_INF, dtype=np.float64)
    back = np.zeros((T, S), dtype=np.int8)

    # init
    alpha[0, 0] = emit[0, 0]
    if S > 1:
        alpha[0, 1] = emit[0, 1]

    # Pre-compute which states can take the s-2 skip (non-blank and != seq[s-2])
    skip_ok = np.zeros(S, dtype=bool)
    if S >= 3:
        skip_ok[2:] = (seq_arr[2:] != blank_id) & (seq_arr[2:] != seq_arr[:-2])

    for t in range(1, T):
        prev = alpha[t - 1]
        # c0 = prev[s], c1 = prev[s-1] (shifted), c2 = prev[s-2] (shifted) when allowed
        c0 = prev
        c1 = np.empty(S, dtype=np.float64)
        c1[0] = NEG_INF
        c1[1:] = prev[:-1]
        c2 = np.full(S, NEG_INF, dtype=np.float64)
        if S >= 3:
            c2[2:] = np.where(skip_ok[2:], prev[:-2], NEG_INF)
        # Compute argmax across (c0, c1, c2)
        stacked = np.stack([c0, c1, c2], axis=0)  # (3, S)
        best_idx = np.argmax(stacked, axis=0)     # (S,) in {0,1,2}
        best_val = stacked[best_idx, np.arange(S)]
        alpha[t] = best_val + emit[t]
        # Store back-pointer as (0,-1,-2) using the index → offset mapping
        back[t] = -best_idx.astype(np.int8)

    # End state: must be at S-1 (last blank) or S-2 (last token)
    end_candidates = [(alpha[T - 1, S - 1], S - 1)]
    if S >= 2:
        end_candidates.append((alpha[T - 1, S - 2], S - 2))
    _best_score, s = max(end_candidates, key=lambda x: x[0])

    # Backtrack
    path: list[int] = [s]
    for t in range(T - 1, 0, -1):
        s = s + back[t, s]
        path.append(s)
    path.reverse()
    # path is a sequence of indices into `seq`. Convert to per-token intervals.
    intervals: list[tuple[int, int]] = []
    cur_token_idx = -1
    cur_start = 0
    for t, s in enumerate(path):
        if seq[s] == blank_id:
            continue
        # Token index in original token_ids = (s - 1) // 2
        tok_idx = (s - 1) // 2
        if tok_idx != cur_token_idx:
            if cur_token_idx >= 0:
                intervals.append((cur_start, t))
            cur_token_idx = tok_idx
            cur_start = t
    if cur_token_idx >= 0:
        intervals.append((cur_start, T))
    # Pad with zero-width intervals for any tokens never visited (shouldn't
    # happen if input was valid, but defensive)
    while len(intervals) < len(token_ids):
        last = intervals[-1][1] if intervals else 0
        intervals.append((last, last))
    return intervals[: len(token_ids)]


# ---------- main aligner class ----------

class CTCAligner:
    """End-to-end aligner: audio + reference text → PhonemeIntervals.

    Frame rate: FastConformer subsamples 8x at 10 ms hop → output frames at
    80 ms each (12.5 fps).
    """
    OUTPUT_HOP_S = 0.080  # 80 ms per output frame
    BLANK_ID = 1024       # vocab is 1024 BPE tokens; index 1024 is CTC blank

    def __init__(
        self,
        model_path: str | Path,
        tokenizer_path: str | Path,
        cuda_feats: bool = True,
        onnx_providers: Optional[List[str]] = None,
    ):
        # Default: prefer CUDA, fall back to CPU. With onnxruntime-gpu installed,
        # the FastConformer encoder runs on GPU and CPU is no longer the bottleneck.
        if onnx_providers is None:
            available = ort.get_available_providers()
            if "CUDAExecutionProvider" in available:
                onnx_providers = ["CUDAExecutionProvider", "CPUExecutionProvider"]
            else:
                onnx_providers = ["CPUExecutionProvider"]
        self.session = ort.InferenceSession(str(model_path), providers=onnx_providers)
        active = self.session.get_providers()
        print(f"  ONNX session providers (in order): {active}")
        self.tokenizer = spm.SentencePieceProcessor(model_file=str(tokenizer_path))
        self.feat = LogMelExtractor()
        self.cuda_feat: Optional[CudaLogMelExtractor] = None
        if cuda_feats:
            try:
                self.cuda_feat = CudaLogMelExtractor.from_cpu_template(self.feat, device="cuda")
            except Exception as e:
                print(f"WARN: CUDA log-mel init failed ({e}); falling back to CPU.")

    def _has_encoder_output(self) -> bool:
        """True iff the ONNX session was built from model_with_encoder.onnx."""
        return any(o.name == "encoder_output" for o in self.session.get_outputs())

    def _run_model(self, audio: np.ndarray) -> np.ndarray:
        feats = self.feat(audio)  # (80, T_in)
        feats = feats[None, ...]  # (1, 80, T_in)
        length = np.array([feats.shape[2]], dtype=np.int64)
        logprobs, = self.session.run(["logprobs"], {"audio_signal": feats, "length": length})
        # logprobs: (1, T_out, V)
        return logprobs[0]

    def _run_model_with_encoder(self, audio: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
        """Returns (logprobs[T_out, V], encoder_features[T_out, 512]).
        Only valid when the session has encoder_output (i.e. model_with_encoder.onnx).
        """
        feats = self.feat(audio)[None, ...]
        length = np.array([feats.shape[2]], dtype=np.int64)
        outs = self.session.run(["logprobs", "encoder_output"], {"audio_signal": feats, "length": length})
        logprobs = outs[0][0]                       # (T_out, V)
        enc = outs[1][0]                            # (D=512, T_out)
        return logprobs, enc.T                       # transpose to (T_out, D)

    def _run_model_batch(self, audios: List[np.ndarray]) -> List[np.ndarray]:
        """Batched ONNX forward — pad features to max time, run once."""
        if not audios:
            return []
        if self.cuda_feat is not None:
            feat_list = self.cuda_feat(audios)
        else:
            feat_list = [self.feat(a) for a in audios]  # each (80, T_i)
        Tmax = max(f.shape[1] for f in feat_list)
        B = len(feat_list)
        batch = np.zeros((B, 80, Tmax), dtype=np.float32)
        lengths = np.zeros(B, dtype=np.int64)
        for i, f in enumerate(feat_list):
            batch[i, :, : f.shape[1]] = f
            lengths[i] = f.shape[1]
        logprobs, = self.session.run(["logprobs"], {"audio_signal": batch, "length": lengths})
        # logprobs: (B, T_out_max, V). Slice each to its actual length.
        # ONNX FastConformer subsamples 8x; out_len = ceil(in_len / 8)
        return [logprobs[i, : (int(lengths[i]) + 7) // 8] for i in range(B)]

    def align_tokens_batch(self, audios: List[np.ndarray], texts: List[str]) -> List[List[TokenInterval]]:
        assert len(audios) == len(texts)
        logprobs_list = self._run_model_batch(audios)
        out: list[list[TokenInterval]] = []
        for lp, text in zip(logprobs_list, texts):
            token_ids = self.tokenizer.encode(text, out_type=int)
            intervals = ctc_forced_align(lp, token_ids, blank_id=self.BLANK_ID)
            out.append([
                TokenInterval(
                    token_id=tok_id, token_str=self.tokenizer.id_to_piece(tok_id),
                    start_s=a * self.OUTPUT_HOP_S, end_s=b * self.OUTPUT_HOP_S,
                )
                for tok_id, (a, b) in zip(token_ids, intervals)
            ])
        return out

    def align_phonemes_batch(self, audios: List[np.ndarray], texts: List[str]) -> List[List[PhonemeInterval]]:
        token_lists = self.align_tokens_batch(audios, texts)
        out: list[list[PhonemeInterval]] = []
        for tokens in token_lists:
            intervals: list[PhonemeInterval] = []
            for tok in tokens:
                piece = tok.token_str.replace("▁", "")
                if not piece:
                    continue
                chars = list(piece)
                dur = (tok.end_s - tok.start_s) / max(1, len(chars))
                for i, ch in enumerate(chars):
                    phoneme, expected = _char_to_phoneme(ch)
                    if phoneme is None:
                        continue
                    intervals.append(PhonemeInterval(
                        phoneme=phoneme,
                        start_s=tok.start_s + i * dur,
                        end_s=tok.start_s + (i + 1) * dur,
                        expected=expected,
                    ))
            out.append(intervals)
        return out

    def align_tokens(self, audio: np.ndarray, reference_text: str) -> List[TokenInterval]:
        logprobs = self._run_model(audio)
        token_ids = self.tokenizer.encode(reference_text, out_type=int)
        intervals = ctc_forced_align(logprobs, token_ids, blank_id=self.BLANK_ID)
        out = []
        for tok_id, (a, b) in zip(token_ids, intervals):
            piece = self.tokenizer.id_to_piece(tok_id)
            out.append(TokenInterval(
                token_id=tok_id,
                token_str=piece,
                start_s=a * self.OUTPUT_HOP_S,
                end_s=b * self.OUTPUT_HOP_S,
            ))
        return out

    def align_phonemes(self, audio: np.ndarray, reference_text: str) -> List[PhonemeInterval]:
        """Token alignment → split each token into per-character intervals →
        each Arabic character is mapped to a phoneme label."""
        tokens = self.align_tokens(audio, reference_text)
        intervals: list[PhonemeInterval] = []
        for tok in tokens:
            # SentencePiece pieces start with ▁ for word-initial pieces; strip it
            piece = tok.token_str.replace("▁", "")
            if not piece:
                continue
            chars = list(piece)
            dur = (tok.end_s - tok.start_s) / max(1, len(chars))
            for i, ch in enumerate(chars):
                phoneme, expected = _char_to_phoneme(ch)
                if phoneme is None:
                    continue
                intervals.append(PhonemeInterval(
                    phoneme=phoneme,
                    start_s=tok.start_s + i * dur,
                    end_s=tok.start_s + (i + 1) * dur,
                    expected=expected,
                ))
        return intervals


# ---------- minimal Arabic G2P table ----------
# Maps a single Arabic character to (phoneme_label, expected_metadata).
# Diacritics influence the *previous* character (handled by stripping them as
# a separate pass — done in _char_to_phoneme). This is intentionally simple;
# Phase 2c can replace it with a richer table.

_ARABIC_LETTER_MAP = {
    "ا": ("aa", {"beats": 2}),     # alif as madd
    "ب": ("b", {}),
    "ت": ("t", {}),
    "ث": ("th", {}),
    "ج": ("j", {}),
    "ح": ("H", {}),
    "خ": ("kh", {}),
    "د": ("d", {}),
    "ذ": ("dh", {}),
    "ر": ("r", {"vowel_context": "fatha"}),  # default; G2P can refine
    "ز": ("z", {}),
    "س": ("s", {}),
    "ش": ("sh", {}),
    "ص": ("S", {}),
    "ض": ("D", {}),
    "ط": ("T", {}),
    "ظ": ("Z", {}),
    "ع": ("3", {}),
    "غ": ("gh", {}),
    "ف": ("f", {}),
    "ق": ("q", {}),
    "ك": ("k", {}),
    "ل": ("l", {}),
    "م": ("m", {}),
    "ن": ("n", {}),
    "ه": ("h", {}),
    "و": ("w", {}),
    "ي": ("y", {}),
    "ة": ("h", {}),
    "ى": ("aa", {"beats": 2}),
    "ء": ("'", {}),
    "أ": ("'", {}),
    "إ": ("'", {}),
    "آ": ("aa", {"beats": 2}),
    "ؤ": ("'", {}),
    "ئ": ("'", {}),
}

# Tashkeel codepoints (consumed by the previous letter)
_FATHA = "َ"
_KASRA = "ِ"
_DAMMA = "ُ"
_SUKUN = "ْ"
_SHADDA = "ّ"
_FATHATAN = "ً"
_DAMMATAN = "ٌ"
_KASRATAN = "ٍ"


def _char_to_phoneme(ch: str) -> tuple[str | None, dict]:
    """Map an Arabic character to (phoneme, expected_metadata)."""
    if ch in _ARABIC_LETTER_MAP:
        return _ARABIC_LETTER_MAP[ch]
    # Diacritics are consumed by the previous letter — they don't have their
    # own time slot in the simple G2P. We drop them here.
    return None, {}
