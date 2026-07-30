package com.rnr.deenfocus.tajweed

import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import java.io.File
import org.json.JSONObject
import org.junit.Assume.assumeTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

/**
 * DIAGNOSTIC ONLY — not a regression test, not wired into CI. Investigates the
 * "wrong ayah still scores 40-60%" report by feeding the *real* golden recordings
 * through the *real* on-device ONNX pipeline (same models/samples as
 * [TajweedOnDeviceParityTest]) but pairing each recording with a deliberately
 * WRONG `expectedArabic` (a completely different ayah, zero shared words).
 *
 * Answers, with evidence rather than guesses:
 *   1. What is the raw ASR transcription (`hypothesis`) when the wrong ayah is recited?
 *      (Should reflect what was actually said, independent of what was "expected".)
 *   2. What wordAccuracy / per-word statuses does the current forced-align +
 *      pronunciation-head pipeline produce for a totally mismatched pair?
 *
 * Writes `/sdcard/Android/data/com.rnr.deenfocus/files/tajweed_mismatch_diagnostic.json`.
 */
@RunWith(AndroidJUnit4::class)
class TajweedMismatchDiagnosticTest {

    private lateinit var context: android.content.Context
    private lateinit var importDir: File
    private lateinit var samplesDir: File

    @Before
    fun setUp() {
        context = InstrumentationRegistry.getInstrumentation().targetContext
        TajweedEngine.resetForTesting()
        val store = ModelStore(context)
        importDir = store.importDir
        samplesDir = File(context.getExternalFilesDir(null), "TajweedSamples")
    }

    @Test
    fun mismatchedAyahProducesRawHypothesisAndScore() {
        val store = ModelStore(context)
        if (!store.isAvailable() && importDir.resolve("model_with_encoder.onnx").exists()) {
            store.ensureModel(null)
        }
        assumeTrue("ONNX pack not installed (push to ${importDir.absolutePath} first)", store.isAvailable())
        assumeTrue("samples not pushed to ${samplesDir.absolutePath}", samplesDir.isDirectory)

        // Ground truth (from python_reference_transcripts.json / TajweedOnDeviceParityTest):
        //   01_alafasy_fatihah.wav actually says: مَالِكِ يَوْمِ الدِّينِ   (Al-Fatiha 1:4)
        //   02_basfar_ikhlas.wav   actually says: قُلْ هُوَ اللَّهُ أَحَدٌ  (Al-Ikhlas 112:1)
        // These two ayat share ZERO words. Pair each recording with the OTHER's expected
        // text to simulate "reciting a completely different ayah than the one asked for".
        val cases = listOf(
            Triple(
                "01_alafasy_fatihah.wav",
                "قُلْ هُوَ اللَّهُ أَحَدٌ", // WRONG expected text for this audio
                "actually says: مَالِكِ يَوْمِ الدِّينِ",
            ),
            Triple(
                "02_basfar_ikhlas.wav",
                "مَالِكِ يَوْمِ الدِّينِ", // WRONG expected text for this audio
                "actually says: قُلْ هُوَ اللَّهُ أَحَدٌ",
            ),
        )

        val results = org.json.JSONArray()
        for ((name, wrongExpected, note) in cases) {
            val wav = File(samplesDir, name)
            assumeTrue("missing $name", wav.exists())
            val out = TajweedDebugRunner.runSamplePipeline(
                context = context,
                modelDirectory = null,
                wavFile = wav,
                expectedArabic = wrongExpected,
                surah = 0,
                ayah = 0,
            )
            out.put("sample", name)
            out.put("note", note)
            results.put(out)

            val score = out.getJSONObject("score")
            android.util.Log.i(
                "TajweedMismatch",
                "sample=$name expected(WRONG)=\"$wrongExpected\" " +
                    "hypothesis(RAW)=\"${score.getString("hypothesis")}\" " +
                    "wordAccuracy=${score.getDouble("wordAccuracy")} " +
                    "exactMatch=${score.getBoolean("exactMatch")} " +
                    "tokens=${score.getJSONArray("tokens")}",
            )
            // Lexical-first regression: wrong ayah must not score as "mostly correct".
            org.junit.Assert.assertTrue(
                "wrong-ayah wordAccuracy must be near zero, got ${score.getDouble("wordAccuracy")}",
                score.getDouble("wordAccuracy") < 0.15,
            )
            org.junit.Assert.assertFalse(score.getBoolean("exactMatch"))
        }

        val report = JSONObject()
            .put("platform", "android")
            .put("device", android.os.Build.MODEL)
            .put("purpose", "mismatch diagnostic - wrong expected text vs real recording")
            .put("samples", results)
        val outFile = File(context.getExternalFilesDir(null), "tajweed_mismatch_diagnostic.json")
        TajweedDebugRunner.resultToFile(report, outFile)
        android.util.Log.i("TajweedMismatch", "wrote ${outFile.absolutePath}")
    }
}
