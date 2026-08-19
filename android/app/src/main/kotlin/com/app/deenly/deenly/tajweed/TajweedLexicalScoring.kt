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
     * Instrumentation tags for remaining lexical mismatches after deterministic
     * normalization / tokenization fixes. Logged as e.g. `sub(reason=model)`.
     */
    object MismatchReason {
        const val ATTACHED_WAW = "attached_waw"
        const val DAGGER_ALIF = "dagger_alif"
        const val HAMZA_VARIANT = "hamza_variant"
        const val QURANIC_MARK = "quranic_mark"
        const val MODEL = "model"
    }

    /**
     * Combining marks / sukun / extended Quranic diacritics stripped after
     * orthographic mapping. U+0670 (dagger alif) is handled separately.
     */
    private const val DIACRITICS =
        "\u064B\u064C\u064D\u064E\u064F\u0650\u0651\u0652\u0615" +
            "\u0653\u0654\u0655\u0656\u0657\u0658\u0659\u065A\u065B\u065C\u065D\u065E\u065F\u06E1"

    /** Non-lexical mushaf symbols dropped from expected word lists (not spoken). */
    private const val NON_LEXICAL_MARKS = "\u066D"

    /** Zero-width / mushaf format controls stripped from the letterstream. */
    private fun isFormatControl(code: Int): Boolean = when (code) {
        0x200B, 0x200C, 0x200D, 0xFEFF, 0x00A0, 0x202F,
        0x2009, 0x200A, 0x2060, 0x061C,
        -> true
        else -> false
    }

    private fun isHehFamily(code: Int): Boolean = when (code) {
        0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3 -> true
        else -> false
    }

    private fun isYaFamily(code: Int): Boolean = when (code) {
        0x064A, 0x0649, 0x06CC -> true
        else -> false
    }

    private fun isKaf(code: Int): Boolean = when (code) {
        0x0643, 0x06A9 -> true
        else -> false
    }

    private fun isIgnorableMark(ch: Char): Boolean {
        val code = ch.code
        return ch in DIACRITICS || code == 0x0640 || code in 0x06D6..0x06ED ||
            ch in NON_LEXICAL_MARKS || isFormatControl(code)
    }

    private fun isWhitespace(ch: Char): Boolean = ch.isWhitespace()

    private fun previousBaseCode(text: String, index: Int): Int {
        var k = index - 1
        while (k >= 0 && isIgnorableMark(text[k])) k--
        return if (k >= 0 && !isWhitespace(text[k])) text[k].code else -1
    }

    enum class LexicalOp {
        MATCH,
        SUB,
        MISS,
        EXTRA,
    }

    data class WordAlignOp(
        val op: LexicalOp,
        val expectedIndex: Int?,
        val hypIndex: Int?,
        val text: String,
        /** Set for SUB/MISS/EXTRA — see [MismatchReason]. */
        val reason: String? = null,
    )

    fun splitWords(text: String): List<String> =
        text.split(Regex("\\s+"))
            .map { it.trim() }
            .filter { it.isNotEmpty() && normalizeArabic(it).isNotEmpty() }

    fun lexicalWords(text: String, referenceText: String = text): List<String> {
        val canonical = splitWords(referenceText)
            .map(::normalizeArabic)
            .filter { it.isNotEmpty() }
        val stream = normalizeArabic(text)
        var i = 0
        val out = ArrayList<String>(canonical.size)
        for (word in canonical) {
            if (i + word.length <= stream.length &&
                stream.regionMatches(i, word, 0, word.length)
            ) {
                out.add(word)
                i += word.length
            } else {
                return splitWords(text).map(::normalizeArabic).filter { it.isNotEmpty() }
            }
        }
        if (i != stream.length) {
            return splitWords(text).map(::normalizeArabic).filter { it.isNotEmpty() }
        }
        return out
    }

    /** Expected side: presentation-aware tokenization + drop non-lexical mushaf marks. */
    fun prepareExpectedWords(text: String, referenceText: String = text): List<String> =
        filterLexicalExpectedWords(lexicalWords(text, referenceText))

    /** ASR side: whitespace split + peel attached clitic [و]. */
    fun prepareHypothesisWords(hypothesis: String): List<String> =
        splitAttachedWawHypothesisWords(splitWords(hypothesis))

    /** Drops pause / annotation-only tokens (e.g. IndoPak U+066D `٭`). */
    fun filterLexicalExpectedWords(words: List<String>): List<String> =
        words.filter { !isNonLexicalAnnotationToken(it) }

    fun isNonLexicalAnnotationToken(text: String): Boolean {
        if (text.isEmpty()) return true
        var hasBase = false
        for (ch in text) {
            if (isWhitespace(ch) || isFormatControl(ch.code)) continue
            if (isIgnorableMark(ch) || ch in NON_LEXICAL_MARKS) continue
            hasBase = true
            break
        }
        return !hasBase
    }

    /**
     * Splits `وَ…` ASR tokens into standalone `و` + remainder so they align with
     * IndoPak expected clitics. Only splits when remainder is non-empty.
     */
    fun splitAttachedWawHypothesisWords(words: List<String>): List<String> {
        val out = ArrayList<String>(words.size + 4)
        for (word in words) {
            val (waw, rest) = peelLeadingWaw(word)
            if (waw != null && rest.isNotEmpty()) {
                out.add(waw)
                out.add(rest)
            } else {
                out.add(word)
            }
        }
        return out
    }

    /** Returns (`و` display token, remainder) or (null, original) when no peel. */
    fun peelLeadingWaw(word: String): Pair<String?, String> {
        var i = 0
        while (i < word.length && isIgnorableMark(word[i])) i++
        if (i >= word.length || word[i] != '\u0648') return null to word
        var j = i + 1
        while (j < word.length && isIgnorableMark(word[j])) j++
        val rest = word.substring(j)
        if (rest.isEmpty()) return null to word
        return word.substring(0, j) to rest
    }

    fun normalizeArabic(text: String): String {
        val sb = StringBuilder(text.length)
        var i = 0
        while (i < text.length) {
            val ch = text[i]
            when {
                isWhitespace(ch) -> i++
                ch == '\u0670' -> {
                    var j = i + 1
                    while (j < text.length && isIgnorableMark(text[j])) j++
                    val next = when {
                        j >= text.length -> -1
                        isWhitespace(text[j]) -> -1
                        else -> text[j].code
                    }
                    val prev = previousBaseCode(text, i)
                    val dropDagger = isHehFamily(next) || isYaFamily(next) || isKaf(next) ||
                        (next == -1 && isYaFamily(prev))
                    if (!dropDagger) sb.append('\u0627')
                    i++
                }
                ch == '\u0671' -> {
                    sb.append('\u0627')
                    i++
                }
                isIgnorableMark(ch) -> i++
                isHehFamily(ch.code) -> {
                    sb.append('\u0647')
                    i++
                }
                else -> {
                    sb.append(ch)
                    i++
                }
            }
        }
        return sb.toString()
            .replace('\u0623', '\u0627')
            .replace('\u0625', '\u0627')
            .replace('\u0622', '\u0627')
            .replace('\u0649', '\u064A')
            .replace('\u06A9', '\u0643')
            .replace('\u06CC', '\u064A')
            .replace("\u0627\u0644\u0627\u0626\u0643", "\u0627\u0644\u0626\u0643")
            .replace("\u0627\u0648\u0644\u0627\u0626\u0643", "\u0627\u0648\u0644\u0626\u0643")
            .trim()
    }

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
                    ops.add(
                        WordAlignOp(
                            LexicalOp.SUB,
                            i - 1,
                            j - 1,
                            expected[i - 1],
                            classifyMismatchReason(
                                LexicalOp.SUB,
                                expected[i - 1],
                                hypothesis[j - 1],
                                expN[i - 1],
                                hypN[j - 1],
                            ),
                        ),
                    )
                    i--; j--
                }
                i > 0 && dp[i][j] == dp[i - 1][j] + 1 -> {
                    ops.add(
                        WordAlignOp(
                            LexicalOp.MISS,
                            i - 1,
                            null,
                            expected[i - 1],
                            classifyMismatchReason(
                                LexicalOp.MISS,
                                expected[i - 1],
                                null,
                                expN[i - 1],
                                null,
                            ),
                        ),
                    )
                    i--
                }
                j > 0 && dp[i][j] == dp[i][j - 1] + 1 -> {
                    ops.add(
                        WordAlignOp(
                            LexicalOp.EXTRA,
                            null,
                            j - 1,
                            hypothesis[j - 1],
                            MismatchReason.MODEL,
                        ),
                    )
                    j--
                }
                i > 0 -> {
                    ops.add(
                        WordAlignOp(
                            LexicalOp.MISS,
                            i - 1,
                            null,
                            expected[i - 1],
                            classifyMismatchReason(
                                LexicalOp.MISS,
                                expected[i - 1],
                                null,
                                expN[i - 1],
                                null,
                            ),
                        ),
                    )
                    i--
                }
                else -> {
                    ops.add(
                        WordAlignOp(
                            LexicalOp.EXTRA,
                            null,
                            j - 1,
                            hypothesis[j - 1],
                            MismatchReason.MODEL,
                        ),
                    )
                    j--
                }
            }
        }
        ops.reverse()
        return ops
    }

    fun classifyMismatchReason(
        op: LexicalOp,
        expectedWord: String,
        hypWord: String?,
        expectedNorm: String,
        hypNorm: String?,
    ): String {
        when (op) {
            LexicalOp.EXTRA -> return MismatchReason.MODEL
            LexicalOp.MISS -> {
                if (isNonLexicalAnnotationToken(expectedWord)) return MismatchReason.QURANIC_MARK
                if (expectedNorm == "\u0648") return MismatchReason.ATTACHED_WAW
                return MismatchReason.MODEL
            }
            LexicalOp.SUB -> {
                val hyp = hypWord ?: return MismatchReason.MODEL
                val hypN = hypNorm ?: normalizeArabic(hyp)
                if (expectedNorm == "\u0648" || (hypN.startsWith("\u0648") && hypN.length > 1)) {
                    return MismatchReason.ATTACHED_WAW
                }
                if (containsDaggerAlif(expectedWord) || containsDaggerAlif(hyp)) {
                    return MismatchReason.DAGGER_ALIF
                }
                if (isUlaaikVariant(expectedNorm, hypN)) {
                    return MismatchReason.HAMZA_VARIANT
                }
                if (isNonLexicalAnnotationToken(expectedWord)) {
                    return MismatchReason.QURANIC_MARK
                }
                return MismatchReason.MODEL
            }
            LexicalOp.MATCH -> return MismatchReason.MODEL
        }
    }

    private fun containsDaggerAlif(text: String): Boolean = '\u0670' in text

    private fun isUlaaikVariant(expectedNorm: String, hypNorm: String): Boolean {
        val pair = setOf(expectedNorm, hypNorm)
        return pair == setOf("\u0627\u0648\u0644\u0627\u0626\u0643", "\u0627\u0648\u0644\u0626\u0643") ||
            pair == setOf("\u0627\u0644\u0627\u0626\u0643", "\u0627\u0644\u0626\u0643")
    }

    fun formatOpForLog(op: WordAlignOp): String {
        val name = op.op.name.lowercase()
        val reason = op.reason ?: return name
        return "$name(reason=$reason)"
    }

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

    fun tokensFromAlignment(ops: List<WordAlignOp>): List<Map<String, Any?>> =
        ops.map { op ->
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
                    reason = op.reason,
                )
                LexicalOp.MISS -> tokenMap(
                    text = op.text,
                    status = "miss",
                    lexical = "miss",
                    pronunciation = null,
                    prob = 0.0f,
                    reason = op.reason,
                )
                LexicalOp.EXTRA -> tokenMap(
                    text = op.text,
                    status = "extra",
                    lexical = "extra",
                    pronunciation = null,
                    prob = 0.0f,
                    reason = op.reason,
                )
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
        reason: String? = null,
    ): Map<String, Any?> = buildMap {
        put("text", text)
        put("status", status)
        put("lexical", lexical)
        put("pronunciation", pronunciation)
        put("prob", prob)
        put("startSec", startSec)
        put("endSec", endSec)
        if (reason != null) put("reason", reason)
    }

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
