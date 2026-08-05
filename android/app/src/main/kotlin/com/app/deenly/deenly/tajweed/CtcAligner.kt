package com.rnr.deenfocus.tajweed

/** [tokenIndex] is the position within the `tokenIds` sequence passed to [CtcAligner.forcedAlign]
 * — needed (in addition to [tokenId], the vocab id, which can repeat) to map an interval back to
 * which expected word it belongs to. */
data class TokenInterval(val tokenId: Int, val tokenIndex: Int, val startFrame: Int, val endFrame: Int) {
    val startSec: Double get() = startFrame * 0.08
    val endSec: Double get() = endFrame * 0.08
}

/**
 * CTC forced alignment. Port of ios/Runner/Tajweed/CtcAligner.swift (itself a port of
 * vendor/tajweed/aligner.py::ctc_forced_align) — keep the DP identical across platforms.
 *
 * alpha/back use flat buffers (same recurrence as nested arrays) for fewer allocations.
 */
object CtcAligner {
    const val BLANK_ID = 1024
    private const val NEG_INF = -1e18

    fun forcedAlign(logprobs: Array<FloatArray>, tokenIds: List<Int>): List<TokenInterval> {
        val t = logprobs.size
        val v = if (t > 0) logprobs[0].size else 0
        if (t <= 0 || v <= BLANK_ID) {
            throw TajweedNativeException(TajweedErrorCode.INFERENCE_FAILED, "Invalid logprobs.")
        }
        if (tokenIds.isEmpty()) return emptyList()

        val seq = ArrayList<Int>(tokenIds.size * 2 + 1)
        seq.add(BLANK_ID)
        for (tok in tokenIds) {
            seq.add(tok)
            seq.add(BLANK_ID)
        }
        val s = seq.size
        if (t < s / 2) {
            throw TajweedNativeException(
                TajweedErrorCode.AUDIO_TOO_SHORT,
                "Audio too short for alignment (T=$t, need >= ${s / 2}).",
            )
        }

        val alpha = DoubleArray(t * s) { NEG_INF }
        val back = ByteArray(t * s)

        val skipOk = BooleanArray(s)
        if (s >= 3) {
            for (sIdx in 2 until s) {
                skipOk[sIdx] = seq[sIdx] != BLANK_ID && seq[sIdx] != seq[sIdx - 2]
            }
        }

        fun emit(tIdx: Int, sIdx: Int): Double = logprobs[tIdx][seq[sIdx]].toDouble()

        alpha[0] = emit(0, 0)
        if (s > 1) alpha[1] = emit(0, 1)

        for (tIdx in 1 until t) {
            val prevBase = (tIdx - 1) * s
            val curBase = tIdx * s
            for (sIdx in 0 until s) {
                var best = alpha[prevBase + sIdx]
                var bestIdx: Byte = 0
                if (sIdx >= 1) {
                    val cand = alpha[prevBase + sIdx - 1]
                    if (cand > best) {
                        best = cand
                        bestIdx = 1
                    }
                }
                if (sIdx >= 2 && skipOk[sIdx]) {
                    val cand = alpha[prevBase + sIdx - 2]
                    if (cand > best) {
                        best = cand
                        bestIdx = 2
                    }
                }
                alpha[curBase + sIdx] = best + emit(tIdx, sIdx)
                back[curBase + sIdx] = (-bestIdx).toByte()
            }
        }

        var sIdx = s - 1
        val lastBase = (t - 1) * s
        if (s >= 2 && alpha[lastBase + s - 2] > alpha[lastBase + s - 1]) {
            sIdx = s - 2
        }

        val path = IntArray(t)
        path[t - 1] = sIdx
        for (tIdx in t - 1 downTo 1) {
            sIdx += back[tIdx * s + sIdx].toInt()
            path[tIdx - 1] = sIdx
        }

        val intervals = ArrayList<TokenInterval>(tokenIds.size)
        var tokenIndex = 0
        var start: Int? = null
        for (tIdx in 0 until t) {
            val state = path[tIdx]
            val isToken = state % 2 == 1
            if (isToken) {
                val thisToken = state / 2
                if (start == null) {
                    start = tIdx
                    tokenIndex = thisToken
                } else if (thisToken != tokenIndex) {
                    intervals.add(TokenInterval(tokenIds[tokenIndex], tokenIndex, start, tIdx))
                    start = tIdx
                    tokenIndex = thisToken
                }
            } else if (start != null) {
                intervals.add(TokenInterval(tokenIds[tokenIndex], tokenIndex, start, tIdx))
                start = null
            }
        }
        if (start != null && tokenIndex < tokenIds.size) {
            intervals.add(TokenInterval(tokenIds[tokenIndex], tokenIndex, start, t))
        }
        return intervals
    }
}
