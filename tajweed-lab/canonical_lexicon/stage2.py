"""Stage-2 spoken-letter fold (ADR-010).

This module is **independent** of production ``TajweedLexicalScoring.normalizeArabic``.
It defines the spoken canonical letter identity used by the lexicon generator and
(on-device) the shadow canonical evaluator.
"""

from __future__ import annotations

DIACRITICS = set(chr(c) for c in range(0x064B, 0x0653)) | {
    "\u0615",
    "\u06E1",
}
DIACRITICS |= {chr(c) for c in range(0x0653, 0x0660)}
FORMAT_CONTROLS = {
    0x200B,
    0x200C,
    0x200D,
    0xFEFF,
    0x00A0,
    0x202F,
    0x2009,
    0x200A,
    0x2060,
    0x061C,
    0x066D,
}
HEH_FAMILY = {0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3}
YA_FAMILY = {0x064A, 0x0649, 0x06CC}
KAF_FAMILY = {0x0643, 0x06A9}


def is_ignorable_mark(ch: str) -> bool:
    cp = ord(ch)
    return (
        ch in DIACRITICS
        or cp == 0x0640
        or (0x06D6 <= cp <= 0x06ED)
        or cp in FORMAT_CONTROLS
    )


def is_heh_family(code: int) -> bool:
    return code in HEH_FAMILY


def is_ya_family(code: int) -> bool:
    return code in YA_FAMILY


def is_kaf_family(code: int) -> bool:
    return code in KAF_FAMILY


def stage2_letterstream(text: str) -> str:
    """Fold Mushaf / Imlaei text to spoken canonical letters (no spaces)."""
    scalars = list(text)
    out: list[str] = []
    i = 0
    while i < len(scalars):
        ch = scalars[i]
        cp = ord(ch)
        if ch.isspace():
            i += 1
            continue
        if cp == 0x0670:
            j = i + 1
            while j < len(scalars) and is_ignorable_mark(scalars[j]):
                j += 1
            if j >= len(scalars) or scalars[j].isspace():
                next_cp = -1
            else:
                next_cp = ord(scalars[j])
            drop = False
            if next_cp >= 0:
                drop = (
                    is_heh_family(next_cp)
                    or is_ya_family(next_cp)
                    or is_kaf_family(next_cp)
                    or next_cp == 0x0644  # lam — e.g. ذلك (no spoken alef)
                )
            else:
                k = i - 1
                while k >= 0 and is_ignorable_mark(scalars[k]):
                    k -= 1
                prev = ord(scalars[k]) if k >= 0 and not scalars[k].isspace() else -1
                drop = prev >= 0 and is_ya_family(prev)
            if not drop:
                out.append("\u0627")
            i += 1
            continue
        if cp == 0x0671:
            out.append("\u0627")
            i += 1
            continue
        if is_ignorable_mark(ch):
            i += 1
            continue
        if is_heh_family(cp):
            out.append("\u0647")
            i += 1
            continue
        out.append(ch)
        i += 1

    s = "".join(out)
    for a, b in [
        ("أ", "ا"),
        ("إ", "ا"),
        ("آ", "ا"),
        ("ى", "ي"),
        ("ک", "ك"),
        ("ی", "ي"),
        ("الائك", "الئك"),
        ("اولائك", "اولئك"),
    ]:
        s = s.replace(a, b)
    # Spoken ṣalāh: Mushaf و+ة / Imlaei ا+ة converge on الصلاه
    s = s.replace("صلوه", "صلاه")
    return s


def stage2_word(text: str) -> str:
    return stage2_letterstream(text)


def split_ascii_words(text: str) -> list[str]:
    parts: list[str] = []
    for raw in text.split():
        w = raw.strip()
        if w and stage2_word(w):
            parts.append(w)
    return parts
