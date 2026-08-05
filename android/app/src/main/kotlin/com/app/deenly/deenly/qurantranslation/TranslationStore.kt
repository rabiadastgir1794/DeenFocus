package com.rnr.deenfocus.qurantranslation

import android.content.Context
import com.rnr.deenfocus.assetdownload.AIAssetManager
import com.rnr.deenfocus.assetdownload.AssetAtomicInstaller
import com.rnr.deenfocus.assetdownload.AssetDownloadException
import com.rnr.deenfocus.assetdownload.AssetIntegrityVerifier
import java.io.File
import org.json.JSONObject

/** On-disk lifecycle for one downloaded Quran translation language pack. */
class TranslationStore private constructor(context: Context) {
    private val appContext = context.applicationContext
    private val installer = AssetAtomicInstaller()

    private val rootDir: File
        get() = File(appContext.filesDir, "QuranTranslations")

    private val catalogCache: TranslationCatalogCache
        get() = TranslationCatalogCache(rootDir)

    fun languageRoot(languageCode: String): File = File(rootDir, languageCode)

    fun activeDir(languageCode: String): File = File(languageRoot(languageCode), "active")

    fun translationFile(languageCode: String): File = File(activeDir(languageCode), "translation.json")

    fun isAvailable(languageCode: String): Boolean = translationFile(languageCode).exists()

    fun installFromDirectory(stagingDir: File, languageCode: String, manifest: JSONObject) {
        val translationName = manifest.optString("translation", "translation.json")
        val stagingFile = File(stagingDir, translationName)
        if (!stagingFile.exists()) {
            throw AssetDownloadException.InvalidManifest("Missing $translationName in staging.")
        }
        val shaMap = manifest.optJSONObject("sha256")
        val expected = shaMap?.optString("translation", null)
        AssetIntegrityVerifier.verify(stagingFile, expected)

        val active = activeDir(languageCode)
        val previous = File(languageRoot(languageCode), "previous")
        val tempActive = File(languageRoot(languageCode), "staging-active-${System.currentTimeMillis()}")
        tempActive.mkdirs()
        stagingFile.copyTo(File(tempActive, "translation.json"), overwrite = true)
        File(tempActive, "translation_manifest.json").writeText(manifest.toString(2))

        installer.activate(tempActive, active, previous)
        tempActive.deleteRecursively()
    }

    fun ensureTranslation(languageCode: String, progress: ((Double) -> Unit)? = null) {
        registerSharedCatalog()
        val entry = catalogCache.entryForLanguage(languageCode)
            ?: throw AssetDownloadException.InvalidManifest(
                "No translation_pack in catalog for language \"$languageCode\".",
            )
        val plugin = TranslationAssetSync(this, entry.packId, languageCode)
        AIAssetManager.shared.register(plugin)
        AIAssetManager.shared.ensureAsset(entry.packId, progress = progress)
    }

    companion object {
        @Volatile
        private var instance: TranslationStore? = null

        fun getInstance(context: Context): TranslationStore =
            instance ?: synchronized(this) {
                instance ?: TranslationStore(context.applicationContext).also { instance = it }
            }

        private fun registerSharedCatalog() {
            if (AIAssetManager.shared.catalogUrl == null) {
                AIAssetManager.shared.catalogUrl = TranslationAssetDistributionConfig.catalogUrl
            }
        }
    }
}
