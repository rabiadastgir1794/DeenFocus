"""CTC decode helpers."""

from __future__ import annotations

BLANK_ID = 1024


def collapse_ctc(ids: list[int], blank_id: int = BLANK_ID) -> list[int]:
    out: list[int] = []
    prev = -1
    for i in ids:
        if i == blank_id:
            prev = -1
            continue
        if i != prev:
            out.append(int(i))
        prev = i
    return out
