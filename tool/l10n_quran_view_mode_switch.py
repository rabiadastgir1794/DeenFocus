#!/usr/bin/env python3
"""Insert Quran surah/page view toggle l10n keys after quranModePage."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"
ANCHOR = "quranModePage"

EN = {
    "quranSwitchToPageView": "Page view",
    "quranSwitchToSurahView": "Surah view",
}

TRANSLATIONS: dict[str, dict[str, str]] = {
    "en": EN,
    "ar": {
        **EN,
        "quranSwitchToPageView": "عرض الصفحة",
        "quranSwitchToSurahView": "عرض السورة",
    },
    "de": {
        **EN,
        "quranSwitchToPageView": "Seitenansicht",
        "quranSwitchToSurahView": "Surenansicht",
    },
    "es": {
        **EN,
        "quranSwitchToPageView": "Vista de página",
        "quranSwitchToSurahView": "Vista de sura",
    },
    "fr": {
        **EN,
        "quranSwitchToPageView": "Vue page",
        "quranSwitchToSurahView": "Vue sourate",
    },
    "hi": {
        **EN,
        "quranSwitchToPageView": "पृष्ठ दृश्य",
        "quranSwitchToSurahView": "सूरह दृश्य",
    },
    "it": {
        **EN,
        "quranSwitchToPageView": "Vista pagina",
        "quranSwitchToSurahView": "Vista sura",
    },
    "nl": {
        **EN,
        "quranSwitchToPageView": "Paginaweergave",
        "quranSwitchToSurahView": "Soeraweergave",
    },
    "pt": {
        **EN,
        "quranSwitchToPageView": "Vista de página",
        "quranSwitchToSurahView": "Vista de sura",
    },
    "ro": {
        **EN,
        "quranSwitchToPageView": "Vizualizare pagină",
        "quranSwitchToSurahView": "Vizualizare sură",
    },
    "ru": {
        **EN,
        "quranSwitchToPageView": "Просмотр страницы",
        "quranSwitchToSurahView": "Просмотр суры",
    },
    "zh": {
        **EN,
        "quranSwitchToPageView": "页面视图",
        "quranSwitchToSurahView": "章节视图",
    },
    "az": {
        **EN,
        "quranSwitchToPageView": "Səhifə görünüşü",
        "quranSwitchToSurahView": "Surə görünüşü",
    },
}


def insert_after_anchor(data: dict, anchor: str, new_entries: dict) -> None:
    if "quranSwitchToPageView" in data:
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
