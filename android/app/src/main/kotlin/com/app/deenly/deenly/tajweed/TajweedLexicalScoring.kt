package com.rnr.deenfocus.tajweed

/**
 * Pure Arabic text + word-alignment helpers for lexical-first Tajweed scoring
 * (ADR-006). Unit-testable on the plain JVM without Robolectric.
 *
 * Lexical identity (match / sub / miss / extra) is decided by word-level edit
 * distance against the ASR hypothesis. Pronunciation quality is a separate
 * concept applied only to matched words by [TajweedEngine].
 */
object TajweedLexicalScoring {
    /**
     * Combining marks / sukun forms stripped after orthographic mapping.
     * Note: U+0670 (dagger alif) is **not** stripped — it is mapped to alef so
     * Uthmani `مَٰلِكِ` and Imlaei `مَالِكِ` both become `مالك`.
     * U+06E1 (Quranic high sukun) is stripped like ordinary sukun U+0652.
     */
    private const val DIACRITICS =
        "\u064B\u064C\u064D\u064E\u064F\u0650\u0651\u0652\u0615\u0653\u0654\u06E1"

    enum class LexicalOp {
        MATCH,
        SUB,
        MISS,
        EXTRA,
    }

    /**
     * One step of the word-level alignment between expected ayah words and
     * ASR hypothesis words.
     */
    data class WordAlignOp(
        val op: LexicalOp,
        /** Index into expected words; null for EXTRA. */
        val expectedIndex: Int?,
        /** Index into hypothesis words; null for MISS. */
        val hypIndex: Int?,
        /** Display text: expected word for MATCH/SUB/MISS, hyp word for EXTRA. */
        val text: String,
    )

    fun splitWords(text: String): List<String> =
        text.split(Regex("\\s+")).map { it.trim() }.filter { it.isNotEmpty() }

    /**
     * Canonical Arabic for lexical equality (Uthmani mushaf ↔ Imlaei ASR).
     *
     * Rules (order matters):
     * 1. Map dagger alif U+0670 and alef wasla U+0671 → alef U+0627.
     * 2. Drop tashkeel / sukun (including Quranic sukun U+06E1) and Quranic
     *    annotation marks U+06D6..U+06ED; drop tatweel U+0640.
     * 3. Fold hamza-bearing alefs أ/إ/آ → ا and alif maqsura ى → ي.
     *
     * Does not fuzzy-match or merge distinct consonants (e.g. bare `ملك` ≠ `مالك`).
     */
    fun normalizeArabic(text: String): String {
        val sb = StringBuilder(text.length)
        for (ch in text) {
            when (ch) {
                '\u0670', '\u0671' -> sb.append('\u0627') // ٰ / ٱ → ا
                '\u0640' -> Unit // tatweel
                else -> {
                    val code = ch.code
                    if (DIACRITICS.indexOf(ch) >= 0) continue
                    // Quranic annotation signs (pause, sajda, rub el hizb, etc.)
                    if (code in 0x06D6..0x06ED) continue
                    sb.append(ch)
                }
            }
        }
        return sb.toString()
            .replace('\u0623', '\u0627') // أ -> ا
            .replace('\u0625', '\u0627') // إ -> ا
            .replace('\u0622', '\u0627') // آ -> ا
            .replace('\u0649', '\u064A') // ى -> ي
            .trim()
    }

    /**
     * Word-level Levenshtein alignment (equal / replace / delete / insert).
     * Equal only when [normalizeArabic] forms match.
     */
    fun alignWords(expected: List<String>, hypothesis: List<String>): List<WordAlignOp> {
        val n = expected.size
        val m = hypothesis.size
        val expN = expected.map(::normalizeArabic)
        val hypN = hypothesis.map(::normalizeArabic)

        val dp = Array(n + 1) { IntArray(m + 1) }
        for (i in 1..n) dp[i][0] = i
        for (j in 1..m) dp[0][j] = j
        for (i in 1..n) {
            for (j in 1..m) {
                val cost = if (expN[i - 1] == hypN[j - 1]) 0 else 1
                dp[i][j] = minOf(
                    dp[i - 1][j] + 1,
                    dp[i][j - 1] + 1,
                    dp[i - 1][j - 1] + cost,
                )
            }
        }

        val ops = ArrayList<WordAlignOp>()
        var i = n
        var j = m
        while (i > 0 || j > 0) {
            when {
                i > 0 && j > 0 && expN[i - 1] == hypN[j - 1] &&
                    dp[i][j] == dp[i - 1][j - 1] -> {
                    ops.add(WordAlignOp(LexicalOp.MATCH, i - 1, j - 1, expected[i - 1]))
                    i--; j--
                }
                i > 0 && j > 0 && dp[i][j] == dp[i - 1][j - 1] + 1 -> {
                    ops.add(WordAlignOp(LexicalOp.SUB, i - 1, j - 1, expected[i - 1]))
                    i--; j--
                }
                i > 0 && dp[i][j] == dp[i - 1][j] + 1 -> {
                    ops.add(WordAlignOp(LexicalOp.MISS, i - 1, null, expected[i - 1]))
                    i--
                }
                j > 0 && dp[i][j] == dp[i][j - 1] + 1 -> {
                    ops.add(WordAlignOp(LexicalOp.EXTRA, null, j - 1, hypothesis[j - 1]))
                    j--
                }
                i > 0 -> {
                    ops.add(WordAlignOp(LexicalOp.MISS, i - 1, null, expected[i - 1]))
                    i--
                }
                else -> {
                    ops.add(WordAlignOp(LexicalOp.EXTRA, null, j - 1, hypothesis[j - 1]))
                    j--
                }
            }
        }
        ops.reverse()
        return ops
    }

