#!/usr/bin/env python3
"""Sample city label for home promo widget previews."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "homePromoNewBadge"

TRANSLATIONS: dict[str, str] = {
    "en": "Lahore",
    "ar": "لاہور",
    "de": "Lahore",
    "es": "Lahore",
    "fr": "Lahore",
    "hi": "लाहौर",
    "it": "Lahore",
    "nl": "Lahore",
    "pt": "Lahore",
    "ro": "Lahore",
    "ru": "Лахор",
    "zh": "拉合尔",
    "az": "Lahore",
}


def main() -> None:
    for locale, value in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        data["homePromoPreviewCity"] = value
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
