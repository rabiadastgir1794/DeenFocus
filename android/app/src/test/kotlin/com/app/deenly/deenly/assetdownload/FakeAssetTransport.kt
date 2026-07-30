package com.rnr.deenfocus.assetdownload

import java.io.File
import java.io.RandomAccessFile

/**
 * Deterministic, network-free [AssetTransport] double for unit tests. Lets tests
 * simulate: normal success, a one-time mid-transfer failure (to exercise retry +
 * resume), and missing/erroring JSON endpoints (catalog/manifest unavailable).
 */
class FakeAssetTransport : AssetTransport {
    val jsonResponses = mutableMapOf<String, String>()
    val jsonErrors = mutableMapOf<String, Exception>()
    val fileBytes = mutableMapOf<String, ByteArray>()

    /** If set for a URL, the first `fetchAppending` call writes up to this many bytes then throws. */
    val failFirstNBytesFor = mutableMapOf<String, Int>()
    private val failedOnce = mutableSetOf<String>()

    /** Records every (url, rangeStart) pair passed to `fetchAppending`, in order. */
    val rangeCallLog = mutableListOf<Pair<String, Long>>()

    override fun fetchJson(url: String, timeoutMs: Int): String {
        jsonErrors[url]?.let { throw it }
        return jsonResponses[url] ?: throw AssetDownloadException.BadStatusCode(404)
    }

    override fun fetchAppending(url: String, rangeStart: Long, destinationPath: File): AssetTransportChunk {
        rangeCallLog.add(url to rangeStart)
        val full = fileBytes[url] ?: throw AssetDownloadException.BadStatusCode(404)

        val cutoff = failFirstNBytesFor[url]
        if (cutoff != null && !failedOnce.contains(url)) {
            failedOnce.add(url)
            val partial = full.copyOfRange(rangeStart.toInt(), minOf(cutoff, full.size))
            appendBytes(partial, destinationPath)
            throw AssetDownloadException.Network("simulated interruption")
        }

        val remaining = full.copyOfRange(rangeStart.toInt(), full.size)
        appendBytes(remaining, destinationPath)
        return AssetTransportChunk(
            totalSize = full.size.toLong(),
            isComplete = true,
            bytesWritten = remaining.size.toLong(),
        )
    }

    private fun appendBytes(bytes: ByteArray, destination: File) {
        RandomAccessFile(destination, "rw").use { raf ->
            raf.seek(raf.length())
            raf.write(bytes)
        }
    }
}
