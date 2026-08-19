package com.rnr.deenfocus.assetdownload

import java.io.File
import org.json.JSONArray
import org.json.JSONObject
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.annotation.Config

/**
 * ADR-009: proves [AIAssetManager] is genuinely generic — driving a fully
 * synthetic, non-Tajweed [AIAssetPlugin] end-to-end, and proving two
 * unrelated assets can share one catalog + manager without interfering with
 * each other. Runs under Robolectric (like [com.rnr.deenfocus.tajweed.TajweedAssetSyncTest])
 * purely so `org.json.JSONObject`/`JSONArray` behave like the real library
 * instead of the SDK stub jar's `returnDefaultValues` no-ops.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class AIAssetManagerTest {
    /**
     * A minimal in-memory [AIAssetPlugin] standing in for a future asset kind
     * (e.g. a Qari audio pack or translation pack) — has no knowledge of
     * Tajweed, ONNX, or ModelStore, proving the manager doesn't either.
     */
    private class FakePlugin(override val assetId: String, override val kind: String) : AIAssetPlugin {
        override val workingDirectory: File =
            java.nio.file.Files.createTempDirectory("ai-asset-manager-test-$assetId").toFile()
        var installedFiles: Map<String, ByteArray> = emptyMap()
            private set
        var installCallCount = 0

        override fun isAvailable(): Boolean = installedFiles.isNotEmpty()

        override fun fileSpecs(manifest: JSONObject, artifactBase: String): List<AssetDownloadManager.FileSpec> {
            val files = manifest.optJSONArray("files")
                ?: throw AssetDownloadException.InvalidManifest("FakePlugin manifest missing 'files'.")
            return (0 until files.length()).map { i ->
                val name = files.getString(i)
                AssetDownloadManager.FileSpec(url = artifactBase + name, relativePath = name)
            }
        }

        override fun install(stagingDir: File, manifestJson: JSONObject, progress: ((Double) -> Unit)?) {
            installCallCount += 1
            val files = manifestJson.optJSONArray("files") ?: JSONArray()
            val result = mutableMapOf<String, ByteArray>()
            for (i in 0 until files.length()) {
                val name = files.getString(i)
                result[name] = File(stagingDir, name).readBytes()
            }
            installedFiles = result
            progress?.invoke(1.0)
        }
    }

    private fun jsonArrayOf(vararg items: String): JSONArray = JSONArray().apply { items.forEach { put(it) } }

    private fun catalogJson(entries: List<JSONObject>): String =
        JSONObject().apply {
            put("catalogVersion", 1)
            val packs = JSONArray()
            entries.forEach { packs.put(it) }
            put("packs", packs)
        }.toString()

    @Test
    fun ensureAsset_throwsWhenPluginNotRegistered() {
        val manager = AIAssetManager()
        manager.catalogUrl = "https://cdn.test/catalog.json"

        try {
            manager.ensureAsset("unregistered-asset")
            fail("Expected InvalidManifest")
        } catch (e: AssetDownloadException.InvalidManifest) {
            // expected
        }
    }

    @Test
    fun twoIndependentAssets_shareOneCatalogWithoutInterference() {
        val catalogUrl = "https://cdn.test/catalog.json"
        val pluginA = FakePlugin("asset-a", "qari_audio")
        val pluginB = FakePlugin("asset-b", "translation_pack")

        val manifestAUrl = "https://cdn.test/asset-a/1.0.0/manifest.json"
        val manifestBUrl = "https://cdn.test/asset-b/1.0.0/manifest.json"
        val artifactBaseA = "https://cdn.test/asset-a/1.0.0/"
        val artifactBaseB = "https://cdn.test/asset-b/1.0.0/"

        val transport = FakeAssetTransport()
        transport.jsonResponses[catalogUrl] = catalogJson(
            listOf(
                JSONObject().apply {
                    put("packId", "asset-a"); put("kind", "qari_audio"); put("latestVersion", "1.0.0")
                    put("manifestUrl", JSONObject().put("android", manifestAUrl))
                },
                JSONObject().apply {
                    put("packId", "asset-b"); put("kind", "translation_pack"); put("latestVersion", "1.0.0")
                    put("manifestUrl", JSONObject().put("android", manifestBUrl))
                },
            ),
        )
        transport.jsonResponses[manifestAUrl] = JSONObject().apply {
            put("files", jsonArrayOf("a.mp3"))
            put("artifactBaseUrl", artifactBaseA)
        }.toString()
        transport.jsonResponses[manifestBUrl] = JSONObject().apply {
            put("files", jsonArrayOf("b.json"))
            put("artifactBaseUrl", artifactBaseB)
        }.toString()
        transport.fileBytes[artifactBaseA + "a.mp3"] = byteArrayOf(1, 2, 3)
        transport.fileBytes[artifactBaseB + "b.json"] = byteArrayOf(4, 5, 6, 7)

        val manager = AIAssetManager(AssetManifestFetcher(transport), AssetDownloadManager(transport))
        manager.register(pluginA)
        manager.register(pluginB)
        manager.catalogUrl = catalogUrl

        manager.ensureAsset("asset-a")
        manager.ensureAsset("asset-b")

        assertArrayEquals(byteArrayOf(1, 2, 3), pluginA.installedFiles["a.mp3"])
        assertArrayEquals(byteArrayOf(4, 5, 6, 7), pluginB.installedFiles["b.json"])
        assertEquals(1, pluginA.installCallCount)
        assertEquals(1, pluginB.installCallCount)

        // Re-running ensureAsset for the already-installed, still-fresh asset
        // must not touch the network again.
        transport.rangeCallLog.clear()
        manager.ensureAsset("asset-a")
        assertTrue(transport.rangeCallLog.isEmpty())
        assertEquals("Fresh + already-available asset must not reinstall", 1, pluginA.installCallCount)
    }

    @Test
    fun ensureAsset_performsFirstInstallWhenNotYetAvailable() {
        val catalogUrl = "https://cdn.test/catalog.json"
        val plugin = FakePlugin("asset-c", "tafsir_pack")

        val manifestUrl = "https://cdn.test/asset-c/1.0.0/manifest.json"
        val artifactBase = "https://cdn.test/asset-c/1.0.0/"

        val transport = FakeAssetTransport()
        transport.jsonResponses[catalogUrl] = catalogJson(
            listOf(
                JSONObject().apply {
                    put("packId", "asset-c"); put("kind", "tafsir_pack"); put("latestVersion", "2.0.0")
                    put("manifestUrl", JSONObject().put("android", manifestUrl))
                },
            ),
        )
        transport.jsonResponses[manifestUrl] = JSONObject().apply {
            put("files", jsonArrayOf("c.json"))
            put("artifactBaseUrl", artifactBase)
        }.toString()
        transport.fileBytes[artifactBase + "c.json"] = byteArrayOf(9, 9)

        val manager = AIAssetManager(AssetManifestFetcher(transport), AssetDownloadManager(transport))
        manager.register(plugin)
        manager.catalogUrl = catalogUrl

        assertFalse(plugin.isAvailable())
        manager.ensureAsset("asset-c")
        assertTrue(plugin.isAvailable())
        assertArrayEquals(byteArrayOf(9, 9), plugin.installedFiles["c.json"])
    }
}
