package com.rnr.deenfocus.tajweed

/** Port of ios/Runner/Tajweed/CtcDecoder.swift — must stay byte-for-byte identical logic. */
object CtcDecoder {
    const val BLANK_ID = 1024

    fun collapse(ids: List<Int>, blankId: Int = BLANK_ID): List<Int> {
        val out = ArrayList<Int>()
        var prev = -1
        for (i in ids) {
            if (i == blankId) {
                prev = -1
                continue
            }
            if (i != prev) {
                out.add(i)
            }
            prev = i
        }
        return out
    }
}
