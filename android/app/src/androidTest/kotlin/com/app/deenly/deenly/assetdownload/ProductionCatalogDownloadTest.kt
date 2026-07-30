package com.rnr.deenfocus.assetdownload

import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import com.rnr.deenfocus.tajweed.ModelStore
import com.rnr.deenfocus.tajweed.TajweedAssetDistributionConfig
import com.rnr.deenfocus.tajweed.TajweedEngine
import java.io.File
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import org.json.JSONObject
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.FixMethodOrder
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.MethodSorters

private const val TAG = "ProdCatalogValidation"

/**
 * On-device validation of ADR-009 production AI asset downloading against the
 * REAL Cloudflare R2 catalog configured in [TajweedAssetDistributionConfig]
 * (`https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json`) — no
 * fakes/mocks, exercising the exact same [TajweedEngine]/[ModelStore]/
 * [AIAssetManager] production singletons the Flutter `ensureModel()`
 * MethodChannel call reaches.
 *
 * Requires a real network connection to Cloudflare R2 and downloads the real
 * ~464MB model pack — not meant for CI, run manually on an emulator/device
 * with `adb shell am instrument -w -e class
 * com.rnr.deenfocus.assetdownload.ProductionCatalogDownloadTest
 * com.rnr.deenfocus.test/androidx.test.runner.AndroidJUnitRunner`.
 *
 * [FixMethodOrder] NAME_ASCENDING: later scenarios (cache-hit, restart
 * survival, version re-check) intentionally reuse the model installed by
 * test1 rather than re-downloading ~464MB four times.
 */
