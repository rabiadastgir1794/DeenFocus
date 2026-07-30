package com.rnr.deenfocus.tajweed

import android.os.Looper
import androidx.test.core.app.ApplicationProvider
import com.rnr.deenfocus.assetdownload.AIAssetManager
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config

/**
 * Phase 3 Android validation pass — functional / error-mapping / threading checks that
 * need a real (Robolectric-shadowed) Android Context, mirroring the functional +
 * threading + error-mapping sections of ios/RunnerTests/RunnerTests.swift. No model pack
 * is installed in this sandbox, so these exercise the MODEL_MISSING / NOT_RECORDING paths
 * exactly like the iOS suite does without the gated CoreML/ONNX weights.
 *
 * Pinned to SDK 34: Robolectric 4.14.1 doesn't yet ship shadows for this project's
 * targetSdk (36); the pin only affects the simulated framework version under test, not
 * production minSdk/targetSdk.
 */
@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class TajweedEngineRobolectricTest {
    private var savedProductionCatalogUrl: String? = null

    // engine.ensureModel() ultimately calls the real ModelStore.ensureModel(),
    // which (with no model installed) now reaches out to AIAssetManager.shared
    // using the real production Cloudflare R2 catalog URL. These tests must
    // stay hermetic/offline, so disable that for the duration of each test —
    // no AIAssetManager/ModelStore/TajweedEngine production code is touched.
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

    private fun freshEngine(): TajweedEngine {
        // TajweedEngine is a process-wide singleton in production; Robolectric can reuse
        // the same classloader/statics across test methods, so force a fresh instance
        // per test for isolation.
        TajweedEngine.resetForTesting()
        return TajweedEngine.getInstance(ApplicationProvider.getApplicationContext())
    }

    private fun <T> awaitResult(block: ((Result<T>) -> Unit) -> Unit): Result<T> {
        val latch = CountDownLatch(1)
        var outcome: Result<T>? = null
        block { r ->
            outcome = r
            latch.countDown()
        }
        assertTrue("Completion callback timed out", latch.await(5, TimeUnit.SECONDS))
        // Drain the Robolectric main-thread scheduler so mainHandler.post{} callbacks run.
        shadowOf(Looper.getMainLooper()).idle()
        return outcome!!
    }

    @Test
    fun getRecordingStateStartsIdle() {
        assertEquals("idle", freshEngine().getRecordingState())
    }

    @Test
    fun ensureModelFailsWithModelMissingWhenNoPackInstalled() {
        val engine = freshEngine()
        val result = awaitResult<Unit> { engine.ensureModel(it) }
        assertTrue(result.isFailure)
        assertEquals(TajweedErrorCode.MODEL_MISSING, (result.exceptionOrNull() as TajweedNativeException).code)
    }

    @Test
    fun prepareModelFailsWithModelMissingWhenNoPackInstalled() {
        val engine = freshEngine()
        val result = awaitResult<Unit> { engine.prepareModel(it) }
        assertTrue(result.isFailure)
        assertEquals(TajweedErrorCode.MODEL_MISSING, (result.exceptionOrNull() as TajweedNativeException).code)
    }

    @Test
    fun stopRecordingAndScoreFailsWithNotRecordingWhenIdle() {
        val engine = freshEngine()
        val result = awaitResult<Map<String, Any?>> { engine.stopRecordingAndScore(it) }
        assertTrue(result.isFailure)
        assertEquals(TajweedErrorCode.NOT_RECORDING, (result.exceptionOrNull() as TajweedNativeException).code)
    }

    @Test
    fun cancelRecordingFailsWithNotRecordingWhenIdle() {
        val engine = freshEngine()
        val result = awaitResult<Unit> { engine.cancelRecording(it) }
        assertTrue(result.isFailure)
        assertEquals(TajweedErrorCode.NOT_RECORDING, (result.exceptionOrNull() as TajweedNativeException).code)
    }

    @Test
    fun disposeIsIdempotentAndReturnsToIdle() {
        val engine = freshEngine()
        engine.dispose()
        engine.dispose()
        engine.dispose()
        // dispose() is fire-and-forget on the work executor; give it a moment to land.
        Thread.sleep(200)
        assertEquals("idle", engine.getRecordingState())
        assertFalse(engine.isWarmedUpForTesting)
    }

    @Test
    fun engineCallbacksRunOffTheCallingMainThread() {
        val engine = freshEngine()
        val latch = CountDownLatch(1)
        var ranOnBackgroundThread = false
        engine.ensureModel {
            ranOnBackgroundThread = Looper.myLooper() != Looper.getMainLooper()
            latch.countDown()
        }
        assertTrue(latch.await(5, TimeUnit.SECONDS))
        assertTrue("Engine should complete on its background work executor", ranOnBackgroundThread)
    }

    @Test
    fun repeatedEnsureAndDisposeCyclesRemainStable() {
        val engine = freshEngine()
        repeat(20) {
            val latch = CountDownLatch(1)
            engine.ensureModel {
                engine.dispose()
                latch.countDown()
            }
            assertTrue(latch.await(5, TimeUnit.SECONDS))
        }
        Thread.sleep(200)
        assertEquals("idle", engine.getRecordingState())
    }

    @Test
    fun channelHandlerMapsNativeErrorCodeAndFallsBackSafely() {
        val native = TajweedNativeException(TajweedErrorCode.MIC_PERMISSION_DENIED, "denied")
        assertEquals(TajweedErrorCode.MIC_PERMISSION_DENIED, TajweedChannelHandler.flutterCode(native))
        // Any *other* exception type must never leak a raw Kotlin error code to Flutter.
        assertEquals(TajweedErrorCode.INFERENCE_FAILED, TajweedChannelHandler.flutterCode(IllegalStateException("boom")))
    }

    @Test
    fun modelStoreReportsUnavailableWhenNothingInstalled() {
        val store = ModelStore(ApplicationProvider.getApplicationContext())
        if (store.manifestFile.exists()) {
            fail("Unexpected pre-existing manifest in a fresh Robolectric sandbox.")
        }
        assertFalse(store.isAvailable())
    }
}
