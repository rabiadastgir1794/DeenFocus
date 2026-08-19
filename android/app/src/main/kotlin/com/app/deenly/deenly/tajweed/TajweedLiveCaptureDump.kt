package com.rnr.deenfocus.tajweed

import android.content.Context
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock
import org.json.JSONArray
import org.json.JSONObject

/**
 * Debug dump of Tajweed captures for cross-platform comparison.
 * Always overwrites `last.wav` + `last_stages.json` (compatibility), and also
 * archives a uniquely named `{surah}_{ayah}_attempt_NNNN.{wav,json}` so history
 * is never overwritten.
 */
object TajweedLiveCaptureDump {
    private const val TAG = "TajweedLiveCompare"

    @JvmField
    var enabled: Boolean = true

    private val lock = ReentrantLock()

    fun directory(context: Context): File =
        File(context.getExternalFilesDir(null), "TajweedLiveCompare").also { it.mkdirs() }

    fun dump(context: Context, pcm: FloatArray, stages: Map<String, Any?>) {
        if (!enabled) return
        lock.withLock {
            val dir = directory(context)
            try {
                val lastWav = File(dir, "last.wav")
                val lastJson = File(dir, "last_stages.json")
                writeWavMono16k(pcm, lastWav)

                val (surah, ayah) = parseRef(stages)
                val attempt = nextAttemptIndex(dir, surah, ayah)
                val basename = String.format(Locale.US, "%d_%d_attempt_%04d", surah, ayah, attempt)
                val archived = enrichStages(stages, surah, ayah, attempt, basename)
                val jsonText = (mapToJson(archived) as JSONObject).toString(2)
                lastJson.writeText(jsonText)

                val archiveWav = File(dir, "$basename.wav")
                val archiveJson = File(dir, "$basename.json")
                writeWavMono16k(pcm, archiveWav)
                archiveJson.writeText(jsonText)

                Log.i(
                    TAG,
                    "wrote last.wav + $basename (${pcm.size} samples) attempt=$attempt",
                )
            } catch (e: Exception) {
                Log.e(TAG, "dump failed: ${e.message}", e)
            }
        }
    }

    private fun parseRef(stages: Map<String, Any?>): Pair<Int, Int> {
        val surahDirect = (stages["surah"] as? Number)?.toInt()
        val ayahDirect = (stages["ayah"] as? Number)?.toInt()
        if (surahDirect != null && ayahDirect != null) return surahDirect to ayahDirect
        val ref = stages["ref"]?.toString().orEmpty()
        val parts = ref.split(":")
        val surah = parts.getOrNull(0)?.toIntOrNull() ?: 0
        val ayah = parts.getOrNull(1)?.toIntOrNull() ?: 0
        return surah to ayah
    }

    private fun nextAttemptIndex(dir: File, surah: Int, ayah: Int): Int {
        val prefix = String.format(Locale.US, "%d_%d_attempt_", surah, ayah)
        var maxN = 0
        val names = dir.list() ?: return 1
        for (name in names) {
            if (!name.startsWith(prefix) || !name.endsWith(".wav")) continue
            val mid = name.removePrefix(prefix).removeSuffix(".wav")
            val n = mid.toIntOrNull() ?: continue
            if (n > maxN) maxN = n
        }
        return maxN + 1
    }

    private fun enrichStages(
        stages: Map<String, Any?>,
        surah: Int,
        ayah: Int,
        attemptIndex: Int,
        basename: String,
    ): Map<String, Any?> {
        val modelInfo = stages["modelInfo"] as? Map<*, *>
        val iso = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.US).apply {
            timeZone = TimeZone.getTimeZone("UTC")
        }
        return stages.toMutableMap().apply {
            put("surah", surah)
            put("ayah", ayah)
            put("attemptIndex", attemptIndex)
            put("attemptBasename", basename)
            put("expectedRaw", stages["expected"] ?: stages["originalExpectedAyah"] ?: "")
            put("hypRaw", stages["hypothesis"] ?: stages["originalAsrHypothesis"] ?: "")
            put("accuracy", stages["wordAccuracy"] ?: 0.0)
            put("ops", stages["lexicalOps"] ?: emptyList<Any>())
            put("bucket", modelInfo?.get("bucketOrFixedT") ?: stages["bucketT"] ?: 0)
            put("coldLoad", modelInfo?.get("modelWasColdLoad") ?: false)
            put("timestamp", iso.format(Date()))
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun mapToJson(value: Any?): Any {
        return when (value) {
            null -> JSONObject.NULL
            is Map<*, *> -> {
                val obj = JSONObject()
                for ((k, v) in value) obj.put(k.toString(), mapToJson(v))
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

    fun writeWavMono16k(pcm: FloatArray, file: File) {
        val sampleRate = 16_000
        val dataSize = pcm.size * 2
        val out = ByteArray(44 + dataSize)
        val bb = ByteBuffer.wrap(out).order(ByteOrder.LITTLE_ENDIAN)
        fun ascii(s: String) = s.toByteArray(Charsets.US_ASCII)

        bb.put(ascii("RIFF"))
        bb.putInt(36 + dataSize)
        bb.put(ascii("WAVE"))
        bb.put(ascii("fmt "))
        bb.putInt(16)
        bb.putShort(1) // PCM
        bb.putShort(1) // mono
        bb.putInt(sampleRate)
        bb.putInt(sampleRate * 2)
        bb.putShort(2) // block align
        bb.putShort(16) // bits
        bb.put(ascii("data"))
        bb.putInt(dataSize)
        for (s in pcm) {
            val clamped = s.coerceIn(-1f, 1f)
            bb.putShort((clamped * Short.MAX_VALUE).toInt().toShort())
        }
        FileOutputStream(file).use { it.write(out) }
    }
}
