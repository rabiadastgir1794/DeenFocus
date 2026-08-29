#!/usr/bin/env python3
"""Localize lock-screen widget countdown strings in all app_*.arb files."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

META = {
    "@widgetLockCountdownHoursMinutes": {
        "placeholders": {
            "hours": {"type": "String"},
            "minutes": {"type": "String"},
        },
    },
    "@widgetLockCountdownMinutes": {
        "placeholders": {
            "minutes": {"type": "String"},
        },
    },
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": {
        "widgetLockCountdownHoursMinutes": "In {hours}h {minutes}m",
        "widgetLockCountdownMinutes": "In {minutes}m",
    },
    "ar": {
        "widgetLockCountdownHoursMinutes": "خلال {hours} س و {minutes} د",
        "widgetLockCountdownMinutes": "خلال {minutes} د",
    },
    "az": {
        "widgetLockCountdownHoursMinutes": "{hours} saat {minutes} dəq sonra",
        "widgetLockCountdownMinutes": "{minutes} dəq sonra",
    },
    "de": {
        "widgetLockCountdownHoursMinutes": "In {hours} Std. {minutes} Min.",
        "widgetLockCountdownMinutes": "In {minutes} Min.",
    },
    "es": {
        "widgetLockCountdownHoursMinutes": "En {hours} h {minutes} min",
        "widgetLockCountdownMinutes": "En {minutes} min",
    },
    "fr": {
        "widgetLockCountdownHoursMinutes": "Dans {hours} h {minutes} min",
        "widgetLockCountdownMinutes": "Dans {minutes} min",
    },
    "hi": {
        "widgetLockCountdownHoursMinutes": "{hours} घं {minutes} मि में",
        "widgetLockCountdownMinutes": "{minutes} मि में",
    },
    "it": {
        "widgetLockCountdownHoursMinutes": "Tra {hours} h {minutes} min",
        "widgetLockCountdownMinutes": "Tra {minutes} min",
    },
    "nl": {
        "widgetLockCountdownHoursMinutes": "Over {hours} u {minutes} m",
        "widgetLockCountdownMinutes": "Over {minutes} m",
    },
    "pt": {
        "widgetLockCountdownHoursMinutes": "Em {hours} h {minutes} min",
        "widgetLockCountdownMinutes": "Em {minutes} min",
    },
    "ro": {
        "widgetLockCountdownHoursMinutes": "În {hours} h {minutes} min",
        "widgetLockCountdownMinutes": "În {minutes} min",
    },
    "ru": {
        "widgetLockCountdownHoursMinutes": "Через {hours} ч {minutes} мин",
        "widgetLockCountdownMinutes": "Через {minutes} мин",
    },
    "zh": {
        "widgetLockCountdownHoursMinutes": "{hours}小时{minutes}分钟后",
        "widgetLockCountdownMinutes": "{minutes}分钟后",
    },
}


def main() -> None:
    for locale, values in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        data.pop("widgetLockCountdownHoursMinutesPattern", None)
        data.pop("widgetLockCountdownMinutesPattern", None)
        data.update(values)
        data.update(META)
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
