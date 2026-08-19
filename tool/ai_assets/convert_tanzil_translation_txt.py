#!/usr/bin/env python3
"""Convert a Tanzil plain-text Quran translation (.txt) to app translation.json.

Tanzil text format: one ayah per line (6236 lines), then a `#` metadata footer.
Continuation wraps (rare) start with a leading space and are merged into the
previous ayah. Output shape matches assets/raw/english_translation.json.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

EXPECTED_AYAHS = 6236


def load_ayah_lines(path: Path) -> list[str]:
    ayahs: list[str] = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        if raw.startswith("#"):
            break
        if not raw.strip():
            continue
        if raw.startswith(" ") and ayahs:
            ayahs[-1] = ayahs[-1] + raw
            continue
        ayahs.append(raw)
    return ayahs


def convert(txt_path: Path, quran_path: Path) -> list[dict]:
    ayahs = load_ayah_lines(txt_path)
    if len(ayahs) != EXPECTED_AYAHS:
        raise SystemExit(
            f"{txt_path.name}: expected {EXPECTED_AYAHS} ayahs, got {len(ayahs)}"
        )

    quran = json.loads(quran_path.read_text(encoding="utf-8"))
    out: list[dict] = []
    cursor = 0
    for surah in quran:
        surah_index = str(surah["@index"])
        surah_ayas = []
        for aya in surah["aya"]:
            surah_ayas.append(
                {"@index": str(aya["@index"]), "@text": ayahs[cursor]}
            )
            cursor += 1
        out.append({"@index": surah_index, "@name": "", "aya": surah_ayas})
    if cursor != EXPECTED_AYAHS:
        raise SystemExit(f"Internal mismatch: consumed {cursor} ayahs")
    return out


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("txt", type=Path, help="Tanzil .txt translation file")
    parser.add_argument(
        "--quran",
        type=Path,
        default=Path("assets/raw/quran_paak.json"),
        help="Arabic Quran JSON used for surah/ayah indices",
    )
    parser.add_argument(
        "--out",
        type=Path,
        required=True,
        help="Output translation.json path",
    )
    args = parser.parse_args()
    data = convert(args.txt, args.quran)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(
        json.dumps(data, ensure_ascii=False, separators=(",", ":")) + "\n",
        encoding="utf-8",
    )
    size = args.out.stat().st_size
    print(f"Wrote {args.out} ({size} bytes, {EXPECTED_AYAHS} ayahs)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
