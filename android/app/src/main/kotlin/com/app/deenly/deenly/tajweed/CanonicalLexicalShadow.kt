package com.rnr.deenfocus.tajweed

import android.util.Log

/** Shadow canonical lexical evaluator — logs diffs only; never changes production score. */
object CanonicalLexicalShadow {
    data class ShadowOp(
        val op: String,
        val expectedWordId: String?,
        val hypIndex: Int?,
        val expectedCanonical: String?,
        val hypCanonical: String?,
    )

    data class DiffRow(
        val index: Int,
        val legacyOp: String,
        val shadowOp: String,
        val expectedWordId: String?,
        val legacyReason: String?,
        val note: String,
    )

    data class Result(
        val enabled: Boolean,
        val lexiconVersion: String?,
        val shadowWordAccuracy: Double?,
        val legacyWordAccuracy: Double,
        val identical: Boolean,
        val shadowOps: List<ShadowOp>,
        val diffs: List<DiffRow>,
    )

    fun compare(
        surah: Int,
        ayah: Int,
        hypWords: List<String>,
        legacyOps: List<TajweedLexicalScoring.WordAlignOp>,
        legacyWordAccuracy: Double,
    ): Result {
        if (!CanonicalLexiconStore.shadowEnabled()) {
            return Result(
                enabled = false,
                lexiconVersion = null,
                shadowWordAccuracy = null,
                legacyWordAccuracy = legacyWordAccuracy,
                identical = true,
                shadowOps = emptyList(),
                diffs = emptyList(),
            )
        }

        val ayahLex = CanonicalLexiconStore.ayah(surah, ayah)
        if (ayahLex == null) {
            Log.w("TajweedCanonicalShadow", "ref=$surah:$ayah missing from lexicon")
            return Result(
                enabled = true,
                lexiconVersion = CanonicalLexiconStore.manifestInfo()?.lexiconVersion,
                shadowWordAccuracy = null,
                legacyWordAccuracy = legacyWordAccuracy,
                identical = false,
                shadowOps = emptyList(),
                diffs = listOf(
                    DiffRow(0, "n/a", "n/a", null, null, "lexicon_miss"),
                ),
            )
        }

        val expectedCanonical = ayahLex.words.map { it.canonical }
        val expectedIds = ayahLex.words.map { it.id }
        val hypCanonical = normalizeHypothesisWords(hypWords)
        val shadowOps = alignCanonical(expectedCanonical, expectedIds, hypCanonical)
        val shadowAcc = wordAccuracy(shadowOps, expectedCanonical.size)
        val diffs = buildDiffs(legacyOps, shadowOps, expectedIds)
        val identical = diffs.isEmpty()

        Log.i(
            "TajweedCanonicalShadow",
            "ref=$surah:$ayah legacyAcc=$legacyWordAccuracy shadowAcc=$shadowAcc identical=$identical diffs=${diffs.size}",
        )
        diffs.take(8).forEach { row ->
            Log.i(
                "TajweedCanonicalShadow",
                "diff[${row.index}] legacy=${row.legacyOp} shadow=${row.shadowOp} id=${row.expectedWordId ?: "-"} note=${row.note}",
            )
        }

        return Result(
            enabled = true,
            lexiconVersion = CanonicalLexiconStore.manifestInfo()?.lexiconVersion,
            shadowWordAccuracy = shadowAcc,
            legacyWordAccuracy = legacyWordAccuracy,
            identical = identical,
            shadowOps = shadowOps,
            diffs = diffs,
        )
    }

    fun normalizeHypothesisWords(words: List<String>): List<String> =
        splitAttachedWaw(words).map { CanonicalStage2.word(it) }.filter { it.isNotEmpty() }

    private fun splitAttachedWaw(words: List<String>): List<String> {
        val out = mutableListOf<String>()
        for (word in words) {
            val (waw, rest) = peelLeadingWaw(word)
            if (waw != null && rest.isNotEmpty()) {
                out.add(CanonicalStage2.word(waw))
                out.add(rest)
            } else {
                out.add(word)
            }
        }
        return out
    }

    private fun peelLeadingWaw(word: String): Pair<String?, String> {
        val scalars = word.toList()
        var i = 0
        while (i < scalars.size && isIgnorableMark(scalars[i])) i++
        if (i >= scalars.size || scalars[i].code != 0x0648) return null to word
        var j = i + 1
        while (j < scalars.size && isIgnorableMark(scalars[j])) j++
        val rest = scalars.subList(j, scalars.size).joinToString("")
        if (rest.isEmpty()) return null to word
        val wawToken = scalars.subList(0, j).joinToString("")
        return wawToken to rest
    }

    private fun isIgnorableMark(ch: Char): Boolean {
        val cp = ch.code
        if (cp in 0x064B..0x0652 || cp == 0x0615 || cp == 0x06E1) return true
        if (cp == 0x0640) return true
        if (cp in 0x06D6..0x06ED) return true
        return false
    }

