#!/usr/bin/env python3
"""Generate assets/quran/<mushaf>.json — per-ayah page/juz/hizb metadata.

DeenFocus's Reading Engine (Surah / Juz / Page modes) needs to know, for every
ayah, which of the 604 standard Madani Mushaf pages and which of the 30 Juz it
belongs to. That mapping is NOT derivable from assets/raw/quran_paak.json
(text only) — it comes from the Quran's fixed physical layout, so it is
generated once from an authoritative source and checked in as a static asset.

Source: Tanzil Project structural metadata (quran-data.xml), (C) Tanzil.info,
license CC BY 3.0 — https://tanzil.net/docs/quran_metadata
The XML encodes, for each page/juz, the (sura, aya) at which it *starts*.
This script expands those start markers into a flat per-ayah record:
    { "surah": s, "ayah": a, "page": p, "juz": j }

Usage:
    curl -sL https://tanzil.net/res/text/metadata/quran-data.xml -o /tmp/quran-data.xml
    python3 tool/generate_quran_metadata.py /tmp/quran-data.xml --mushaf uthmani

Output: assets/quran/<mushaf>.json

To add a future mushaf standard (e.g. IndoPak), source an equivalent
sura/aya -> page/juz start table for that printing and re-run this script
with --mushaf indopak. No app code needs to change — see
lib/features/quran/reading_engine/mushaf_metadata_loader.dart.
"""
from __future__ import annotations

import argparse
import json
import xml.etree.ElementTree as ET
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
QURAN_PAAK_JSON = REPO_ROOT / "assets" / "raw" / "quran_paak.json"


def _load_surah_ayah_counts() -> dict[int, int]:
    """Read {surah_number: ayah_count} from the bundled Quran text asset.

    This keeps the generated metadata in lockstep with the exact ayah
    numbering already shipped in the app, rather than trusting a second
    external source for surah lengths.
    """
    with QURAN_PAAK_JSON.open("r", encoding="utf-8") as f:
        surahs = json.load(f)
    return {int(s["@index"]): len(s["aya"]) for s in surahs}


def _parse_start_markers(xml_path: Path, tag: str, item_tag: str) -> list[tuple[int, int]]:
    """Parse <tag><item_tag sura="s" aya="a" />...</tag> into [(sura, aya), ...] in index order."""
    tree = ET.parse(xml_path)
    root = tree.getroot()
    container = root.find(tag)
    if container is None:
        raise ValueError(f"'<{tag}>' section not found in {xml_path}")
    markers: list[tuple[int, int]] = []
    for el in container.findall(item_tag):
        markers.append((int(el.get("sura")), int(el.get("aya"))))
    return markers


def _build_ayah_numbers_for_markers(
    markers: list[tuple[int, int]],
    ayah_counts: dict[int, int],
) -> list[int]:
    """Convert each (sura, aya) start marker into a global 1-based ayah index."""
    surah_offsets: dict[int, int] = {}
    running = 0
    for surah in sorted(ayah_counts):
        surah_offsets[surah] = running
        running += ayah_counts[surah]

    global_indices: list[int] = []
    for sura, aya in markers:
        global_indices.append(surah_offsets[sura] + aya)  # aya is 1-based
    return global_indices


def generate(xml_path: Path, mushaf: str) -> None:
    ayah_counts = _load_surah_ayah_counts()
    total_ayahs = sum(ayah_counts.values())

    page_markers = _parse_start_markers(xml_path, "pages", "page")
    juz_markers = _parse_start_markers(xml_path, "juzs", "juz")

    page_starts = _build_ayah_numbers_for_markers(page_markers, ayah_counts)
    juz_starts = _build_ayah_numbers_for_markers(juz_markers, ayah_counts)

    def number_for(global_index: int, starts: list[int]) -> int:
        # starts is ascending; find the last start <= global_index.
        number = 1
        for i, start in enumerate(starts):
            if global_index >= start:
                number = i + 1
            else:
                break
        return number

    ayahs = []
    global_index = 0
    for surah in sorted(ayah_counts):
        for ayah in range(1, ayah_counts[surah] + 1):
            global_index += 1
            ayahs.append(
                {
                    "surah": surah,
                    "ayah": ayah,
                    "page": number_for(global_index, page_starts),
                    "juz": number_for(global_index, juz_starts),
                }
            )

    assert len(ayahs) == total_ayahs, f"expected {total_ayahs} ayahs, built {len(ayahs)}"
    assert ayahs[-1]["page"] == len(page_markers), "last ayah should be on the last page"
    assert ayahs[-1]["juz"] == len(juz_markers), "last ayah should be in the last juz"

    output = {
        "mushaf": mushaf,
        "source": "Tanzil Project quran-data.xml (CC BY 3.0), https://tanzil.net",
        "totalSurahs": len(ayah_counts),
        "totalAyahs": total_ayahs,
        "totalPages": len(page_markers),
        "totalJuz": len(juz_markers),
        "ayahs": ayahs,
    }

    out_dir = REPO_ROOT / "assets" / "quran"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / f"{mushaf}.json"
    with out_path.open("w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, separators=(",", ":"))

    print(f"Wrote {out_path} ({out_path.stat().st_size:,} bytes, {len(ayahs)} ayahs, "
          f"{len(page_markers)} pages, {len(juz_markers)} juz)")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("xml_path", type=Path, help="Path to a downloaded Tanzil quran-data.xml")
    parser.add_argument("--mushaf", default="uthmani", help="Output filename stem (default: uthmani)")
    args = parser.parse_args()
    generate(args.xml_path, args.mushaf)


if __name__ == "__main__":
    main()
