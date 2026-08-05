#!/usr/bin/env python3
"""Generate and validate ADR-010 canonical lexicon pack."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from canonical_lexicon.generator import write_pack  # noqa: E402
from canonical_lexicon.validate import assert_pack_valid  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate canonical spoken-Quran lexicon pack")
    parser.add_argument(
        "--output",
        type=Path,
        default=ROOT.parent / "memory/features/tajweed/fixtures/canonical_lexicon_v1",
        help="Output directory for manifest.json + ayahs.ndjson",
    )
    args = parser.parse_args()

    manifest = write_pack(args.output)
    assert_pack_valid(args.output)
    print(
        f"OK lexiconVersion={manifest.lexiconVersion} ayahs={manifest.ayahCount} "
        f"sha256={manifest.payloadSha256[:12]}…"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
