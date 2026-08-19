package com.rnr.deenfocus.qurantranslation

import com.rnr.deenfocus.assetdownload.AssetCatalog
import com.rnr.deenfocus.assetdownload.AssetDownloadException
import com.rnr.deenfocus.assetdownload.AssetManifestFetcher
import java.io.File
import org.json.JSONObject

/** One row from `catalog.json` for a downloadable Quran translation. */
data class TranslationCatalogEntry(
    val packId: String,
    val language: String,
    val displayName: String?,
    val latestVersion: String,
    /** Platform-specific approximate download size from catalog `approxSizeBytes.android`. */
    val approxSizeBytes: Long? = null,
)

/**
 * Cached shared `catalog.json` with 24h freshness (mirrors AIAssetManager cadence).
 * Translation packs are discovered by `kind == translation_pack` and `language`.
 */
class TranslationCatalogCache(
    private val rootDir: File,
    private val fetcher: AssetManifestFetcher = AssetManifestFetcher(),
) {
    private val cacheFile = File(rootDir, "catalog_cache.json")

    @Synchronized
    fun catalog(forceRefresh: Boolean = false): AssetCatalog {
        if (!forceRefresh) {
            readCache()?.let { cached ->
                if (isFresh(cached.fetchedAtMs)) return cached.catalog
            }
        }
        val url = TranslationAssetDistributionConfig.catalogUrl
        if (url == null) {
            readCache()?.let { return it.catalog }
            throw AssetDownloadException.InvalidManifest("Translation catalog URL not configured.")
        }
        val fetched = fetcher.fetchCatalog(url)
        writeCache(CachedCatalog(System.currentTimeMillis(), fetched))
        return fetched
    }

    fun translationEntries(forceRefresh: Boolean = false): List<TranslationCatalogEntry> =
        translationEntries(catalog(forceRefresh))

    fun translationEntries(catalog: AssetCatalog): List<TranslationCatalogEntry> =
        catalog.packs.mapNotNull { entry ->
            if (entry.kind != TranslationAssetDistributionConfig.TRANSLATION_KIND) return@mapNotNull null
            val lang = entry.language ?: return@mapNotNull null
            if (lang.isEmpty()) return@mapNotNull null
            TranslationCatalogEntry(
                packId = entry.packId,
                language = lang,
                displayName = entry.displayName,
                latestVersion = entry.latestVersion,
                approxSizeBytes = entry.approxSizeBytes?.get("android"),
            )
        }

    fun entryForLanguage(languageCode: String, forceRefresh: Boolean = false): TranslationCatalogEntry? =
        translationEntries(forceRefresh).firstOrNull { it.language == languageCode }

    private fun isFresh(fetchedAtMs: Long): Boolean {
        val elapsedHours = (System.currentTimeMillis() - fetchedAtMs) / (1000.0 * 60 * 60)
        return elapsedHours < TranslationAssetDistributionConfig.CHECK_INTERVAL_HOURS
    }

    private data class CachedCatalog(val fetchedAtMs: Long, val catalog: AssetCatalog)

    private fun readCache(): CachedCatalog? {
        if (!cacheFile.exists()) return null
        return try {
            val json = JSONObject(cacheFile.readText())
            CachedCatalog(json.getLong("fetchedAtMs"), AssetCatalog.parse(json.getJSONObject("catalog")))
        } catch (_: Exception) {
            null
        }
    }

    private fun writeCache(cached: CachedCatalog) {
        rootDir.mkdirs()
        val catalogJson = catalogToJson(cached.catalog)
        val payload = JSONObject().apply {
            put("fetchedAtMs", cached.fetchedAtMs)
            put("catalog", catalogJson)
        }
        cacheFile.writeText(payload.toString(2))
    }

    private fun catalogToJson(catalog: AssetCatalog): JSONObject {
        val packsArray = org.json.JSONArray()
        for (pack in catalog.packs) {
            packsArray.put(
                JSONObject().apply {
                    put("packId", pack.packId)
                    pack.kind?.let { put("kind", it) }
                    pack.displayName?.let { put("displayName", it) }
                    pack.language?.let { put("language", it) }
                    pack.riwayah?.let { put("riwayah", it) }
                    put("isDefault", pack.isDefault)
                    put("latestVersion", pack.latestVersion)
                    pack.minimumAppVersion?.let { put("minimumAppVersion", it) }
                    put("manifestUrl", JSONObject(pack.manifestUrl))
                    pack.approxSizeBytes?.let { sizes ->
                        put("approxSizeBytes", JSONObject(sizes))
                    }
                },
            )
        }
        return JSONObject().apply {
            put("catalogVersion", catalog.catalogVersion)
            catalog.updatedAt?.let { put("updatedAt", it) }
            catalog.recommendedCheckIntervalHours?.let { put("recommendedCheckIntervalHours", it) }
            put("packs", packsArray)
        }
    }
}
