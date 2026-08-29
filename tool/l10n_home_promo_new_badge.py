#!/usr/bin/env python3
"""Insert homePromoNewBadge l10n key after homeLockScreenPromoCta."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "homeLockScreenPromoCta"

TRANSLATIONS: dict[str, str] = {
    "en": "NEW",
    "ar": "جديد",
    "de": "NEU",
    "es": "NUEVO",
    "fr": "NOUVEAU",
    "hi": "नया",
    "it": "NUOVO",
    "nl": "NIEUW",
    "pt": "NOVO",
    "ro": "NOU",
    "ru": "НОВОЕ",
    "zh": "新",
    "az": "YENİ",
}


def main() -> None:
    for locale, value in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        data["homePromoNewBadge"] = value
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
