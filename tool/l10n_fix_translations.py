#!/usr/bin/env python3
"""Merge screenshot/onboarding localization fixes into all app_*.arb files."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

# Shared new keys (also added to EN)
NEW_EN = {
    "weekdayLetterMon": "M",
    "weekdayLetterTue": "T",
    "weekdayLetterWed": "W",
    "weekdayLetterThu": "T",
    "weekdayLetterFri": "F",
    "weekdayLetterSat": "S",
    "weekdayLetterSun": "S",
    "focusHomeBlockingNightAndSalah": "Night Discipline and Salah mode are blocking selected apps.",
    "focusHomeBlockingNight": "Night Discipline is blocking selected apps.",
    "focusHomeBlockingSalah": "Salah mode is blocking selected apps.",
    "focusHomeAppsBlockedNow": "Selected apps are blocked right now.",
    "focusHomeModeEnabled": "{mode} is enabled.",
    "focusHomeModesEnabled": "{modes} are enabled.",
    "focusHomeChooseMode": "Choose a mode to protect your attention.",
    "focusStatusSelectApps": "Select apps to start",
    "focusStatusBlockingNightAndSalah": "Night Discipline and Salah mode are blocking apps now",
    "focusStatusBlockingNight": "Night Discipline is blocking apps now",
    "focusStatusBlockingSalah": "Salah mode is blocking apps now",
    "focusStatusAppsLocked": "Apps are locked now",
    "focusStatusUnlockedUntil": "Unlocked until {time}",
    "focusStatusNoMode": "No focus mode enabled",
    "focusStatusReadyToLock": "Ready to lock {targets}",
}

NEW_EN_META = {
    "@focusHomeModeEnabled": {
        "placeholders": {"mode": {"type": "String"}},
    },
    "@focusHomeModesEnabled": {
        "placeholders": {"modes": {"type": "String"}},
    },
    "@focusStatusUnlockedUntil": {
        "placeholders": {"time": {"type": "String"}},
    },
    "@focusStatusReadyToLock": {
        "placeholders": {"targets": {"type": "String"}},
    },
}


def load_arb(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def dump_arb(path: Path, data: dict) -> None:
    # Keep stable key order: existing order, then append new keys before closing
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )


def merge(data: dict, updates: dict) -> None:
    for k, v in updates.items():
        data[k] = v


# --- translations -----------------------------------------------------------

from l10n_fix_data import TRANSLATIONS  # noqa: E402


def main() -> None:
    en_path = ROOT / "app_en.arb"
    en = load_arb(en_path)
    merge(en, NEW_EN)
    merge(en, NEW_EN_META)
    dump_arb(en_path, en)
    print(f"updated en (+{len(NEW_EN)} keys)")

    for loc, updates in TRANSLATIONS.items():
        path = ROOT / f"app_{loc}.arb"
        data = load_arb(path)
        # include new keys for this locale
        full = dict(updates)
        merge(data, full)
        dump_arb(path, data)
        print(f"updated {loc} ({len(full)} keys)")


if __name__ == "__main__":
    main()
