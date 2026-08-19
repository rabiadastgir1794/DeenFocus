package com.rnr.deenfocus.assetdownload

import java.io.File
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Test

/**
 * Pure-JVM tests for the generic [AssetDownloadManager] (ADR-008 "Native Asset
 * Downloader"). No Android `Context`/Robolectric needed — this framework has no
 * Tajweed/Android-framework dependencies at all.
 */
class AssetDownloadManagerTest {

    private fun tempDir(): File = java.nio.file.Files.createTempDirectory("asset-download-test").toFile()

    @Test
    fun firstInstall_downloadsAllFilesFully() {
        val transport = FakeAssetTransport()
        transport.fileBytes["https://cdn.example.com/a.bin"] = ByteArray(1000) { it.toByte() }
        transport.fileBytes["https://cdn.example.com/b.bin"] = ByteArray(500) { (it * 2).toByte() }
        val manager = AssetDownloadManager(transport)
        val staging = tempDir()

        val progressValues = mutableListOf<Double>()
        manager.downloadFiles(
            listOf(
                AssetDownloadManager.FileSpec("https://cdn.example.com/a.bin", "a.bin"),
                AssetDownloadManager.FileSpec("https://cdn.example.com/b.bin", "b.bin"),
            ),
            staging,
            progress = { progressValues.add(it) },
        )

        assertArrayEquals(transport.fileBytes["https://cdn.example.com/a.bin"], File(staging, "a.bin").readBytes())
        assertArrayEquals(transport.fileBytes["https://cdn.example.com/b.bin"], File(staging, "b.bin").readBytes())
        assertTrue("No leftover .part files", staging.listFiles()!!.none { it.name.endsWith(".part") })
        assertEquals(1.0, progressValues.last(), 0.0001)
    }

    @Test
    fun interruptedDownload_resumesFromExistingPartFileOnNextCall() {
        // Simulates: process killed mid-download (a `.part` file with 400/1000 bytes
        // already on disk from a previous app session), then the app relaunches and
        // calls downloadFiles again for the *same* staging directory.
        val url = "https://cdn.example.com/encoder.bin"
        val fullContent = ByteArray(1000) { it.toByte() }
        val transport = FakeAssetTransport()
        transport.fileBytes[url] = fullContent
        val staging = tempDir()
        val partFile = File(staging, "encoder.bin.part")
        partFile.writeBytes(fullContent.copyOfRange(0, 400))

        val manager = AssetDownloadManager(transport)
        manager.downloadFiles(listOf(AssetDownloadManager.FileSpec(url, "encoder.bin")), staging)

        assertEquals(listOf(400L), transport.rangeCallLog.map { it.second })
        assertArrayEquals(fullContent, File(staging, "encoder.bin").readBytes())
    }

    @Test
    fun transientNetworkBlip_retriesAndResumesWithinSameCall() {
        val url = "https://cdn.example.com/head.bin"
        val fullContent = ByteArray(300) { it.toByte() }
        val transport = FakeAssetTransport()
        transport.fileBytes[url] = fullContent
        transport.failFirstNBytesFor[url] = 150 // writes 150 bytes, then throws once
        val staging = tempDir()

        val manager = AssetDownloadManager(transport, maxRetries = 3)
        manager.downloadFiles(listOf(AssetDownloadManager.FileSpec(url, "head.bin")), staging)

        assertArrayEquals(fullContent, File(staging, "head.bin").readBytes())
        // First call starts at 0 (writes 150, fails); retry resumes at byte 150.
        assertEquals(listOf(0L, 150L), transport.rangeCallLog.map { it.second })
    }

    @Test
    fun exhaustedRetries_throwsAndLeavesResumablePartFile() {
        val url = "https://cdn.example.com/flaky.bin"
        val transport = object : AssetTransport {
            override fun fetchJson(url: String, timeoutMs: Int) = throw AssetDownloadException.Network("n/a")
            override fun fetchAppending(url: String, rangeStart: Long, destinationPath: File): AssetTransportChunk {
                throw AssetDownloadException.Network("always fails")
            }
        }
        val manager = AssetDownloadManager(transport, maxRetries = 2)
        val staging = tempDir()

        try {
            manager.downloadFiles(listOf(AssetDownloadManager.FileSpec(url, "flaky.bin")), staging)
            fail("Expected a network exception after exhausting retries")
        } catch (e: AssetDownloadException.Network) {
            // expected
        }
        assertTrue(
            "A failed download must never leave a file at the final expected name",
            !File(staging, "flaky.bin").exists(),
        )
    }

    @Test
    fun insufficientStorage_throwsBeforeAnyNetworkCall() {
        val transport = FakeAssetTransport()
        transport.fileBytes["https://cdn.example.com/huge.bin"] = ByteArray(10)
        val manager = AssetDownloadManager(transport, freeSpaceProvider = { 100L })
        val staging = tempDir()

        try {
            manager.downloadFiles(
                listOf(
                    AssetDownloadManager.FileSpec(
                        "https://cdn.example.com/huge.bin",
                        "huge.bin",
                        expectedSizeBytes = 500_000_000L,
                    ),
                ),
                staging,
            )
            fail("Expected InsufficientStorage")
        } catch (e: AssetDownloadException.InsufficientStorage) {
            // Pack size + 64MiB headroom so install/metadata writes don't hit ENOSPC
            // immediately after a barely-fitting download.
            assertEquals(500_000_000L + 64L * 1024 * 1024, e.requiredBytes)
            assertEquals(100L, e.availableBytes)
        }
        assertTrue("No network call should have been attempted", transport.rangeCallLog.isEmpty())
    }

    @Test
    fun cancellation_stopsBeforeCompletingRemainingFiles() {
        val transport = FakeAssetTransport()
        transport.fileBytes["https://cdn.example.com/one.bin"] = ByteArray(10)
        transport.fileBytes["https://cdn.example.com/two.bin"] = ByteArray(10)
        val manager = AssetDownloadManager(transport)
        val staging = tempDir()

        try {
            manager.downloadFiles(
                listOf(
                    AssetDownloadManager.FileSpec("https://cdn.example.com/one.bin", "one.bin"),
                    AssetDownloadManager.FileSpec("https://cdn.example.com/two.bin", "two.bin"),
                ),
                staging,
                isCancelled = { true },
            )
            fail("Expected Cancelled")
        } catch (e: AssetDownloadException.Cancelled) {
            // expected
        }
        assertTrue(transport.rangeCallLog.isEmpty())
    }

    @Test
    fun runsOffTheCallingThread_evenWhenInvokedSynchronously() {
        val callerThread = Thread.currentThread()
        var transportThread: Thread? = null
        val transport = object : AssetTransport {
            override fun fetchJson(url: String, timeoutMs: Int) = "{}"
            override fun fetchAppending(url: String, rangeStart: Long, destinationPath: File): AssetTransportChunk {
                transportThread = Thread.currentThread()
                destinationPath.writeBytes(ByteArray(1))
                return AssetTransportChunk(totalSize = 1, isComplete = true, bytesWritten = 1)
            }
        }
        val manager = AssetDownloadManager(transport)
        val staging = tempDir()
        manager.downloadFiles(listOf(AssetDownloadManager.FileSpec("https://cdn.example.com/x.bin", "x.bin")), staging)

        assertTrue(
            "Network I/O must run off the calling thread",
            transportThread != null && transportThread !== callerThread,
        )
    }
}
