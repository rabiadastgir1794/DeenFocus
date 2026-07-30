#!/usr/bin/env python3
"""Convert local Tajweed ONNX packs → CoreML (.mlpackage) for the DIY POC.

coremltools ≥8 dropped direct `source=\"onnx\"`. The current standard pipeline is:

  ONNX → onnx2torch (PyTorch GraphModule) → torch.jit.trace → coremltools

Isolated experiment — does not touch ios/Runner or production ModelStore.

Usage (from tajweed-lab, venv active):
  python experiments/diy_coreml_poc/convert_onnx_to_coreml.py
  python experiments/diy_coreml_poc/convert_onnx_to_coreml.py --head-only
  python experiments/diy_coreml_poc/convert_onnx_to_coreml.py --encoder-only
"""

from __future__ import annotations

import argparse
import json
import shutil
import sys
import time
import traceback
from pathlib import Path

import coremltools as ct
import numpy as np
import torch
from onnx2torch import convert as onnx2torch_convert

ROOT = Path(__file__).resolve().parents[2]
ONNX_DIR = ROOT / "models" / "onnx"
OUT_DIR = Path(__file__).resolve().parent / "artifacts"

ENCODER_ONNX = ONNX_DIR / "model_with_encoder.onnx"
HEAD_ONNX = ONNX_DIR / "pronunciation_head.onnx"

T_MIN, T_MAX, T_DEFAULT = 80, 4800, 480


def _register_torch_op_aliases() -> None:
    """onnx2torch emits aten::less / aten::greater; coremltools only registers lt/gt."""
    from coremltools.converters.mil.frontend.torch.ops import (  # noqa: WPS433
        _TORCH_OPS_REGISTRY as registry,
    )

    aliases = {
        "less": "lt",
        "greater": "gt",
        "less_equal": "le",
        "greater_equal": "ge",
    }
    for alias, canonical in aliases.items():
        if alias not in registry and canonical in registry:
            registry[alias] = registry[canonical]


def _save_mlpackage(model: ct.models.MLModel, out: Path) -> None:
    out.parent.mkdir(parents=True, exist_ok=True)
    if out.exists():
        shutil.rmtree(out)
    model.save(str(out))


def convert_head(*, precision=ct.precision.FLOAT16) -> Path:
    out = OUT_DIR / "pronunciation_head.mlpackage"
    print(f"Converting pronunciation head\n  src={HEAD_ONNX}\n  dst={out}\n  precision={precision}")
    t0 = time.time()
    torch_model = onnx2torch_convert(str(HEAD_ONNX))
    torch_model.eval()
    example_enc = torch.zeros(1, 512, dtype=torch.float32)
    example_tok = torch.zeros(1, dtype=torch.int64)
    with torch.no_grad():
        traced = torch.jit.trace(torch_model, (example_enc, example_tok))

    _register_torch_op_aliases()
    mlmodel = ct.convert(
        traced,
        inputs=[
            ct.TensorType(name="enc_feature", shape=(1, 512), dtype=np.float32),
            ct.TensorType(name="token_id", shape=(1,), dtype=np.int64),
        ],
        convert_to="mlprogram",
        minimum_deployment_target=ct.target.iOS16,
        compute_precision=precision,
    )
    # Rename output if needed for stable predict() keys.
    spec = mlmodel.get_spec()
    if spec.description.output:
        ct.utils.rename_feature(spec, spec.description.output[0].name, "prob_correct")
        mlmodel = ct.models.MLModel(spec, weights_dir=mlmodel.weights_dir)

    _save_mlpackage(mlmodel, out)
    print(f"  done in {(time.time() - t0):.1f}s → {out}")
    return out


