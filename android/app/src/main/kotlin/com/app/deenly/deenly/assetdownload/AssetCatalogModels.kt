package com.rnr.deenfocus.assetdownload

import org.json.JSONObject

/**
 * Reserved for future integrity upgrades (ADR-008): v1 never verifies these,
 * SHA-256 remains the sole authoritative check (unchanged `ModelStore` logic).
 */
data class AssetCatalogSignature(
    val algorithm: String,
    val publicKeyId: String,
    val signatureBase64: String,
) {
    companion object {
        fun parse(json: JSONObject?): AssetCatalogSignature? {
            if (json == null) return null
            val algorithm = json.optString("algorithm", "")
            val publicKeyId = json.optString("publicKeyId", "")
            val signature = json.optString("signatureBase64", "")
            if (algorithm.isEmpty() || signature.isEmpty()) return null
            return AssetCatalogSignature(algorithm, publicKeyId, signature)
        }
    }
}

/**
 * One downloadable pack entry in the catalog (packId/version/platform-based
 * layout, per ADR-008) — generic across any future asset type (Tajweed models,
 * translations, TTS voices, OCR packs, ...), not just Tajweed.
 */
data class AssetCatalogEntry(
    val packId: String,
    /**
     * Free-form asset category (ADR-009), e.g. `"tajweed_model"`,
     * `"qari_audio"`, `"translation_pack"`, `"tafsir_pack"`. Optional/
     * unvalidated by the framework — purely descriptive metadata for
     * tooling/UI.
     */
    val kind: String?,
    val displayName: String?,
    val language: String?,
    val riwayah: String?,
    val isDefault: Boolean,
    val latestVersion: String,
    val minimumAppVersion: String?,
    /** Per-platform URL to that platform's `model_manifest.json` (keys: "ios"/"android"). */
    val manifestUrl: Map<String, String>,
    /** Per-platform approximate total download size, used for a pre-flight free-space check. */
    val approxSizeBytes: Map<String, Long>?,
) {
    companion object {
        fun parse(json: JSONObject): AssetCatalogEntry {
            val manifestUrlJson = json.optJSONObject("manifestUrl") ?: JSONObject()
            val manifestUrl = mutableMapOf<String, String>()
            manifestUrlJson.keys().forEach { key -> manifestUrl[key] = manifestUrlJson.getString(key) }
            val sizeJson = json.optJSONObject("approxSizeBytes")
            val sizes = sizeJson?.let { obj ->
                val map = mutableMapOf<String, Long>()
                obj.keys().forEach { key -> map[key] = obj.getLong(key) }
                map
            }
            return AssetCatalogEntry(
                packId = json.getString("packId"),
                kind = json.optString("kind", null),
                displayName = json.optString("displayName", null),
                language = json.optString("language", null),
                riwayah = json.optString("riwayah", null),
                isDefault = json.optBoolean("isDefault", false),
                latestVersion = json.getString("latestVersion"),
                minimumAppVersion = json.optString("minimumAppVersion", null),
                manifestUrl = manifestUrl,
                approxSizeBytes = sizes,
            )
        }
    }
}

/** The tiny top-level `catalog.json` polled periodically by consumers. */
data class AssetCatalog(
    val catalogVersion: Int,
    val updatedAt: String?,
    val recommendedCheckIntervalHours: Double?,
    val catalogSignature: AssetCatalogSignature?,
    val packs: List<AssetCatalogEntry>,
) {
    fun entry(packId: String): AssetCatalogEntry? = packs.firstOrNull { it.packId == packId }

    fun defaultEntry(): AssetCatalogEntry? = packs.firstOrNull { it.isDefault } ?: packs.firstOrNull()

    companion object {
        fun parse(json: JSONObject): AssetCatalog {
            val packsJson = json.optJSONArray("packs")
            val packs = mutableListOf<AssetCatalogEntry>()
            if (packsJson != null) {
                for (i in 0 until packsJson.length()) {
                    packs.add(AssetCatalogEntry.parse(packsJson.getJSONObject(i)))
                }
            }
            return AssetCatalog(
                catalogVersion = json.optInt("catalogVersion", 1),
                updatedAt = json.optString("updatedAt", null),
                recommendedCheckIntervalHours =
                    if (json.has("recommendedCheckIntervalHours")) json.optDouble("recommendedCheckIntervalHours") else null,
                catalogSignature = AssetCatalogSignature.parse(json.optJSONObject("catalogSignature")),
                packs = packs,
            )
        }
    }
}
