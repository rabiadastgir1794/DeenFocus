#!/usr/bin/env python3
"""Upsert Nightly Daily Wrap-Up reminder strings into all ARBs."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

EN = {
    "nightlyWrapUpPrayersTitle": "Finish today's prayers",
    "nightlyWrapUpPrayersBody":
        "Mark any unfinished or missed prayers to protect your Prayer Streak.",
    "nightlyWrapUpChecklistTitle": "Complete your Daily Checklist",
    "nightlyWrapUpChecklistBody":
        "A few checklist items are still open — wrap up your day with intention.",
    "nightlyWrapUpBothTitle": "Wrap up your day",
    "nightlyWrapUpBothBody":
        "Mark remaining prayers and finish your Daily Checklist before the day ends.",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "nightlyWrapUpPrayersTitle": "أكمل صلوات اليوم",
        "nightlyWrapUpPrayersBody":
            "سجّل أي صلاة غير مكتملة أو فائتة لحماية سلسلة صلاتك.",
        "nightlyWrapUpChecklistTitle": "أكمل قائمتك اليومية",
        "nightlyWrapUpChecklistBody":
            "لا تزال بعض عناصر القائمة مفتوحة — اختم يومك بنية.",
        "nightlyWrapUpBothTitle": "اختم يومك",
        "nightlyWrapUpBothBody":
            "سجّل الصلوات المتبقية وأكمل قائمتك اليومية قبل نهاية اليوم.",
    },
    "az": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Bugünkü namazları tamamlayın",
        "nightlyWrapUpPrayersBody":
            "Namaz seriyanızı qorumaq üçün tamamlanmamış və ya buraxılmış namazları işarələyin.",
        "nightlyWrapUpChecklistTitle": "Gündəlik yoxlama siyahınızı tamamlayın",
        "nightlyWrapUpChecklistBody":
            "Bir neçə siyahı elementi hələ açıqdır — günü niyyətlə yekunlaşdırın.",
        "nightlyWrapUpBothTitle": "Gününüzü yekunlaşdırın",
        "nightlyWrapUpBothBody":
            "Qalan namazları işarələyin və gündəlik siyahınızı gün bitməmiş tamamlayın.",
    },
    "de": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Schließe die Gebete von heute ab",
        "nightlyWrapUpPrayersBody":
            "Markiere offene oder verpasste Gebete, um deine Gebets-Serie zu schützen.",
        "nightlyWrapUpChecklistTitle": "Vervollständige deine Tagescheckliste",
        "nightlyWrapUpChecklistBody":
            "Einige Punkte sind noch offen — schließe den Tag bewusst ab.",
        "nightlyWrapUpBothTitle": "Schließe deinen Tag ab",
        "nightlyWrapUpBothBody":
            "Markiere offene Gebete und schließe deine Tagescheckliste vor Tagesende ab.",
    },
    "es": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Completa las oraciones de hoy",
        "nightlyWrapUpPrayersBody":
            "Marca las oraciones pendientes o perdidas para proteger tu racha de oración.",
        "nightlyWrapUpChecklistTitle": "Completa tu lista diaria",
        "nightlyWrapUpChecklistBody":
            "Aún quedan tareas abiertas — cierra el día con intención.",
        "nightlyWrapUpBothTitle": "Cierra tu día",
        "nightlyWrapUpBothBody":
            "Marca las oraciones pendientes y termina tu lista diaria antes de que termine el día.",
    },
    "fr": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Terminez les prières d’aujourd’hui",
        "nightlyWrapUpPrayersBody":
            "Marquez les prières incomplètes ou manquées pour protéger votre série de prières.",
        "nightlyWrapUpChecklistTitle": "Complétez votre liste du jour",
        "nightlyWrapUpChecklistBody":
            "Quelques éléments restent ouverts — concluez votre journée avec intention.",
        "nightlyWrapUpBothTitle": "Concluez votre journée",
        "nightlyWrapUpBothBody":
            "Marquez les prières restantes et terminez votre liste du jour avant la fin de la journée.",
    },
    "hi": {
        **EN,
        "nightlyWrapUpPrayersTitle": "आज की नमाज़ें पूरी करें",
        "nightlyWrapUpPrayersBody":
            "अपनी प्रार्थना स्ट्रीक बचाने के लिए अधूरी या छूटी नमाज़ें मार्क करें।",
        "nightlyWrapUpChecklistTitle": "अपनी दैनिक चेकलिस्ट पूरी करें",
        "nightlyWrapUpChecklistBody":
            "कुछ आइटम अभी बाकी हैं — इरादे के साथ दिन पूरा करें।",
        "nightlyWrapUpBothTitle": "अपना दिन पूरा करें",
        "nightlyWrapUpBothBody":
            "बाकी नमाज़ें मार्क करें और दिन खत्म होने से पहले चेकलिस्ट पूरी करें।",
    },
    "it": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Completa le preghiere di oggi",
        "nightlyWrapUpPrayersBody":
            "Segna le preghiere incomplete o mancate per proteggere la tua serie di preghiere.",
        "nightlyWrapUpChecklistTitle": "Completa la checklist giornaliera",
        "nightlyWrapUpChecklistBody":
            "Alcuni elementi sono ancora aperti — chiudi la giornata con intenzione.",
        "nightlyWrapUpBothTitle": "Chiudi la giornata",
        "nightlyWrapUpBothBody":
            "Segna le preghiere rimanenti e completa la checklist prima della fine della giornata.",
    },
    "nl": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Rond de gebeden van vandaag af",
        "nightlyWrapUpPrayersBody":
            "Markeer onvoltooide of gemiste gebeden om je gebedsreeks te beschermen.",
        "nightlyWrapUpChecklistTitle": "Voltooi je dagelijkse checklist",
        "nightlyWrapUpChecklistBody":
            "Er staan nog items open — rond je dag met intentie af.",
        "nightlyWrapUpBothTitle": "Rond je dag af",
        "nightlyWrapUpBothBody":
            "Markeer openstaande gebeden en voltooi je checklist voor het einde van de dag.",
    },
    "pt": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Conclua as orações de hoje",
        "nightlyWrapUpPrayersBody":
            "Marque orações incompletas ou perdidas para proteger sua sequência de oração.",
        "nightlyWrapUpChecklistTitle": "Complete sua lista diária",
        "nightlyWrapUpChecklistBody":
            "Ainda há itens abertos — encerre o dia com intenção.",
        "nightlyWrapUpBothTitle": "Encerre o seu dia",
        "nightlyWrapUpBothBody":
            "Marque as orações restantes e termine sua lista diária antes do fim do dia.",
    },
    "ro": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Finalizează rugăciunile de azi",
        "nightlyWrapUpPrayersBody":
            "Marchează rugăciunile neterminate sau ratate pentru a-ți proteja seria de rugăciune.",
        "nightlyWrapUpChecklistTitle": "Completează lista zilnică",
        "nightlyWrapUpChecklistBody":
            "Câteva elemente sunt încă deschise — încheie ziua cu intenție.",
        "nightlyWrapUpBothTitle": "Încheie-ți ziua",
        "nightlyWrapUpBothBody":
            "Marchează rugăciunile rămase și termină lista zilnică înainte de sfârșitul zilei.",
    },
    "ru": {
        **EN,
        "nightlyWrapUpPrayersTitle": "Завершите молитвы сегодня",
        "nightlyWrapUpPrayersBody":
            "Отметьте незавершённые или пропущенные молитвы, чтобы сохранить серию молитв.",
        "nightlyWrapUpChecklistTitle": "Завершите ежедневный список",
        "nightlyWrapUpChecklistBody":
            "Несколько пунктов ещё открыты — завершите день с намерением.",
        "nightlyWrapUpBothTitle": "Завершите свой день",
        "nightlyWrapUpBothBody":
            "Отметьте оставшиеся молитвы и завершите ежедневный список до конца дня.",
    },
    "zh": {
        **EN,
        "nightlyWrapUpPrayersTitle": "完成今天的礼拜",
        "nightlyWrapUpPrayersBody": "标记未完成或错过的礼拜，以保护你的礼拜连续记录。",
        "nightlyWrapUpChecklistTitle": "完成今日清单",
        "nightlyWrapUpChecklistBody": "还有几项未完成——有意识地结束今天。",
        "nightlyWrapUpBothTitle": "结束你的一天",
        "nightlyWrapUpBothBody": "标记剩余礼拜，并在今天结束前完成每日清单。",
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
