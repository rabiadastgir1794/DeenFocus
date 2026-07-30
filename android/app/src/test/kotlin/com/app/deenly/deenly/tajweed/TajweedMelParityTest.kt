package com.rnr.deenfocus.tajweed

import java.io.File
import java.nio.ByteBuffer
import java.nio.ByteOrder
import org.junit.Assert.assertFalse
import org.junit.Test

// Phase 4A: dumps Android's real MelFrontend output on the actual golden Quran
// recitation clips (tajweed-lab samples, wav files) to /tmp/tajweed_parity/android/<name>.json,
// so tajweed-lab/scripts/parity_compare_mel.py can diff it against the Python reference
// (tajweed-lab/parity/python/) and iOS's dump (produced by
// RunnerTests.testPhase4AMelParityDumpOnGoldenSamples) on the exact same audio.
//
// This is a plain JVM test (no Android runtime / Robolectric needed) - MelFrontend is
// pure Kotlin math, and this test itself runs on the host machine, which also has
// tajweed-lab/samples checked out, so no asset copying is required.
class TajweedMelParityTest {

    /** Gradle runs unit tests with cwd = `android/app`, so the repo root is two levels up. */
    private fun repoRoot(): File {
        val dir = File(System.getProperty("user.dir") ?: ".")
        return dir.parentFile?.parentFile ?: dir
    }

    private fun readPcm16Mono(wav: File): FloatArray {
        val bytes = wav.readBytes()
        val buf = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
        require(buf.int == 0x46464952) { "Not a RIFF file: ${wav.name}" } // "RIFF" little-endian
        buf.int // chunk size
        require(buf.int == 0x45564157) { "Not a WAVE file: ${wav.name}" } // "WAVE"

        var channels = 1
        var bitsPerSample = 16
        var dataStart = -1
        var dataSize = 0
        while (buf.remaining() >= 8) {
            val chunkId = buf.int
            val chunkSize = buf.int
            val chunkStart = buf.position()
            if (chunkId == 0x20746d66) { // "fmt "
                buf.short // audioFormat
                channels = buf.short.toInt()
                buf.int // sampleRate
                buf.int // byteRate
                buf.short // blockAlign
                bitsPerSample = buf.short.toInt()
            } else if (chunkId == 0x61746164) { // "data"
                dataStart = chunkStart
                dataSize = chunkSize
            }
            buf.position(chunkStart + chunkSize + (chunkSize and 1))
        }
        require(dataStart >= 0) { "No data chunk in ${wav.name}" }
        require(bitsPerSample == 16) { "Expected PCM16 in ${wav.name}, got $bitsPerSample-bit" }

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

    @Test
    fun dumpMelForGoldenSamples() {
        val samplesDir = File(repoRoot(), "tajweed-lab/samples")
        if (!samplesDir.isDirectory) {
            println("Phase4A: golden samples not found at ${samplesDir.absolutePath} — skipping mel parity dump.")
            return
        }
        val wavs = samplesDir.listFiles { f -> f.extension.equals("wav", ignoreCase = true) }
            ?.sortedBy { it.name } ?: emptyList()
        assertFalse("Expected golden .wav samples in ${samplesDir.absolutePath}", wavs.isEmpty())

        val outDir = File("/tmp/tajweed_parity/android")
        outDir.mkdirs()

        for (wav in wavs) {
            val pcm = readPcm16Mono(wav)
            val result = MelFrontend.logMel(pcm)
            val name = wav.nameWithoutExtension
            val featuresCsv = result.features.joinToString(",") { it.toDouble().toString() }
            val json = """
                {"sample":"${wav.name}","n_mels":${MelFrontend.N_MELS},"time":${result.time},"features":[$featuresCsv]}
            """.trimIndent()
            File(outDir, "$name.json").writeText(json)
            println("Phase4A: dumped Android mel for ${wav.name} -> ${outDir.absolutePath}/$name.json (T=${result.time})")
        }
    }
}
