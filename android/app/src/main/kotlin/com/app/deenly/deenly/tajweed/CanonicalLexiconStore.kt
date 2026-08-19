package com.rnr.deenfocus.tajweed

import android.content.Context
import android.content.pm.ApplicationInfo
import android.util.Log
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader

/** Versioned canonical spoken-Quran lexicon (ADR-010). */
object CanonicalLexiconStore {
    data class CanonicalWord(
        val id: String,
        val canonical: String,
        val surfaceUthmani: String = "",
        val surfaceIndopak: String = "",
        val surfaceImlaei: String = "",
    ) {
        /** UI chip text — Uthmani surface when present; never used for alignment. */
        val uiText: String
            get() = when {
                surfaceUthmani.isNotEmpty() -> surfaceUthmani
                surfaceImlaei.isNotEmpty() -> surfaceImlaei
                else -> canonical
            }
    }

    data class AyahLexicon(val ref: String, val words: List<CanonicalWord>)

    data class Manifest(
        val lexiconVersion: String,
        val linguisticSpecVersion: String,
        val stage2FoldRevision: String,
        val ayahCount: Int,
    )

    @Volatile
    private var appContext: Context? = null

    @Volatile
    private var manifest: Manifest? = null

    @Volatile
    private var ayahIndex: Map<String, AyahLexicon>? = null

    @Volatile
    private var debuggable = false

    fun shadowEnabled(): Boolean = debuggable

    fun manifestInfo(): Manifest? = manifest

    fun ayah(surah: Int, ayah: Int): AyahLexicon? = ayahIndex?.get("$surah:$ayah")

    /** Store application context only — does not parse the lexicon pack. */
    @Synchronized
    fun bind(context: Context) {
        appContext = context.applicationContext
        debuggable =
            (context.applicationInfo.flags and ApplicationInfo.FLAG_DEBUGGABLE) != 0
    }

    /**
     * Parse `ayahs.ndjson` (~12MB). Call only from a background worker
     * (e.g. score path) — never from Activity / FlutterEngine configure.
     */
    @Synchronized
    fun loadIfNeeded() {
        if (ayahIndex != null) return
        val context = appContext
        if (context == null) {
            Log.w("TajweedCanonical", "loadIfNeeded skipped — bind() not called")
            ayahIndex = emptyMap()
            return
        }
        val t0 = System.nanoTime()
        try {
            context.assets.open("tajweed/canonical_lexicon/manifest.json").use { stream ->
                val json = JSONObject(stream.bufferedReader().readText())
                manifest = Manifest(
                    lexiconVersion = json.optString("lexiconVersion"),
                    linguisticSpecVersion = json.optString("linguisticSpecVersion"),
                    stage2FoldRevision = json.optString("stage2FoldRevision"),
                    ayahCount = json.optInt("ayahCount"),
                )
            }
            val index = mutableMapOf<String, AyahLexicon>()
            context.assets.open("tajweed/canonical_lexicon/ayahs.ndjson").use { stream ->
                BufferedReader(InputStreamReader(stream, Charsets.UTF_8)).forEachLine { line ->
                    if (line.isBlank()) return@forEachLine
                    val row = JSONObject(line)
                    val ref = row.getString("ref")
                    val wordsJson = row.getJSONArray("words")
                    val words = buildList {
                        for (i in 0 until wordsJson.length()) {
                            val w = wordsJson.getJSONObject(i)
                            val surfaces = w.optJSONObject("surfaceForms")
                            add(
                                CanonicalWord(
                                    id = w.getString("id"),
                                    canonical = w.getString("canonical"),
                                    surfaceUthmani = surfaces?.optString("uthmani").orEmpty(),
                                    surfaceIndopak = surfaces?.optString("indopak").orEmpty(),
                                    surfaceImlaei = surfaces?.optString("imlaei").orEmpty(),
                                ),
                            )
                        }
                    }
                    index[ref] = AyahLexicon(ref, words)
                }
            }
            ayahIndex = index
            val ms = (System.nanoTime() - t0) / 1_000_000.0
            Log.i(
                "TajweedCanonical",
                "loaded lexiconVersion=${manifest?.lexiconVersion} ayahs=${index.size} in ${"%.0f".format(ms)}ms",
            )
        } catch (e: Exception) {
            Log.w("TajweedCanonical", "lexicon load failed: ${e.message}")
            ayahIndex = emptyMap()
        }
    }

    /** Unit tests only — inject a minimal ayah map without reading assets. */
    @Synchronized
    fun installForTesting(ayahs: Map<String, AyahLexicon>, version: String = "test") {
        debuggable = true
        manifest = Manifest(
            lexiconVersion = version,
            linguisticSpecVersion = "test",
            stage2FoldRevision = "test",
            ayahCount = ayahs.size,
        )
        ayahIndex = ayahs
    }

    @Synchronized
    fun resetForTesting() {
        manifest = null
        ayahIndex = null
        debuggable = false
        appContext = null
    }
}
