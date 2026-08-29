#!/usr/bin/env python3
"""Insert Home Lock Screen Styles promo l10n keys after homeTajweedPromoWordAccuracy."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "@homeTajweedPromoWordAccuracy"

EN = {
    "homeLockScreenPromoTitle": "Lock Screen Styles",
    "homeLockScreenPromoBody":
        "Personalize your lock screen with beautiful Islamic designs and helpful reminders.",
    "homeLockScreenPromoCta": "Explore Styles",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "homeLockScreenPromoTitle": "أنماط شاشة القفل",
        "homeLockScreenPromoBody":
            "خصّص شاشة القفل بتصاميم إسلامية جميلة وتذكيرات مفيدة.",
        "homeLockScreenPromoCta": "استكشف الأنماط",
    },
    "de": {
        **EN,
        "homeLockScreenPromoTitle": "Sperrbildschirm-Stile",
        "homeLockScreenPromoBody":
            "Gestalte deinen Sperrbildschirm mit schönen islamischen Designs und hilfreichen Erinnerungen.",
        "homeLockScreenPromoCta": "Stile entdecken",
    },
    "es": {
        **EN,
        "homeLockScreenPromoTitle": "Estilos de pantalla de bloqueo",
        "homeLockScreenPromoBody":
            "Personaliza tu pantalla de bloqueo con diseños islámicos y recordatorios útiles.",
        "homeLockScreenPromoCta": "Explorar estilos",
    },
    "fr": {
        **EN,
        "homeLockScreenPromoTitle": "Styles d'écran de verrouillage",
        "homeLockScreenPromoBody":
            "Personnalisez votre écran de verrouillage avec de beaux designs islamiques et des rappels utiles.",
        "homeLockScreenPromoCta": "Explorer les styles",
    },
    "hi": {
        **EN,
        "homeLockScreenPromoTitle": "लॉक स्क्रीन शैलियाँ",
        "homeLockScreenPromoBody":
            "सुंदर इस्लामी डिज़ाइन और उपयोगी रिमाइंडर के साथ अपनी लॉक स्क्रीन को व्यक्तिगत बनाएं।",
        "homeLockScreenPromoCta": "शैलियाँ देखें",
    },
    "it": {
        **EN,
        "homeLockScreenPromoTitle": "Stili schermata di blocco",
        "homeLockScreenPromoBody":
            "Personalizza la schermata di blocco con bellissimi design islamici e promemoria utili.",
        "homeLockScreenPromoCta": "Esplora stili",
    },
    "nl": {
        **EN,
        "homeLockScreenPromoTitle": "Vergrendelschermstijlen",
        "homeLockScreenPromoBody":
            "Personaliseer je vergrendelscherm met mooie islamitische designs en nuttige herinneringen.",
        "homeLockScreenPromoCta": "Stijlen verkennen",
    },
    "pt": {
        **EN,
        "homeLockScreenPromoTitle": "Estilos de tela de bloqueio",
        "homeLockScreenPromoBody":
            "Personalize sua tela de bloqueio com belos designs islâmicos e lembretes úteis.",
        "homeLockScreenPromoCta": "Explorar estilos",
    },
    "ro": {
        **EN,
        "homeLockScreenPromoTitle": "Stiluri ecran de blocare",
        "homeLockScreenPromoBody":
            "Personalizează ecranul de blocare cu designuri islamice frumoase și memento-uri utile.",
        "homeLockScreenPromoCta": "Explorează stiluri",
    },
    "ru": {
        **EN,
        "homeLockScreenPromoTitle": "Стили экрана блокировки",
        "homeLockScreenPromoBody":
            "Настройте экран блокировки красивыми исламскими дизайнами и полезными напоминаниями.",
        "homeLockScreenPromoCta": "Посмотреть стили",
    },
    "zh": {
        **EN,
        "homeLockScreenPromoTitle": "锁屏样式",
        "homeLockScreenPromoBody": "用精美的伊斯兰设计和实用提醒个性化你的锁屏。",
        "homeLockScreenPromoCta": "探索样式",
    },
    "az": {
        **EN,
        "homeLockScreenPromoTitle": "Kilid ekranı stilləri",
        "homeLockScreenPromoBody":
            "Kilid ekranınızı gözəl islami dizaynlar və faydalı xatırlatmalarla fərdiləşdirin.",
        "homeLockScreenPromoCta": "Stilləri kəşf et",
    },
}


def insert_after_anchor(data: dict, anchor: str, new_entries: dict) -> None:
    if "homeLockScreenPromoTitle" in data:
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