    fun alignCanonical(
        expected: List<String>,
        expectedIds: List<String>,
        hypothesis: List<String>,
    ): List<ShadowOp> {
        val n = expected.size
        val m = hypothesis.size
        val dp = Array(n + 1) { IntArray(m + 1) }
        if (n >= 1) for (i in 1..n) dp[i][0] = i
        if (m >= 1) for (j in 1..m) dp[0][j] = j
        if (n >= 1 && m >= 1) {
            for (i in 1..n) {
                for (j in 1..m) {
                    val cost = if (expected[i - 1] == hypothesis[j - 1]) 0 else 1
                    dp[i][j] = minOf(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)
                }
            }
        }

        val ops = mutableListOf<ShadowOp>()
        var i = n
        var j = m
        while (i > 0 || j > 0) {
            when {
                i > 0 && j > 0 && expected[i - 1] == hypothesis[j - 1] && dp[i][j] == dp[i - 1][j - 1] -> {
                    ops.add(
                        ShadowOp("match", expectedIds[i - 1], j - 1, expected[i - 1], hypothesis[j - 1]),
                    )
                    i--; j--
                }
                i > 0 && j > 0 && dp[i][j] == dp[i - 1][j - 1] + 1 -> {
                    ops.add(
                        ShadowOp("sub", expectedIds[i - 1], j - 1, expected[i - 1], hypothesis[j - 1]),
                    )
                    i--; j--
                }
                i > 0 && dp[i][j] == dp[i - 1][j] + 1 -> {
                    ops.add(ShadowOp("miss", expectedIds[i - 1], null, expected[i - 1], null))
                    i--
                }
                j > 0 && dp[i][j] == dp[i][j - 1] + 1 -> {
                    ops.add(ShadowOp("extra", null, j - 1, null, hypothesis[j - 1]))
                    j--
                }
                i > 0 -> {
                    ops.add(ShadowOp("miss", expectedIds[i - 1], null, expected[i - 1], null))
                    i--
                }
                else -> {
                    ops.add(ShadowOp("extra", null, j - 1, null, hypothesis[j - 1]))
                    j--
                }
            }
        }
        return ops.asReversed()
    }

    private fun wordAccuracy(ops: List<ShadowOp>, expectedCount: Int): Double {
        if (expectedCount <= 0) return 0.0
        return ops.count { it.op == "match" }.toDouble() / expectedCount.toDouble()
    }

    private fun buildDiffs(
        legacyOps: List<TajweedLexicalScoring.WordAlignOp>,
        shadowOps: List<ShadowOp>,
        expectedIds: List<String>,
    ): List<DiffRow> {
        val legacySig = legacyOps.map { op ->
            val idx = op.expectedIndex?.toString() ?: "-"
            "${op.op}:$idx"
        }
        val shadowSig = shadowOps.map { op ->
            val id = op.expectedWordId ?: "-"
            "${op.op}:$id"
        }
        if (legacySig == shadowSig) return emptyList()

        val rows = mutableListOf<DiffRow>()
        val limit = maxOf(legacyOps.size, shadowOps.size)
        for (idx in 0 until limit) {
            val legacy = legacyOps.getOrNull(idx)
            val shadow = shadowOps.getOrNull(idx)
            val legacyOp = legacy?.op?.name?.lowercase() ?: "none"
            val shadowOp = shadow?.op ?: "none"
            val legacyIdx = legacy?.expectedIndex
            val shadowIdx = shadow?.expectedWordId?.let { expectedIds.indexOf(it) }
            if (legacyOp == shadowOp && legacyIdx == shadowIdx) continue
            val note = when {
                legacyOp == "sub" && shadowOp == "match" -> "legacy_false_sub"
                legacyOp == "match" && shadowOp == "sub" -> "shadow_regression"
                legacyOps.size != shadowOps.size -> "op_count_mismatch"
                else -> "op_sequence_diff"
            }
            rows.add(
                DiffRow(
                    index = idx,
                    legacyOp = legacyOp,
                    shadowOp = shadowOp,
                    expectedWordId = shadow?.expectedWordId,
                    legacyReason = legacy?.reason,
                    note = note,
                ),
            )
        }
        return rows
    }

    fun toStagesPayload(result: Result): Map<String, Any?> = mapOf(
        "enabled" to result.enabled,
        "lexiconVersion" to result.lexiconVersion,
        "shadowWordAccuracy" to result.shadowWordAccuracy,
        "legacyWordAccuracy" to result.legacyWordAccuracy,
        "identical" to result.identical,
        "shadowOps" to result.shadowOps.map { op ->
            buildMap<String, Any?> {
                put("op", op.op)
                op.expectedWordId?.let { put("expectedWordId", it) }
                op.hypIndex?.let { put("hypIndex", it) }
                op.expectedCanonical?.let { put("expectedCanonical", it) }
                op.hypCanonical?.let { put("hypCanonical", it) }
            }
        },
        "legacyVsShadowDiff" to result.diffs.map { row ->
            mapOf(
                "index" to row.index,
                "legacyOp" to row.legacyOp,
                "shadowOp" to row.shadowOp,
                "expectedWordId" to row.expectedWordId,
                "legacyReason" to row.legacyReason,
                "note" to row.note,
            )
        },
    )
}
