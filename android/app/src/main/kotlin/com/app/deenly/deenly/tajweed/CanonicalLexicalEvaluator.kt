package com.rnr.deenfocus.tajweed

import android.util.Log

/**
 * ADR-010 M3 production lexical authority.
 * Expected = lexicon canonical IDs only. Display Mushaf never consulted.
 * Hypothesis = Stage-2 + M2.5 و/ف rematerialization, then exact DP on canonical strings.
 */
object CanonicalLexicalEvaluator {
    data class Evaluation(
        val ops: List<TajweedLexicalScoring.WordAlignOp>,
        val expectedCount: Int,
        val lexiconVersion: String?,
        val hypCanonical: List<String>,
        val expectedCanonical: List<String>,
    )

    private data class TrackedToken(
        val canonical: String,
        /** Index into [TajweedLexicalScoring.prepareHypothesisWords] (pronunciation FA space). */
        val pronIndex: Int,
    )

    /**
     * @param hypothesisWords [TajweedLexicalScoring.prepareHypothesisWords] output so hypIndex
     * stays in the same space pronunciation FA already uses.
     * @return null when ayah missing (fail closed — no display fallback while flag is on).
     */
    fun evaluate(
        surah: Int,
        ayah: Int,
        hypothesisWords: List<String>,
    ): Evaluation? {
        val ayahLex = CanonicalLexiconStore.ayah(surah, ayah)
        if (ayahLex == null || ayahLex.words.isEmpty()) {
            Log.w("TajweedCanonical", "ref=$surah:$ayah lexicon miss — fail closed")
            return null
        }

        val expectedCanonical = ayahLex.words.map { it.canonical }
        val expectedIds = ayahLex.words.map { it.id }
        val tracked = rematerializeClitics(
            normalizeHypothesisWords(hypothesisWords),
            expectedCanonical,
        )
        val hypCanonical = tracked.map { it.canonical }
        val shadowOps = CanonicalLexicalShadow.alignCanonical(
            expectedCanonical,
            expectedIds,
            hypCanonical,
        )
        val ops = toLegacyOps(shadowOps, ayahLex.words, tracked)
        Log.i(
            "TajweedCanonical",
            "ref=$surah:$ayah lexicon=${CanonicalLexiconStore.manifestInfo()?.lexiconVersion} " +
                "expected=${expectedCanonical.size} hyp=${hypCanonical.size} " +
                "ops=${ops.map { TajweedLexicalScoring.formatOpForLog(it) }}",
        )
        return Evaluation(
            ops = ops,
            expectedCount = expectedCanonical.size,
            lexiconVersion = CanonicalLexiconStore.manifestInfo()?.lexiconVersion,
            hypCanonical = hypCanonical,
            expectedCanonical = expectedCanonical,
        )
    }

    private fun normalizeHypothesisWords(words: List<String>): List<TrackedToken> {
        val out = mutableListOf<TrackedToken>()
        for ((i, word) in words.withIndex()) {
            val (clitic, rest) = peelLeadingClitic(word)
            if (clitic != null && rest.isNotEmpty()) {
                val cFold = CanonicalStage2.word(clitic)
                val rFold = CanonicalStage2.word(rest)
                if (cFold.isNotEmpty()) out.add(TrackedToken(cFold, i))
                if (rFold.isNotEmpty()) out.add(TrackedToken(rFold, i))
            } else {
                val folded = CanonicalStage2.word(word)
                if (folded.isNotEmpty()) out.add(TrackedToken(folded, i))
            }
        }
        return out
    }

    private fun rematerializeClitics(
        hyp: List<TrackedToken>,
        expectedCanonical: List<String>,
    ): List<TrackedToken> {
        val expectedSet = expectedCanonical.toSet()
        val out = mutableListOf<TrackedToken>()
        var j = 0
        while (j < hyp.size) {
            val h = hyp[j]
            if ((h.canonical == "و" || h.canonical == "ف") && j + 1 < hyp.size) {
                val host = hyp[j + 1]
                val merged = h.canonical + host.canonical
                if (merged in expectedSet) {
                    out.add(TrackedToken(merged, host.pronIndex))
                    j += 2
                    continue
                }
            }
            out.add(h)
            j += 1
        }
        return out
    }

    private fun peelLeadingClitic(word: String): Pair<String?, String> {
        val scalars = word.toList()
        var i = 0
        while (i < scalars.size && isIgnorableMark(scalars[i])) i++
        if (i >= scalars.size) return null to word
        val cp = scalars[i].code
        if (cp != 0x0648 && cp != 0x0641) return null to word
        var j = i + 1
        while (j < scalars.size && isIgnorableMark(scalars[j])) j++
        val rest = scalars.subList(j, scalars.size).joinToString("")
        if (rest.isEmpty()) return null to word
        val clitic = scalars.subList(0, j).joinToString("")
        return clitic to rest
    }

    private fun isIgnorableMark(ch: Char): Boolean {
        val cp = ch.code
        if (cp in 0x064B..0x0652 || cp == 0x0615 || cp == 0x06E1) return true
        if (cp == 0x0640) return true
        if (cp in 0x06D6..0x06ED) return true
        return false
    }

    private fun toLegacyOps(
        shadowOps: List<CanonicalLexicalShadow.ShadowOp>,
        words: List<CanonicalLexiconStore.CanonicalWord>,
        tracked: List<TrackedToken>,
    ): List<TajweedLexicalScoring.WordAlignOp> {
        val byId = words.associateBy { it.id }
        return shadowOps.map { op ->
            val pronHyp = op.hypIndex?.let { hi ->
                if (hi in tracked.indices) tracked[hi].pronIndex else hi
            }
            when (op.op) {
                "match" -> {
                    val word = op.expectedWordId?.let { byId[it] }
                    TajweedLexicalScoring.WordAlignOp(
                        op = TajweedLexicalScoring.LexicalOp.MATCH,
                        expectedIndex = op.expectedWordId?.let { id -> words.indexOfFirst { it.id == id } }
                            ?.takeIf { it >= 0 },
                        hypIndex = pronHyp,
                        text = word?.uiText ?: (op.expectedCanonical ?: ""),
                        reason = null,
                    )
                }
                "sub" -> {
                    val word = op.expectedWordId?.let { byId[it] }
                    TajweedLexicalScoring.WordAlignOp(
                        op = TajweedLexicalScoring.LexicalOp.SUB,
                        expectedIndex = op.expectedWordId?.let { id -> words.indexOfFirst { it.id == id } }
                            ?.takeIf { it >= 0 },
                        hypIndex = pronHyp,
                        text = word?.uiText ?: (op.expectedCanonical ?: ""),
                        reason = TajweedLexicalScoring.MismatchReason.MODEL,
                    )
                }
                "miss" -> {
                    val word = op.expectedWordId?.let { byId[it] }
                    TajweedLexicalScoring.WordAlignOp(
                        op = TajweedLexicalScoring.LexicalOp.MISS,
                        expectedIndex = op.expectedWordId?.let { id -> words.indexOfFirst { it.id == id } }
                            ?.takeIf { it >= 0 },
                        hypIndex = null,
                        text = word?.uiText ?: (op.expectedCanonical ?: ""),
                        reason = TajweedLexicalScoring.MismatchReason.MODEL,
                    )
                }
                else -> TajweedLexicalScoring.WordAlignOp(
                    op = TajweedLexicalScoring.LexicalOp.EXTRA,
                    expectedIndex = null,
                    hypIndex = pronHyp,
                    text = op.hypCanonical ?: "",
                    reason = TajweedLexicalScoring.MismatchReason.MODEL,
                )
            }
        }
    }
}
