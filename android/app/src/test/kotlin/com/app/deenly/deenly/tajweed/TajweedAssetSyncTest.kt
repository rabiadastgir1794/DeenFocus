package com.rnr.deenfocus.tajweed

import androidx.test.core.app.ApplicationProvider
import com.rnr.deenfocus.assetdownload.AIAssetManager
import com.rnr.deenfocus.assetdownload.AssetDownloadException
import com.rnr.deenfocus.assetdownload.AssetDownloadManager
import com.rnr.deenfocus.assetdownload.AssetManifestFetcher
import com.rnr.deenfocus.assetdownload.FakeAssetTransport
import java.io.File
import java.security.MessageDigest
import org.json.JSONObject
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/**
 * ADR-008/ADR-009: end-to-end tests for the Tajweed [AIAssetPlugin]
 * ([TajweedAssetSync]) driven through a real [AIAssetManager] instance and
 * wired to a real [ModelStore] — proves the production model-distribution
 * path (catalog -> manifest -> download -> ModelStore's own unmodified
 * verify/activate/rollback) behaves correctly for every required scenario,
 * entirely offline via [FakeAssetTransport].
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class TajweedAssetSyncTest {
    private val assetId = TajweedAssetDistributionConfig.ASSET_ID
    private var savedProductionCatalogUrl: String? = null

    // Every test in this class either injects its own isolated AIAssetManager
    // (via makeManager/FakeAssetTransport) or, for the one test that calls the
    // real store.ensureModel(), must NEVER be allowed to hit the real
    // production Cloudflare R2 endpoint from a unit test. ModelStore's lazy
    // `assetSync` reads TajweedAssetDistributionConfig.catalogUrl the first
    // time it's touched, so nulling it out here (before that happens) is
    // sufficient — no AIAssetManager/ModelStore production code is touched.
    @Before
    fun disableRealNetworkCatalogForTests() {
        savedProductionCatalogUrl = TajweedAssetDistributionConfig.catalogUrl
        TajweedAssetDistributionConfig.catalogUrl = null
        AIAssetManager.shared.catalogUrl = null
    }

    @After
    fun restoreProductionCatalogConfig() {
        TajweedAssetDistributionConfig.catalogUrl = savedProductionCatalogUrl
    }
    private val catalogUrl = "https://cdn.test/tajweed/catalog.json"
    private val manifestUrlV1 = "https://cdn.test/tajweed/packs/hafs-en-v1/1.0.0/android/model_manifest.json"
    private val manifestUrlV2 = "https://cdn.test/tajweed/packs/hafs-en-v1/1.1.0/android/model_manifest.json"
    private val artifactBaseV1 = "https://cdn.test/tajweed/packs/hafs-en-v1/1.0.0/android/"
    private val artifactBaseV2 = "https://cdn.test/tajweed/packs/hafs-en-v1/1.1.0/android/"

    private fun sha256(bytes: ByteArray): String =
        MessageDigest.getInstance("SHA-256").digest(bytes).joinToString("") { "%02x".format(it) }

    private fun freshModelStore(): ModelStore {
        val store = ModelStore(ApplicationProvider.getApplicationContext())
        store.rootDir.deleteRecursively()
        return store
    }

    private fun makeManager(store: ModelStore, transport: FakeAssetTransport): AIAssetManager {
        val manager = AIAssetManager(AssetManifestFetcher(transport), AssetDownloadManager(transport))
        manager.register(TajweedAssetSync(store))
        return manager
    }

    private fun catalogJson(version: String, approxSizeBytes: Long? = null): String = JSONObject().apply {
        put("catalogVersion", 1)
        put(
            "packs",
            org.json.JSONArray().put(
                JSONObject().apply {
                    put("packId", "hafs-en-v1")
                    put("kind", "tajweed_model")
                    put("isDefault", true)
                    put("latestVersion", version)
                    put(
                        "manifestUrl",
                        JSONObject().put(
                            "android",
                            if (version == "1.0.0") manifestUrlV1 else manifestUrlV2,
                        ),
                    )
                    if (approxSizeBytes != null) {
                        put("approxSizeBytes", JSONObject().put("android", approxSizeBytes))
                    }
                },
            ),
        )
    }.toString()

    private fun seedTransport(
        transport: FakeAssetTransport,
        manifestUrl: String,
        artifactBase: String,
        encoderBytes: ByteArray,
        headBytes: ByteArray,
        tokenizerBytes: ByteArray,
        tokensBytes: ByteArray,
        version: String,
        corruptEncoderSha: Boolean = false,
    ) {
        transport.fileBytes[artifactBase + "model_with_encoder.onnx"] = encoderBytes
        transport.fileBytes[artifactBase + "pronunciation_head.onnx"] = headBytes
        transport.fileBytes[artifactBase + "tokenizer.model"] = tokenizerBytes
        transport.fileBytes[artifactBase + "tokens.txt"] = tokensBytes
        val manifest = JSONObject().apply {
            put("version", version)
            put("encoder", "model_with_encoder.onnx")
            put("pronunciationHead", "pronunciation_head.onnx")
            put("tokenizer", "tokenizer.model")
            put("tokens", "tokens.txt")
            put("artifactBaseUrl", artifactBase)
            put("minimumAppVersion", "1.0.0")
            put(
                "sha256",
                JSONObject().apply {
                    put("encoder", if (corruptEncoderSha) "0".repeat(64) else sha256(encoderBytes))
                    put("pronunciationHead", sha256(headBytes))
                    put("tokenizer", sha256(tokenizerBytes))
                },
            )
        }
        transport.jsonResponses[manifestUrl] = manifest.toString()
    }

    @Test
    fun performFirstInstall_downloadsAndActivatesRealModel() {
        val store = freshModelStore()
        val transport = FakeAssetTransport()
        transport.jsonResponses[catalogUrl] = catalogJson("1.0.0")
        val encoderBytes = ByteArray(2000) { it.toByte() }
        seedTransport(
            transport, manifestUrlV1, artifactBaseV1,
            encoderBytes, ByteArray(500) { 1 }, ByteArray(300) { 2 }, ByteArray(100) { 3 },
            version = "1.0.0",
        )
        val manager = makeManager(store, transport)

        manager.performFirstInstall(assetId, catalogUrl = catalogUrl)

        assertTrue(store.isAvailable())
        assertEquals(sha256(encoderBytes), sha256(store.encoderFile().readBytes()))
        val state = JSONObject(File(store.rootDir, "update_state.json").readText())
        assertEquals("1.0.0", state.getString("installedVersion"))
    }

    @Test
    fun performFirstInstall_catalogUnavailable_throws() {
        val store = freshModelStore()
        val transport = FakeAssetTransport() // no catalog response registered -> 404
        val manager = makeManager(store, transport)

        try {
            manager.performFirstInstall(assetId, catalogUrl = catalogUrl)
            fail("Expected a badStatusCode(404) failure")
        } catch (e: AssetDownloadException.BadStatusCode) {
            assertEquals(404, e.code)
        }
        assertFalse(store.isAvailable())
    }

    @Test
    fun ensureModel_fallsBackToModelMissing_whenCatalogUnavailable() {
        // ModelStore.ensureModel() is the real adapter boundary: it must
        // translate any AIAssetManager failure (not configured / registered /
        // unreachable) into the stable TajweedErrorCode.MODEL_MISSING
        // contract Flutter expects.
        val store = freshModelStore()
        try {
            store.ensureModel()
            fail("Expected MODEL_MISSING")
        } catch (e: TajweedNativeException) {
            assertEquals(TajweedErrorCode.MODEL_MISSING, e.code)
        }
    }

    @Test
    fun checkForUpdate_newerVersionAvailable_downloadsAndActivates() {
        val store = freshModelStore()
        // Seed an existing v1.0.0 install first.
        val installTransport = FakeAssetTransport()
        installTransport.jsonResponses[catalogUrl] = catalogJson("1.0.0")
        seedTransport(
            installTransport, manifestUrlV1, artifactBaseV1,
            ByteArray(100) { 1 }, ByteArray(50) { 2 }, ByteArray(30) { 3 }, ByteArray(10) { 4 },
            version = "1.0.0",
        )
        makeManager(store, installTransport).performFirstInstall(assetId, catalogUrl = catalogUrl)

        // Now check for an update to v1.1.0 with different artifact content.
        val updateTransport = FakeAssetTransport()
        updateTransport.jsonResponses[catalogUrl] = catalogJson("1.1.0")
        val newEncoder = ByteArray(200) { 9 }
        seedTransport(
            updateTransport, manifestUrlV2, artifactBaseV2,
            newEncoder, ByteArray(80) { 8 }, ByteArray(40) { 7 }, ByteArray(20) { 6 },
            version = "1.1.0",
        )
        val manager = makeManager(store, updateTransport)
        manager.checkForUpdateAndInstallIfNeeded(assetId, catalogUrl = catalogUrl)

        assertTrue(store.isAvailable())
        assertEquals(sha256(newEncoder), sha256(store.encoderFile().readBytes()))
        val state = JSONObject(File(store.rootDir, "update_state.json").readText())
        assertEquals("1.1.0", state.getString("installedVersion"))
    }

    @Test
    fun checkForUpdate_sameVersion_doesNotRedownload() {
        val store = freshModelStore()
        val transport = FakeAssetTransport()
        transport.jsonResponses[catalogUrl] = catalogJson("1.0.0")
        seedTransport(
            transport, manifestUrlV1, artifactBaseV1,
            ByteArray(100) { 1 }, ByteArray(50) { 2 }, ByteArray(30) { 3 }, ByteArray(10) { 4 },
            version = "1.0.0",
        )
        val manager = makeManager(store, transport)
        manager.performFirstInstall(assetId, catalogUrl = catalogUrl)
        transport.rangeCallLog.clear()

        manager.checkForUpdateAndInstallIfNeeded(assetId, catalogUrl = catalogUrl)

        assertTrue("No file should be re-downloaded for an unchanged version", transport.rangeCallLog.isEmpty())
    }

    @Test
    fun checksumMismatch_onFirstInstall_neverActivates() {
        val store = freshModelStore()
        val transport = FakeAssetTransport()
        transport.jsonResponses[catalogUrl] = catalogJson("1.0.0")
        seedTransport(
            transport, manifestUrlV1, artifactBaseV1,
            ByteArray(100) { 1 }, ByteArray(50) { 2 }, ByteArray(30) { 3 }, ByteArray(10) { 4 },
            version = "1.0.0",
            corruptEncoderSha = true,
        )
        val manager = makeManager(store, transport)

        try {
            manager.performFirstInstall(assetId, catalogUrl = catalogUrl)
            fail("Expected SHA-256 verification failure")
        } catch (e: TajweedNativeException) {
            assertEquals(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, e.code)
        }
        assertFalse("A tampered/corrupt pack must never become active", store.isAvailable())
    }

    @Test
    fun failedUpdate_rollsBackAndKeepsPreviousModelActive() {
        val store = freshModelStore()
        val goodEncoder = ByteArray(100) { 1 }
        val installTransport = FakeAssetTransport()
        installTransport.jsonResponses[catalogUrl] = catalogJson("1.0.0")
        seedTransport(
            installTransport, manifestUrlV1, artifactBaseV1,
            goodEncoder, ByteArray(50) { 2 }, ByteArray(30) { 3 }, ByteArray(10) { 4 },
            version = "1.0.0",
        )
        makeManager(store, installTransport).performFirstInstall(assetId, catalogUrl = catalogUrl)

        val badTransport = FakeAssetTransport()
        badTransport.jsonResponses[catalogUrl] = catalogJson("1.1.0")
        seedTransport(
            badTransport, manifestUrlV2, artifactBaseV2,
            ByteArray(200) { 9 }, ByteArray(80) { 8 }, ByteArray(40) { 7 }, ByteArray(20) { 6 },
            version = "1.1.0",
            corruptEncoderSha = true,
        )
        val manager = makeManager(store, badTransport)

        try {
            manager.checkForUpdateAndInstallIfNeeded(assetId, catalogUrl = catalogUrl)
            fail("Expected the corrupt update to fail verification")
        } catch (e: TajweedNativeException) {
            assertEquals(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, e.code)
        }

        assertTrue("The previously active model must still be available after a failed update", store.isAvailable())
        assertEquals(
            "A failed update must never replace the currently active model",
            sha256(goodEncoder),
            sha256(store.encoderFile().readBytes()),
        )
    }

    @Test
    fun checkForUpdate_catalogUnreachable_keepsExistingModelSilently() {
        val store = freshModelStore()
        val installTransport = FakeAssetTransport()
        installTransport.jsonResponses[catalogUrl] = catalogJson("1.0.0")
        val encoderBytes = ByteArray(100) { 1 }
        seedTransport(
            installTransport, manifestUrlV1, artifactBaseV1,
            encoderBytes, ByteArray(50) { 2 }, ByteArray(30) { 3 }, ByteArray(10) { 4 },
            version = "1.0.0",
        )
        makeManager(store, installTransport).performFirstInstall(assetId, catalogUrl = catalogUrl)

        // Offline: the catalog endpoint now errors out entirely.
        val offlineTransport = FakeAssetTransport()
        offlineTransport.jsonErrors[catalogUrl] = AssetDownloadException.Network("no connectivity")
        val manager = makeManager(store, offlineTransport)

        manager.checkForUpdateAndInstallIfNeeded(assetId, catalogUrl = catalogUrl) // must not throw

        assertTrue(store.isAvailable())
        assertEquals(sha256(encoderBytes), sha256(store.encoderFile().readBytes()))
        assertTrue("No download should have been attempted while offline", offlineTransport.rangeCallLog.isEmpty())
    }

    @Test
    fun performFirstInstall_insufficientStorage_doesNotActivateAnything() {
        val store = freshModelStore()
        val transport = FakeAssetTransport()
        // Catalog declares a pack far larger than the (faked) available free space.
        transport.jsonResponses[catalogUrl] = catalogJson("1.0.0", approxSizeBytes = 500_000_000_000L)
        seedTransport(
            transport, manifestUrlV1, artifactBaseV1,
            ByteArray(100) { 1 }, ByteArray(50) { 2 }, ByteArray(30) { 3 }, ByteArray(10) { 4 },
            version = "1.0.0",
        )
        val starvedDownloader = AssetDownloadManager(transport, freeSpaceProvider = { 1_000L })
        val manager = AIAssetManager(AssetManifestFetcher(transport), starvedDownloader)
        manager.register(TajweedAssetSync(store))

        try {
            manager.performFirstInstall(assetId, catalogUrl = catalogUrl)
            fail("Expected an insufficient-storage failure before any download")
        } catch (e: AssetDownloadException.InsufficientStorage) {
            assertEquals(500_000_000_000L + 64L * 1024 * 1024, e.requiredBytes)
        }
        assertTrue("No network call should have been attempted", transport.rangeCallLog.isEmpty())
        assertFalse("Nothing must be activated when storage is insufficient", store.isAvailable())
    }

    @Test
    fun catalogWithUnrelatedAssetEntry_isIgnored() {
        // A shared multi-asset catalog (ADR-009) may list other assets (e.g. a
        // future Qari pack) alongside Tajweed. Tajweed's own lookup must
        // match its assetId exactly and never fall back to an unrelated entry.
        val store = freshModelStore()
        val transport = FakeAssetTransport()
        val catalog = JSONObject().apply {
            put("catalogVersion", 1)
            put(
                "packs",
                org.json.JSONArray().put(
                    JSONObject().apply {
                        put("packId", "qari-alafasy")
                        put("kind", "qari_audio")
                        put("isDefault", true)
                        put("latestVersion", "1.0.0")
                        put(
                            "manifestUrl",
                            JSONObject().put("android", "https://cdn.test/qari/alafasy/1.0.0/android/model_manifest.json"),
                        )
                    },
                ),
            )
        }
        transport.jsonResponses[catalogUrl] = catalog.toString()
        val manager = makeManager(store, transport)

        try {
            manager.performFirstInstall(assetId, catalogUrl = catalogUrl)
            fail("Expected InvalidManifest (no entry for this assetId)")
        } catch (e: AssetDownloadException.InvalidManifest) {
            // expected
        }
        assertFalse(store.isAvailable())
    }
}
