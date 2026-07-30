package com.rnr.deenfocus.assetdownload

import android.util.Log
import java.io.File
import java.util.concurrent.ConcurrentHashMap
import org.json.JSONObject

private const val TAG = "AIAssetManager"

/**
 * Generic, multi-asset orchestrator built on top of the AssetDownload
 * framework (ADR-008 / ADR-009 "AI Asset Manager"). One shared `catalog.json`
 * can list any number of independently versioned assets — Tajweed AI models,
 * Qari audio packs, translation packs, tafsir packs, future AI models — each
 * registering its own [AIAssetPlugin]. This class owns: catalog fetch,
 * per-asset "last checked" freshness, version comparison, staging-directory
 * lifecycle, and progress weighting. It knows nothing about what any
 * registered asset actually contains — all of that lives in the asset's own
 * plugin. Tajweed ([TajweedAssetSync][com.rnr.deenfocus.tajweed.TajweedAssetSync])
 * is the first asset registered with this manager.
 */
class AIAssetManager(
    private val fetcher: AssetManifestFetcher = AssetManifestFetcher(),
    private val downloader: AssetDownloadManager = AssetDownloadManager(),
) {
    companion object {
        /** Process-wide instance used by production consumers (e.g. `ModelStore`). */
        val shared = AIAssetManager()
    }

    /**
     * Root HTTPS URL of the shared `catalog.json`. Null until infrastructure
     * is provisioned — every method below is then fully inert for assets
     * that rely on it (never touches the network).
     */
    @Volatile
    var catalogUrl: String? = null

    @Volatile
    var checkIntervalHours: Double = 24.0

    private val platformKey = "android"
    private val plugins = ConcurrentHashMap<String, AIAssetPlugin>()

    /**
     * Registers (or replaces) the plugin responsible for [plugin]'s assetId.
     * Safe to call multiple times — e.g. idempotent lazy registration at
     * first use from a consumer's own `ensureModel()`-style entry point.
     */
    fun register(plugin: AIAssetPlugin) {
        plugins[plugin.assetId] = plugin
    }

    fun plugin(assetId: String): AIAssetPlugin? = plugins[assetId]

    private data class UpdateState(val lastCheckedAt: Long, val installedVersion: String)

    private fun stateFile(plugin: AIAssetPlugin): File = File(plugin.workingDirectory, "update_state.json")

    private fun readState(plugin: AIAssetPlugin): UpdateState? {
        val file = stateFile(plugin)
        if (!file.exists()) return null
        return try {
            val json = JSONObject(file.readText())
            UpdateState(json.getLong("lastCheckedAt"), json.getString("installedVersion"))
        } catch (_: Exception) {
            null
        }
    }

    private fun writeState(plugin: AIAssetPlugin, state: UpdateState) {
        plugin.workingDirectory.mkdirs()
        val json = JSONObject().apply {
            put("lastCheckedAt", state.lastCheckedAt)
            put("installedVersion", state.installedVersion)
        }
        stateFile(plugin).writeText(json.toString())
    }

    /**
     * True when the last successful catalog check for [assetId] happened
     * within [intervalHours] — gates "don't hit the network every launch,
     * only check a tiny manifest at most once a day."
     */
    fun isCheckFresh(assetId: String, intervalHours: Double = checkIntervalHours): Boolean {
        val plugin = plugins[assetId] ?: return false
        val state = readState(plugin) ?: return false
        val elapsedHours = (System.currentTimeMillis() - state.lastCheckedAt) / 3_600_000.0
        return elapsedHours < intervalHours
    }

    /**
     * Called when nothing is installed for [assetId] yet. Throws a generic
     * [AssetDownloadException] — never a feature-specific error type — if
     * the asset isn't registered, distribution isn't configured, or the
     * network or verification fails. Callers translate that at their own
     * adapter boundary (see `ModelStore.ensureModel()`), exactly as before
     * this refactor.
     */
    fun performFirstInstall(
        assetId: String,
        catalogUrl: String? = this.catalogUrl,
        progress: ((Double) -> Unit)? = null,
    ) {
        val plugin = plugins[assetId]
            ?: throw AssetDownloadException.InvalidManifest("No AIAssetPlugin registered for assetId $assetId.")
        val url = catalogUrl
            ?: throw AssetDownloadException.InvalidManifest("Asset distribution not configured for $assetId.")
        syncFromCatalog(plugin, url, forceInstall = true, progress = progress)
    }

    /**
     * Called when a verified asset is already active. Best-effort only: any
     * failure here must never affect an already-working install — callers
     * should swallow (not surface) exceptions from this method.
     */
    fun checkForUpdateAndInstallIfNeeded(
        assetId: String,
        catalogUrl: String? = this.catalogUrl,
        progress: ((Double) -> Unit)? = null,
    ) {
        val plugin = plugins[assetId] ?: return
        val url = catalogUrl ?: return
        syncFromCatalog(plugin, url, forceInstall = false, progress = progress)
    }

    /**
     * High-level convenience: no-op if already available and the catalog
     * check is still fresh, best-effort update check if stale, full
     * first-install if nothing is active yet. This is what any registered
     * asset's own `ensureXyz()` entry point should call.
     */
    fun ensureAsset(
        assetId: String,
        catalogUrl: String? = this.catalogUrl,
        progress: ((Double) -> Unit)? = null,
    ) {
        val plugin = plugins[assetId]
            ?: throw AssetDownloadException.InvalidManifest("No AIAssetPlugin registered for assetId $assetId.")
        if (plugin.isAvailable()) {
            if (isCheckFresh(assetId)) {
                Log.i(TAG, "[cache-hit] Asset '$assetId' already installed and catalog check is fresh " +
                    "(< $checkIntervalHours h since last check) — skipping network entirely.")
                progress?.invoke(1.0)
                return
            }
            Log.i(TAG, "Asset '$assetId' is installed but the $checkIntervalHours h catalog-check window has " +
                "elapsed — performing a best-effort update check.")
            try {
                checkForUpdateAndInstallIfNeeded(assetId, catalogUrl, progress)
            } catch (e: Exception) {
                Log.w(TAG, "Best-effort update check failed for '$assetId'; keeping the currently active " +
                    "version. Reason: ${e.message}")
            }
            progress?.invoke(1.0)
            return
        }
        Log.i(TAG, "Asset '$assetId' is not yet installed — performing first install.")
        performFirstInstall(assetId, catalogUrl, progress)
    }

    private fun syncFromCatalog(
        plugin: AIAssetPlugin,
        catalogUrl: String,
        forceInstall: Boolean,
        progress: ((Double) -> Unit)?,
    ) {
        val notifier = AssetProgressNotifier(
            listOf("catalog" to 0.05, "manifest" to 0.05, "download" to 0.85, "install" to 0.05),
        ) { p -> progress?.invoke(p) }

        Log.i(TAG, "[catalog] Fetching catalog.json for asset '${plugin.assetId}' (forceInstall=$forceInstall) " +
            "from $catalogUrl")
        val catalog: AssetCatalog
        try {
            catalog = fetcher.fetchCatalog(catalogUrl)
            notifier.update("catalog", 1.0)
            Log.i(TAG, "[catalog] Fetched catalog.json OK — ${catalog.packs.size} pack(s) listed.")
        } catch (e: Exception) {
            Log.w(TAG, "[catalog] Failed to fetch catalog.json from $catalogUrl: ${e.message}" +
                if (forceInstall) " — aborting first install." else " — keeping existing installed asset (offline-first).")
            if (forceInstall) throw e
            return // Offline-first: keep using the already-installed, already-verified asset.
        }

        // Exact assetId match only — no "fall back to any default entry".
        // That Tajweed-only convenience would be unsafe now that one shared
        // catalog can list many unrelated assets (Qari packs, translations, ...).
        val entry = catalog.entry(plugin.assetId)
        if (entry == null) {
            Log.w(TAG, "[catalog] No entry for assetId '${plugin.assetId}' in catalog.json.")
            if (forceInstall) {
                throw AssetDownloadException.InvalidManifest("Catalog has no entry for assetId ${plugin.assetId}.")
            }
            return
        }
        Log.i(TAG, "[catalog] Catalog entry for '${plugin.assetId}': kind=${entry.kind}, " +
            "latestVersion=${entry.latestVersion}")
        val manifestUrl = entry.manifestUrl[platformKey]
        if (manifestUrl == null) {
            Log.w(TAG, "[catalog] Catalog entry '${plugin.assetId}' has no manifest URL for platform " +
                "'$platformKey'.")
            if (forceInstall) {
                throw AssetDownloadException.InvalidManifest(
                    "Catalog entry ${plugin.assetId} has no manifest for platform $platformKey.",
                )
            }
            return
        }

        if (!forceInstall) {
            val installed = readState(plugin)
            if (installed != null && !isNewerVersion(entry.latestVersion, installed.installedVersion)) {
                Log.i(TAG, "[version-check] '${plugin.assetId}' is already at the latest version " +
                    "(${installed.installedVersion}) — no download needed.")
                writeState(plugin, UpdateState(System.currentTimeMillis(), installed.installedVersion))
                return
            }
            if (installed != null) {
                Log.i(TAG, "[version-check] '${plugin.assetId}' update available: " +
                    "${installed.installedVersion} -> ${entry.latestVersion}")
            }
        }

        Log.i(TAG, "[manifest] Fetching model_manifest.json for '${plugin.assetId}' v${entry.latestVersion} " +
            "from $manifestUrl")
        val manifestJson: JSONObject
        try {
            manifestJson = fetcher.fetchManifestJson(manifestUrl)
            notifier.update("manifest", 1.0)
            Log.i(TAG, "[manifest] Fetched model_manifest.json OK for '${plugin.assetId}' v${entry.latestVersion}")
        } catch (e: Exception) {
            Log.w(TAG, "[manifest] Failed to fetch manifest from $manifestUrl: ${e.message}" +
                if (forceInstall) " — aborting first install." else " — keeping existing installed asset.")
            if (forceInstall) throw e
            return
        }

        val artifactBase = manifestJson.optString("artifactBaseUrl", "").ifEmpty {
            manifestUrl.substringBeforeLast("/") + "/"
        }
        val specs = plugin.fileSpecs(manifestJson, artifactBase).toMutableList()
        val approxTotalSize = entry.approxSizeBytes?.get(platformKey)
        if (approxTotalSize != null && specs.isNotEmpty() && specs[0].expectedSizeBytes == null) {
            specs[0] = specs[0].copy(expectedSizeBytes = approxTotalSize)
        }
        Log.i(TAG, "[download] Resolved ${specs.size} file(s) for '${plugin.assetId}' v${entry.latestVersion} " +
            "from artifact base $artifactBase: ${specs.joinToString { it.relativePath }}")

        // Stable (non-UUID) staging path so an interrupted download resumes
        // correctly even after an app relaunch — see AssetDownloadManager's
        // `.part`-file resume.
        val stagingDir = File(File(plugin.workingDirectory, "download-staging"), "${plugin.assetId}-${entry.latestVersion}")
        Log.i(TAG, "[download] Staging directory: ${stagingDir.absolutePath}")

        downloader.downloadFiles(specs, stagingDir) { p -> notifier.update("download", p) }
        Log.i(TAG, "[download] All ${specs.size} file(s) downloaded for '${plugin.assetId}' v${entry.latestVersion}" +
            " — handing off to plugin.install() for SHA-256 verification + activation.")
        try {
            plugin.install(stagingDir, manifestJson) { p -> notifier.update("install", p) }
        } catch (e: Exception) {
            // Only wipe staging when the *content* is known-bad. Disk-full /
            // rename/activation failures must keep the already-downloaded pack
            // so the next ensureAsset() can resume/activate without re-fetching
            // hundreds of MB (confirmed ENOSPC failure mode on constrained emulators).
            val corruptContent = e is AssetDownloadException.IntegrityMismatch ||
                (e.message?.contains("SHA-256", ignoreCase = true) == true) ||
                (e.message?.contains("Invalid staging manifest", ignoreCase = true) == true) ||
                (e.message?.contains("Missing artifact", ignoreCase = true) == true) ||
                (e.message?.contains("Invalid remote manifest", ignoreCase = true) == true)
            if (corruptContent) {
                Log.e(TAG, "[install] '${plugin.assetId}' v${entry.latestVersion} failed verification " +
                    "(${e.message}) — deleting corrupted staged download at ${stagingDir.absolutePath}.")
                stagingDir.deleteRecursively()
            } else {
                Log.e(TAG, "[install] '${plugin.assetId}' v${entry.latestVersion} failed activation " +
                    "(${e.message}) — keeping staged download at ${stagingDir.absolutePath} for retry.")
            }
            throw e
        }
        Log.i(TAG, "[install] '${plugin.assetId}' v${entry.latestVersion} verified and activated successfully.")
        // Plugin may have renamed stagingDir into its active path (same-volume
        // activate) — only delete leftovers if the directory is still present.
        if (stagingDir.exists()) {
            stagingDir.deleteRecursively()
        }

        writeState(plugin, UpdateState(System.currentTimeMillis(), entry.latestVersion))
        Log.i(TAG, "[state] Recorded '${plugin.assetId}' installedVersion=${entry.latestVersion}, " +
            "lastCheckedAt=${System.currentTimeMillis()}")
    }

    private fun isNewerVersion(candidate: String, current: String): Boolean {
        fun parts(v: String) = v.split(".").map { it.toIntOrNull() ?: 0 }
        val c = parts(candidate)
        val k = parts(current)
        for (i in 0 until maxOf(c.size, k.size)) {
            val a = c.getOrElse(i) { 0 }
            val b = k.getOrElse(i) { 0 }
            if (a != b) return a > b
        }
        return false
    }
}
