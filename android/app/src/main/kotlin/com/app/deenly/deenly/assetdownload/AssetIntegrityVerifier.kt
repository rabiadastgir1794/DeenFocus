package com.rnr.deenfocus.assetdownload

import java.io.File
import java.security.MessageDigest

/**
 * Generic SHA-256 integrity checker, independent of any consumer's manifest shape.
 *
 * Tajweed's `ModelStore.verifySha` (ADR-007) keeps its own copy of this logic and
 * is intentionally left unmodified per ADR-008 — this type exists for *future*
 * asset consumers (translations, TTS voices, OCR, ...) that don't have their own
 * ModelStore-equivalent yet, so they get the same integrity guarantee for free.
 */
object AssetIntegrityVerifier {
    fun sha256Hex(file: File): String {
        val digest = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { input ->
            val buffer = ByteArray(1 shl 20)
            var read: Int
            while (input.read(buffer).also { read = it } > 0) {
                digest.update(buffer, 0, read)
            }
        }
        return digest.digest().joinToString("") { "%02x".format(it) }
    }

    fun verify(file: File, expectedHex: String?) {
        if (expectedHex.isNullOrEmpty()) return
        val actual = sha256Hex(file)
        if (!actual.equals(expectedHex, ignoreCase = true)) {
            throw AssetDownloadException.IntegrityMismatch(file.name)
        }
    }
}
