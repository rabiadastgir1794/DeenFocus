package com.rnr.deenfocus.qurantranslation

import com.rnr.deenfocus.assetdownload.AIAssetPlugin
import com.rnr.deenfocus.assetdownload.AssetDownloadException
import com.rnr.deenfocus.assetdownload.AssetDownloadManager
import org.json.JSONObject

/** Quran translation [AIAssetPlugin] — one instance per catalog `packId`. */
class TranslationAssetSync(
    private val store: TranslationStore,
    override val assetId: String,
    private val languageCode: String,
) : AIAssetPlugin {
    override val kind: String = TranslationAssetDistributionConfig.TRANSLATION_KIND
    override val workingDirectory get() = store.languageRoot(languageCode)

    override fun isAvailable(): Boolean = store.isAvailable(languageCode)

    override fun fileSpecs(manifest: JSONObject, artifactBase: String): List<AssetDownloadManager.FileSpec> {
        val name = manifest.optString("translation", "")
        if (name.isEmpty()) {
            throw AssetDownloadException.InvalidManifest("Invalid translation manifest: missing \"translation\" key.")
        }
        return listOf(AssetDownloadManager.FileSpec(url = artifactBase + name, relativePath = name))
    }

    override fun install(stagingDir: java.io.File, manifestJson: JSONObject, progress: ((Double) -> Unit)?) {
        store.installFromDirectory(stagingDir, languageCode, manifestJson)
        progress?.invoke(1.0)
    }
}
