#!/usr/bin/env python3
"""Upsert App Demo mode-picker copy keys into all app_*.arb files."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

KEYS: dict[str, dict[str, str]] = {
    "en": {
        "settingsAppDemoChooseModeTitle": "Experience App Lock",
        "settingsAppDemoChooseModeSubtitle":
            "Choose a Focus Mode and see how selected apps pause — without leaving DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "Pause distractions at Salah so you can pray with presence.",
        "settingsAppDemoSleepCardSubtitle":
            "Protect your nights so rest comes easier — and Fajr feels lighter.",
        "settingsAppDemoChildCardSubtitle":
            "Hand over your phone knowing only allowed apps stay open.",
    },
    "ar": {
        "settingsAppDemoChooseModeTitle": "جرّب قفل التطبيقات",
        "settingsAppDemoChooseModeSubtitle":
            "اختر وضع تركيز وشاهد كيف تتوقف التطبيقات المحددة — دون مغادرة DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "أوقف المشتتات وقت الصلاة لتصلّي بحضور قلب.",
        "settingsAppDemoSleepCardSubtitle":
            "احمِ ليلك لترتاح أفضل — ويستيقظ فجرك أخف.",
        "settingsAppDemoChildCardSubtitle":
            "سلّم هاتفك مطمئنًا: فقط التطبيقات المسموحة تبقى مفتوحة.",
    },
    "az": {
        "settingsAppDemoChooseModeTitle": "Tətbiq Kilidini sınayın",
        "settingsAppDemoChooseModeSubtitle":
            "Bir Fokus rejimi seçin və seçilmiş tətbiqlərin necə dayandığını görün — DeenFocus-dan çıxmadan.",
        "settingsAppDemoPrayerCardSubtitle":
            "Namaz vaxtı diqqəti yayındıranları dayandırın ki, huşu ilə namaz qılasınız.",
        "settingsAppDemoSleepCardSubtitle":
            "Gecələrinizi qoruyun ki, daha rahat yatın — və Fəcr daha yüngül olsun.",
        "settingsAppDemoChildCardSubtitle":
            "Telefonunuzu əminliklə verin: yalnız icazəli tətbiqlər açıq qalır.",
    },
    "de": {
        "settingsAppDemoChooseModeTitle": "App-Sperre erleben",
        "settingsAppDemoChooseModeSubtitle":
            "Wähle einen Fokus-Modus und sieh, wie ausgewählte Apps pausieren — ohne DeenFocus zu verlassen.",
        "settingsAppDemoPrayerCardSubtitle":
            "Pausiere Ablenkungen zur Salah, damit du mit Präsenz beten kannst.",
        "settingsAppDemoSleepCardSubtitle":
            "Schütze deine Nächte, damit Ruhe leichter fällt — und Fajr leichter wird.",
        "settingsAppDemoChildCardSubtitle":
            "Gib dein Handy mit Zuversicht weiter — nur erlaubte Apps bleiben offen.",
    },
    "es": {
        "settingsAppDemoChooseModeTitle": "Prueba el bloqueo de apps",
        "settingsAppDemoChooseModeSubtitle":
            "Elige un modo Focus y mira cómo se pausan las apps seleccionadas — sin salir de DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "Pausa las distracciones en el Salah para orar con presencia.",
        "settingsAppDemoSleepCardSubtitle":
            "Protege tus noches para descansar mejor — y que el Fajr se sienta más ligero.",
        "settingsAppDemoChildCardSubtitle":
            "Entrega tu teléfono con tranquilidad: solo quedan abiertas las apps permitidas.",
    },
    "fr": {
        "settingsAppDemoChooseModeTitle": "Découvrez le verrouillage",
        "settingsAppDemoChooseModeSubtitle":
            "Choisissez un mode Focus et voyez comment les apps sélectionnées se mettent en pause — sans quitter DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "Mettez les distractions en pause pendant la Salah pour prier avec présence.",
        "settingsAppDemoSleepCardSubtitle":
            "Protégez vos nuits pour mieux vous reposer — et un Fajr plus léger.",
        "settingsAppDemoChildCardSubtitle":
            "Confiez votre téléphone en toute sérénité : seules les apps autorisées restent ouvertes.",
    },
    "hi": {
        "settingsAppDemoChooseModeTitle": "ऐप लॉक आज़माएँ",
        "settingsAppDemoChooseModeSubtitle":
            "एक फ़ोकस मोड चुनें और देखें कि चुने गए ऐप्स कैसे रुकते हैं — DeenFocus छोड़े बिना।",
        "settingsAppDemoPrayerCardSubtitle":
            "सलाह के समय ध्यान भटकाने वाले ऐप्स रोकें, ताकि आप पूरी मौजूदगी से नमाज़ पढ़ सकें।",
        "settingsAppDemoSleepCardSubtitle":
            "अपनी रातों की रक्षा करें ताकि आराम आसान हो — और फ़ज्र हल्का लगे।",
        "settingsAppDemoChildCardSubtitle":
            "बेफ़िक्र होकर फ़ोन दें — केवल अनुमति वाले ऐप्स खुले रहेंगे।",
    },
    "it": {
        "settingsAppDemoChooseModeTitle": "Prova il blocco app",
        "settingsAppDemoChooseModeSubtitle":
            "Scegli una modalità Focus e vedi come le app selezionate si mettono in pausa — senza uscire da DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "Metti in pausa le distrazioni durante la Salah per pregare con presenza.",
        "settingsAppDemoSleepCardSubtitle":
            "Proteggi le tue notti per riposare meglio — e un Fajr più leggero.",
        "settingsAppDemoChildCardSubtitle":
            "Consegna il telefono con serenità: restano aperte solo le app consentite.",
    },
    "nl": {
        "settingsAppDemoChooseModeTitle": "Ervaar App Lock",
        "settingsAppDemoChooseModeSubtitle":
            "Kies een Focus-modus en zie hoe geselecteerde apps pauzeren — zonder DeenFocus te verlaten.",
        "settingsAppDemoPrayerCardSubtitle":
            "Pauzeer afleidingen tijdens Salah zodat je met aanwezigheid kunt bidden.",
        "settingsAppDemoSleepCardSubtitle":
            "Bescherm je nachten zodat rust makkelijker komt — en Fajr lichter voelt.",
        "settingsAppDemoChildCardSubtitle":
            "Geef je telefoon met vertrouwen door — alleen toegestane apps blijven open.",
    },
    "pt": {
        "settingsAppDemoChooseModeTitle": "Experimente o bloqueio",
        "settingsAppDemoChooseModeSubtitle":
            "Escolha um modo Focus e veja como os apps selecionados pausam — sem sair do DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "Pause distrações no Salah para orar com presença.",
        "settingsAppDemoSleepCardSubtitle":
            "Proteja suas noites para descansar melhor — e um Fajr mais leve.",
        "settingsAppDemoChildCardSubtitle":
            "Entregue o telefone com confiança: só os apps permitidos ficam abertos.",
    },
    "ro": {
        "settingsAppDemoChooseModeTitle": "Experimentează App Lock",
        "settingsAppDemoChooseModeSubtitle":
            "Alege un mod Focus și vezi cum aplicațiile selectate se pun pe pauză — fără să părăsești DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "Pune pe pauză distragerile la Salah ca să te rogi cu prezență.",
        "settingsAppDemoSleepCardSubtitle":
            "Protejează-ți nopțile ca odihna să vină mai ușor — iar Fajr să fie mai ușor.",
        "settingsAppDemoChildCardSubtitle":
            "Încredințează telefonul liniștit: rămân deschise doar aplicațiile permise.",
    },
    "ru": {
        "settingsAppDemoChooseModeTitle": "Попробуйте блокировку",
        "settingsAppDemoChooseModeSubtitle":
            "Выберите режим Focus и посмотрите, как выбранные приложения ставятся на паузу — не покидая DeenFocus.",
        "settingsAppDemoPrayerCardSubtitle":
            "Приостанавливайте отвлечения во время намаза, чтобы молиться с присутствием.",
        "settingsAppDemoSleepCardSubtitle":
            "Защитите ночи, чтобы отдых давался легче — а Фаджр ощущался легче.",
        "settingsAppDemoChildCardSubtitle":
            "Передавайте телефон спокойно: открытыми остаются только разрешённые приложения.",
    },
    "zh": {
        "settingsAppDemoChooseModeTitle": "体验应用锁定",
        "settingsAppDemoChooseModeSubtitle":
            "选择一种专注模式，看看所选应用如何暂停——无需离开 DeenFocus。",
        "settingsAppDemoPrayerCardSubtitle":
            "在礼拜时暂停干扰，让你专心祈祷。",
        "settingsAppDemoSleepCardSubtitle":
            "守护夜晚，让休息更轻松——晨礼也更轻盈。",
        "settingsAppDemoChildCardSubtitle":
            "安心交出手机：只有你允许的应用保持可用。",
    },
}


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        locale = path.stem.removeprefix("app_")
        payload = KEYS.get(locale) or KEYS["en"]
        data = json.loads(path.read_text(encoding="utf-8"))
        data.update(payload)
        path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"updated {path.name}")


if __name__ == "__main__":
    main()
