#!/usr/bin/env python3
"""Cycle Mode settings: Protect prayer streak + helper subtitles."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": {
        "cycleModePauseStreaksLabel": "Protect prayer streak",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Keep your streak intact during cycle days"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Don't count cycle days in your prayer stats"
        ),
    },
    "ar": {
        "cycleModePauseStreaksLabel": "حماية سلسلة الصلاة",
        "cycleModeProtectPrayerStreakSubtitle": (
            "حافظي على سلسلتك خلال أيام الدورة"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "لا تُحسب أيام الدورة في إحصائيات صلاتك"
        ),
    },
    "de": {
        "cycleModePauseStreaksLabel": "Gebets-Serie schützen",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Behalte deine Serie während der Zyklustage"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Zyklustage nicht in den Gebetsstatistiken zählen"
        ),
    },
    "es": {
        "cycleModePauseStreaksLabel": "Proteger racha de oración",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Mantén tu racha intacta durante los días del ciclo"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "No contar los días del ciclo en tus estadísticas de oración"
        ),
    },
    "fr": {
        "cycleModePauseStreaksLabel": "Protéger la série de prières",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Garde ta série intacte pendant les jours du cycle"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Ne pas compter les jours du cycle dans tes stats de prière"
        ),
    },
    "hi": {
        "cycleModePauseStreaksLabel": "नमाज़ स्ट्रीक की सुरक्षा",
        "cycleModeProtectPrayerStreakSubtitle": (
            "चक्र के दिनों में अपनी स्ट्रीक बनाए रखें"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "चक्र के दिनों को नमाज़ आँकड़ों में न गिनें"
        ),
    },
    "it": {
        "cycleModePauseStreaksLabel": "Proteggi la serie di preghiere",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Mantieni la tua serie durante i giorni del ciclo"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Non contare i giorni del ciclo nelle statistiche di preghiera"
        ),
    },
    "nl": {
        "cycleModePauseStreaksLabel": "Gebedsreeks beschermen",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Behoud je reeks tijdens cyclusdagen"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Cyclusdagen niet meerekenen in je gebedstatistieken"
        ),
    },
    "pt": {
        "cycleModePauseStreaksLabel": "Proteger sequência de oração",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Mantém a tua sequência intacta durante os dias do ciclo"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Não contar os dias do ciclo nas estatísticas de oração"
        ),
    },
    "ro": {
        "cycleModePauseStreaksLabel": "Protejează seria de rugăciuni",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Păstrează seria intactă în zilele de ciclu"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Nu include zilele de ciclu în statisticile de rugăciune"
        ),
    },
    "ru": {
        "cycleModePauseStreaksLabel": "Защитить серию намазов",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Сохраняй серию во время дней цикла"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Не учитывать дни цикла в статистике намазов"
        ),
    },
    "zh": {
        "cycleModePauseStreaksLabel": "保护礼拜连续记录",
        "cycleModeProtectPrayerStreakSubtitle": (
            "在周期日内保持连续记录不变"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "周期日不计入礼拜统计数据"
        ),
    },
    "az": {
        "cycleModePauseStreaksLabel": "Namaz seriyasını qoru",
        "cycleModeProtectPrayerStreakSubtitle": (
            "Sikl günlərində seriyanı qoruyun"
        ),
        "cycleModeExcludeFromStatisticsSubtitle": (
            "Sikl günlərini namaz statistikasında saymayın"
        ),
    },
}


def main() -> None:
    for locale, entries in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        for key, value in entries.items():
            data[key] = value
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
