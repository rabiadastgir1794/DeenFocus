"""Load DeenFocus Quran assets for the tajweed lab UI."""

from __future__ import annotations

import json
import re
import unicodedata
from functools import lru_cache
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[2]
ARABIC_PATH = REPO_ROOT / "assets" / "raw" / "quran_paak.json"
ENGLISH_PATH = REPO_ROOT / "assets" / "raw" / "english_translation.json"

# Mirrors lib/features/quran/data/quran_local_repository.dart
SURAH_ENGLISH_NAMES: dict[int, str] = {
    1: "Al-Fatihah",
    2: "Al-Baqarah",
    3: "Ali 'Imran",
    4: "An-Nisa",
    5: "Al-Ma'idah",
    6: "Al-An'am",
    7: "Al-A'raf",
    8: "Al-Anfal",
    9: "At-Tawbah",
    10: "Yunus",
    11: "Hud",
    12: "Yusuf",
    13: "Ar-Ra'd",
    14: "Ibrahim",
    15: "Al-Hijr",
    16: "An-Nahl",
    17: "Al-Isra",
    18: "Al-Kahf",
    19: "Maryam",
    20: "Ta-Ha",
    21: "Al-Anbiya",
    22: "Al-Hajj",
    23: "Al-Mu'minun",
    24: "An-Nur",
    25: "Al-Furqan",
    26: "Ash-Shu'ara",
    27: "An-Naml",
    28: "Al-Qasas",
    29: "Al-'Ankabut",
    30: "Ar-Rum",
    31: "Luqman",
    32: "As-Sajdah",
    33: "Al-Ahzab",
    34: "Saba'",
    35: "Fatir",
    36: "Ya-Sin",
    37: "As-Saffat",
    38: "Sad",
    39: "Az-Zumar",
    40: "Ghafir",
    41: "Fussilat",
    42: "Ash-Shura",
    43: "Az-Zukhruf",
    44: "Ad-Dukhan",
    45: "Al-Jathiyah",
    46: "Al-Ahqaf",
    47: "Muhammad",
    48: "Al-Fath",
    49: "Al-Hujurat",
    50: "Qaf",
    51: "Adh-Dhariyat",
    52: "At-Tur",
    53: "An-Najm",
    54: "Al-Qamar",
    55: "Ar-Rahman",
    56: "Al-Waqi'ah",
    57: "Al-Hadid",
    58: "Al-Mujadilah",
    59: "Al-Hashr",
    60: "Al-Mumtahanah",
    61: "As-Saff",
    62: "Al-Jumu'ah",
    63: "Al-Munafiqun",
    64: "At-Taghabun",
    65: "At-Talaq",
    66: "At-Tahrim",
    67: "Al-Mulk",
    68: "Al-Qalam",
    69: "Al-Haqqah",
    70: "Al-Ma'arij",
    71: "Nuh",
    72: "Al-Jinn",
    73: "Al-Muzzammil",
    74: "Al-Muddaththir",
    75: "Al-Qiyamah",
    76: "Al-Insan",
    77: "Al-Mursalat",
    78: "An-Naba'",
    79: "An-Nazi'at",
    80: "'Abasa",
    81: "At-Takwir",
    82: "Al-Infitar",
    83: "Al-Mutaffifin",
    84: "Al-Inshiqaq",
    85: "Al-Buruj",
    86: "At-Tariq",
    87: "Al-A'la",
    88: "Al-Ghashiyah",
    89: "Al-Fajr",
    90: "Al-Balad",
    91: "Ash-Shams",
    92: "Al-Layl",
    93: "Ad-Duhaa",
    94: "Ash-Sharh",
    95: "At-Tin",
    96: "Al-'Alaq",
    97: "Al-Qadr",
    98: "Al-Bayyinah",
    99: "Az-Zalzalah",
    100: "Al-'Adiyat",
    101: "Al-Qari'ah",
    102: "At-Takathur",
    103: "Al-'Asr",
    104: "Al-Humazah",
    105: "Al-Fil",
    106: "Quraysh",
    107: "Al-Ma'un",
    108: "Al-Kawthar",
    109: "Al-Kafirun",
    110: "An-Nasr",
    111: "Al-Masad",
    112: "Al-Ikhlas",
    113: "Al-Falaq",
    114: "An-Nas",
}

_DIACRITICS_RE = re.compile(
    r"[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640]"
)


