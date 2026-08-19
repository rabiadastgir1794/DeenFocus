#!/usr/bin/env python3
"""Merge pack entries into the live R2 catalog.json (ADR-009).

Fetches the current production catalog (or reads --from), upserts packs from
--add (by packId), writes the result, and optionally uploads it LAST via
upload_to_r2.sh.

Usage:
  # Build local catalog with a new translation pack merged in:
  python3 tool/ai_assets/merge_catalog.py \\
    --add tool/ai_assets/specs/catalog-pack-quran-translation-en.json \\
    --out /tmp/release/catalog.json

  # Build + upload (atomic go-live):
  python3 tool/ai_assets/merge_catalog.py \\
    --add tool/ai_assets/specs/catalog-pack-quran-translation-en.json \\
    --out /tmp/release/catalog.json \\
    --upload
"""
from __future__ import annotations

import argparse
import datetime
import json
import subprocess
import sys
import urllib.request
from pathlib import Path

DEFAULT_CATALOG_URL = (
    "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json"
)


def _load_json(path: Path) -> dict | list:
    return json.loads(path.read_text(encoding="utf-8"))


def _fetch_catalog(url: str) -> dict:
    # r2.dev public host rejects bare Python-urllib User-Agents (HTTP 403).
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "DeenFocus-ai-assets/1.0 (catalog-merge)"},
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        return json.loads(resp.read().decode("utf-8"))


def _normalize_pack(raw: dict | list) -> list[dict]:
    if isinstance(raw, list):
        return raw
    if "packs" in raw:
        return list(raw["packs"])
    if "packId" in raw:
        return [raw]
    raise ValueError("Expected a pack object, {packs:[...]}, or a pack list.")


def merge_catalog(base: dict, additions: list[dict]) -> dict:
    packs = list(base.get("packs") or [])
    by_id = {p["packId"]: i for i, p in enumerate(packs)}
    for pack in additions:
        if "packId" not in pack or "latestVersion" not in pack or "manifestUrl" not in pack:
            raise ValueError(f"Pack missing required fields: {pack.get('packId')}")
        if pack["packId"] in by_id:
            packs[by_id[pack["packId"]]] = pack
        else:
            by_id[pack["packId"]] = len(packs)
            packs.append(pack)
    return {
        "catalogVersion": base.get("catalogVersion", 1),
        "updatedAt": datetime.datetime.now(datetime.timezone.utc).strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        ),
        "recommendedCheckIntervalHours": base.get(
            "recommendedCheckIntervalHours", 24
        ),
        "packs": packs,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "--from-url",
        default=DEFAULT_CATALOG_URL,
        help="Live catalog URL to fetch as base (ignored if --from-file is set).",
    )
    parser.add_argument(
        "--from-file",
        type=Path,
        help="Local catalog JSON to use as base instead of fetching.",
    )
    parser.add_argument(
        "--add",
        action="append",
        type=Path,
        required=True,
        help="Pack JSON (or {packs:[...]}) to upsert. Repeatable.",
    )
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument(
        "--upload",
        action="store_true",
        help="After writing --out, upload as catalog.json via upload_to_r2.sh",
    )
    args = parser.parse_args()

    if args.from_file:
        base = _load_json(args.from_file)
    else:
        print(f"Fetching base catalog: {args.from_url}")
        base = _fetch_catalog(args.from_url)

    additions: list[dict] = []
    for path in args.add:
        additions.extend(_normalize_pack(_load_json(path)))

    catalog = merge_catalog(base, additions)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_text(json.dumps(catalog, indent=2) + "\n", encoding="utf-8")
    print(
        f"Wrote {args.out} ({len(catalog['packs'])} pack(s)): "
        + ", ".join(p["packId"] for p in catalog["packs"])
    )

    if args.upload:
        script = Path(__file__).resolve().parent / "upload_to_r2.sh"
        subprocess.check_call(
            [
                str(script),
                "catalog.json",
                str(args.out),
                "--cache-control",
                "public, max-age=60",
            ]
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
