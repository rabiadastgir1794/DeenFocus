package com.rnr.deenfocus.tajweed

import android.content.Context
import android.util.Log
import com.rnr.deenfocus.assetdownload.AIAssetManager
import com.rnr.deenfocus.assetdownload.AssetDownloadException
import org.json.JSONObject
import java.io.File
import java.security.MessageDigest
import java.util.UUID

private const val TAG = "ModelStore"

/**
 * On-device model pack lifecycle (ADR-007). Port of ios/Runner/Tajweed/ModelStore.swift.
 * Artifacts differ (ONNX `.onnx` vs CoreML `.mlpackage`) but the manifest shape,
 * verify/activate/rollback steps, and error codes are identical across platforms.
 */
class ModelStore(private val context: Context) {
    private val rootName = "TajweedModels"

    /** Prefer external app files dir so debug `adb push` packs and active models share a volume
     * (rename/activate without doubling the ~450MB encoder on constrained emulators). */
    private val baseDir: File
        get() = context.getExternalFilesDir(null) ?: context.filesDir

    val rootDir: File get() = File(baseDir, rootName)
    val activeDir: File get() = File(rootDir, "active")
    val manifestFile: File get() = File(activeDir, "model_manifest.json")

    /** Debug/manual install path — mirrors iOS `Documents/TajweedImport`. */
    val importDir: File get() = File(baseDir, "TajweedImport")

    // ADR-008/ADR-009: lazy so plain unit tests that never call ensureModel()
    // (and never configure a catalog URL) don't pay for constructing the sync
    // helper. Registers Tajweed as an asset with the shared, generic
    // AIAssetManager on first access — idempotent, since `register` simply
    // replaces any existing entry for the same assetId.
    private val assetSync: TajweedAssetSync by lazy {
        TajweedAssetSync(this).also {
            AIAssetManager.shared.register(it)
            AIAssetManager.shared.catalogUrl = TajweedAssetDistributionConfig.catalogUrl
            AIAssetManager.shared.checkIntervalHours = TajweedAssetDistributionConfig.CHECK_INTERVAL_HOURS
        }
    }

    fun isAvailable(): Boolean {
        val manifest = readManifest() ?: return false
        val encoder = manifest.optString("encoder", "")
        val head = manifest.optString("pronunciationHead", "")
        val tokenizer = manifest.optString("tokenizer", "")
        val tokens = manifest.optString("tokens", "tokens.txt")
        if (encoder.isEmpty() || head.isEmpty() || tokenizer.isEmpty()) return false
        return File(activeDir, encoder).exists() &&
            File(activeDir, head).exists() &&
            File(activeDir, tokenizer).exists() &&
            File(activeDir, tokens).exists()
    }

    fun activeManifestVersion(): String =
        readManifest()?.optString("version", "") ?: ""

    fun activeEncoderSha256(): String {
        val sha = readManifest()?.optJSONObject("sha256") ?: return ""
        return sha.optString("encoder", "")
    }

    fun encoderFile(): File = File(activeDir, requireManifest().getString("encoder"))
    fun headFile(): File = File(activeDir, requireManifest().getString("pronunciationHead"))
    fun tokensFile(): File = File(activeDir, requireManifest().optString("tokens", "tokens.txt"))

    /** Install a prepared directory (onnx files + tokenizer + manifest) into active. */
    fun installFromDirectory(source: File, progress: ((Double) -> Unit)? = null) {
        progress?.invoke(0.05)
        if (!source.exists() || !source.isDirectory) {
            throw TajweedNativeException(TajweedErrorCode.MODEL_MISSING, "Source directory missing.")
        }

        // Same-volume download staging (…/TajweedModels/download-staging/…) already
        // holds the full pack on disk. Verify + rename into `active` instead of
        // copying ~450MB a second time — that double-copy commonly fails with
        // ENOSPC / disk-full right after a successful download (~96% progress).
        val sourceCanonical = try { source.canonicalFile } catch (_: Exception) { source.absoluteFile }
        val rootCanonical = try { rootDir.canonicalFile } catch (_: Exception) { rootDir.absoluteFile }
        val alreadyOnModelVolume = sourceCanonical.path.startsWith(rootCanonical.path + File.separator)
        if (alreadyOnModelVolume) {
            activateVerifiedDirectory(source, progress)
            return
        }

        val staging = File(rootDir, "staging-${UUID.randomUUID()}")
        staging.deleteRecursively()
        staging.mkdirs()

        try {
            val contents = source.listFiles()?.toList().orEmpty()
            contents.forEachIndexed { i, file ->
                file.copyTo(File(staging, file.name), overwrite = true)
                progress?.invoke(0.05 + 0.8 * (i + 1) / maxOf(contents.size, 1))
            }

            ensureManifestPresent(staging, contents)
            activateVerifiedDirectory(staging, progress)
        } finally {
            staging.deleteRecursively()
        }
    }

