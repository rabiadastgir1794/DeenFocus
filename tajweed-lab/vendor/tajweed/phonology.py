"""Arabic phoneme tables used to route tajweed rules.

Conventions:
- Phonemes are lowercase Latin-ascii labels as produced by MMS-FA / espeak
  style transcription (e.g. 'aa' for long fatha, 'q' for qaf).
- Each set is the union of all label variants we expect from upstream
  aligners — if MMS-FA emits a slightly different label we add it here.
"""

# Qalqalah letters (the "bouncing" consonants when they carry a sukun)
QALQALAH = {"q", "T", "tQ", "b", "j", "d"}

# Long vowels (madd) — the lengthened vowels in Quranic recitation
LONG_VOWELS = {"aa", "ii", "uu", "a:", "i:", "u:"}

# Short vowels
SHORT_VOWELS = {"a", "i", "u"}
VOWELS = LONG_VOWELS | SHORT_VOWELS

# Nasal letters (carry ghunnah duration when they appear with sukun
# or in specific contexts like noon-saakinah/tanween).
NASALS = {"n", "m", "ng"}

# Emphatic ("heavy") consonants — always tafkheem.
ALWAYS_EMPHATIC = {"S", "D", "T", "Z", "q", "kh", "gh"}

# ر is the canonical context-dependent emphatic. tafkheem with /a u/, tarqeeq with /i/.
CONTEXT_EMPHATIC = {"r"}

# Letters where ikhfaa / idghaam transitions can occur after a noon-saakinah.
IKHFAA_LETTERS = {"t", "th", "j", "d", "dh", "z", "s", "sh", "S", "D", "T", "Z", "f", "q", "k"}
IDGHAAM_LETTERS = {"y", "r", "m", "l", "w", "n"}

# Friendly display names
RULE_NAMES = {
    "madd": "مد (madd)",
    "ghunnah": "غنة (ghunnah)",
    "qalqalah": "قلقلة (qalqalah)",
    "sukun_pause": "سكون (sukun pause)",
    "tafkheem_tarqeeq": "تفخيم/ترقيق",
    "ikhfaa": "إخفاء (ikhfaa)",
}


def is_qalqalah_letter(phoneme: str) -> bool:
    return phoneme.lower() in {p.lower() for p in QALQALAH}


def is_long_vowel(phoneme: str) -> bool:
    return phoneme in LONG_VOWELS


def is_nasal(phoneme: str) -> bool:
    return phoneme in NASALS


def is_context_emphatic(phoneme: str) -> bool:
    return phoneme in CONTEXT_EMPHATIC
