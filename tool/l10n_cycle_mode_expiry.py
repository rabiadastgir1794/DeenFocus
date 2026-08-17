#!/usr/bin/env python3
"""Upsert Cycle Mode automatic-expiry notification strings into all ARBs."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

EN = {
    "cycleModeEndedNotificationTitle": "Cycle Mode has ended",
    "cycleModeEndedNotificationBody": (
        "Your Cycle Mode is now off. You can resume praying. "
        "If you want to change your Cycle Mode dates, tap here to edit them."
    ),
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "cycleModeEndedNotificationTitle": "انتهى وضع الدورة",
        "cycleModeEndedNotificationBody": (
            "وضع الدورة متوقف الآن. يمكنك استئناف الصلاة. "
            "إذا أردت تغيير تواريخ وضع الدورة، اضغط هنا لتعديلها."
        ),
    },
    "az": {
        **EN,
        "cycleModeEndedNotificationTitle": "Dövr rejimi bitdi",
        "cycleModeEndedNotificationBody": (
            "Dövr rejiminiz indi sönülüdür. Namaza davam edə bilərsiniz. "
            "Dövr rejimi tarixlərini dəyişmək istəyirsinizsə, redaktə etmək üçün bura toxunun."
        ),
    },
    "de": {
        **EN,
        "cycleModeEndedNotificationTitle": "Zyklusmodus ist beendet",
        "cycleModeEndedNotificationBody": (
            "Dein Zyklusmodus ist jetzt aus. Du kannst wieder beten. "
            "Wenn du die Daten des Zyklusmodus ändern möchtest, tippe hier zum Bearbeiten."
        ),
    },
    "es": {
        **EN,
        "cycleModeEndedNotificationTitle": "El modo ciclo ha terminado",
        "cycleModeEndedNotificationBody": (
            "Tu modo ciclo ahora está desactivado. Puedes volver a orar. "
            "Si quieres cambiar las fechas del modo ciclo, toca aquí para editarlas."
        ),
    },
    "fr": {
        **EN,
        "cycleModeEndedNotificationTitle": "Le mode cycle est terminé",
        "cycleModeEndedNotificationBody": (
            "Votre mode cycle est maintenant désactivé. Vous pouvez reprendre la prière. "
            "Si vous voulez modifier les dates du mode cycle, appuyez ici pour les éditer."
        ),
    },
    "hi": {
        **EN,
        "cycleModeEndedNotificationTitle": "साइकिल मोड समाप्त हो गया",
        "cycleModeEndedNotificationBody": (
            "आपका साइकिल मोड अब बंद है। आप नमाज़ फिर से शुरू कर सकते हैं। "
            "अगर आप साइकिल मोड की तारीखें बदलना चाहते हैं, तो उन्हें संपादित करने के लिए यहाँ टैप करें।"
        ),
    },
    "it": {
        **EN,
        "cycleModeEndedNotificationTitle": "La modalità ciclo è terminata",
        "cycleModeEndedNotificationBody": (
            "La modalità ciclo è ora disattivata. Puoi riprendere a pregare. "
            "Se vuoi modificare le date della modalità ciclo, tocca qui per modificarle."
        ),
    },
    "nl": {
        **EN,
        "cycleModeEndedNotificationTitle": "Cyclusmodus is beëindigd",
        "cycleModeEndedNotificationBody": (
            "Je cyclusmodus staat nu uit. Je kunt weer bidden. "
            "Als je de data van de cyclusmodus wilt wijzigen, tik hier om ze te bewerken."
        ),
    },
    "pt": {
        **EN,
        "cycleModeEndedNotificationTitle": "O modo ciclo terminou",
        "cycleModeEndedNotificationBody": (
            "Seu modo ciclo agora está desligado. Você pode retomar as orações. "
            "Se quiser alterar as datas do modo ciclo, toque aqui para editá-las."
        ),
    },
    "ro": {
        **EN,
        "cycleModeEndedNotificationTitle": "Modul ciclu s-a încheiat",
        "cycleModeEndedNotificationBody": (
            "Modul ciclu este acum dezactivat. Poți relua rugăciunea. "
            "Dacă vrei să schimbi datele modului ciclu, apasă aici pentru a le edita."
        ),
    },
    "ru": {
        **EN,
        "cycleModeEndedNotificationTitle": "Режим цикла завершён",
        "cycleModeEndedNotificationBody": (
            "Режим цикла теперь выключен. Вы можете возобновить намаз. "
            "Если хотите изменить даты режима цикла, нажмите здесь, чтобы отредактировать их."
        ),
    },
    "zh": {
        **EN,
        "cycleModeEndedNotificationTitle": "周期模式已结束",
        "cycleModeEndedNotificationBody": (
            "您的周期模式现已关闭。您可以继续礼拜。"
            "若要更改周期模式日期，请点按此处进行编辑。"
        ),
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
