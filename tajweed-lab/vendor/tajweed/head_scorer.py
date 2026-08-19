"""Pronunciation-scoring head — replaces WavLM in the Phase 3 pipeline.

Loads the trained head checkpoint (Phase 3d), takes (encoder_features, token_ids)
as input, and returns per-phoneme correctness probabilities.

Inputs come from the FastConformer ONNX run via the re-exported model that
exposes both `logprobs` and `encoder_output` (Phase 3a).

vs WavLM:
  - 1.33 M params instead of 315 M (200× smaller, fits anywhere)
  - Quran-domain trained (FastConformer encoder + Quran-phonology features)
  - Quran-domain trained, no second model needed on device
  - Discriminative (probability of correct) instead of contrastive distance
  - Doesn't need a reference qari bank — the model itself is the reference
"""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional

import numpy as np

# torch imported lazily so the rule-based path doesn't require it
import torch
import torch.nn as nn


VOCAB_SIZE = 1025
TOK_EMB_DIM = 64
ENC_DIM = 512
HIDDEN = 1024


class PronunciationHead(nn.Module):
    """Same architecture as the training script — load weights into this."""
    def __init__(self, vocab_size=VOCAB_SIZE, enc_dim=ENC_DIM,
                 tok_emb_dim=TOK_EMB_DIM, feat_dim: int = 16, hidden=HIDDEN):
        super().__init__()
        self.tok_emb = nn.Embedding(vocab_size, tok_emb_dim)
        in_dim = enc_dim + tok_emb_dim + feat_dim
        self.mlp = nn.Sequential(
            nn.Linear(in_dim, hidden),
            nn.GELU(),
            nn.Dropout(0.2),
            nn.Linear(hidden, hidden // 2),
            nn.GELU(),
            nn.Dropout(0.2),
            nn.Linear(hidden // 2, hidden // 4),
            nn.GELU(),
            nn.Dropout(0.1),
            nn.Linear(hidden // 4, 1),
        )

    def forward(self, enc_feature, token_id, token_feat):
        emb = self.tok_emb(token_id)
        x = torch.cat([enc_feature, emb, token_feat], dim=-1)
        return self.mlp(x).squeeze(-1)


@dataclass
class HeadScore:
    phoneme: str
    token_id: int
    start_s: float
    end_s: float
    prob_correct: float
    deviation: str   # "ok" (≥0.85), "minor" (0.50-0.85), "major" (<0.50)


class HeadPronunciationScorer:
    """Loads the trained head and applies it to per-token encoder features."""

    def __init__(self, checkpoint_path: str | Path, device: str = "cuda"):
        ckpt = torch.load(checkpoint_path, map_location=device, weights_only=False)
        cfg = ckpt.get("config", {})
        self.device = device
        self.model = PronunciationHead(
            vocab_size=cfg.get("vocab_size", VOCAB_SIZE),
            enc_dim=cfg.get("enc_dim", ENC_DIM),
            tok_emb_dim=cfg.get("tok_emb_dim", TOK_EMB_DIM),
            feat_dim=cfg.get("feat_dim", 16),
            hidden=cfg.get("hidden", HIDDEN),
        ).to(device).eval()
        self.model.load_state_dict(ckpt["state_dict"])
        self.feature_table = torch.as_tensor(ckpt["feature_table"], device=device, dtype=torch.float32)

    @torch.no_grad()
    def score(
        self,
        encoder_features: np.ndarray,  # (T_out, D=512), full clip output of ONNX encoder
        token_intervals: List,         # List[TokenInterval] from CTC alignment
        output_hop_s: float = 0.080,
    ) -> List[HeadScore]:
        """Pool encoder features per token (interval mean), look up token features,
        run through the head. Returns one HeadScore per token interval.
        """
        if not token_intervals:
            return []
        T = encoder_features.shape[0]
        pooled = np.zeros((len(token_intervals), encoder_features.shape[1]), dtype=np.float32)
        for i, iv in enumerate(token_intervals):
            a = max(0, int(round(iv.start_s / output_hop_s)))
            b = max(a + 1, min(T, int(round(iv.end_s / output_hop_s))))
            pooled[i] = encoder_features[a:b].mean(axis=0)
        enc_t = torch.from_numpy(pooled).to(self.device)
        tok_t = torch.tensor([iv.token_id for iv in token_intervals],
                              dtype=torch.long, device=self.device)
        feat_t = self.feature_table[tok_t]
        logits = self.model(enc_t, tok_t, feat_t)
        probs = torch.sigmoid(logits).cpu().numpy()
        out: list[HeadScore] = []
        for i, iv in enumerate(token_intervals):
            p = float(probs[i])
            if p >= 0.40: dev = "ok"
            elif p >= 0.30: dev = "minor"
            else: dev = "major"
            piece = iv.token_str.replace("▁", "") or "_"
            out.append(HeadScore(
                phoneme=piece, token_id=iv.token_id,
                start_s=iv.start_s, end_s=iv.end_s,
                prob_correct=round(p, 4), deviation=dev,
            ))
        return out
