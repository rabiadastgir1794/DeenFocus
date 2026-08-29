#!/usr/bin/env python3
"""Update Cycle Mode home banner copy (title, subtitle, status line)."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

STATUS_EN = (
    "{days, plural, =0{Streak protected • Ends today} "
    "=1{Streak protected • Ends tomorrow} "
    "other{Streak protected • Ends in {days} days}}"
)

STATUS_META = {
    "@cycleModeActiveStatus": {
        "placeholders": {
            "days": {"type": "int"},
        },
    },
}

TRANSLATIONS: dict[str, dict[str, str | dict]] = {
    "en": {
        "cycleModeActiveTitle": "Your cycle is a pause, not a stop.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Quran listening",
        "cycleModeActiveStatus": STATUS_EN,
        **STATUS_META,
    },
    "ar": {
        "cycleModeActiveTitle": "دورتكِ استراحة، لا توقف.",
        "cycleModeActiveSubtitle": "ذكر • تسبيح • الاستماع للقرآن",
        "cycleModeActiveStatus": (
            "{days, plural, =0{السلسلة محمية • ينتهي اليوم} "
            "=1{السلسلة محمية • ينتهي غداً} "
            "other{السلسلة محمية • ينتهي خلال {days} أيام}}"
        ),
        **STATUS_META,
    },
    "de": {
        "cycleModeActiveTitle": "Dein Zyklus ist eine Pause, kein Stopp.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Quran hören",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Serie geschützt • Endet heute} "
            "=1{Serie geschützt • Endet morgen} "
            "other{Serie geschützt • Endet in {days} Tagen}}"
        ),
        **STATUS_META,
    },
    "es": {
        "cycleModeActiveTitle": "Tu ciclo es una pausa, no un stop.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Escuchar el Corán",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Racha protegida • Termina hoy} "
            "=1{Racha protegida • Termina mañana} "
            "other{Racha protegida • Termina en {days} días}}"
        ),
        **STATUS_META,
    },
    "fr": {
        "cycleModeActiveTitle": "Ton cycle est une pause, pas un arrêt.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Écoute du Coran",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Série protégée • Se termine aujourd'hui} "
            "=1{Série protégée • Se termine demain} "
            "other{Série protégée • Se termine dans {days} jours}}"
        ),
        **STATUS_META,
    },
    "hi": {
        "cycleModeActiveTitle": "आपका चक्र एक विराम है, रुकावट नहीं।",
        "cycleModeActiveSubtitle": "ज़िक्र • तस्बीह • क़ुरआन सुनना",
        "cycleModeActiveStatus": (
            "{days, plural, =0{स्ट्रीक सुरक्षित • आज समाप्त} "
            "=1{स्ट्रीक सुरक्षित • कल समाप्त} "
            "other{स्ट्रीक सुरक्षित • {days} दिनों में समाप्त}}"
        ),
        **STATUS_META,
    },
    "it": {
        "cycleModeActiveTitle": "Il tuo ciclo è una pausa, non uno stop.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Ascolto del Corano",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Serie protetta • Termina oggi} "
            "=1{Serie protetta • Termina domani} "
            "other{Serie protetta • Termina tra {days} giorni}}"
        ),
        **STATUS_META,
    },
    "nl": {
        "cycleModeActiveTitle": "Je cyclus is een pauze, geen stop.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Koran luisteren",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Reeks beschermd • Eindigt vandaag} "
            "=1{Reeks beschermd • Eindigt morgen} "
            "other{Reeks beschermd • Eindigt over {days} dagen}}"
        ),
        **STATUS_META,
    },
    "pt": {
        "cycleModeActiveTitle": "O teu ciclo é uma pausa, não uma paragem.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Ouvir o Alcorão",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Sequência protegida • Termina hoje} "
            "=1{Sequência protegida • Termina amanhã} "
            "other{Sequência protegida • Termina em {days} dias}}"
        ),
        **STATUS_META,
    },
    "ro": {
        "cycleModeActiveTitle": "Ciclul tău e o pauză, nu un stop.",
        "cycleModeActiveSubtitle": "Dhikr • Tasbih • Ascultare Coran",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Serie protejată • Se termină azi} "
            "=1{Serie protejată • Se termină mâine} "
            "other{Serie protejată • Se termină în {days} zile}}"
        ),
        **STATUS_META,
    },
    "ru": {
        "cycleModeActiveTitle": "Твой цикл — пауза, а не остановка.",
        "cycleModeActiveSubtitle": "Зикр • Тасбих • Прослушивание Корана",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Серия защищена • Заканчивается сегодня} "
            "=1{Серия защищена • Заканчивается завтра} "
            "other{Серия защищена • Заканчивается через {days} дн.}}"
        ),
        **STATUS_META,
    },
    "zh": {
        "cycleModeActiveTitle": "你的周期是暂停，不是停止。",
        "cycleModeActiveSubtitle": "记念 • 赞珠 • 听古兰经",
        "cycleModeActiveStatus": (
            "{days, plural, =0{连续记录受保护 • 今天结束} "
            "=1{连续记录受保护 • 明天结束} "
            "other{连续记录受保护 • {days} 天后结束}}"
        ),
        **STATUS_META,
    },
    "az": {
        "cycleModeActiveTitle": "Siklindir pause, dayanmaq deyil.",
        "cycleModeActiveSubtitle": "Zikr • Təsbeh • Quran dinləmə",
        "cycleModeActiveStatus": (
            "{days, plural, =0{Seriya qorunur • Bu gün bitir} "
            "=1{Seriya qorunur • Sabah bitir} "
            "other{Seriya qorunur • {days} günə bitir}}"
        ),
        **STATUS_META,
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
