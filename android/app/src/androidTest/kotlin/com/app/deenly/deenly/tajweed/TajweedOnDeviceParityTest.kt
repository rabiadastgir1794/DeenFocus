package com.rnr.deenfocus.tajweed

import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import java.io.File
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Assume.assumeTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Phase 4B on-device / emulator validation for the production ONNX pack.
 *
 * Prerequisites (run from host before this test):
 * ```
 * adb push tajweed-lab/models/onnx/. \
 *   /sdcard/Android/data/com.rnr.deenfocus/files/TajweedImport/
 * adb push tajweed-lab/samples/. \
 *   /sdcard/Android/data/com.rnr.deenfocus/files/TajweedSamples/
 * ```
 *
 * Writes `/sdcard/Android/data/com.rnr.deenfocus/files/tajweed_parity_android.json`.
 */
@RunWith(AndroidJUnit4::class)
class TajweedOnDeviceParityTest {

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
    fun ensureModelInstallsRealOnnxPack() {
        assumeTrue("ONNX pack not pushed to ${importDir.absolutePath}", importDir.resolve("model_with_encoder.onnx").exists())
        assumeTrue("pronunciation_head.onnx missing", importDir.resolve("pronunciation_head.onnx").exists())

        val store = ModelStore(context)
        val t0 = System.nanoTime()
        store.ensureModel(null)
        val installMs = (System.nanoTime() - t0) / 1_000_000.0
        assertTrue(store.isAvailable())
        assertTrue(store.encoderFile().exists())
        assertTrue(store.headFile().exists())
        println("Phase4B: ensureModel install/verify ${"%.0f".format(installMs)}ms")
    }

    @Test
    fun goldenSamplesProduceAdr006Scores() {
        val store = ModelStore(context)
        if (!store.isAvailable() && importDir.resolve("model_with_encoder.onnx").exists()) {
            store.ensureModel(null)
        }
        assumeTrue("ONNX pack not installed (push to ${importDir.absolutePath} first)", store.isAvailable())
        assumeTrue("samples not pushed to ${samplesDir.absolutePath}", samplesDir.isDirectory)

        val cases = listOf(
            Triple("01_alafasy_fatihah.wav", "مَالِكِ يَوْمِ الدِّينِ", 1 to 4),
            Triple("02_basfar_ikhlas.wav", "قُلْ هُوَ اللَّهُ أَحَدٌ", 112 to 1),
            Triple("03_alafasy_naba.wav", "قُلْ هُوَ نَبَأٌ عَظِيمٌ", 38 to 67),
        )

        val results = org.json.JSONArray()
        for ((name, expected, ref) in cases) {
            val wav = File(samplesDir, name)
            assumeTrue("missing $name", wav.exists())
            val out = TajweedDebugRunner.runSamplePipeline(
                context = context,
                modelDirectory = null,
                wavFile = wav,
                expectedArabic = expected,
                surah = ref.first,
                ayah = ref.second,
            )
            out.put("sample", name)
            results.put(out)

            val score = out.getJSONObject("score")
            assertEquals("ref", "${ref.first}:${ref.second}", score.getString("ref"))
            assertTrue("hypothesis non-empty for $name", score.getString("hypothesis").isNotBlank())
            assertTrue(
                "ADR-006 keys for $name",
                score.has("expected") && score.has("tokens") && score.has("wordAccuracy") && score.has("exactMatch"),
            )
            // No platform-specific keys.
            val keys = score.keys().asSequence().toSet()
            val allowed = setOf(
                "ref", "expected", "hypothesis", "durationSec",
                "wordAccuracy", "exactMatch", "tokens",
            )
            assertTrue("unexpected keys $keys", allowed.containsAll(keys))
            // Tokens may include additive ADR-006 fields lexical/pronunciation.
            if (score.getJSONArray("tokens").length() > 0) {
                val tok = score.getJSONArray("tokens").getJSONObject(0)
                val tokKeys = tok.keys().asSequence().toSet()
                val tokAllowed = setOf(
                    "text", "status", "prob", "startSec", "endSec", "lexical", "pronunciation",
                )
                assertTrue("unexpected token keys $tokKeys", tokAllowed.containsAll(tokKeys))
            }
            println(
                "Phase4B: $name hyp=${score.getString("hypothesis")} " +
                    "exact=${score.getBoolean("exactMatch")} " +
                    "acc=${score.getDouble("wordAccuracy")} " +
                    "inferMs=${out.getDouble("inferenceMs")}",
            )
        }

        val report = JSONObject()
            .put("platform", "android")
            .put("device", android.os.Build.MODEL)
            .put("samples", results)
        val outFile = File(context.getExternalFilesDir(null), "tajweed_parity_android.json")
        TajweedDebugRunner.resultToFile(report, outFile)
        println("Phase4B: wrote ${outFile.absolutePath}")
    }
}