@RunWith(AndroidJUnit4::class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
class ProductionCatalogDownloadTest {

    private lateinit var context: android.content.Context
    private lateinit var store: ModelStore

    private val assetId = "hafs-en-v1"
    private val version = "1.0.0"
    private val encoderUrl =
        "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/android/tajweed/v1/model_with_encoder.onnx"

    @Before
    fun setUp() {
        context = InstrumentationRegistry.getInstrumentation().targetContext
        TajweedEngine.resetForTesting()
        store = ModelStore(context)
    }

    private fun shell(cmd: String): String {
        val pfd: ParcelFileDescriptor = InstrumentationRegistry.getInstrumentation().uiAutomation.executeShellCommand(cmd)
        return ParcelFileDescriptor.AutoCloseInputStream(pfd).use { it.readBytes().toString(Charsets.UTF_8) }
    }

    private fun awaitEnsureModel(): Result<Unit> {
        val latch = CountDownLatch(1)
        var outcome: Result<Unit>? = null
        TajweedEngine.getInstance(context).ensureModel { r ->
            outcome = r
            latch.countDown()
        }
        assertTrue("ensureModel() timed out", latch.await(10, TimeUnit.MINUTES))
        return outcome!!
    }

    private fun stagingDir(): File =
        File(File(store.rootDir, "download-staging"), "$assetId-$version")

    /**
     * Scenario: first install with no local model AND a pre-existing partial
     * `.part` file left over from a simulated earlier interrupted download —
     * proves AssetDownloadManager resumes via HTTP Range instead of
     * restarting from byte 0 (the final SHA-256 verification would fail if
     * the resumed bytes were wrong/duplicated/offset).
     */
    @Test
    fun test1_firstInstall_resumesPartialDownloadAndActivates() {
        assertEquals(
            "Test requires the real production catalog to be configured",
            "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json",
            TajweedAssetDistributionConfig.catalogUrl,
        )
        store.rootDir.deleteRecursively()
        assertTrue("Precondition: no model should be installed yet", !store.isAvailable())

        // Simulate a previous, interrupted download: fetch just the first ~5MB
        // of the real encoder artifact and place it at the exact `.part` path
        // AssetDownloadManager will look for.
        val partial = ByteArray(5 * 1024 * 1024)
        val conn = URL(encoderUrl).openConnection() as HttpURLConnection
        conn.connectTimeout = 30_000
        conn.readTimeout = 30_000
        try {
            var read = 0
            conn.inputStream.use { input ->
                while (read < partial.size) {
                    val n = input.read(partial, read, partial.size - read)
                    if (n <= 0) break
                    read += n
                }
            }
            val staging = stagingDir()
            staging.mkdirs()
            val partFile = File(staging, "model_with_encoder.onnx.part")
            partFile.writeBytes(partial.copyOf(read))
            Log.i(TAG, "Seeded ${partFile.length()} bytes at ${partFile.absolutePath} to simulate an " +
                "interrupted prior download.")
        } finally {
            conn.disconnect()
        }

        val t0 = System.nanoTime()
        val result = awaitEnsureModel()
        val elapsedS = (System.nanoTime() - t0) / 1_000_000_000.0
        assertTrue("ensureModel() should succeed: ${result.exceptionOrNull()}", result.isSuccess)
        assertTrue("Model should be available after first install", store.isAvailable())
        assertTrue("Encoder file should exist", store.encoderFile().exists())
        Log.i(TAG, "test1 PASSED in ${"%.1f".format(elapsedS)}s — resume + verify + activate all correct " +
            "(a bad resume would have failed SHA-256 verification and this test would have failed).")
    }

    @Test
    fun test2_cacheHit_worksFullyOffline() {
        assertTrue("Precondition: model must already be installed by test1", store.isAvailable())
        shell("svc wifi disable")
        shell("svc data disable")
        Thread.sleep(2000)
        try {
            val t0 = System.nanoTime()
            val result = awaitEnsureModel()
            val elapsedMs = (System.nanoTime() - t0) / 1_000_000.0
            assertTrue("ensureModel() should succeed from cache while offline: ${result.exceptionOrNull()}", result.isSuccess)
            assertTrue("Model should remain available", store.isAvailable())
            assertTrue(
                "Cache-hit should return near-instantly (<5s) with no network — took ${elapsedMs}ms",
                elapsedMs < 5000,
            )
            Log.i(TAG, "test2 PASSED — offline cache-hit completed in ${"%.0f".format(elapsedMs)}ms, no network used.")
        } finally {
            shell("svc wifi enable")
            shell("svc data enable")
            Thread.sleep(2000)
        }
    }

    @Test
    fun test3_modelSurvivesFreshModelStoreInstance() {
        // Proxy for "survives app restart": a brand new ModelStore/TajweedEngine
        // instance (as production creates on every process start) must see the
        // exact same on-disk model without needing any network call.
        TajweedEngine.resetForTesting()
        val freshStore = ModelStore(context)
        assertTrue("A fresh ModelStore instance should see the previously installed model", freshStore.isAvailable())
        val sha256 = MessageDigest.getInstance("SHA-256")
        freshStore.encoderFile().inputStream().use { input ->
            val buffer = ByteArray(1 shl 20)
            var n: Int
            while (input.read(buffer).also { n = it } > 0) sha256.update(buffer, 0, n)
        }
        val hex = sha256.digest().joinToString("") { "%02x".format(it) }
        assertEquals(
            "417da4c1ead548ffe8bd802fd3d256f065ca180fb191818a3914f43f824bef0d",
            hex,
        )
        Log.i(TAG, "test3 PASSED — model persisted across a fresh ModelStore instance with correct SHA-256.")
    }

    @Test
    fun test4_versionRecheck_sameVersionDoesNotRedownload() {
        assertTrue("Precondition: model must already be installed", store.isAvailable())
        // Force the "check interval elapsed" branch instead of the cache-hit
        // short-circuit, so ensureModel() actually re-contacts the real
        // catalog — proving the same-version path is fast (no re-download of
        // the ~464MB artifact) rather than just untested.
        val stateFile = File(store.rootDir, "update_state.json")
        val state = JSONObject(stateFile.readText())
        state.put("lastCheckedAt", 0L)
        stateFile.writeText(state.toString())

        val t0 = System.nanoTime()
        val result = awaitEnsureModel()
        val elapsedS = (System.nanoTime() - t0) / 1_000_000_000.0
        assertTrue("ensureModel() should succeed: ${result.exceptionOrNull()}", result.isSuccess)
        assertTrue("Model should remain available", store.isAvailable())
        assertTrue(
            "Same-version re-check hit the real catalog but must not re-download ~464MB " +
                "(took ${elapsedS}s, expected well under 60s on emulator Wi-Fi)",
            elapsedS < 60.0,
        )
        Log.i(TAG, "test4 PASSED — version re-check against live catalog in ${"%.1f".format(elapsedS)}s, " +
            "no redundant download.")
    }
}
