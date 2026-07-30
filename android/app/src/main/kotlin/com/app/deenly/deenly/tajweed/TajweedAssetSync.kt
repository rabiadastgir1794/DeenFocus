package com.rnr.deenfocus.tajweed

import android.util.Log
import com.rnr.deenfocus.assetdownload.AIAssetPlugin
import com.rnr.deenfocus.assetdownload.AssetDownloadManager
import java.io.File
import org.json.JSONObject

private const val TAG = "TajweedAssetSync"

/**
 * The Tajweed-specific [AIAssetPlugin] (ADR-009) registered with the shared,
 * generic [com.rnr.deenfocus.assetdownload.AIAssetManager] (ADR-008
 * framework). Tajweed is the first asset registered with the AI Asset
 * Manager; future assets (Qari audio packs, translation packs, tafsir packs,
 * ...) register their own plugin the same way and reuse the exact same
 * download/verify/rollback engine. All Tajweed-aware glue lives here —
 * manifest key names (`encoder`/`pronunciationHead`/`tokenizer`/`tokens`/
 * `sha256`) and delegating final verify/activate to
 * [ModelStore.installFromDirectory] (unmodified). Neither `AIAssetManager`
 * nor anything in the `assetdownload` package imports or references this
 * class, or anything Tajweed/ONNX/ASR-related — keeping the downloader fully
 * isolated from the AI inference engine, per the reviewer's explicit
 * requirement.
 */
class TajweedAssetSync(private val modelStore: ModelStore) : AIAssetPlugin {
    override val assetId: String = TajweedAssetDistributionConfig.ASSET_ID
    override val kind: String = "tajweed_model"
    override val workingDirectory: File get() = modelStore.rootDir

    override fun isAvailable(): Boolean = modelStore.isAvailable()

    override fun fileSpecs(manifest: JSONObject, artifactBase: String): List<AssetDownloadManager.FileSpec> {
        val encoderName = manifest.optString("encoder", "")
        val headName = manifest.optString("pronunciationHead", "")
        val tokenizerName = manifest.optString("tokenizer", "")
        val tokensName = manifest.optString("tokens", "tokens.txt")
        if (encoderName.isEmpty() || headName.isEmpty() || tokenizerName.isEmpty()) {
            Log.e(TAG, "[fileSpecs] Remote manifest is missing encoder/pronunciationHead/tokenizer keys.")
            throw TajweedNativeException(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, "Invalid remote manifest.")
        }
        Log.i(TAG, "[fileSpecs] Tajweed pack artifacts to download: encoder=$encoderName, head=$headName, " +
            "tokenizer=$tokenizerName, tokens=$tokensName (base=$artifactBase)")
        return listOf(encoderName, headName, tokenizerName, tokensName).map { name ->
            AssetDownloadManager.FileSpec(url = artifactBase + name, relativePath = name)
        }
    }

    override fun install(stagingDir: File, manifestJson: JSONObject, progress: ((Double) -> Unit)?) {
        Log.i(TAG, "[install] Handing downloaded files at ${stagingDir.absolutePath} to " +
            "ModelStore.installFromDirectory() for SHA-256 verification + atomic activation.")
        // Write the manifest into staging so ModelStore's OWN (unmodified)
        // verifyStaging/verifySha performs the real, authoritative integrity
        // + shape check before any activation — this adapter never bypasses
        // that gate.
        File(stagingDir, "model_manifest.json").writeText(manifestJson.toString(2))
        modelStore.installFromDirectory(stagingDir, progress)
        Log.i(TAG, "[install] ModelStore.installFromDirectory() completed successfully.")
    }
}
