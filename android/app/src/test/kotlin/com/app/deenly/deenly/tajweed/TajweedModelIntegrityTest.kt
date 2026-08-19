package com.rnr.deenfocus.tajweed

import androidx.test.core.app.ApplicationProvider
import java.io.File
import java.security.MessageDigest
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/**
 * Phase 4A: exercises [ModelStore]'s real SHA-256 + manifest verification pipeline
 * against the actual ONNX encoder artifact already present in
 * `tajweed-lab/models/onnx/model_with_encoder.onnx` (458MB, real weights, downloaded
 * in an earlier session — not a synthetic fixture like Phase 3's unit tests used).
 *
 * The pronunciation-head ONNX export isn't available yet (only a PyTorch checkpoint,
 * `tajweed-lab/models/head/pronunciation_head.pt`, exists — see
 * memory/technical-debt.md TD-009), so a small synthetic placeholder stands in for
 * `pronunciation-head.onnx` here. Its own SHA-256 is still computed and verified for
 * real; only its *content* is a stand-in, not the hashing/verification logic itself.
 *
 * Skips gracefully if tajweed-lab/models isn't present on this machine.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class TajweedModelIntegrityTest {

    private fun repoRoot(): File {
        val dir = File(System.getProperty("user.dir") ?: ".")
        return dir.parentFile?.parentFile ?: dir
    }

    private fun sha256(file: File): String {
        val digest = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { input ->
            val buffer = ByteArray(1 shl 20)
            var read: Int
            while (input.read(buffer).also { read = it } > 0) digest.update(buffer, 0, read)
        }
        return digest.digest().joinToString("") { "%02x".format(it) }
    }

    @Test
    fun realOnnxEncoderPassesSha256AndManifestVerification() {
        val modelsDir = File(repoRoot(), "tajweed-lab/models")
        val encoder = File(modelsDir, "onnx/model_with_encoder.onnx")
        val tokenizer = File(modelsDir, "tokenizer.model")
        val tokens = File(modelsDir, "tokens.txt")
        if (!encoder.exists() || !tokenizer.exists() || !tokens.exists()) {
            println("Phase4A: real ONNX artifacts not found under ${modelsDir.absolutePath} — skipping.")
            return
        }

        val store = ModelStore(ApplicationProvider.getApplicationContext())
        val staging = File(store.rootDir, "phase4a-staging")
        staging.deleteRecursively()
        staging.mkdirs()
        try {
            encoder.copyTo(File(staging, "model_with_encoder.onnx"), overwrite = true)
            tokenizer.copyTo(File(staging, "tokenizer.model"), overwrite = true)
            tokens.copyTo(File(staging, "tokens.txt"), overwrite = true)
            // Placeholder only — see class doc. Its hash is real; its content is not the real head.
            val placeholderHead = File(staging, "pronunciation-head.onnx")
            placeholderHead.writeBytes(ByteArray(128) { it.toByte() })

            val realEncoderSha = sha256(File(staging, "model_with_encoder.onnx"))
            val realTokenizerSha = sha256(File(staging, "tokenizer.model"))
            val realTokensSha = sha256(File(staging, "tokens.txt"))
            val placeholderHeadSha = sha256(placeholderHead)

            assertEquals(64, realEncoderSha.length)
            assertEquals(64, realTokenizerSha.length)

            val manifest = JSONObject().apply {
                put("version", "1.0.0")
                put("encoder", "model_with_encoder.onnx")
                put("pronunciationHead", "pronunciation-head.onnx")
                put("tokenizer", "tokenizer.model")
                put("tokens", "tokens.txt")
                put(
                    "sha256",
                    JSONObject().apply {
                        put("encoder", realEncoderSha)
                        put("pronunciationHead", placeholderHeadSha)
                        put("tokenizer", realTokenizerSha)
                    },
                )
                put("minimumAppVersion", "1.0.0")
            }
            File(staging, "model_manifest.json").writeText(manifest.toString(2))

            // Positive case: correct manifest + correct real hashes -> installs and activates.
            store.installFromDirectory(staging)
            assertTrue("ModelStore should report available after a verified install", store.isAvailable())
            assertEquals(realEncoderSha, sha256(store.encoderFile()))
            assertEquals(realTokensSha, sha256(store.tokensFile()))
            println(
                "Phase4A: real Android model integrity OK — " +
                    "encoder sha256=$realEncoderSha (${encoder.length()} bytes), " +
                    "tokenizer sha256=$realTokenizerSha, tokens sha256=$realTokensSha",
            )
        } finally {
            staging.deleteRecursively()
        }
    }

    @Test
    fun tamperedEncoderHashIsRejected() {
        val modelsDir = File(repoRoot(), "tajweed-lab/models")
        val tokenizer = File(modelsDir, "tokenizer.model")
        val tokens = File(modelsDir, "tokens.txt")
        if (!tokenizer.exists() || !tokens.exists()) {
            println("Phase4A: real tokenizer/tokens not found under ${modelsDir.absolutePath} — skipping.")
            return
        }

        val store = ModelStore(ApplicationProvider.getApplicationContext())
        val staging = File(store.rootDir, "phase4a-tamper-staging")
        staging.deleteRecursively()
        staging.mkdirs()
        try {
            val fakeEncoder = File(staging, "model_with_encoder.onnx")
            fakeEncoder.writeBytes(ByteArray(256) { it.toByte() })
            tokenizer.copyTo(File(staging, "tokenizer.model"), overwrite = true)
            tokens.copyTo(File(staging, "tokens.txt"), overwrite = true)
            val fakeHead = File(staging, "pronunciation-head.onnx")
            fakeHead.writeBytes(ByteArray(64) { it.toByte() })

            val manifest = JSONObject().apply {
                put("version", "1.0.0")
                put("encoder", "model_with_encoder.onnx")
                put("pronunciationHead", "pronunciation-head.onnx")
                put("tokenizer", "tokenizer.model")
                put("tokens", "tokens.txt")
                put(
                    "sha256",
                    JSONObject().apply {
                        // Deliberately wrong hash for the encoder to prove verification rejects tampering.
                        put("encoder", "0".repeat(64))
                        put("pronunciationHead", sha256(fakeHead))
                        put("tokenizer", sha256(File(staging, "tokenizer.model")))
                    },
                )
                put("minimumAppVersion", "1.0.0")
            }
            File(staging, "model_manifest.json").writeText(manifest.toString(2))

            try {
                store.installFromDirectory(staging)
                fail("Expected install to fail on SHA-256 mismatch")
            } catch (e: TajweedNativeException) {
                assertEquals(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, e.code)
            }
            assertFalse("A tampered pack must not become the active model", store.isAvailable())
        } finally {
            staging.deleteRecursively()
        }
    }
}
