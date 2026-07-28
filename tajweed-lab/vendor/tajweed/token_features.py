"""Quran-specific per-token feature lookup.

For each SentencePiece token in our 1024-vocab Quran-trained tokenizer, derive
a binary feature vector that captures the tajweed-relevant properties of the
characters inside that token:

  - which tajweed letter classes appear (qalqalah, long vowel, nasal, emphatic, ر)
  - which short vowels / diacritics appear (fatha, kasra, damma, sukun, shadda)
  - is this a word-initial token (starts with the ▁ marker)
  - token length bucket (short / medium / long)

Why this matters: the pronunciation-scoring head currently sees `token_id` as
an opaque integer + a learned 64-dim embedding. It has to infer Quranic
phonology from features alone. By injecting these explicit class bits, we
give the head a Quran-phonology prior — it knows "this is a qalqalah letter
in a sukun context" without having to discover that from data.

Generated at module load and cached. Re-runnable: lookup table is
deterministic from the tokenizer model file.
"""
from __future__ import annotations

from pathlib import Path
from typing import Dict

import numpy as np

# Arabic letter classes — copied from phonology.py with both the
# Arabic-script form and the romanised form to be safe.
QALQALAH_AR = set("قطبجد")
LONG_VOWEL_AR = set("اىآ")
NASAL_AR = set("نم")
ALWAYS_EMPHATIC_AR = set("صضطظقخغ")
R_LETTER = "ر"  # context-dependent emphatic
HAMZA_AR = set("ءأإؤئ")

# Tashkeel codepoints (diacritics)
FATHA = "َ"
KASRA = "ِ"
DAMMA = "ُ"
SUKUN = "ْ"
SHADDA = "ّ"
FATHATAN = "ً"
KASRATAN = "ٍ"
DAMMATAN = "ٌ"
WORD_INITIAL_MARKER = "▁"  # SentencePiece's start-of-word


# Feature schema. Order matters — once trained, don't reorder.
FEATURE_NAMES = [
    "has_qalqalah",
    "has_long_vowel",
    "has_nasal",
    "has_always_emphatic",
    "has_r",
    "has_hamza",
    "has_fatha",
    "has_kasra",
    "has_damma",
    "has_sukun",
    "has_shadda",
    "has_tanween",   # any of fathatan/kasratan/dammatan
    "is_word_initial",
    "len_short",     # 1-2 chars
    "len_medium",    # 3-5 chars
    "len_long",      # 6+ chars
]
N_FEATURES = len(FEATURE_NAMES)


def _features_for_token(token_str: str) -> list[int]:
    is_word_initial = int(token_str.startswith(WORD_INITIAL_MARKER))
    raw = token_str.replace(WORD_INITIAL_MARKER, "")
    chars = list(raw)
    # Length bucket on the un-diacritised letter count
    letters = [c for c in chars if c not in (FATHA, KASRA, DAMMA, SUKUN, SHADDA,
                                              FATHATAN, KASRATAN, DAMMATAN)]
    L = len(letters)
    return [
        int(any(c in QALQALAH_AR for c in raw)),
        int(any(c in LONG_VOWEL_AR for c in raw)),
        int(any(c in NASAL_AR for c in raw)),
        int(any(c in ALWAYS_EMPHATIC_AR for c in raw)),
        int(R_LETTER in raw),
        int(any(c in HAMZA_AR for c in raw)),
        int(FATHA in raw),
        int(KASRA in raw),
        int(DAMMA in raw),
        int(SUKUN in raw),
        int(SHADDA in raw),
        int(any(c in (FATHATAN, KASRATAN, DAMMATAN) for c in raw)),
        is_word_initial,
        int(1 <= L <= 2),
        int(3 <= L <= 5),
        int(L >= 6),
    ]


def build_token_feature_table(tokenizer_path: str | Path) -> np.ndarray:
    """Build the (V, N_FEATURES) lookup table from a SentencePiece model.

    V includes the +1 CTC blank slot (last index); blank gets all zeros.
    """
    import sentencepiece as spm
    sp = spm.SentencePieceProcessor(model_file=str(tokenizer_path))
    V = sp.get_piece_size()
    table = np.zeros((V + 1, N_FEATURES), dtype=np.float32)
    for tid in range(V):
        try:
            piece = sp.id_to_piece(tid)
            table[tid] = _features_for_token(piece)
        except Exception:
            pass
    # Blank slot (V) stays zero
    return table
