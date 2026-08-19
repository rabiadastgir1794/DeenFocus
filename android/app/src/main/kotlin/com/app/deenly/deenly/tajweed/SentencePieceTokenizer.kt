package com.rnr.deenfocus.tajweed

import java.io.File

/**
 * Lightweight SentencePiece-compatible encode/decode using `tokens.txt`.
 * Port of ios/Runner/Tajweed/SentencePieceTokenizer.swift — greedy longest-match
 * over the vocab (adequate for Phase 3; golden tests should compare
 * diacritic-insensitive text).
 */
class SentencePieceTokenizer(tokensFile: File) {
    private val idToPiece: List<String>
    private val pieceToId = HashMap<String, Int>()
    private val piecesByLength: List<String>

    init {
        val pieces = ArrayList<String>()
        tokensFile.readLines(Charsets.UTF_8).forEach { line ->
            if (line.isEmpty()) return@forEach
            val spaceIdx = line.indexOf(' ')
            val piece = if (spaceIdx >= 0) line.substring(0, spaceIdx) else line
            val id = pieces.size
            pieces.add(piece)
            pieceToId[piece] = id
        }
        if (pieces.isEmpty()) {
            throw TajweedNativeException(TajweedErrorCode.MODEL_LOAD_FAILED, "Empty tokens.txt")
        }
        idToPiece = pieces
        piecesByLength = pieces.sortedByDescending { it.length }
    }

    fun decode(ids: List<Int>): String {
        val sb = StringBuilder()
        for (id in ids) {
            if (id in idToPiece.indices) sb.append(idToPiece[id])
        }
        return sb.toString().replace("\u2581", " ").trim()
    }

    fun encode(text: String): List<Int> {
        var normalized = text.trim()
        if (normalized.isNotEmpty() && !normalized.startsWith("\u2581")) {
            normalized = "\u2581" + normalized.replace(" ", "\u2581")
        }
        val ids = ArrayList<Int>()
        var i = 0
        while (i < normalized.length) {
            var matched = false
            for (piece in piecesByLength) {
                if (normalized.startsWith(piece, i)) {
                    ids.add(pieceToId.getValue(piece))
                    i += piece.length
                    matched = true
                    break
                }
            }
            if (!matched) i += 1
        }
        return ids
    }

    fun piece(id: Int): String {
        if (id !in idToPiece.indices) return ""
        return idToPiece[id].replace("\u2581", "")
    }

    /** True when [id]'s raw piece carries the SentencePiece "▁" word-start marker —
     * i.e. this piece begins a new Quran word rather than continuing the previous one.
     * Used to group per-piece forced-align intervals back into whole-word tokens. */
    fun startsNewWord(id: Int): Boolean {
        if (id !in idToPiece.indices) return false
        return idToPiece[id].startsWith("\u2581")
    }
}