def strip_diacritics(text: str) -> str:
    text = unicodedata.normalize("NFKD", text)
    text = _DIACRITICS_RE.sub("", text)
    return " ".join(text.split())


@lru_cache(maxsize=1)
def _load_raw() -> tuple[list[dict], dict[int, dict]]:
    arabic = json.loads(ARABIC_PATH.read_text(encoding="utf-8"))
    english_list = json.loads(ENGLISH_PATH.read_text(encoding="utf-8"))
    english_by_surah: dict[int, dict] = {}
    for surah in english_list:
        idx = int(surah["@index"])
        english_by_surah[idx] = surah
    return arabic, english_by_surah


@lru_cache(maxsize=1)
def list_surahs() -> list[dict]:
    arabic, _ = _load_raw()
    out: list[dict] = []
    for surah in arabic:
        number = int(surah["@index"])
        ayat = surah.get("aya") or []
        out.append(
            {
                "number": number,
                "name": SURAH_ENGLISH_NAMES.get(number, f"Surah {number}"),
                "arabic_name": surah.get("@name") or "",
                "ayah_count": len(ayat),
            }
        )
    return out


def get_ayah(surah: int, ayah: int) -> dict | None:
    arabic, english_by_surah = _load_raw()
    for surah_obj in arabic:
        if int(surah_obj["@index"]) != surah:
            continue
        for aya in surah_obj.get("aya") or []:
            if int(aya["@index"]) != ayah:
                continue
            eng = ""
            for ea in (english_by_surah.get(surah) or {}).get("aya") or []:
                if int(ea["@index"]) == ayah:
                    eng = ea.get("@text") or ""
                    break
            meta = next((s for s in list_surahs() if s["number"] == surah), None)
            return {
                "surah": surah,
                "ayah": ayah,
                "arabic": aya.get("@text") or "",
                "english": eng,
                "surah_name": (meta or {}).get("name", f"Surah {surah}"),
                "surah_arabic_name": (meta or {}).get("arabic_name", ""),
                "ref": f"{surah}:{ayah}",
            }
    return None


def list_ayahs(surah: int) -> list[dict]:
    arabic, english_by_surah = _load_raw()
    out: list[dict] = []
    for surah_obj in arabic:
        if int(surah_obj["@index"]) != surah:
            continue
        eng_ayat = {
            int(a["@index"]): (a.get("@text") or "")
            for a in (english_by_surah.get(surah) or {}).get("aya") or []
        }
        for aya in surah_obj.get("aya") or []:
            n = int(aya["@index"])
            out.append(
                {
                    "ayah": n,
                    "arabic": aya.get("@text") or "",
                    "english": eng_ayat.get(n, ""),
                    "label": f"Ayah {n}",
                }
            )
        break
    return out


def compare_texts(expected: str, hypothesized: str) -> dict:
    """Simple word-level compare (diacritic-insensitive matching)."""
    from difflib import SequenceMatcher

    exp_words = expected.split()
    hyp_words = hypothesized.split()
    exp_norm = [strip_diacritics(w) for w in exp_words]
    hyp_norm = [strip_diacritics(w) for w in hyp_words]

    sm = SequenceMatcher(a=exp_norm, b=hyp_norm, autojunk=False)
    expected_tokens: list[dict] = []
    heard_tokens: list[dict] = []
    matches = 0
    total = max(len(exp_words), 1)

    for tag, i1, i2, j1, j2 in sm.get_opcodes():
        if tag == "equal":
            for i, j in zip(range(i1, i2), range(j1, j2)):
                matches += 1
                expected_tokens.append({"text": exp_words[i], "status": "ok"})
                heard_tokens.append({"text": hyp_words[j], "status": "ok"})
        elif tag == "replace":
            for i in range(i1, i2):
                expected_tokens.append({"text": exp_words[i], "status": "miss"})
            for j in range(j1, j2):
                heard_tokens.append({"text": hyp_words[j], "status": "wrong"})
        elif tag == "delete":
            for i in range(i1, i2):
                expected_tokens.append({"text": exp_words[i], "status": "miss"})
        elif tag == "insert":
            for j in range(j1, j2):
                heard_tokens.append({"text": hyp_words[j], "status": "extra"})

    exact = strip_diacritics(expected) == strip_diacritics(hypothesized)
    return {
        "exact_match": exact,
        "word_accuracy": round(matches / total, 3),
        "matched_words": matches,
        "expected_words": len(exp_words),
        "expected_tokens": expected_tokens,
        "heard_tokens": heard_tokens,
    }
