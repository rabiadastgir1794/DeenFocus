#!/usr/bin/env python3
"""Insert Home Read Quran promo l10n keys after homePromoNewBadge."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "homePromoNewBadge"

EN = {
    "homeReadQuranPromoTitle": "Read Quran",
    "homeReadQuranPromoSubtitle": "Read, listen & practice tajweed",
    "homeReadQuranPromoCta": "Open Quran",
    "homeReadQuranPromoNewBadge": "New",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "homeReadQuranPromoTitle": "اقرأ القرآن",
        "homeReadQuranPromoSubtitle": "اقرأ واستمع وتدرّب على التجويد",
        "homeReadQuranPromoCta": "افتح القرآن",
        "homeReadQuranPromoNewBadge": "جديد",
    },
    "de": {
        **EN,
        "homeReadQuranPromoTitle": "Koran lesen",
        "homeReadQuranPromoSubtitle": "Lesen, hören & Tajweed üben",
        "homeReadQuranPromoCta": "Koran öffnen",
        "homeReadQuranPromoNewBadge": "Neu",
    },
    "es": {
        **EN,
        "homeReadQuranPromoTitle": "Leer el Corán",
        "homeReadQuranPromoSubtitle": "Lee, escucha y practica el tajweed",
        "homeReadQuranPromoCta": "Abrir Corán",
        "homeReadQuranPromoNewBadge": "Nuevo",
    },
    "fr": {
        **EN,
        "homeReadQuranPromoTitle": "Lire le Coran",
        "homeReadQuranPromoSubtitle": "Lisez, écoutez et pratiquez le tajweed",
        "homeReadQuranPromoCta": "Ouvrir le Coran",
        "homeReadQuranPromoNewBadge": "Nouveau",
    },
    "hi": {
        **EN,
        "homeReadQuranPromoTitle": "क़ुरआन पढ़ें",
        "homeReadQuranPromoSubtitle": "पढ़ें, सुनें और तजवीद का अभ्यास करें",
        "homeReadQuranPromoCta": "क़ुरआन खोलें",
        "homeReadQuranPromoNewBadge": "नया",
    },
    "it": {
        **EN,
        "homeReadQuranPromoTitle": "Leggi il Corano",
        "homeReadQuranPromoSubtitle": "Leggi, ascolta e pratica il tajweed",
        "homeReadQuranPromoCta": "Apri Corano",
        "homeReadQuranPromoNewBadge": "Nuovo",
    },
    "nl": {
        **EN,
        "homeReadQuranPromoTitle": "Lees de Koran",
        "homeReadQuranPromoSubtitle": "Lees, luister & oefen tajweed",
        "homeReadQuranPromoCta": "Open Koran",
        "homeReadQuranPromoNewBadge": "Nieuw",
    },
    "pt": {
        **EN,
        "homeReadQuranPromoTitle": "Ler o Alcorão",
        "homeReadQuranPromoSubtitle": "Leia, ouça e pratique tajweed",
        "homeReadQuranPromoCta": "Abrir Alcorão",
        "homeReadQuranPromoNewBadge": "Novo",
    },
    "ro": {
        **EN,
        "homeReadQuranPromoTitle": "Citește Coranul",
        "homeReadQuranPromoSubtitle": "Citește, ascultă și exersează tajweed",
        "homeReadQuranPromoCta": "Deschide Coranul",
        "homeReadQuranPromoNewBadge": "Nou",
    },
    "ru": {
        **EN,
        "homeReadQuranPromoTitle": "Читать Коран",
        "homeReadQuranPromoSubtitle": "Читайте, слушайте и практикуйте тайвид",
        "homeReadQuranPromoCta": "Открыть Коран",
        "homeReadQuranPromoNewBadge": "Новое",
    },
    "zh": {
        **EN,
        "homeReadQuranPromoTitle": "阅读古兰经",
        "homeReadQuranPromoSubtitle": "阅读、聆听并练习塔吉维德",
        "homeReadQuranPromoCta": "打开古兰经",
        "homeReadQuranPromoNewBadge": "新",
    },
    "az": {
        **EN,
        "homeReadQuranPromoTitle": "Quran oxu",
        "homeReadQuranPromoSubtitle": "Oxu, dinlə və təcvid məşqi et",
        "homeReadQuranPromoCta": "Quranı aç",
        "homeReadQuranPromoNewBadge": "Yeni",
    },
}


def insert_after_anchor(data: dict, anchor: str, new_entries: dict) -> None:
    if "homeReadQuranPromoTitle" in data:
        for key, value in new_entries.items():
            data[key] = value
        return

    keys = list(data.keys())
    if anchor not in keys:
        raise KeyError(f"Anchor {anchor!r} not found")
    ordered: dict = {}
    for key in keys:
        ordered[key] = data[key]
        if key == anchor:
            for nk, nv in new_entries.items():
                ordered[nk] = nv
    data.clear()
    data.update(ordered)


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
