#!/usr/bin/env python3
"""Localize settingsRateDeenFocus in all app_*.arb files."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

TRANSLATIONS: dict[str, str] = {
    "en": "Rate DeenFocus ⭐",
    "ar": "قيّم دين فوكس ⭐",
    "az": "DeenFocus-u qiymətləndir ⭐",
    "de": "DeenFocus bewerten ⭐",
    "es": "Valora DeenFocus ⭐",
    "fr": "Noter DeenFocus ⭐",
    "hi": "DeenFocus को रेट करें ⭐",
    "it": "Valuta DeenFocus ⭐",
    "nl": "Beoordeel DeenFocus ⭐",
    "pt": "Avaliar DeenFocus ⭐",
    "ro": "Evaluează DeenFocus ⭐",
    "ru": "Оценить DeenFocus ⭐",
    "zh": "为 DeenFocus 评分 ⭐",
}


def main() -> None:
    for locale, value in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        data["settingsRateDeenFocus"] = value
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
