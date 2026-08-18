#!/usr/bin/env python3
"""Generate Android values-* and iOS *.lproj Prayer Alarm fallback strings from ARBs."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARB_DIR = ROOT / "lib" / "l10n"
ANDROID_RES = ROOT / "android" / "app" / "src" / "main" / "res"
IOS_RUNNER = ROOT / "ios" / "Runner"

# Flutter ARB key → Android/iOS resource name
KEYS = {
    "prayerAlarmBadge": "prayer_alarm_badge",
    "prayerAlarmSubtitle": "prayer_alarm_subtitle",
    "prayerAlarmIvePrayed": "prayer_alarm_ive_prayed",
    "prayerAlarmDismiss": "prayer_alarm_dismiss",
    "prayerAlarmSnooze": "prayer_alarm_snooze",
    "prayerAlarmsSnoozeLabel": "prayer_alarm_snooze_label",
}

# Title format uses {prayerName} in Flutter; Android uses %1$s.
TITLE_KEY = "prayerAlarmTitle"
SNOOZE_MINUTES_KEY = "prayerAlarmsSnoozeMinutes"

# Android resource folder suffix for each ARB locale.
ANDROID_QUALIFIERS = {
    "ar": "ar",
    "az": "az",
    "de": "de",
    "es": "es",
    "fr": "fr",
    "hi": "hi",
    "it": "it",
    "nl": "nl",
    "pt": "pt",
    "ro": "ro",
    "ru": "ru",
    "zh": "zh",
}


def xml_escape(value: str) -> str:
    return (
        value.replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace('"', '\\"')
        .replace("'", "\\'")
    )


def flutter_to_android_format(value: str) -> str:
    # "{prayerName} — …" → "%1$s — …"
    value = re.sub(r"\{prayerName\}", "%1$s", value)
    # "{minutes} minutes" → "%1$d minutes"
    value = re.sub(r"\{minutes\}", "%1$d", value)
    return value


def write_android(locale: str, data: dict[str, str]) -> None:
    if locale == "en":
        return  # defaults live in values/strings.xml
    qual = ANDROID_QUALIFIERS.get(locale)
    if not qual:
        return
    folder = ANDROID_RES / f"values-{qual}"
    folder.mkdir(parents=True, exist_ok=True)
    lines = ['<?xml version="1.0" encoding="utf-8"?>', "<resources>"]
    for arb_key, res_name in KEYS.items():
        lines.append(
            f'    <string name="{res_name}">{xml_escape(data[arb_key])}</string>'
        )
    title = flutter_to_android_format(data[TITLE_KEY])
    minutes = flutter_to_android_format(data[SNOOZE_MINUTES_KEY])
    lines.append(
        f'    <string name="prayer_alarm_title_format">{xml_escape(title)}</string>'
    )
    lines.append(
        f'    <string name="prayer_alarm_snooze_minutes">{xml_escape(minutes)}</string>'
    )
    lines.append("</resources>\n")
    (folder / "strings.xml").write_text("\n".join(lines), encoding="utf-8")
    print(f"android values-{qual}/strings.xml")


def write_ios(locale: str, data: dict[str, str]) -> None:
    folder = IOS_RUNNER / f"{locale}.lproj"
    folder.mkdir(parents=True, exist_ok=True)
    lines = ['/* AlarmKit App Intent + native fallbacks */']
    mapping = {
        "prayer_alarm_ive_prayed": data["prayerAlarmIvePrayed"],
        "prayer_alarm_subtitle": data["prayerAlarmSubtitle"],
        "prayer_alarm_dismiss": data["prayerAlarmDismiss"],
        "prayer_alarm_badge": data["prayerAlarmBadge"],
        "prayer_alarm_snooze": data["prayerAlarmSnooze"],
        "prayer_alarm_snooze_label": data["prayerAlarmsSnoozeLabel"],
    }
    for key, value in mapping.items():
        escaped = value.replace("\\", "\\\\").replace('"', '\\"')
        lines.append(f'"{key}" = "{escaped}";')
    (folder / "Localizable.strings").write_text(
        "\n".join(lines) + "\n", encoding="utf-8"
    )
    print(f"ios {locale}.lproj/Localizable.strings")


def load_arb(locale: str) -> dict[str, str]:
    path = ARB_DIR / f"app_{locale}.arb"
    raw = json.loads(path.read_text(encoding="utf-8"))
    return {k: v for k, v in raw.items() if not k.startswith("@") and isinstance(v, str)}


def main() -> None:
    for path in sorted(ARB_DIR.glob("app_*.arb")):
        locale = path.stem.removeprefix("app_")
        data = load_arb(locale)
        required = set(KEYS) | {TITLE_KEY, SNOOZE_MINUTES_KEY}
        missing = required - data.keys()
        if missing:
            raise SystemExit(f"{path.name} missing {sorted(missing)}")
        write_android(locale, data)
        write_ios(locale, data)


if __name__ == "__main__":
    main()
