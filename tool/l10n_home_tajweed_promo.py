#!/usr/bin/env python3
"""Insert Home Quran AI Tajweed promo l10n keys after homeWidgetsPromoCta."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "homeWidgetsPromoCta"

EN = {
    "homeTajweedPromoTitle": "Quran AI Tajweed",
    "homeTajweedPromoBody":
        "Recite any verse and get instant AI feedback on your Tajweed.",
    "homeTajweedPromoCta": "Practice Tajweed",
    "homeTajweedPromoAiFeedback": "AI Feedback",
    "homeTajweedPromoWordAccuracy": "{percent}% Word Accuracy",
    "@homeTajweedPromoWordAccuracy": {
        "placeholders": {
            "percent": {"type": "int"},
        },
    },
}

TRANSLATIONS: dict[str, dict[str, str | dict]] = {
    "en": EN,
    "ar": {
        **EN,
        "homeTajweedPromoTitle": "تجويد القرآن بالذكاء الاصطناعي",
        "homeTajweedPromoBody":
            "رتّل أي آية واحصل على ملاحظات فورية من الذكاء الاصطناعي على تجويدك.",
        "homeTajweedPromoCta": "تمرّن على التجويد",
        "homeTajweedPromoAiFeedback": "ملاحظات الذكاء الاصطناعي",
        "homeTajweedPromoWordAccuracy": "{percent}٪ دقة الكلمات",
    },
    "de": {
        **EN,
        "homeTajweedPromoTitle": "Quran KI-Tajweed",
        "homeTajweedPromoBody":
            "Rezitiere einen beliebigen Vers und erhalte sofort KI-Feedback zu deinem Tajweed.",
        "homeTajweedPromoCta": "Tajweed üben",
        "homeTajweedPromoAiFeedback": "KI-Feedback",
        "homeTajweedPromoWordAccuracy": "{percent} % Wortgenauigkeit",
    },
    "es": {
        **EN,
        "homeTajweedPromoTitle": "Tajweed del Corán con IA",
        "homeTajweedPromoBody":
            "Recita cualquier versículo y recibe al instante comentarios de IA sobre tu tajweed.",
        "homeTajweedPromoCta": "Practicar tajweed",
        "homeTajweedPromoAiFeedback": "Comentarios de IA",
        "homeTajweedPromoWordAccuracy": "{percent} % precisión de palabras",
    },
    "fr": {
        **EN,
        "homeTajweedPromoTitle": "Tajweed du Coran par IA",
        "homeTajweedPromoBody":
            "Récitez n'importe quel verset et recevez instantanément des retours IA sur votre tajweed.",
        "homeTajweedPromoCta": "Pratiquer le tajweed",
        "homeTajweedPromoAiFeedback": "Retour IA",
        "homeTajweedPromoWordAccuracy": "{percent} % précision des mots",
    },
    "hi": {
        **EN,
        "homeTajweedPromoTitle": "क़ुरआन AI तजवीद",
        "homeTajweedPromoBody":
            "कोई भी आयत पढ़ें और अपनी तजवीद पर तुरंत AI प्रतिक्रिया पाएं।",
        "homeTajweedPromoCta": "तजवीद का अभ्यास",
        "homeTajweedPromoAiFeedback": "AI प्रतिक्रिया",
        "homeTajweedPromoWordAccuracy": "{percent}% शब्द सटीकता",
    },
    "it": {
        **EN,
        "homeTajweedPromoTitle": "Tajweed del Corano con IA",
        "homeTajweedPromoBody":
            "Recita qualsiasi versetto e ricevi subito feedback IA sul tuo tajweed.",
        "homeTajweedPromoCta": "Pratica il tajweed",
        "homeTajweedPromoAiFeedback": "Feedback IA",
        "homeTajweedPromoWordAccuracy": "{percent}% accuratezza parole",
    },
    "nl": {
        **EN,
        "homeTajweedPromoTitle": "Koran AI Tajweed",
        "homeTajweedPromoBody":
            "Reciteer een willekeurige ayah en krijg direct AI-feedback op je tajweed.",
        "homeTajweedPromoCta": "Tajweed oefenen",
        "homeTajweedPromoAiFeedback": "AI-feedback",
        "homeTajweedPromoWordAccuracy": "{percent}% woordnauwkeurigheid",
    },
    "pt": {
        **EN,
        "homeTajweedPromoTitle": "Tajweed do Alcorão com IA",
        "homeTajweedPromoBody":
            "Recite qualquer versículo e receba feedback instantâneo de IA sobre seu tajweed.",
        "homeTajweedPromoCta": "Praticar tajweed",
        "homeTajweedPromoAiFeedback": "Feedback de IA",
        "homeTajweedPromoWordAccuracy": "{percent}% precisão de palavras",
    },
    "ro": {
        **EN,
        "homeTajweedPromoTitle": "Tajweed Coranic cu IA",
        "homeTajweedPromoBody":
            "Recită orice verset și primește feedback instant de la IA pentru tajweed.",
        "homeTajweedPromoCta": "Exersează tajweed",
        "homeTajweedPromoAiFeedback": "Feedback IA",
        "homeTajweedPromoWordAccuracy": "{percent}% acuratețe cuvinte",
    },
    "ru": {
        **EN,
        "homeTajweedPromoTitle": "ИИ-тайвид Корана",
        "homeTajweedPromoBody":
            "Прочитайте любой аят и сразу получите отзыв ИИ о вашем тайвиде.",
        "homeTajweedPromoCta": "Практика тайвида",
        "homeTajweedPromoAiFeedback": "Отзыв ИИ",
        "homeTajweedPromoWordAccuracy": "{percent}% точность слов",
    },
    "zh": {
        **EN,
        "homeTajweedPromoTitle": "古兰经 AI 塔吉维德",
        "homeTajweedPromoBody": "诵读任意经文，即时获得 AI 塔吉维德反馈。",
        "homeTajweedPromoCta": "练习塔吉维德",
        "homeTajweedPromoAiFeedback": "AI 反馈",
        "homeTajweedPromoWordAccuracy": "{percent}% 词准确率",
    },
    "az": {
        **EN,
        "homeTajweedPromoTitle": "Quran AI Təcvid",
        "homeTajweedPromoBody":
            "İstənilən ayəni oxuyun və təcvidiniz barədə dərhal AI rəyini alın.",
        "homeTajweedPromoCta": "Təcvid məşqi",
        "homeTajweedPromoAiFeedback": "AI rəyi",
        "homeTajweedPromoWordAccuracy": "{percent}% söz dəqiqliyi",
    },
}


def insert_after_anchor(data: dict, anchor: str, new_entries: dict) -> None:
    if "homeTajweedPromoTitle" in data:
        for key, value in new_entries.items():
            data[key] = value
        return

    keys = list(data.keys())
    if anchor not in keys:
        raise KeyError(f"Anchor {anchor!r} not found")
    idx = keys.index(anchor) + 1
    for key, value in new_entries.items():
        data[key] = value
    # Reorder: rebuild dict preserving order with new keys after anchor
    ordered: dict = {}
    inserted = False
    for key in keys:
        ordered[key] = data[key]
        if key == anchor:
            for nk, nv in new_entries.items():
                ordered[nk] = nv
            inserted = True
    if not inserted:
        raise RuntimeError("Failed to insert keys")


def main() -> None:
    for locale, entries in TRANSLATIONS.items():
        path = ROOT / f"app_{locale}.arb"
        with path.open(encoding="utf-8") as f:
            data = json.load(f)
        insert_after_anchor(data, ANCHOR, entries)
        with path.open("w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write("\n")
        print(f"Updated {path.name}")


if __name__ == "__main__":
    main()
