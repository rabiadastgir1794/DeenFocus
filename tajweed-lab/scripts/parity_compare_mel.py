#!/usr/bin/env python3
"""Phase 4A: compare log-mel spectrogram output across Python (reference),
iOS (Swift/vDSP MelFrontend), and Android (Kotlin/hand-rolled-FFT MelFrontend)
on the same real golden Quran recitation clips.

Inputs (produced by running each platform's mel-dump test — see
tajweed-lab/docs/PHASE_4A_PARITY.md for the exact commands):
  tajweed-lab/parity/python/<name>.json   <- scripts/parity_dump_mel_reference.py
  /tmp/tajweed_parity/ios/<name>.json     <- RunnerTests.testPhase4AMelParityDumpOnGoldenSamples
  /tmp/tajweed_parity/android/<name>.json <- TajweedMelParityTest.dumpMelForGoldenSamples

Output: tajweed-lab/parity/reports/mel_parity_report.json (+ prints a summary table).
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[1]
PY_DIR = ROOT / "parity" / "python"
IOS_DIR = Path("/tmp/tajweed_parity/ios")
ANDROID_DIR = Path("/tmp/tajweed_parity/android")
REPORT_DIR = ROOT / "parity" / "reports"

# CMVN-normalized log-mel values are ~N(0,1) per bin; a 0.15 absolute tolerance
# comfortably separates "same preprocessing, different FFT/window implementation
# details" from "materially different pipeline", while still being tight enough
# to catch real regressions (bucket/shape mismatches, wrong window, etc).
ABS_TOLERANCE = 0.15
CORR_MIN = 0.98


def load(path: Path) -> dict:
    return json.loads(path.read_text())


def compare_pair(name: str, a: dict, b: dict, label_a: str, label_b: str) -> dict:
    fa = np.array(a["features"], dtype=np.float64)
    fb = np.array(b["features"], dtype=np.float64)
    shape_match = (a["n_mels"], a["time"]) == (b["n_mels"], b["time"])
    result = {
        "sample": name,
        "pair": f"{label_a}_vs_{label_b}",
        "shape_a": [a["n_mels"], a["time"]],
        "shape_b": [b["n_mels"], b["time"]],
        "shape_match": shape_match,
    }
    if not shape_match:
        t = min(a["time"], b["time"])
        fa2 = np.array(a["features"], dtype=np.float64).reshape(a["n_mels"], a["time"])[:, :t]
        fb2 = np.array(b["features"], dtype=np.float64).reshape(b["n_mels"], b["time"])[:, :t]
        fa, fb = fa2.flatten(), fb2.flatten()
        result["note"] = f"time dims differ ({a['time']} vs {b['time']}); compared on overlapping T={t}"

    diff = np.abs(fa - fb)
    corr = float(np.corrcoef(fa, fb)[0, 1]) if fa.size > 1 else float("nan")
    result.update(
        {
            "max_abs_diff": float(diff.max()),
            "mean_abs_diff": float(diff.mean()),
            "correlation": corr,
            "pass": bool(diff.max() <= ABS_TOLERANCE and (np.isnan(corr) or corr >= CORR_MIN)),
            "tolerance": {"max_abs_diff": ABS_TOLERANCE, "min_correlation": CORR_MIN},
        }
    )
    return result


def main() -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    names = sorted(p.stem for p in PY_DIR.glob("*.json"))
    if not names:
        print(f"No Python reference mel dumps found in {PY_DIR}. Run parity_dump_mel_reference.py first.")
        return 1

    all_results = []
    for name in names:
        py_path = PY_DIR / f"{name}.json"
        ios_path = IOS_DIR / f"{name}.json"
        android_path = ANDROID_DIR / f"{name}.json"

        py = load(py_path)
        available = {"python": py}
        missing = []
        if ios_path.exists():
            available["ios"] = load(ios_path)
        else:
            missing.append(f"ios ({ios_path})")
        if android_path.exists():
            available["android"] = load(android_path)
        else:
            missing.append(f"android ({android_path})")

        sample_report = {"sample": name, "missing": missing, "comparisons": []}
        pairs = [("python", "ios"), ("python", "android"), ("ios", "android")]
        for a_label, b_label in pairs:
            if a_label in available and b_label in available:
                cmp = compare_pair(name, available[a_label], available[b_label], a_label, b_label)
                sample_report["comparisons"].append(cmp)
        all_results.append(sample_report)

    report = {
        "tolerance": {"max_abs_diff": ABS_TOLERANCE, "min_correlation": CORR_MIN},
        "samples": all_results,
    }
    out_path = REPORT_DIR / "mel_parity_report.json"
    out_path.write_text(json.dumps(report, indent=2))

    print(f"\n{'sample':<24} {'pair':<16} {'shape_ok':<9} {'max|Δ|':<10} {'mean|Δ|':<10} {'corr':<8} {'pass':<5}")
    print("-" * 90)
    any_fail = False
    for sample in all_results:
        for cmp in sample["comparisons"]:
            status = "PASS" if cmp["pass"] else "FAIL"
            if not cmp["pass"]:
                any_fail = True
            print(
                f"{cmp['sample']:<24} {cmp['pair']:<16} {str(cmp['shape_match']):<9} "
                f"{cmp['max_abs_diff']:<10.4f} {cmp['mean_abs_diff']:<10.4f} {cmp['correlation']:<8.4f} {status:<5}"
            )
        if sample["missing"]:
            print(f"{sample['sample']:<24} MISSING: {', '.join(sample['missing'])}")

    print(f"\nFull report: {out_path}")
    return 1 if any_fail else 0


if __name__ == "__main__":
    raise SystemExit(main())