    /**
     * Writes a minimal manifest when the source only has raw ONNX files (legacy
     * adb-push path). No-op when `model_manifest.json` is already present.
     */
    private fun ensureManifestPresent(staging: File, contents: List<File>) {
        val manifestPath = File(staging, "model_manifest.json")
        if (manifestPath.exists()) return
        val encoder = contents.firstOrNull { it.name.endsWith(".onnx") && it.name.contains("encoder") }
            ?: contents.firstOrNull { it.name.endsWith(".onnx") && !it.name.contains("head") }
        val head = contents.firstOrNull { it.name.endsWith(".onnx") && it.name.contains("head") }
        if (encoder == null || head == null) {
            throw TajweedNativeException(
                TajweedErrorCode.MODEL_DOWNLOAD_FAILED,
                "Could not locate encoder/head .onnx files.",
            )
        }
        val manifest = JSONObject().apply {
            put("version", "1.0.0")
            put("encoder", encoder.name)
            put("pronunciationHead", head.name)
            put("tokenizer", "tokenizer.model")
            put("tokens", "tokens.txt")
            put("sha256", JSONObject())
            put("minimumAppVersion", "1.0.0")
        }
        manifestPath.writeText(manifest.toString(2))
    }

    /** Verify [source] then atomically swap it into [activeDir] (rename preferred). */
    private fun activateVerifiedDirectory(source: File, progress: ((Double) -> Unit)?) {
        verifyStaging(source)
        progress?.invoke(0.9)

        Log.i(TAG, "[activation] Verification passed — activating ${source.absolutePath} -> " +
            activeDir.absolutePath)
        rootDir.mkdirs()
        val previous = File(rootDir, "previous")
        previous.deleteRecursively()
        if (activeDir.exists()) {
            if (!activeDir.renameTo(previous)) {
                val needed = dirSizeBytes(activeDir)
                val available = rootDir.usableSpace
                if (available < needed) {
                    throw TajweedNativeException(
                        TajweedErrorCode.MODEL_DOWNLOAD_FAILED,
                        "Not enough space to snapshot previous model " +
                            "(need ~$needed bytes, have $available). Free space and retry.",
                    )
                }
                activeDir.copyRecursively(previous, overwrite = true)
                activeDir.deleteRecursively()
            }
        }
        try {
            if (!source.renameTo(activeDir)) {
                // Directory rename often fails on emulated storage; move files
                // one-by-one with rename (same volume, ~zero extra space) instead
                // of copyRecursively which needs another ~450MB and hits ENOSPC.
                moveDirectoryContents(source, activeDir)
                source.deleteRecursively()
            }
        } catch (e: TajweedNativeException) {
            if (previous.exists()) {
                previous.renameTo(activeDir)
            }
            throw e
        } catch (e: Exception) {
            if (previous.exists()) {
                previous.renameTo(activeDir)
            }
            throw TajweedNativeException(
                TajweedErrorCode.MODEL_DOWNLOAD_FAILED,
                "Activation failed: ${e.message}",
            )
        }
        previous.deleteRecursively()
        progress?.invoke(1.0)
        Log.i(TAG, "[activation] Model activated at ${activeDir.absolutePath} (from $source).")
    }

    private fun dirSizeBytes(dir: File): Long {
        if (!dir.exists()) return 0L
        return dir.walkTopDown().filter { it.isFile }.map { it.length() }.sum()
    }

    /**
     * Moves every child of [from] into [to] preferring same-volume rename.
     * Falls back to copy only when rename fails *and* free space covers the file.
     */
    private fun moveDirectoryContents(from: File, to: File) {
        to.mkdirs()
        val children = from.listFiles()?.toList().orEmpty()
        for (child in children) {
            val dest = File(to, child.name)
            if (child.renameTo(dest)) continue
            val available = to.usableSpace
            if (available < child.length()) {
                throw TajweedNativeException(
                    TajweedErrorCode.MODEL_DOWNLOAD_FAILED,
                    "write failed: ENOSPC (No space left on device) while activating " +
                        "${child.name} (need ${child.length()} bytes, have $available). " +
                        "Downloaded files were kept — free space and retry ensureModel.",
                )
            }
            if (child.isDirectory) {
                child.copyRecursively(dest, overwrite = true)
                child.deleteRecursively()
            } else {
                child.copyTo(dest, overwrite = true)
                child.delete()
            }
        }
    }

