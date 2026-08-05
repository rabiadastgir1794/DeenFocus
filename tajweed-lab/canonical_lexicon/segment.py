"""Letterstream segmentation and Uthmani↔Imlaei boundary projection."""

from __future__ import annotations

from canonical_lexicon.stage2 import stage2_letterstream, stage2_word


def align_prefix_boundaries(left: str, right: str) -> list[int]:
    """For each ``i in 0..len(left)``, index in ``right`` aligned to ``left[:i]``."""
    n, m = len(left), len(right)
    dp = [[0] * (m + 1) for _ in range(n + 1)]
    for i in range(1, n + 1):
        dp[i][0] = i
    for j in range(1, m + 1):
        dp[0][j] = j
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            cost = 0 if left[i - 1] == right[j - 1] else 1
            dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)

    bounds = [0] * (n + 1)
    i, j = n, m
    while i > 0 or j > 0:
        if (
            i > 0
            and j > 0
            and dp[i][j]
            == dp[i - 1][j - 1] + (0 if left[i - 1] == right[j - 1] else 1)
        ):
            bounds[i] = j
            i -= 1
            j -= 1
        elif i > 0 and dp[i][j] == dp[i - 1][j] + 1:
            bounds[i] = j
            i -= 1
        elif j > 0 and dp[i][j] == dp[i][j - 1] + 1:
            j -= 1
        else:
            break
    bounds[0] = 0
    bounds[n] = m
    for k in range(1, n + 1):
        if bounds[k] < bounds[k - 1]:
            bounds[k] = bounds[k - 1]
    bounds[n] = m
    return bounds


def project_word_boundaries(
    uth_words: list[str], paak_stream: str
) -> tuple[list[str], list[int]]:
    uth_word_stream = "".join(stage2_word(w) for w in uth_words)
    if uth_word_stream == paak_stream:
        bounds = [0]
        pos = 0
        for w in uth_words:
            pos += len(stage2_word(w))
            bounds.append(pos)
        return _slice_stream(paak_stream, bounds), bounds

    letter_bounds = align_prefix_boundaries(uth_word_stream, paak_stream)
    uth_cum = [0]
    for w in uth_words:
        uth_cum.append(uth_cum[-1] + len(stage2_word(w)))
    paak_bounds = [letter_bounds[end] for end in uth_cum]
    return _slice_stream(paak_stream, paak_bounds), paak_bounds


def _slice_stream(stream: str, bounds: list[int]) -> list[str]:
    return [stream[bounds[i] : bounds[i + 1]] for i in range(len(bounds) - 1)]


def _cumulative_sizes(sizes: list[int]) -> list[int]:
    bounds = [0]
    pos = 0
    for n in sizes:
        pos += n
        bounds.append(pos)
    return bounds


def extract_surface_spans(text: str, canonical_words: list[str]) -> list[str]:
    """Extract original-script word spans aligned to ``canonical_words``."""
    source_stream = stage2_letterstream(text)
    target_stream = "".join(canonical_words)
    if not target_stream:
        raise ValueError("empty canonical word list")

    target_cum = _cumulative_sizes([len(w) for w in canonical_words])

    if source_stream == target_stream:
        stream_lens = [len(w) for w in canonical_words]
    else:
        align = align_prefix_boundaries(target_stream, source_stream)
        stream_lens = [
            align[target_cum[i + 1]] - align[target_cum[i]]
            for i in range(len(canonical_words))
        ]

    return _walk_by_stream_lengths(text, stream_lens)


def extract_indopak_surfaces(uth_words: list[str], indopak_text: str) -> list[str]:
    """Extract IndoPak display spans per Uthmani word boundary."""
    uth_stream = "".join(stage2_word(w) for w in uth_words)
    indo_stream = stage2_letterstream(indopak_text)
    uth_cum = _cumulative_sizes([len(stage2_word(w)) for w in uth_words])
    if uth_stream == indo_stream:
        stream_lens = [len(stage2_word(w)) for w in uth_words]
    else:
        align = align_prefix_boundaries(uth_stream, indo_stream)
        stream_lens = [
            align[uth_cum[i + 1]] - align[uth_cum[i]] for i in range(len(uth_words))
        ]
    return _walk_by_stream_lengths(indopak_text, stream_lens)


def _extend_trailing_ignorable(scalars: list[str], start: int, cursor: int) -> int:
    """Include trailing marks that do not add spoken letters (e.g. tanwin)."""
    while cursor < len(scalars):
        ch = scalars[cursor]
        if ch.isspace():
            break
        prev_len = len(stage2_letterstream("".join(scalars[start:cursor])))
        next_len = len(stage2_letterstream("".join(scalars[start : cursor + 1])))
        if next_len > prev_len:
            break
        cursor += 1
    return cursor


def _skip_leading_whitespace(scalars: list[str], cursor: int) -> int:
    while cursor < len(scalars) and scalars[cursor].isspace():
        cursor += 1
    return cursor


def _walk_by_stream_lengths(text: str, stream_lens: list[int]) -> list[str]:
    scalars = list(text)
    out: list[str] = []
    cursor = 0

    for word_idx, need in enumerate(stream_lens):
        if need < 0:
            raise ValueError(f"negative stream length at word {word_idx}")
        cursor = _skip_leading_whitespace(scalars, cursor)
        start = cursor
        got = 0
        while cursor <= len(scalars):
            chunk = "".join(scalars[start:cursor])
            got = len(stage2_letterstream(chunk))
            if got == need:
                cursor = _extend_trailing_ignorable(scalars, start, cursor)
                break
            if got > need:
                while cursor > start and got > need:
                    cursor -= 1
                    got = len(stage2_letterstream("".join(scalars[start:cursor])))
                cursor = _extend_trailing_ignorable(scalars, start, cursor)
                break
            cursor += 1
        if got != need:
            raise ValueError(
                f"could not span word {word_idx}: need {need} stream letters, got {got}"
            )
        span = "".join(scalars[start:cursor]).strip()
        if not span:
            raise ValueError(f"empty surface span at word {word_idx}")
        out.append(span)

    return out
