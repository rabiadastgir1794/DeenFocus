package com.rnr.deenfocus.assetdownload

import org.json.JSONObject

/**
 * Fetches the tiny top-level catalog and per-pack manifests over HTTPS (ADR-008).
 * Knows nothing about what a "pack" is used for (Tajweed, translations, TTS
 * voices, OCR, ...) — callers decode the per-pack manifest into whatever shape
 * they need.
 */
class AssetManifestFetcher(
    private val transport: AssetTransport = HttpUrlConnectionAssetTransport(),
) {
    fun fetchCatalog(url: String, timeoutMs: Int = 5_000): AssetCatalog {
        val text = transport.fetchJson(url, timeoutMs)
        return try {
            AssetCatalog.parse(JSONObject(text))
        } catch (e: Exception) {
            throw AssetDownloadException.DecodeFailed("catalog.json: ${e.message}")
        }
    }

    /**
     * Fetches a per-pack manifest as a raw [JSONObject] — the consumer (e.g.
     * Tajweed's `TajweedAssetSync`) interprets its own keys (`encoder`,
     * `pronunciationHead`, `sha256`, ...), matching the existing ADR-007 shape.
     */
    fun fetchManifestJson(url: String, timeoutMs: Int = 10_000): JSONObject {
        val text = transport.fetchJson(url, timeoutMs)
        return try {
            JSONObject(text)
        } catch (e: Exception) {
            throw AssetDownloadException.DecodeFailed("manifest is not a JSON object: ${e.message}")
        }
    }
}
