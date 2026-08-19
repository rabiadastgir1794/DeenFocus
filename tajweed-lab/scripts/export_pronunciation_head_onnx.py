#!/usr/bin/env python3
"""Export pronunciation_head.pt → ONNX for Android (ADR-007 / TD-010).

Wraps the trained PronunciationHead so the ONNX graph matches the native
Android/iOS API already used by PronunciationHeadModel:

  inputs:
    enc_feature  — float32 [batch, 512]   (mean-pooled encoder frames)
    token_id     — int64   [batch]
  outputs:
    prob_correct — float32 [batch]        (sigmoid of head logits)

The checkpoint's per-token feature_table (1025×16) is baked into the
exported graph as a constant Embedding lookup, so the mobile runtime does
not need a separate feature_table file or a third input.

Usage (from tajweed-lab, with venv active + torch/onnx installed):
  python scripts/export_pronunciation_head_onnx.py
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

import numpy as np
import torch
import torch.nn as nn

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "vendor"))

from tajweed.head_scorer import PronunciationHead  # noqa: E402

CKPT = ROOT / "models" / "head" / "pronunciation_head.pt"
OUT_DIR = ROOT / "models" / "onnx"
OUT_ONNX = OUT_DIR / "pronunciation_head.onnx"
OUT_MANIFEST = OUT_DIR / "model_manifest.json"
ENCODER_ONNX = OUT_DIR / "model_with_encoder.onnx"
TOKENS = ROOT / "models" / "tokens.txt"
TOKENIZER = ROOT / "models" / "tokenizer.model"


class PronunciationHeadOnnxWrapper(nn.Module):
    """Bake feature_table lookup so mobile only needs enc + token_id."""

    def __init__(self, head: PronunciationHead, feature_table: torch.Tensor):
        super().__init__()
        self.head = head
        # nn.Embedding weights = feature_table so ONNX exports as Gather.
        self.feat_emb = nn.Embedding.from_pretrained(feature_table, freeze=True)

    def forward(self, enc_feature: torch.Tensor, token_id: torch.Tensor) -> torch.Tensor:
        # token_id: int64 [B]
        token_feat = self.feat_emb(token_id)
        logits = self.head(enc_feature, token_id, token_feat)
        return torch.sigmoid(logits)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    if not CKPT.exists():
        print(f"ERROR: checkpoint missing: {CKPT}", file=sys.stderr)
        return 1

    ckpt = torch.load(CKPT, map_location="cpu", weights_only=False)
    cfg = ckpt.get("config", {})
    head = PronunciationHead(
        vocab_size=cfg.get("vocab_size", 1025),
        enc_dim=cfg.get("enc_dim", 512),
        tok_emb_dim=cfg.get("tok_emb_dim", 64),
        feat_dim=cfg.get("feat_dim", 16),
        hidden=cfg.get("hidden", 1024),
    )
    head.load_state_dict(ckpt["state_dict"])
    head.eval()
    # Drop Dropout for inference export (eval mode already disables it, but
    # ONNX is happier with deterministic graphs).
    for m in head.modules():
        if isinstance(m, nn.Dropout):
            m.p = 0.0

    feature_table = torch.as_tensor(np.asarray(ckpt["feature_table"]), dtype=torch.float32)
    wrapper = PronunciationHeadOnnxWrapper(head, feature_table).eval()

    enc_dim = int(cfg.get("enc_dim", 512))
    dummy_enc = torch.randn(1, enc_dim, dtype=torch.float32)
    dummy_tok = torch.zeros(1, dtype=torch.long)

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"Exporting → {OUT_ONNX}")
    # Prefer legacy exporter path when available so we can force a single
    # self-contained .onnx (no sidecar .onnx.data) that ModelStore can copy
    # as one file into the Android active pack.
    try:
        torch.onnx.export(
            wrapper,
            (dummy_enc, dummy_tok),
            str(OUT_ONNX),
            input_names=["enc_feature", "token_id"],
            output_names=["prob_correct"],
            dynamic_axes={
                "enc_feature": {0: "batch"},
                "token_id": {0: "batch"},
                "prob_correct": {0: "batch"},
            },
            opset_version=17,
            do_constant_folding=True,
            dynamo=False,
        )
    except TypeError:
        torch.onnx.export(
            wrapper,
            (dummy_enc, dummy_tok),
            str(OUT_ONNX),
            input_names=["enc_feature", "token_id"],
            output_names=["prob_correct"],
            dynamic_axes={
                "enc_feature": {0: "batch"},
                "token_id": {0: "batch"},
                "prob_correct": {0: "batch"},
            },
            opset_version=17,
            do_constant_folding=True,
        )
        # Dynamo path may write external data — fold into a single file.
        try:
            from onnx import load_model, save_model

            model = load_model(str(OUT_ONNX), load_external_data=True)
            save_model(model, str(OUT_ONNX), save_as_external_data=False, size_threshold=0)
            sidecar = OUT_ONNX.with_suffix(".onnx.data")
            if sidecar.exists():
                sidecar.unlink()
        except Exception as e:
            print(f"WARNING: could not fold external data: {e}", file=sys.stderr)

    # Numeric smoke: PyTorch vs ORT on the same dummy.
    with torch.no_grad():
        pt_out = wrapper(dummy_enc, dummy_tok).numpy()
    try:
        import onnxruntime as ort

        sess = ort.InferenceSession(str(OUT_ONNX), providers=["CPUExecutionProvider"])
        ort_out = sess.run(
            None,
            {
                "enc_feature": dummy_enc.numpy(),
                "token_id": dummy_tok.numpy().astype(np.int64),
            },
        )[0]
        max_diff = float(np.max(np.abs(pt_out - ort_out)))
        print(f"ORT smoke max|Δ| vs PyTorch: {max_diff:.6e}")
        if max_diff > 1e-5:
            print("WARNING: ONNX numeric drift above 1e-5", file=sys.stderr)
    except Exception as e:
        print(f"WARNING: could not run ORT smoke check: {e}", file=sys.stderr)

    # Android ModelStore expects encoder + pronunciationHead + tokenizer + tokens
    # under one install directory with a model_manifest.json.
    encoder_name = ENCODER_ONNX.name if ENCODER_ONNX.exists() else "model_with_encoder.onnx"
    manifest = {
        "version": "1.0.0",
        "encoder": encoder_name,
        "pronunciationHead": OUT_ONNX.name,
        "tokenizer": "tokenizer.model",
        "tokens": "tokens.txt",
        "sha256": {
            "encoder": sha256_file(ENCODER_ONNX) if ENCODER_ONNX.exists() else "PENDING",
            "pronunciationHead": sha256_file(OUT_ONNX),
            "tokenizer": sha256_file(TOKENIZER) if TOKENIZER.exists() else "PENDING",
            "tokens": sha256_file(TOKENS) if TOKENS.exists() else "PENDING",
        },
        "minimumAppVersion": "1.0.0",
        "notes": "pronunciation_head.onnx exported from models/head/pronunciation_head.pt; feature_table baked in.",
    }
    OUT_MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {OUT_MANIFEST}")
    print(f"Head size: {OUT_ONNX.stat().st_size} bytes")
    print(f"Head SHA-256: {manifest['sha256']['pronunciationHead']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