    /**
     * Phase 3 local dev path (unchanged): adb-pushed `TajweedImport` still takes
     * priority so `TajweedDebugRunner`/instrumented QA is unaffected. ADR-008/
     * ADR-009 add a production network path on top via the generic
     * [AIAssetManager] (with Tajweed as its first registered asset) — this
     * method's *signature*, error codes, and the verify/activate logic it
     * calls into ([installFromDirectory] above) are unchanged. While
     * `TajweedAssetDistributionConfig.catalogUrl` is unset (no bucket provisioned
     * yet), the new paths are fully inert and behavior is identical to before.
     */
    fun ensureModel(progress: ((Double) -> Unit)? = null) {
        val assetId = assetSync.assetId
        if (isAvailable()) {
            if (AIAssetManager.shared.isCheckFresh(assetId)) {
                Log.i(TAG, "[cache-hit] Model already installed at ${activeDir.absolutePath} and catalog check " +
                    "is fresh — using cached model, no network call.")
                progress?.invoke(1.0)
                return
            }
            Log.i(TAG, "[ensureModel] Model already installed at ${activeDir.absolutePath}; catalog-check " +
                "window elapsed — asking AIAssetManager for a best-effort update check.")
            // Offline-first: a failed/absent update check must never break an
            // already-working, already-verified installed model.
            try {
                AIAssetManager.shared.checkForUpdateAndInstallIfNeeded(assetId, progress = progress)
            } catch (e: Exception) {
                Log.w(TAG, "[ensureModel] Update check failed (${e.message}) — continuing with the currently " +
                    "active model.")
            }
            progress?.invoke(1.0)
            return
        }
        if (importDir.exists()) {
            // Same-volume activation: rename TajweedImport → TajweedModels/active when possible
            // so we don't need a second ~450MB copy on disk (critical for emulators).
            Log.i(TAG, "[ensureModel] No active model, but local ${importDir.absolutePath} exists — " +
                "using adb-pushed dev import instead of a network download.")
            activateFromImport(progress)
            return
        }
        Log.i(TAG, "[ensureModel] No active model and no local import dir — requesting first install from " +
            "AIAssetManager (assetId=$assetId).")
        try {
            AIAssetManager.shared.performFirstInstall(assetId, progress = progress)
            Log.i(TAG, "[ensureModel] First install complete — model is now active at ${activeDir.absolutePath}.")
            return
        } catch (e: TajweedNativeException) {
            // A genuine content/verification failure (e.g. checksum mismatch)
            // from TajweedAssetSync.install() — surface it as-is, never mask
            // it as MODEL_MISSING.
            Log.e(TAG, "[ensureModel] First install failed with a content/verification error: ${e.message}")
            throw e
        } catch (e: AssetDownloadException) {
            // Catalog was reachable and a real download/install attempt ran —
            // do NOT remask as MODEL_MISSING (that message tells people to
            // adb-push, which is wrong once Cloudflare R2 distribution is live).
            // When distribution is not configured, keep the historic MODEL_MISSING
            // fallback so offline/dev paths and unit tests stay unchanged.
            if (TajweedAssetDistributionConfig.catalogUrl != null) {
                Log.e(TAG, "[ensureModel] First install failed during download/install: ${e.message}")
                throw TajweedNativeException(
                    TajweedErrorCode.MODEL_DOWNLOAD_FAILED,
                    e.message ?: e.toString(),
                )
            }
            Log.w(TAG, "[ensureModel] First install could not proceed (${e.message}) — falling back to " +
                "MODEL_MISSING.")
        } catch (e: Exception) {
            // e.g. IOException while copying the ~450MB pack into ModelStore's
            // install staging (disk full). Same rule: surface as download
            // failure when a catalog is configured; only fall back to the
            // historic MODEL_MISSING/adb-push hint when distribution is off.
            if (TajweedAssetDistributionConfig.catalogUrl != null) {
                Log.e(TAG, "[ensureModel] First install failed after catalog was configured: ${e.message}")
                throw TajweedNativeException(
                    TajweedErrorCode.MODEL_DOWNLOAD_FAILED,
                    e.message ?: e.toString(),
                )
            }
            Log.w(TAG, "[ensureModel] First install could not proceed (${e.message}) — falling back to " +
                "MODEL_MISSING.")
        }
        throw TajweedNativeException(
            TajweedErrorCode.MODEL_MISSING,
            "Model pack not installed. Push ONNX packages into ${importDir.absolutePath} (adb push), then retry ensureModel.",
        )
    }