    /**
     * Lexical accuracy only: matched expected words ÷ expected word count.
     * Pronunciation severity (minor/major) does not reduce this figure.
     * Extra tokens are ignored in both numerator and denominator.
     */
    fun wordAccuracyFromTokens(tokens: List<Map<String, Any?>>, expectedWordCount: Int): Double {
        if (expectedWordCount == 0) return if (tokens.isEmpty()) 1.0 else 0.0
        val correct = tokens.count { isLexicalMatch(it) }
        return correct.toDouble() / expectedWordCount
    }

    fun isExpectedToken(token: Map<String, Any?>): Boolean {
        val lexical = token["lexical"] as? String
        if (lexical != null) return lexical != "extra"
        return (token["status"] as? String) != "extra"
    }

    fun isLexicalMatch(token: Map<String, Any?>): Boolean {
        val lexical = token["lexical"] as? String
        if (lexical != null) return lexical == "match"
        val status = token["status"] as? String
        return status == "ok" || status == "minor" || status == "major"
    }

    fun tokensFromAlignment(ops: List<WordAlignOp>): List<Map<String, Any?>> {
        return ops.map { op ->
            when (op.op) {
                LexicalOp.MATCH -> tokenMap(
                    text = op.text,
                    status = "ok",
                    lexical = "match",
                    pronunciation = "ok",
                    prob = 1.0f,
                )
                LexicalOp.SUB -> tokenMap(
                    text = op.text,
                    status = "sub",
                    lexical = "sub",
                    pronunciation = null,
                    prob = 0.0f,
                )
                LexicalOp.MISS -> tokenMap(
                    text = op.text,
                    status = "miss",
                    lexical = "miss",
                    pronunciation = null,
                    prob = 0.0f,
                )
                LexicalOp.EXTRA -> tokenMap(
                    text = op.text,
                    status = "extra",
                    lexical = "extra",
                    pronunciation = null,
                    prob = 0.0f,
                )
            }
        }
    }

    fun tokenMap(
        text: String,
        status: String,
        lexical: String,
        pronunciation: String?,
        prob: Float,
        startSec: Double? = null,
        endSec: Double? = null,
    ): Map<String, Any?> = buildMap {
        put("text", text)
        put("status", status)
        put("lexical", lexical)
        put("pronunciation", pronunciation)
        put("prob", prob)
        put("startSec", startSec)
        put("endSec", endSec)
    }

    /** Maps each token-id index → word index via SentencePiece ▁ markers. */
    fun pieceWordIndices(tokenIds: List<Int>, startsNewWord: (Int) -> Boolean): IntArray {
        val out = IntArray(tokenIds.size)
        var wordIdx = -1
        for (i in tokenIds.indices) {
            if (i == 0 || startsNewWord(tokenIds[i])) wordIdx += 1
            out[i] = wordIdx.coerceAtLeast(0)
        }
        return out
    }

    fun lexicalTokenReport(expected: List<String>, hypothesis: List<String>): List<Map<String, Any?>> =
        tokensFromAlignment(alignWords(expected, hypothesis))

    fun wordAccuracyScore(expected: List<String>, hypothesis: List<String>): Double {
        if (expected.isEmpty()) return if (hypothesis.isEmpty()) 1.0 else 0.0
        val matches = alignWords(expected, hypothesis).count { it.op == LexicalOp.MATCH }
        return matches.toDouble() / expected.size
    }
}
