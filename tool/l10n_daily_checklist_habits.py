#!/usr/bin/env python3
"""Upsert Daily Checklist habit strings and rename the discipline section."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

NEW_KEYS = (
    "dailyChecklistOptional",
    "dailyChecklistIstighfar",
    "dailyChecklistSalawat",
    "dailyChecklistControlAngerSpeakKindly",
)

EN: dict[str, str] = {
    "dailyChecklistSectionDistraction": "Personal discipline",
    "dailyChecklistOptional": "Optional",
    "dailyChecklistIstighfar": "Istighfar",
    "dailyChecklistSalawat": "Salawat / Durood",
    "dailyChecklistControlAngerSpeakKindly": "Control anger / Speak kindly",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        "dailyChecklistSectionDistraction": "الانضباط الشخصي",
        "dailyChecklistOptional": "اختياري",
        "dailyChecklistIstighfar": "استغفار",
        "dailyChecklistSalawat": "الصلاة على النبي",
        "dailyChecklistControlAngerSpeakKindly": "كظم الغيظ / الكلام الطيب",
    },
    "az": {
        "dailyChecklistSectionDistraction": "Şəxsi intizam",
        "dailyChecklistOptional": "İstəyə bağlı",
        "dailyChecklistIstighfar": "İstighfar",
        "dailyChecklistSalawat": "Salavat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Qəzəbi idarə et / Xoş danış",
    },
    "de": {
        "dailyChecklistSectionDistraction": "Persönliche Disziplin",
        "dailyChecklistOptional": "Optional",
        "dailyChecklistIstighfar": "Istighfar",
        "dailyChecklistSalawat": "Salawat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Wut zügeln / Freundlich sprechen",
    },
    "es": {
        "dailyChecklistSectionDistraction": "Disciplina personal",
        "dailyChecklistOptional": "Opcional",
        "dailyChecklistIstighfar": "Istighfar",
        "dailyChecklistSalawat": "Salawat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Controlar la ira / Hablar con amabilidad",
    },
    "fr": {
        "dailyChecklistSectionDistraction": "Discipline personnelle",
        "dailyChecklistOptional": "Facultatif",
        "dailyChecklistIstighfar": "Istighfar",
        "dailyChecklistSalawat": "Salawat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Maîtriser la colère / Parler avec douceur",
    },
    "hi": {
        "dailyChecklistSectionDistraction": "व्यक्तिगत अनुशासन",
        "dailyChecklistOptional": "वैकल्पिक",
        "dailyChecklistIstighfar": "इस्तिग़फ़ार",
        "dailyChecklistSalawat": "सलावात / दुरूद",
        "dailyChecklistControlAngerSpeakKindly": "गुस्सा नियंत्रित करें / नर्म बोलें",
    },
    "it": {
        "dailyChecklistSectionDistraction": "Disciplina personale",
        "dailyChecklistOptional": "Facoltativo",
        "dailyChecklistIstighfar": "Istighfar",
        "dailyChecklistSalawat": "Salawat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Controlla la rabbia / Parla con gentilezza",
    },
    "nl": {
        "dailyChecklistSectionDistraction": "Persoonlijke discipline",
        "dailyChecklistOptional": "Optioneel",
        "dailyChecklistIstighfar": "Istighfar",
        "dailyChecklistSalawat": "Salawat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Beheers woede / Spreek vriendelijk",
    },
    "pt": {
        "dailyChecklistSectionDistraction": "Disciplina pessoal",
        "dailyChecklistOptional": "Opcional",
        "dailyChecklistIstighfar": "Istighfar",
        "dailyChecklistSalawat": "Salawat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Controlar a raiva / Falar com gentileza",
    },
    "ro": {
        "dailyChecklistSectionDistraction": "Disciplină personală",
        "dailyChecklistOptional": "Opțional",
        "dailyChecklistIstighfar": "Istighfar",
        "dailyChecklistSalawat": "Salawat / Durood",
        "dailyChecklistControlAngerSpeakKindly": "Controlează furia / Vorbește cu bunătate",
    },
    "ru": {
        "dailyChecklistSectionDistraction": "Личная дисциплина",
        "dailyChecklistOptional": "Необязательно",
        "dailyChecklistIstighfar": "Истигфар",
        "dailyChecklistSalawat": "Салават / Дуруд",
        "dailyChecklistControlAngerSpeakKindly": "Сдерживать гнев / Говорить мягко",
    },
    "zh": {
        "dailyChecklistSectionDistraction": "个人自律",
        "dailyChecklistOptional": "可选",
        "dailyChecklistIstighfar": "求饶（Istighfar）",
        "dailyChecklistSalawat": "赞圣 / Durood",
        "dailyChecklistControlAngerSpeakKindly": "克制怒气 / 友善说话",
    },
}


def _json_value(value: Any) -> str:
    dumped = json.dumps(value, ensure_ascii=False, indent=2)
    if "\n" not in dumped:
        return dumped
    return dumped.replace("\n", "\n  ")


def upsert(path: Path, locale: str) -> None:
    original = path.read_text(encoding="utf-8")
    data = json.loads(original)
    values = TRANSLATIONS.get(locale, EN)
    text = original

    section_key = "dailyChecklistSectionDistraction"
    old_section = data.get(section_key)
    new_section = values.get(section_key, EN[section_key])
    if old_section != new_section:
        old_line = f"{json.dumps(section_key)}: {json.dumps(old_section, ensure_ascii=False)}"
        new_line = f"{json.dumps(section_key)}: {json.dumps(new_section, ensure_ascii=False)}"
        if old_line not in text:
            raise SystemExit(f"{path.name}: could not replace {section_key}")
        text = text.replace(old_line, new_line, 1)

    to_add: dict[str, str] = {}
    for key in NEW_KEYS:
        new_value = values.get(key, EN[key])
        if data.get(key) != new_value:
            to_add[key] = new_value
    if not to_add and text == original:
        print(f"unchanged {path.name}")
        return

    if to_add:
        snippet = ",\n".join(
            f"  {json.dumps(key)}: {_json_value(value)}" for key, value in to_add.items()
        )
        text = text.rstrip()
        if not text.endswith("}"):
            raise SystemExit(f"{path.name} does not end with }}")
        text = text[:-1].rstrip()
        if not text.endswith(","):
            text += ","
        text = f"{text}\n{snippet}\n}}\n"

    path.write_text(text if text.endswith("\n") else f"{text}\n", encoding="utf-8")
    print(f"updated {path.name}")


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        if path.name.endswith(".bak"):
            continue
        upsert(path, path.stem.removeprefix("app_"))


if __name__ == "__main__":
    main()
