#!/usr/bin/env python3
"""Upsert surah/tajweed header subtitle strings into all ARBs."""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "lib" / "l10n"

KEYS: dict[str, dict[str, str]] = {
    "quranSurahHeaderSubtitle": {
        "en": "{name} • {count} verses",
        "ar": "{name} • {count} آيات",
        "az": "{name} • {count} ayə",
        "de": "{name} • {count} Verse",
        "es": "{name} • {count} versos",
        "fr": "{name} • {count} versets",
        "hi": "{name} • {count} आयतें",
        "it": "{name} • {count} versi",
        "nl": "{name} • {count} verzen",
        "pt": "{name} • {count} versos",
        "ro": "{name} • {count} versuri",
        "ru": "{name} • {count} аятов",
        "zh": "{name} • {count} 节经文",
    },
    "tajweedPracticeAyahTitle": {
        "en": "{surah} · {ref}",
        "ar": "{surah} · {ref}",
        "az": "{surah} · {ref}",
        "de": "{surah} · {ref}",
        "es": "{surah} · {ref}",
        "fr": "{surah} · {ref}",
        "hi": "{surah} · {ref}",
        "it": "{surah} · {ref}",
        "nl": "{surah} · {ref}",
        "pt": "{surah} · {ref}",
        "ro": "{surah} · {ref}",
        "ru": "{surah} · {ref}",
        "zh": "{surah} · {ref}",
    },
}


def main() -> None:
    for path in sorted(ROOT.glob("app_*.arb")):
        locale = path.stem.removeprefix("app_")
        data = json.loads(path.read_text(encoding="utf-8"))
        for key, variants in KEYS.items():
            data[key] = variants.get(locale, variants["en"])
        path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"updated {path.name}")


if __name__ == "__main__":
    main()