def convert_encoder(
    *, flexible: bool = True, precision=ct.precision.FLOAT16, fixed_t: int = T_DEFAULT
) -> Path:
    out = OUT_DIR / "encoder.mlpackage"
    print(
        f"Converting encoder\n  src={ENCODER_ONNX}\n  dst={out}\n  "
        f"flexible={flexible} precision={precision} fixed_t={fixed_t}"
    )
    t0 = time.time()

    print("  onnx2torch load (large graph — may take minutes)…")
    torch_model = onnx2torch_convert(str(ENCODER_ONNX))
    torch_model.eval()

    t_ex = fixed_t if not flexible else T_DEFAULT
    example_audio = torch.zeros(1, 80, t_ex, dtype=torch.float32)
    example_length = torch.tensor([t_ex], dtype=torch.int64)
    print(f"  tracing with T={t_ex}…")
    with torch.no_grad():
        traced = torch.jit.trace(torch_model, (example_audio, example_length), strict=False)

    if flexible:
        audio_shape = (
            1,
            80,
            ct.RangeDim(lower_bound=T_MIN, upper_bound=T_MAX, default=T_DEFAULT),
        )
    else:
        audio_shape = (1, 80, fixed_t)

    print("  coremltools convert…")
    _register_torch_op_aliases()
    try:
        mlmodel = ct.convert(
            traced,
            inputs=[
                ct.TensorType(name="audio_signal", shape=audio_shape, dtype=np.float32),
                ct.TensorType(name="length", shape=(1,), dtype=np.int64),
            ],
            convert_to="mlprogram",
            minimum_deployment_target=ct.target.iOS16,
            compute_precision=precision,
        )
    except Exception:
        if not flexible:
            raise
        print("  flexible conversion failed; retrying fixed T=480…")
        traceback.print_exc()
        return convert_encoder(flexible=False, precision=precision)

    # Stabilize output names to match ONNX / Android.
    spec = mlmodel.get_spec()
    outs = list(spec.description.output)
    renamed: dict[str, str] = {}
    for o in outs:
        if o.name in ("logprobs", "encoder_output"):
            continue
        shape: list[int] = []
        if o.type.WhichOneof("Type") == "multiArrayType":
            for d in o.type.multiArrayType.shape:
                # CT7 uses Dim messages; CT9 may expose plain ints.
                shape.append(int(getattr(d, "dim_value", d) if not isinstance(d, int) else d))
        if shape and shape[-1] == 1025:
            renamed[o.name] = "logprobs"
        elif shape and (512 in shape):
            renamed[o.name] = "encoder_output"
    if len(renamed) < 2 and len(outs) == 2:
        if outs[0].name not in ("logprobs", "encoder_output"):
            renamed[outs[0].name] = "logprobs"
        if outs[1].name not in ("logprobs", "encoder_output"):
            renamed[outs[1].name] = "encoder_output"
    for old, new in renamed.items():
        print(f"  rename output {old!r} → {new!r}")
        ct.utils.rename_feature(spec, old, new)
    if renamed:
        mlmodel = ct.models.MLModel(spec, weights_dir=mlmodel.weights_dir)

    _save_mlpackage(mlmodel, out)
    meta = {
        "pipeline": "onnx→onnx2torch→torch.jit.trace→coremltools",
        "source": str(ENCODER_ONNX),
        "flexible": flexible,
        "compute_precision": str(precision),
        "t_min": T_MIN if flexible else fixed_t,
        "t_max": T_MAX if flexible else fixed_t,
        "seconds": time.time() - t0,
        "coremltools": ct.__version__,
        "torch": torch.__version__,
    }
    (OUT_DIR / "encoder_conversion_meta.json").write_text(
        json.dumps(meta, indent=2) + "\n", encoding="utf-8"
    )
    print(f"  done in {meta['seconds']:.1f}s → {out}")
    return out


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--head-only", action="store_true")
    parser.add_argument("--encoder-only", action="store_true")
    parser.add_argument("--fixed-encoder", action="store_true")
    parser.add_argument(
        "--fp32",
        action="store_true",
        help="Use FLOAT32 compute precision (avoids known FP16 NaN overflows on this graph).",
    )
    args = parser.parse_args()

    precision = ct.precision.FLOAT32 if args.fp32 else ct.precision.FLOAT16
    print(f"compute_precision={precision}")

    for path in (ENCODER_ONNX, HEAD_ONNX):
        if not path.exists():
            print(f"ERROR: missing {path}", file=sys.stderr)
            return 1

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    results: dict = {
        "coremltools": ct.__version__,
        "torch": torch.__version__,
        "pipeline": "onnx→onnx2torch→torch.jit.trace→coremltools",
        "compute_precision": "FLOAT32" if args.fp32 else "FLOAT16",
    }

    if not args.encoder_only:
        try:
            results["head"] = str(convert_head(precision=precision))
        except Exception as e:
            results["head_error"] = f"{type(e).__name__}: {e}"
            traceback.print_exc()
            if args.head_only:
                (OUT_DIR / "conversion_status.json").write_text(
                    json.dumps(results, indent=2) + "\n", encoding="utf-8"
                )
                return 1

    if not args.head_only:
        try:
            results["encoder"] = str(
                convert_encoder(flexible=not args.fixed_encoder, precision=precision)
            )
        except Exception as e:
            results["encoder_error"] = f"{type(e).__name__}: {e}"
            traceback.print_exc()
            (OUT_DIR / "conversion_status.json").write_text(
                json.dumps(results, indent=2) + "\n", encoding="utf-8"
            )
            return 1

    (OUT_DIR / "conversion_status.json").write_text(
        json.dumps(results, indent=2) + "\n", encoding="utf-8"
    )
    print("Wrote", OUT_DIR / "conversion_status.json")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
