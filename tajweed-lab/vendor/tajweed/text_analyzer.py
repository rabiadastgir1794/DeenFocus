"""Diacritized Arabic text analyzer for tajweed rule applicability.

Produces a sequence of CharAnnotation objects from a Quranic verse string.
Each annotation carries:
  - the base Arabic letter
  - its diacritic state (fatha / kasra / damma / sukun / tanween-fath/-damm/-kasr / shaddah)
  - context flags computed from neighbors (next/prev letter + diacritic)
  - the **list of tajweed rules** triggered AT this letter (and any params)

The downstream rule engine (tajweed.engine) consumes these annotations to
decide which acoustic measurement to run on which audio slice.

Hafs riwayah conventions only.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Optional


# ===================== Arabic letter sets =====================
ARABIC_LETTERS = set("ءأإآؤئابتثجحخدذرزسشصضطظعغفقكلمنهوي ة ى".replace(" ", ""))

# Throat letters → idhar halqi (noon-saakinah + these = clear pronunciation)
IDHAR_LETTERS = set("ءهعحغخ")

# Yarmaloon → idgham (noon merges into the following letter)
IDGHAM_LETTERS = set("يرملون")
# Subset: no ghunnah on ر and ل (no nasal during merge)
IDGHAM_NO_GHUNNAH = set("رل")
# Subset: with ghunnah on ي ن م و
IDGHAM_WITH_GHUNNAH = set("ينمو")

# Ba → iqlab (noon turns into hidden meem with ghunnah)
IQLAB_LETTER = "ب"

# 15 letters → ikhfa haqiqi (noon partially hidden, ghunnah continues)
IKHFA_LETTERS = set("صذثكجشقسدطزفتضظ")

# Meem-saakin rules: next letter determines rule
MEEM_IDGHAM_LETTER = "م"       # meem + meem = idgham shafawi (with ghunnah)
MEEM_IKHFA_LETTER = "ب"        # meem + ba = ikhfa shafawi
# Anything else after a saakin meem = idhar shafawi

# Qalqalah letters
QALQALAH_LETTERS = set("قطبجد")

# Always-emphatic letters (tafkheem always)
ALWAYS_EMPHATIC = set("خصضطظغق")

# Sun letters (lam of "ال" assimilates — silent lam, shaddah on next letter)
SUN_LETTERS = set("تثدذرزسشصضطظلن")
# Moon letters (lam of "ال" pronounced clearly)
MOON_LETTERS = set("ءبجحخعغفقكمهوي")

# Special: lam of lafdh al-jalalah (الله) — tafkheem if preceded by fatha/damma
ALLAH_LAFDH = "الله"

# Diacritics
FATHA   = "َ"
KASRA   = "ِ"
DAMMA   = "ُ"
SUKUN   = "ْ"
SHADDAH = "ّ"
FATHATAN = "ً"
DAMMATAN = "ٌ"
KASRATAN = "ٍ"
TANWEEN_SET = {FATHATAN, DAMMATAN, KASRATAN}
HARAKA_SET = {FATHA, KASRA, DAMMA}

# Wasl alef (هـ)
WASL_HAMZA = "ٱ"


@dataclass
class CharAnnotation:
    """All the context for one Arabic letter in the recitation stream."""
    char: str                       # base letter (one of ARABIC_LETTERS)
    index: int                      # position in the original string
    has_sukun: bool = False
    has_shaddah: bool = False
    tanween: Optional[str] = None   # 'fath' | 'damm' | 'kasr' | None
    vowel: Optional[str] = None     # 'fatha' | 'kasra' | 'damma' | None
    next_letter: Optional[str] = None
    next_vowel: Optional[str] = None       # vowel on the next letter (after sukun on this)
    next_has_shaddah: bool = False
    prev_letter: Optional[str] = None
    prev_vowel: Optional[str] = None
    is_word_initial: bool = False
    is_word_final: bool = False
    word_text: str = ""                    # the whole word this letter is in
    word_index: int = 0                    # 0-based word number
    rules: list[dict] = field(default_factory=list)
    # rules entries: {"rule": "idgham_with_ghunnah", "params": {...}, "msg_en": "...", "msg_ar": "..."}


def _strip_diacritics(text: str) -> str:
    return "".join(c for c in text if c not in TANWEEN_SET and c not in HARAKA_SET
                   and c not in {SUKUN, SHADDAH})


def _parse_word(word: str, word_idx: int) -> list[CharAnnotation]:
    """First pass: parse a single word into per-letter annotations
    with diacritic info, but no inter-letter rule yet."""
    anns: list[CharAnnotation] = []
    i = 0
    char_idx = 0
    n = len(word)
    while i < n:
        ch = word[i]
        if ch in HARAKA_SET or ch in TANWEEN_SET or ch in {SUKUN, SHADDAH}:
            i += 1
            continue
        if ch not in ARABIC_LETTERS and ch != WASL_HAMZA:
            i += 1
            continue
        # New letter slot
        a = CharAnnotation(char=ch, index=char_idx, word_index=word_idx, word_text=word)
        char_idx += 1
        # Look ahead for attached diacritics
        j = i + 1
        while j < n and word[j] in (HARAKA_SET | TANWEEN_SET | {SUKUN, SHADDAH}):
            d = word[j]
            if d == SHADDAH:
                a.has_shaddah = True
            elif d == SUKUN:
                a.has_sukun = True
            elif d == FATHA:
                a.vowel = "fatha"
            elif d == KASRA:
                a.vowel = "kasra"
            elif d == DAMMA:
                a.vowel = "damma"
            elif d == FATHATAN:
                a.tanween = "fath"
            elif d == DAMMATAN:
                a.tanween = "damm"
            elif d == KASRATAN:
                a.tanween = "kasr"
            j += 1
        anns.append(a)
        i = j
    if anns:
        anns[0].is_word_initial = True
        anns[-1].is_word_final = True
    return anns


def _link_neighbors(all_anns: list[CharAnnotation]) -> None:
    """Fill prev/next letter context across word boundaries
    (tajweed rules cross word boundaries in continuous recitation)."""
    for i, a in enumerate(all_anns):
        if i > 0:
            p = all_anns[i - 1]
            a.prev_letter = p.char
            a.prev_vowel = p.vowel
        if i + 1 < len(all_anns):
            n = all_anns[i + 1]
            a.next_letter = n.char
            a.next_vowel = n.vowel
            a.next_has_shaddah = n.has_shaddah


def _detect_nun_rules(a: CharAnnotation) -> Optional[dict]:
    """Noon-saakinah / tanween rules: depend on the NEXT consonant.

    Returns a rule dict for the noon position or None.
    """
    is_noon_saakin = (a.char == "ن" and a.has_sukun)
    is_tanween = a.tanween is not None
    if not (is_noon_saakin or is_tanween):
        return None
    nxt = a.next_letter
    if nxt is None:
        return None  # end of utterance — pause cancels rule

    if nxt in IDHAR_LETTERS:
        return {"rule": "idhar_halqi",
                "msg_en": f"Pronounce the noon/tanween clearly before {nxt}",
                "msg_ar": "إظهار حلقي",
                "params": {}}
    if nxt in IDGHAM_NO_GHUNNAH:
        return {"rule": "idgham_no_ghunnah",
                "msg_en": f"Merge noon/tanween into {nxt} without ghunnah",
                "msg_ar": "إدغام بلا غنة",
                "params": {}}
    if nxt in IDGHAM_WITH_GHUNNAH:
        return {"rule": "idgham_with_ghunnah",
                "msg_en": f"Merge noon/tanween into {nxt} with ghunnah (~2 beats)",
                "msg_ar": "إدغام بغنة",
                "params": {"expected_ghunnah_s": 0.30}}
    if nxt == IQLAB_LETTER:
        return {"rule": "iqlab",
                "msg_en": "Convert noon/tanween to a hidden meem before ب (with ghunnah)",
                "msg_ar": "إقلاب",
                "params": {"expected_ghunnah_s": 0.30}}
    if nxt in IKHFA_LETTERS:
        return {"rule": "ikhfa_haqiqi",
                "msg_en": f"Partially hide the noon before {nxt} with ghunnah (~2 beats)",
                "msg_ar": "إخفاء حقيقي",
                "params": {"expected_ghunnah_s": 0.30}}
    return None


def _detect_meem_rules(a: CharAnnotation) -> Optional[dict]:
    """Meem-saakin rules (3): idgham/ikhfa/idhar shafawi."""
    if a.char != "م" or not a.has_sukun:
        return None
    nxt = a.next_letter
    if nxt is None:
        return None
    if nxt == "م":
        return {"rule": "idgham_shafawi",
                "msg_en": "Merge meem-saakin into the next meem with ghunnah",
                "msg_ar": "إدغام شفوي",
                "params": {"expected_ghunnah_s": 0.30}}
    if nxt == "ب":
        return {"rule": "ikhfa_shafawi",
                "msg_en": "Lightly hide the meem-saakin before ب with ghunnah",
                "msg_ar": "إخفاء شفوي",
                "params": {"expected_ghunnah_s": 0.30}}
    return {"rule": "idhar_shafawi",
            "msg_en": f"Pronounce the meem-saakin clearly before {nxt}",
            "msg_ar": "إظهار شفوي",
            "params": {}}


def _detect_madd_rules(a: CharAnnotation, all_anns: list[CharAnnotation], i: int) -> Optional[dict]:
    """Madd typology. Five basic types we handle now:
      - madd tabi'i (natural): alif/waw/yaa madd letter with no hamza/sukun next → 2 beats
      - madd muttasil (joined): madd letter + hamza in SAME word → 4-5 beats
      - madd munfasil (separated): madd letter + hamza in NEXT word → 4-5 beats
      - madd lazim kalimi muthaqqal: madd + sukun on next letter (incl. shaddah) → 6 beats
      - madd 'aridh: madd letter at end of utterance (stopped) → 2-6 beats (ok range)
    """
    is_madd_letter = (
        (a.char == "ا") or
        (a.char == "ى") or
        (a.char == "آ") or
        (a.char == "و" and a.has_sukun and a.prev_vowel == "damma") or
        (a.char == "ي" and a.has_sukun and a.prev_vowel == "kasra")
    )
    if not is_madd_letter:
        return None
    # Look at NEXT letter and its diacritic, possibly across word boundary
    if i + 1 >= len(all_anns):
        # End of utterance → madd 'aridh (allowed 2/4/6)
        return {"rule": "madd_aridh",
                "msg_en": "Stopping at a long vowel — hold for 2, 4, or 6 beats",
                "msg_ar": "مد عارض للسكون",
                "params": {"expected_beats": 4.0, "tolerance_beats": 2.5}}
    nxt = all_anns[i + 1]
    same_word = (nxt.word_index == a.word_index)
    # All hamza-bearing characters count as hamza for madd-trigger purposes
    HAMZA_CHARS = {"ء", "أ", "إ", "آ", "ؤ", "ئ"}
    if nxt.char in HAMZA_CHARS:
        if same_word:
            return {"rule": "madd_muttasil",
                    "msg_en": "Connected madd with hamza in same word — hold ~4 beats",
                    "msg_ar": "مد متصل",
                    "params": {"expected_beats": 4.0, "tolerance_beats": 0.8}}
        return {"rule": "madd_munfasil",
                "msg_en": "Separated madd with hamza in next word — hold ~4 beats",
                "msg_ar": "مد منفصل",
                "params": {"expected_beats": 4.0, "tolerance_beats": 1.0}}
    if nxt.has_shaddah or nxt.has_sukun:
        return {"rule": "madd_lazim",
                "msg_en": "Required madd (sukun/shaddah follows) — hold ~6 beats",
                "msg_ar": "مد لازم",
                "params": {"expected_beats": 6.0, "tolerance_beats": 0.8}}
    return {"rule": "madd_tabii",
            "msg_en": "Natural madd — hold ~2 beats",
            "msg_ar": "مد طبيعي",
            "params": {"expected_beats": 2.0, "tolerance_beats": 1.5}}


def _detect_qalqalah_rules(a: CharAnnotation, is_utterance_end: bool) -> Optional[dict]:
    """Qalqalah sughra (small bounce mid-word) vs kubra (full bounce on stop)."""
    if a.char not in QALQALAH_LETTERS or not a.has_sukun:
        return None
    if is_utterance_end or a.is_word_final:
        return {"rule": "qalqalah_kubra",
                "msg_en": f"Full bounce on {a.char} at the stop",
                "msg_ar": "قلقلة كبرى",
                "params": {"strength": "strong"}}
    return {"rule": "qalqalah_sughra",
            "msg_en": f"Small bounce on {a.char} in the middle of a word",
            "msg_ar": "قلقلة صغرى",
            "params": {"strength": "mild"}}


def _detect_ra_rules(a: CharAnnotation) -> Optional[dict]:
    """ر tafkheem vs tarqeeq.

    Simplified Hafs rules (covering ~90% of cases):
      - ر with fatha or damma → tafkheem
      - ر with kasra → tarqeeq
      - ر saakin: look at the vowel BEFORE
        * fatha/damma → tafkheem
        * kasra → tarqeeq (unless followed by an emphatic letter — istilaa)
    """
    if a.char != "ر":
        return None
    if a.vowel == "fatha" or a.vowel == "damma":
        return {"rule": "ra_tafkheem", "msg_en": "Heavy ر (tafkheem)",
                "msg_ar": "تفخيم الراء", "params": {"expected": "tafkheem"}}
    if a.vowel == "kasra":
        return {"rule": "ra_tarqeeq", "msg_en": "Light ر (tarqeeq)",
                "msg_ar": "ترقيق الراء", "params": {"expected": "tarqeeq"}}
    if a.has_sukun:
        prev_v = a.prev_vowel
        if prev_v in ("fatha", "damma"):
            return {"rule": "ra_tafkheem_saakin",
                    "msg_en": "Heavy ر (tafkheem) — preceded by fatha/damma",
                    "msg_ar": "تفخيم الراء الساكنة",
                    "params": {"expected": "tafkheem"}}
        if prev_v == "kasra":
            return {"rule": "ra_tarqeeq_saakin",
                    "msg_en": "Light ر (tarqeeq) — preceded by kasra",
                    "msg_ar": "ترقيق الراء الساكنة",
                    "params": {"expected": "tarqeeq"}}
    return None


def _detect_allah_lafdh(a: CharAnnotation, all_anns: list[CharAnnotation], i: int) -> Optional[dict]:
    """Lam in الله: tafkheem if preceded by fatha/damma, tarqeeq if preceded by kasra."""
    if a.char != "ل" or not a.has_shaddah:
        return None
    # Check the word is "الله" or "اللهم"
    word = a.word_text
    word_letters = "".join(c for c in word if c in ARABIC_LETTERS)
    if word_letters not in ("الله", "اللهم"):
        return None
    # Look at the immediately preceding vowel (not part of "ال" prefix itself,
    # but the vowel of the prior word's last letter).
    prev_v = None
    for k in range(i - 1, -1, -1):
        if all_anns[k].vowel:
            prev_v = all_anns[k].vowel
            break
        if all_anns[k].has_sukun:
            break
    expected = "tafkheem" if prev_v in ("fatha", "damma") else "tarqeeq"
    return {"rule": "allah_lafdh",
            "msg_en": f"Lam in 'Allah' — {expected} (heavy/light)",
            "msg_ar": ("تفخيم لام لفظ الجلالة" if expected == "tafkheem"
                       else "ترقيق لام لفظ الجلالة"),
            "params": {"expected": expected}}


def _detect_lam_shamsiyyah(a: CharAnnotation, all_anns: list[CharAnnotation], i: int) -> Optional[dict]:
    """ال + sun letter → lam is silent, next letter has shaddah. ال + moon letter → clear lam.

    Note: in fully diacritized Quran text, the lam of ال may NOT carry an
    explicit sukun — what marks the rule is shaddah on the next consonant
    (sun letter case) or sukun on the lam (moon letter case). Accept both.
    """
    if a.char != "ل":
        return None
    # Must be preceded by alef of "ال" word-initially
    if i == 0:
        return None
    prev = all_anns[i - 1]
    if prev.char != "ا" or not prev.is_word_initial:
        return None
    if i + 1 >= len(all_anns):
        return None
    nxt = all_anns[i + 1]
    # Sun-letter rule: shaddah on the next consonant (lam is then silent)
    if nxt.char in SUN_LETTERS and nxt.has_shaddah:
        return {"rule": "lam_shamsiyyah",
                "msg_en": f"Silent lam — shaddah on {nxt.char}",
                "msg_ar": "لام شمسية",
                "params": {"expected": "silent_lam"}}
    # Moon-letter rule: lam pronounced (commonly carries sukun)
    if nxt.char in MOON_LETTERS and (a.has_sukun or not a.vowel):
        return {"rule": "lam_qamariyyah",
                "msg_en": f"Pronounce the lam clearly before {nxt.char}",
                "msg_ar": "لام قمرية",
                "params": {"expected": "pronounced_lam"}}
    return None


def _detect_hamzat_wasl(a: CharAnnotation) -> Optional[dict]:
    """Hamzat wasl (connecting hamza): silent if mid-utterance, vocalized at start."""
    if a.char == WASL_HAMZA or (a.char == "ا" and a.is_word_initial and not a.vowel
                                  and not a.tanween and not a.has_shaddah and not a.has_sukun
                                  and a.word_index > 0):
        return {"rule": "hamzat_wasl",
                "msg_en": "Connecting alef — silent in middle of recitation, vocalized only at start",
                "msg_ar": "همزة الوصل",
                "params": {"expected": "silent_in_continuation"}}
    return None


# ===================== Tier-2 rule detectors =====================

def _detect_idgham_mutamathilain(a: CharAnnotation) -> Optional[dict]:
    """Idgham mutamathilain — identical letters back-to-back (first has sukun).
    The first letter merges silently into the second, which carries shaddah.
    Exception: madd letters (و / ي with their vowel marker) don't apply.
    """
    if not a.has_sukun or a.char in ("ا", "آ", "ى"):
        return None
    if not a.next_letter or a.next_letter != a.char:
        return None
    # Excludes madd-letter situations (و sukin after damma, ي sukin after kasra)
    if a.char == "و" and a.prev_vowel == "damma":
        return None
    if a.char == "ي" and a.prev_vowel == "kasra":
        return None
    return {"rule": "idgham_mutamathilain",
            "msg_en": f"Identical letters merge — {a.char} into {a.next_letter} with shaddah",
            "msg_ar": "إدغام متماثلين",
            "params": {"expected": "silent_first"}}


def _detect_madd_badal(a: CharAnnotation, all_anns: list[CharAnnotation], i: int) -> Optional[dict]:
    """Madd badal: hamza immediately followed by a madd letter (within same word).
    Held for 2 beats normally; some qira'at extend to 4. In Hafs, 2 beats.
    """
    HAMZA_CHARS = {"ء", "أ", "إ", "آ", "ؤ", "ئ"}
    if a.char not in HAMZA_CHARS:
        return None
    if i + 1 >= len(all_anns):
        return None
    nxt = all_anns[i + 1]
    if nxt.word_index != a.word_index:
        return None
    is_madd_after = (nxt.char in ("ا", "آ", "ى") or
                      (nxt.char == "و" and nxt.has_sukun and a.vowel == "damma") or
                      (nxt.char == "ي" and nxt.has_sukun and a.vowel == "kasra"))
    if not is_madd_after:
        return None
    return {"rule": "madd_badal",
            "msg_en": "Hamza + madd letter (badal) — hold ~2 beats",
            "msg_ar": "مد البدل",
            "params": {"expected_beats": 2.0, "tolerance_beats": 1.0}}


def _detect_leen(a: CharAnnotation) -> Optional[dict]:
    """Leen letters: و or ي with sukun preceded by fatha (soft transition,
    not a full long vowel). At a stop they may extend to 2-6 beats (madd leen).
    """
    if not a.has_sukun:
        return None
    if a.char not in ("و", "ي"):
        return None
    if a.prev_vowel != "fatha":
        return None
    # Treat as leen — at end of utterance / word-final → may extend
    if a.is_word_final:
        return {"rule": "madd_leen",
                "msg_en": f"Leen letter at stop — may hold 2 to 6 beats",
                "msg_ar": "مد اللين",
                "params": {"expected_beats": 4.0, "tolerance_beats": 2.5}}
    return {"rule": "leen",
            "msg_en": f"Soft leen sound — gentle {a.char}",
            "msg_ar": "حرف لين",
            "params": {}}


def _detect_specific_qira_marks(a: CharAnnotation) -> Optional[dict]:
    """Detect specific qira'a / waqf markers in the mushaf. These are
    Unicode characters added to the Arabic text (very rare in plain text
    but present in fully-marked editions).
    """
    # Sakta marker (س) appears in 4 specific places in Hafs; we'd need
    # word-position context. Skip for now as deterministic detector.
    return None


def analyze_text(text: str) -> list[CharAnnotation]:
    """Public entry point. Parse the diacritized verse and return per-letter
    annotations with rules attached.

    The audio-aligner is responsible for assigning time intervals to each
    returned annotation by `index` order.
    """
    # Split into words on whitespace
    words = [w for w in text.split() if w.strip()]
    all_anns: list[CharAnnotation] = []
    for wi, word in enumerate(words):
        all_anns.extend(_parse_word(word, wi))
    _link_neighbors(all_anns)

    # Apply rule detectors
    n = len(all_anns)
    for i, a in enumerate(all_anns):
        is_utt_end = (i == n - 1)
        for det in (
            lambda: _detect_nun_rules(a),
            lambda: _detect_meem_rules(a),
            lambda: _detect_madd_rules(a, all_anns, i),
            lambda: _detect_qalqalah_rules(a, is_utt_end),
            lambda: _detect_ra_rules(a),
            lambda: _detect_allah_lafdh(a, all_anns, i),
            lambda: _detect_lam_shamsiyyah(a, all_anns, i),
            lambda: _detect_hamzat_wasl(a),
            lambda: _detect_idgham_mutamathilain(a),
            lambda: _detect_madd_badal(a, all_anns, i),
            lambda: _detect_leen(a),
        ):
            r = det()
            if r is not None:
                a.rules.append(r)
    return all_anns


def applicable_rules(text: str) -> dict[str, int]:
    """Quick count of which rules apply in a given verse — useful for sanity checks."""
    anns = analyze_text(text)
    counts: dict[str, int] = {}
    for a in anns:
        for r in a.rules:
            counts[r["rule"]] = counts.get(r["rule"], 0) + 1
    return counts
