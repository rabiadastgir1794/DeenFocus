#!/usr/bin/env python3
"""Upsert Focus Mode App Demo enable-offer strings into all ARBs."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

EN = {
    "appLockDemoOfferPrayerTitle": "Ready to try Prayer Mode?",
    "appLockDemoOfferSleepTitle": "Ready to try Sleep Mode?",
    "appLockDemoOfferChildTitle": "Ready to try Child Mode?",
    "appLockDemoOfferPrayerCta": "Enable Prayer Mode",
    "appLockDemoOfferSleepCta": "Enable Sleep Mode",
    "appLockDemoOfferChildCta": "Enable Child Mode",
    "appLockDemoOfferNotNow": "Not now",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "appLockDemoOfferPrayerTitle": "هل أنت مستعد لتجربة وضع الصلاة؟",
        "appLockDemoOfferSleepTitle": "هل أنت مستعد لتجربة وضع النوم؟",
        "appLockDemoOfferChildTitle": "هل أنت مستعد لتجربة وضع الطفل؟",
        "appLockDemoOfferPrayerCta": "تفعيل وضع الصلاة",
        "appLockDemoOfferSleepCta": "تفعيل وضع النوم",
        "appLockDemoOfferChildCta": "تفعيل وضع الطفل",
        "appLockDemoOfferNotNow": "ليس الآن",
    },
    "az": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Namaz Rejimini sınamağa hazırsınız?",
        "appLockDemoOfferSleepTitle": "Yuxu Rejimini sınamağa hazırsınız?",
        "appLockDemoOfferChildTitle": "Uşaq Rejimini sınamağa hazırsınız?",
        "appLockDemoOfferPrayerCta": "Namaz Rejimini aktiv et",
        "appLockDemoOfferSleepCta": "Yuxu Rejimini aktiv et",
        "appLockDemoOfferChildCta": "Uşaq Rejimini aktiv et",
        "appLockDemoOfferNotNow": "İndi yox",
    },
    "de": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Bereit, den Gebetsmodus auszuprobieren?",
        "appLockDemoOfferSleepTitle": "Bereit, den Schlafmodus auszuprobieren?",
        "appLockDemoOfferChildTitle": "Bereit, den Kindermodus auszuprobieren?",
        "appLockDemoOfferPrayerCta": "Gebetsmodus aktivieren",
        "appLockDemoOfferSleepCta": "Schlafmodus aktivieren",
        "appLockDemoOfferChildCta": "Kindermodus aktivieren",
        "appLockDemoOfferNotNow": "Nicht jetzt",
    },
    "es": {
        **EN,
        "appLockDemoOfferPrayerTitle": "¿Listo para probar el Modo Oración?",
        "appLockDemoOfferSleepTitle": "¿Listo para probar el Modo Sueño?",
        "appLockDemoOfferChildTitle": "¿Listo para probar el Modo Niño?",
        "appLockDemoOfferPrayerCta": "Activar Modo Oración",
        "appLockDemoOfferSleepCta": "Activar Modo Sueño",
        "appLockDemoOfferChildCta": "Activar Modo Niño",
        "appLockDemoOfferNotNow": "Ahora no",
    },
    "fr": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Prêt à essayer le Mode Prière ?",
        "appLockDemoOfferSleepTitle": "Prêt à essayer le Mode Sommeil ?",
        "appLockDemoOfferChildTitle": "Prêt à essayer le Mode Enfant ?",
        "appLockDemoOfferPrayerCta": "Activer le Mode Prière",
        "appLockDemoOfferSleepCta": "Activer le Mode Sommeil",
        "appLockDemoOfferChildCta": "Activer le Mode Enfant",
        "appLockDemoOfferNotNow": "Pas maintenant",
    },
    "hi": {
        **EN,
        "appLockDemoOfferPrayerTitle": "प्रार्थना मोड आज़माने के लिए तैयार हैं?",
        "appLockDemoOfferSleepTitle": "स्लीप मोड आज़माने के लिए तैयार हैं?",
        "appLockDemoOfferChildTitle": "चाइल्ड मोड आज़माने के लिए तैयार हैं?",
        "appLockDemoOfferPrayerCta": "प्रार्थना मोड चालू करें",
        "appLockDemoOfferSleepCta": "स्लीप मोड चालू करें",
        "appLockDemoOfferChildCta": "चाइल्ड मोड चालू करें",
        "appLockDemoOfferNotNow": "अभी नहीं",
    },
    "it": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Pronto a provare la Modalità Preghiera?",
        "appLockDemoOfferSleepTitle": "Pronto a provare la Modalità Sonno?",
        "appLockDemoOfferChildTitle": "Pronto a provare la Modalità Bambino?",
        "appLockDemoOfferPrayerCta": "Attiva Modalità Preghiera",
        "appLockDemoOfferSleepCta": "Attiva Modalità Sonno",
        "appLockDemoOfferChildCta": "Attiva Modalità Bambino",
        "appLockDemoOfferNotNow": "Non ora",
    },
    "nl": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Klaar om Gebedsmodus te proberen?",
        "appLockDemoOfferSleepTitle": "Klaar om Slaapmodus te proberen?",
        "appLockDemoOfferChildTitle": "Klaar om Kindmodus te proberen?",
        "appLockDemoOfferPrayerCta": "Gebedsmodus inschakelen",
        "appLockDemoOfferSleepCta": "Slaapmodus inschakelen",
        "appLockDemoOfferChildCta": "Kindmodus inschakelen",
        "appLockDemoOfferNotNow": "Niet nu",
    },
    "pt": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Pronto para experimentar o Modo Oração?",
        "appLockDemoOfferSleepTitle": "Pronto para experimentar o Modo Sono?",
        "appLockDemoOfferChildTitle": "Pronto para experimentar o Modo Criança?",
        "appLockDemoOfferPrayerCta": "Ativar Modo Oração",
        "appLockDemoOfferSleepCta": "Ativar Modo Sono",
        "appLockDemoOfferChildCta": "Ativar Modo Criança",
        "appLockDemoOfferNotNow": "Agora não",
    },
    "ro": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Ești gata să încerci Modul Rugăciune?",
        "appLockDemoOfferSleepTitle": "Ești gata să încerci Modul Somn?",
        "appLockDemoOfferChildTitle": "Ești gata să încerci Modul Copil?",
        "appLockDemoOfferPrayerCta": "Activează Modul Rugăciune",
        "appLockDemoOfferSleepCta": "Activează Modul Somn",
        "appLockDemoOfferChildCta": "Activează Modul Copil",
        "appLockDemoOfferNotNow": "Nu acum",
    },
    "ru": {
        **EN,
        "appLockDemoOfferPrayerTitle": "Готовы попробовать Режим молитвы?",
        "appLockDemoOfferSleepTitle": "Готовы попробовать Режим сна?",
        "appLockDemoOfferChildTitle": "Готовы попробовать Детский режим?",
        "appLockDemoOfferPrayerCta": "Включить Режим молитвы",
        "appLockDemoOfferSleepCta": "Включить Режим сна",
        "appLockDemoOfferChildCta": "Включить Детский режим",
        "appLockDemoOfferNotNow": "Не сейчас",
    },
    "zh": {
        **EN,
        "appLockDemoOfferPrayerTitle": "准备试试礼拜模式吗？",
        "appLockDemoOfferSleepTitle": "准备试试睡眠模式吗？",
        "appLockDemoOfferChildTitle": "准备试试儿童模式吗？",
        "appLockDemoOfferPrayerCta": "启用礼拜模式",
        "appLockDemoOfferSleepCta": "启用睡眠模式",
        "appLockDemoOfferChildCta": "启用儿童模式",
        "appLockDemoOfferNotNow": "暂时不要",
    },
}


def upsert(path: Path, locale: str) -> None:
    data = json.loads(path.read_text(encoding="utf-8"))
    values = TRANSLATIONS.get(locale, EN)
    for key, value in values.items():
        data[key] = value
    for key, value in EN.items():
        data.setdefault(key, value)
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"updated {path.name}")


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        if path.name.endswith(".bak"):
            continue
        upsert(path, path.stem.removeprefix("app_"))


if __name__ == "__main__":
    main()