    private fun activateFromImport(progress: ((Double) -> Unit)?) {
        progress?.invoke(0.1)
        verifyStaging(importDir)
        progress?.invoke(0.5)
        rootDir.mkdirs()
        val previous = File(rootDir, "previous")
        previous.deleteRecursively()
        if (activeDir.exists()) {
            if (!activeDir.renameTo(previous)) {
                activeDir.copyRecursively(previous, overwrite = true)
                activeDir.deleteRecursively()
            }
        }
        try {
            // Prefer atomic rename (same filesystem). Fallback: copy then clear import.
            if (!importDir.renameTo(activeDir)) {
                installFromDirectory(importDir, progress)
                return
            }
            progress?.invoke(1.0)
        } catch (e: Exception) {
            if (previous.exists()) {
                previous.renameTo(activeDir)
            }
            throw TajweedNativeException(
                TajweedErrorCode.MODEL_DOWNLOAD_FAILED,
                "Activation failed: ${e.message}",
            )
        } finally {
            previous.deleteRecursively()
        }
    }

    private fun requireManifest(): JSONObject =
        readManifest() ?: throw TajweedNativeException(TajweedErrorCode.MODEL_MISSING, "No active model manifest.")

    private fun readManifest(): JSONObject? {
        if (!manifestFile.exists()) return null
        return try {
            JSONObject(manifestFile.readText())
        } catch (_: Exception) {
            null
        }
    }

    private fun verifyStaging(staging: File) {
        Log.i(TAG, "[verify] Verifying staged model at ${staging.absolutePath}")
        val manifestPath = File(staging, "model_manifest.json")
        val manifest = try {
            JSONObject(manifestPath.readText())
        } catch (_: Exception) {
            Log.e(TAG, "[verify] Invalid or missing model_manifest.json in ${staging.absolutePath}")
            throw TajweedNativeException(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, "Invalid staging manifest.")
        }
        val encoder = manifest.optString("encoder", "")
        val head = manifest.optString("pronunciationHead", "")
        val tokenizer = manifest.optString("tokenizer", "")
        val tokens = manifest.optString("tokens", "tokens.txt")
        if (encoder.isEmpty() || head.isEmpty() || tokenizer.isEmpty()) {
            Log.e(TAG, "[verify] Manifest is missing required keys (encoder/pronunciationHead/tokenizer).")
            throw TajweedNativeException(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, "Invalid staging manifest.")
        }
        for (name in listOf(encoder, head, tokenizer, tokens)) {
            if (!File(staging, name).exists()) {
                Log.e(TAG, "[verify] Missing artifact on disk: $name (expected at ${File(staging, name).absolutePath})")
                throw TajweedNativeException(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, "Missing artifact: $name")
            }
        }
        val sha = manifest.optJSONObject("sha256")
        if (sha != null) {
            verifySha(staging, encoder, sha.optString("encoder", null))
            verifySha(staging, head, sha.optString("pronunciationHead", null))
            verifySha(staging, tokenizer, sha.optString("tokenizer", null))
            Log.i(TAG, "[verify] SHA-256 verification passed for encoder, pronunciationHead, tokenizer.")
        } else {
            Log.w(TAG, "[verify] Manifest has no 'sha256' block — skipping integrity check (dev/local-import path).")
        }
    }

    private fun verifySha(staging: File, name: String, expected: String?) {
        if (expected.isNullOrEmpty() || expected == "PENDING_AFTER_HF_ACCESS") {
            Log.d(TAG, "[verify-sha] $name: no expected hash in manifest — skipping.")
            return
        }
        Log.d(TAG, "[verify-sha] Computing SHA-256 for $name (${File(staging, name).length()} bytes)...")
        val file = File(staging, name)
        val digest = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { input ->
            val buffer = ByteArray(8192)
            var read: Int
            while (input.read(buffer).also { read = it } > 0) {
                digest.update(buffer, 0, read)
            }
        }
        val hex = digest.digest().joinToString("") { "%02x".format(it) }
        if (!hex.equals(expected, ignoreCase = true)) {
            Log.e(TAG, "[verify-sha] SHA-256 MISMATCH for $name: expected=$expected actual=$hex — " +
                "rejecting this download, will not activate.")
            throw TajweedNativeException(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, "SHA-256 mismatch for $name")
        }
        Log.d(TAG, "[verify-sha] $name OK (sha256=$hex)")
    }
}
