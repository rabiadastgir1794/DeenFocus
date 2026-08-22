#!/usr/bin/env python3
"""Make insightsChipUpToday take a count placeholder."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

META = {
    "placeholders": {
        "count": {"type": "int"},
    }
}


def upsert(path: Path, locale: str) -> None:
    original = path.read_text(encoding="utf-8")
    data = json.loads(original)
    text = original
    old = data.get("insightsChipUpToday")
    if old != "↑ {count}":
        old_line = f'"insightsChipUpToday": {json.dumps(old, ensure_ascii=False)}'
        new_line = '"insightsChipUpToday": "↑ {count}"'
        if old_line not in text:
            raise SystemExit(f"{path.name}: could not replace insightsChipUpToday")
        text = text.replace(old_line, new_line, 1)

    if locale == "en":
        data_after = json.loads(text)
        if data_after.get("@insightsChipUpToday") != META:
            if '"@insightsChipUpToday"' not in text:
                needle = '"insightsChipUpToday": "↑ {count}",\n'
                insert = (
                    needle
                    + '  "@insightsChipUpToday": {\n'
                    + '    "placeholders": {\n'
                    + '      "count": {\n'
                    + '        "type": "int"\n'
                    + "      }\n"
                    + "    }\n"
                    + "  },\n"
                )
                if needle not in text:
                    raise SystemExit(f"{path.name}: missing chip key for metadata")
                text = text.replace(needle, insert, 1)

    if text == original:
        print(f"unchanged {path.name}")
        return
    path.write_text(text if text.endswith("\n") else f"{text}\n", encoding="utf-8")
    print(f"updated {path.name}")


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        upsert(path, path.stem.removeprefix("app_"))


if __name__ == "__main__":
    main()
