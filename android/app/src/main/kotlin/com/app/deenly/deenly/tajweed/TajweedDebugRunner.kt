package com.rnr.deenfocus.tajweed

import android.content.Context
import android.util.Log
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder

/**
 * Native-only harness to validate the ONNX pipeline without Flutter UI.
 * Mirror of ios/Runner/Tajweed/Debug/TajweedDebugRunner.swift.
 *
 * Typical flow from an instrumented test / adb shell:
 * 1. adb push tajweed-lab/models/onnx → app externalFilesDir/TajweedImport
 * 2. TajweedDebugRunner.runSamplePipeline(context, null, wavFile, expected, surah, ayah)
 */
object TajweedDebugRunner {
    private const val TAG = "TajweedDebug"

    fun installModels(context: Context, from: File) {
        val store = ModelStore(context)
        store.installFromDirectory(from) { p ->
            Log.i(TAG, "install progress $p")
        }
    }

    fun runSamplePipeline(
        context: Context,
        modelDirectory: File?,
        wavFile: File,
        expectedArabic: String,
        surah: Int,
        ayah: Int,
    ): JSONObject {
        val engine = TajweedEngine.getInstance(context)
        val store = ModelStore(context)

        val coldStart = System.nanoTime()
        if (modelDirectory != null) {
            installModels(context, modelDirectory)
        } else if (!store.isAvailable()) {
            store.ensureModel { p -> Log.i(TAG, "ensure progress $p") }
        }
        if (!store.isAvailable()) {
            throw TajweedNativeException(
                TajweedErrorCode.MODEL_MISSING,
                "Model pack not installed. Push ONNX pack into ${store.importDir.absolutePath}",
            )
        }
        val coldMs = (System.nanoTime() - coldStart) / 1_000_000.0

        engine.dispose()
        Thread.sleep(200)

        val pcm = loadWavMono16k(wavFile)
        val (report, timings) = engine.scorePcmForDebug(pcm, surah, ayah, expectedArabic)

        val out = JSONObject()
        out.put("coldSetupMs", coldMs)
        out.put("warmOrReuseMs", timings["warmOrReuseMs"] ?: 0.0)
        out.put("inferenceMs", timings["inferenceMs"] ?: 0.0)
        out.put("score", mapToJson(report))
        Log.i(TAG, "timings cold=${"%.1f".format(coldMs)}ms warm=${timings["warmOrReuseMs"]}ms infer=${timings["inferenceMs"]}ms")
        Log.i(TAG, "hypothesis=${report["hypothesis"]} exact=${report["exactMatch"]}")
        return out
    }

    @Suppress("UNCHECKED_CAST")
    private fun mapToJson(value: Any?): Any? {
        return when (value) {
            null -> JSONObject.NULL
            is Map<*, *> -> {
                val obj = JSONObject()
                for ((k, v) in value) {
                    obj.put(k.toString(), mapToJson(v))
                }
                obj
            }
            is List<*> -> {
                val arr = JSONArray()
                for (item in value) arr.put(mapToJson(item))
                arr
            }
            is Number, is Boolean, is String -> value
            else -> value.toString()
        }
    }

    fun loadWavMono16k(wav: File): FloatArray {
        val bytes = wav.readBytes()
        val buf = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
        require(buf.int == 0x46464952) { "Not a RIFF file: ${wav.name}" }
        buf.int
        require(buf.int == 0x45564157) { "Not a WAVE file: ${wav.name}" }

        var channels = 1
        var bitsPerSample = 16
        var sampleRate = 16000
        var dataStart = -1
        var dataSize = 0
        while (buf.remaining() >= 8) {
            val chunkId = buf.int
            val chunkSize = buf.int
            val chunkStart = buf.position()
            if (chunkId == 0x20746d66) {
                buf.short
                channels = buf.short.toInt()
                sampleRate = buf.int
                buf.int
                buf.short
                bitsPerSample = buf.short.toInt()
            } else if (chunkId == 0x61746164) {
                dataStart = chunkStart
                dataSize = chunkSize
            }
            buf.position(chunkStart + chunkSize + (chunkSize and 1))
        }
        require(dataStart >= 0) { "No data chunk in ${wav.name}" }
        require(bitsPerSample == 16) { "Expected PCM16 in ${wav.name}" }
        require(sampleRate == MelFrontend.SAMPLE_RATE) {
            "Expected 16kHz WAV, got $sampleRate"
        }

        buf.position(dataStart)
        val sampleCount = dataSize / 2
        val samples = ShortArray(sampleCount)
        for (i in 0 until sampleCount) samples[i] = buf.short
        val frames = sampleCount / channels
        val mono = FloatArray(frames)
        for (f in 0 until frames) {
            var sum = 0f
            for (c in 0 until channels) sum += samples[f * channels + c] / 32768f
            mono[f] = sum / channels
        }
        return mono
    }

    fun resultToFile(result: JSONObject, outFile: File) {
        outFile.parentFile?.mkdirs()
        outFile.writeText(result.toString(2))
    }

    /** Convenience: JSONArray of results for multiple samples. */
    fun resultsArray(results: List<JSONObject>): JSONArray {
        val arr = JSONArray()
        results.forEach { arr.put(it) }
        return arr
    }
}
