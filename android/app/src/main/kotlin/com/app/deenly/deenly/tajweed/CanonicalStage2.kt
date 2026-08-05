package com.rnr.deenfocus.tajweed

/** Stage-2 spoken-letter fold for ADR-010 canonical lexicon (shadow path only). */
object CanonicalStage2 {
    private val diacritics = setOf(
        *('\u064B'..'\u0652').map { it.toString() }.toTypedArray(),
        "\u0615", "\u06E1",
        *('\u0653'..'\u065F').map { it.toString() }.toTypedArray(),
    )
    private val formatControls = setOf(
        '\u200B', '\u200C', '\u200D', '\uFEFF', '\u00A0', '\u202F',
        '\u2009', '\u200A', '\u2060', '\u061C', '\u066D',
    )

    fun letterstream(text: String): String {
        val scalars = text.toList()
        val out = StringBuilder()
        var i = 0
        while (i < scalars.size) {
            val ch = scalars[i]
            if (ch.isWhitespace()) {
                i++
                continue
            }
            val cp = ch.code
            if (cp == 0x0670) {
                var j = i + 1
                while (j < scalars.size && isIgnorableMark(scalars[j])) j++
                val next = if (j >= scalars.size || scalars[j].isWhitespace()) -1 else scalars[j].code
                val drop = if (next >= 0) {
                    isHehFamily(next) || isYaFamily(next) || isKafFamily(next) || next == 0x0644
                } else {
                    val prev = previousBaseCode(scalars, i)
                    prev >= 0 && isYaFamily(prev)
                }
                if (!drop) out.append('\u0627')
                i++
                continue
            }
            if (cp == 0x0671) {
                out.append('\u0627')
                i++
                continue
            }
            if (isIgnorableMark(ch)) {
                i++
                continue
            }
            if (isHehFamily(cp)) {
                out.append('\u0647')
                i++
                continue
            }
            out.append(ch)
            i++
        }
        var s = out.toString()
        for ((a, b) in listOf(
            "أ" to "ا", "إ" to "ا", "آ" to "ا", "ى" to "ي", "ک" to "ك", "ی" to "ي",
            "الائك" to "الئك", "اولائك" to "اولئك",
        )) {
            s = s.replace(a, b)
        }
        return s.replace("صلوه", "صلاه")
    }

    fun word(text: String): String = letterstream(text)

    fun splitWords(text: String): List<String> =
        text.split(Regex("\\s+")).map { it.trim() }.filter { it.isNotEmpty() && word(it).isNotEmpty() }

    private fun isIgnorableMark(ch: Char): Boolean {
        val cp = ch.code
        if (ch.toString() in diacritics) return true
        if (cp == 0x0640) return true
        if (cp in 0x06D6..0x06ED) return true
        if (ch in formatControls) return true
        return false
    }

    private fun previousBaseCode(scalars: List<Char>, index: Int): Int {
        var k = index - 1
        while (k >= 0) {
            val ch = scalars[k]
            if (ch.isWhitespace()) { k--; continue }
            if (isIgnorableMark(ch)) { k--; continue }
            return ch.code
        }
        return -1
    }

    private fun isHehFamily(code: Int): Boolean =
        code in setOf(0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3)

    private fun isYaFamily(code: Int): Boolean =
        code in setOf(0x064A, 0x0649, 0x06CC)

    private fun isKafFamily(code: Int): Boolean =
        code in setOf(0x0643, 0x06A9)
}
