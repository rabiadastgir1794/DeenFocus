package com.rnr.deenfocus.assetdownload

import android.util.Log
import java.io.RandomAccessFile
import java.net.HttpURLConnection
import java.net.URL

private const val TAG = "AssetTransport"

/**
 * Max bytes read per HTTP round-trip in [HttpUrlConnectionAssetTransport.fetchAppending].
 * Bounds peak memory to a small, fixed multiple of this value (via the streaming copy
 * loop's own 64KB buffer) regardless of how large the remote asset is — critical for
 * ~450MB+ model packs on memory-constrained devices/emulators. Also gives
 * [AssetDownloadManager]'s outer loop a natural, frequent resume point if the process
 * dies mid-file, and smoother progress reporting than one giant single-shot read.
 */
private const val DOWNLOAD_CHUNK_BYTES = 8L * 1024 * 1024

/** Result of one ranged fetch performed by an [AssetTransport]. */
data class AssetTransportChunk(
    /** Total size of the remote resource if known (from Content-Length/Content-Range). */
    val totalSize: Long?,
    /** True when this response is known to cover the resource through EOF. */
    val isComplete: Boolean,
    /** Number of bytes written to `destinationPath` by this call. */
    val bytesWritten: Long,
)

/**
 * Abstracts the actual network transport so [AssetDownloadManager]/[AssetManifestFetcher]
 * are unit-testable without real network access, and so this framework stays reusable
 * for future consumers that might need a different transport (e.g. signed URLs).
 */
interface AssetTransport {
    /**
     * Fetches bytes for [url] starting at byte offset [rangeStart], appending them to
     * the file at [destinationPath] (creating it if needed; truncating first only if
     * the server ignores the requested range and returns the full body from byte 0).
     */
    fun fetchAppending(url: String, rangeStart: Long, destinationPath: java.io.File): AssetTransportChunk

    /** Fetches a small JSON document in full (used for catalog.json / model_manifest.json). */
    fun fetchJson(url: String, timeoutMs: Int): String
}

/**
 * Production transport: HTTP Range requests over [HttpURLConnection] (no new
 * dependency — no OkHttp/Retrofit needed, consistent with this codebase's
 * dependency-light convention, e.g. TD-008's hand-rolled FFT). Synchronous by
 * design; callers (`AssetDownloadManager`) always run this off the main thread.
 */
class HttpUrlConnectionAssetTransport : AssetTransport {

    override fun fetchJson(url: String, timeoutMs: Int): String {
        val connection = URL(url).openConnection() as HttpURLConnection
        connection.connectTimeout = timeoutMs
        connection.readTimeout = timeoutMs
        connection.requestMethod = "GET"
        connection.setRequestProperty("Cache-Control", "no-cache")
        try {
            val code = connection.responseCode
            Log.d(TAG, "[http] GET $url -> $code")
            if (code !in 200..299) {
                throw AssetDownloadException.BadStatusCode(code)
            }
            return connection.inputStream.use { it.readBytes() }.toString(Charsets.UTF_8)
        } catch (e: java.io.IOException) {
            Log.w(TAG, "[http] GET $url failed: ${e.message}")
            throw AssetDownloadException.Network(e.message ?: "network error")
        } finally {
            connection.disconnect()
        }
    }

    override fun fetchAppending(url: String, rangeStart: Long, destinationPath: java.io.File): AssetTransportChunk {
        val connection = URL(url).openConnection() as HttpURLConnection
        connection.connectTimeout = 30_000
        connection.readTimeout = 30_000
        connection.requestMethod = "GET"
        if (rangeStart > 0) {
            connection.setRequestProperty("Range", "bytes=$rangeStart-")
        }
        try {
            val code = connection.responseCode
            Log.d(TAG, "[http] GET $url (Range: bytes=$rangeStart-) -> $code")
            if (code !in 200..299) {
                throw AssetDownloadException.BadStatusCode(code)
            }
            // Server ignored our Range header; response is the full file from byte 0.
            if (code == 200 && rangeStart > 0) {
                Log.w(TAG, "[http] Server ignored Range header for $url — restarting $destinationPath from byte 0.")
                destinationPath.delete()
            }

            val contentRange = connection.getHeaderField("Content-Range")
            val totalSize: Long? = when {
                contentRange != null && contentRange.contains("/") ->
                    contentRange.substringAfterLast("/").toLongOrNull()
                connection.contentLengthLong > 0 ->
                    connection.contentLengthLong + (if (code == 206) rangeStart else 0)
                else -> null
            }

            // Parent must exist before RandomAccessFile — otherwise Android throws
            // ENOENT ("…onnx.part: open failed: ENOENT") which surfaces as a
            // confusing network error instead of a disk/setup failure.
            ensureParentDir(destinationPath)

            // Stream at most DOWNLOAD_CHUNK_BYTES to disk via a small fixed buffer —
            // never buffer the whole (potentially 450MB+) response body in memory.
            // If more than one chunk remains, isComplete=false and the caller
            // (AssetDownloadManager.downloadOne) issues a fresh Range request
            // continuing from the new offset.
            var written = 0L
            var reachedEof = false
            try {
                RandomAccessFile(destinationPath, "rw").use { raf ->
                    raf.seek(raf.length())
                    connection.inputStream.use { input ->
                        val buffer = ByteArray(64 * 1024)
                        while (written < DOWNLOAD_CHUNK_BYTES) {
                            val toRead = minOf(buffer.size.toLong(), DOWNLOAD_CHUNK_BYTES - written).toInt()
                            val n = input.read(buffer, 0, toRead)
                            if (n <= 0) {
                                reachedEof = true
                                break
                            }
                            raf.write(buffer, 0, n)
                            written += n
                        }
                    }
                }
            } catch (e: java.io.IOException) {
                throw mapIoException(e, destinationPath)
            }

            val newSize = destinationPath.length()
            val isComplete = if (totalSize != null) newSize >= totalSize else reachedEof
            return AssetTransportChunk(totalSize = totalSize, isComplete = isComplete, bytesWritten = written)
        } catch (e: AssetDownloadException) {
            throw e
        } catch (e: java.io.IOException) {
            Log.w(TAG, "[http] GET $url (Range: bytes=$rangeStart-) failed: ${e.message}")
            throw mapIoException(e, destinationPath)
        } finally {
            connection.disconnect()
        }
    }

    private fun ensureParentDir(file: java.io.File) {
        val parent = file.parentFile ?: return
        if (parent.exists()) return
        if (!parent.mkdirs() && !parent.exists()) {
            val available = parent.parentFile?.usableSpace ?: 0L
            throw AssetDownloadException.DiskError(
                "Could not create download directory ${parent.absolutePath} " +
                    "(available=${available} bytes). Free space and retry.",
            )
        }
    }

    private fun mapIoException(e: java.io.IOException, destinationPath: java.io.File): AssetDownloadException {
        val msg = e.message ?: "I/O error"
        Log.w(TAG, "[http] write to ${destinationPath.absolutePath} failed: $msg")
        return when {
            msg.contains("ENOSPC", ignoreCase = true) ||
                msg.contains("No space left", ignoreCase = true) -> {
                val available = destinationPath.parentFile?.usableSpace ?: 0L
                AssetDownloadException.InsufficientStorage(
                    requiredBytes = destinationPath.length().coerceAtLeast(1L),
                    availableBytes = available,
                )
            }
            msg.contains("ENOENT", ignoreCase = true) ->
                AssetDownloadException.DiskError(msg)
            else -> AssetDownloadException.Network(msg)
        }
    }
}
