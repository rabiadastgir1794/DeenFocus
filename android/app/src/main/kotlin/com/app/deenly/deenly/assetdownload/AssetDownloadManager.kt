package com.rnr.deenfocus.assetdownload

import android.util.Log
import java.io.File
import java.util.concurrent.Executors

private const val TAG = "AssetDownloadManager"

/**
 * Downloads a set of files into a staging directory: resumable (via HTTP Range +
 * on-disk `.part` files), retried with backoff, cancellable, off-main-thread, and
 * storage-checked before starting. Generic — has no knowledge of Tajweed, ONNX,
 * or any specific manifest shape; consumers hand it plain (url, relativePath)
 * pairs (ADR-008 "Native Asset Downloader" framework).
 */
class AssetDownloadManager(
    private val transport: AssetTransport = HttpUrlConnectionAssetTransport(),
    private val maxRetries: Int = 3,
    /** Injectable for tests; defaults to the real volume free-space check. */
    private val freeSpaceProvider: (File) -> Long? = { dir -> dir.usableSpace.takeIf { it > 0 } },
) {
    data class FileSpec(
        val url: String,
        val relativePath: String,
        val expectedSizeBytes: Long? = null,
    )

  // Single-thread executor: this framework's own guarantee that network + disk
  // I/O never runs on the caller's thread (including the main thread), regardless
  // of what thread `downloadFiles` is invoked from.
  private val workExecutor = Executors.newSingleThreadExecutor { r -> Thread(r, "asset-download-manager") }

  /**
   * Downloads every file in [specs] into [stagingDir], resuming any partially
   * written `.part` file left over from a previous interrupted attempt (including
   * across app relaunches, as long as the caller reuses the same [stagingDir] for
   * the same pack version). Safe to call from any thread, including the main
   * thread — the actual work always runs on an internal background thread.
   */
  fun downloadFiles(
    specs: List<FileSpec>,
    stagingDir: File,
    isCancelled: () -> Boolean = { false },
    progress: ((Double) -> Unit)? = null,
  ) {
    // Prefer an existing ancestor for usableSpace — a non-existent staging
    // parent can make File.usableSpace return 0 (ENOENT), which would either
    // skip the check or falsely trip InsufficientStorage before mkdirs.
    val spaceProbe = stagingDir.parentFile?.takeIf { it.exists() }
      ?: stagingDir.parentFile?.parentFile?.takeIf { it.exists() }
      ?: stagingDir
    // Require pack size + headroom so activation/metadata writes don't hit
    // ENOSPC immediately after a "successful" download on tight emulators.
    val required = specs.mapNotNull { it.expectedSizeBytes }.sum()
    val headroomBytes = 64L * 1024 * 1024
    if (required > 0) {
      val available = freeSpaceProvider(spaceProbe)
      if (available != null && available < required + headroomBytes) {
        throw AssetDownloadException.InsufficientStorage(required + headroomBytes, available)
      }
    }

    val future = workExecutor.submit {
      downloadFilesSync(specs, stagingDir, isCancelled, progress)
    }
    try {
      future.get()
    } catch (e: java.util.concurrent.ExecutionException) {
      throw e.cause ?: e
    }
  }

    private fun downloadFilesSync(
        specs: List<FileSpec>,
        stagingDir: File,
        isCancelled: () -> Boolean,
        progress: ((Double) -> Unit)?,
    ) {
        if (!stagingDir.mkdirs() && !stagingDir.exists()) {
            throw AssetDownloadException.DiskError(
                "Could not create staging directory ${stagingDir.absolutePath}",
            )
        }
        val total = maxOf(specs.size, 1).toDouble()
        Log.i(TAG, "[download] Starting download of ${specs.size} file(s) into ${stagingDir.absolutePath}")
        specs.forEachIndexed { index, spec ->
            if (isCancelled()) throw AssetDownloadException.Cancelled
            val finalFile = File(stagingDir, spec.relativePath)
            val parent = finalFile.parentFile
            if (parent != null && !parent.mkdirs() && !parent.exists()) {
                throw AssetDownloadException.DiskError(
                    "Could not create directory ${parent.absolutePath}",
                )
            }
            val partFile = File(finalFile.parentFile, "${finalFile.name}.part")
            Log.i(TAG, "[download] (${index + 1}/${specs.size}) ${spec.relativePath} <- ${spec.url}" +
                (spec.expectedSizeBytes?.let { " (expected ~$it bytes)" } ?: ""))
            downloadOne(spec, partFile, isCancelled) { fileFraction ->
                progress?.invoke((index + fileFraction) / total)
            }
            Log.i(TAG, "[download] (${index + 1}/${specs.size}) ${spec.relativePath} — download complete " +
                "(${partFile.length()} bytes).")
            // Only rename `.part` -> the manifest-expected final name once fully
            // downloaded, so a half-written file can never be mistaken for a
            // complete artifact by a later verify/install pass.
            finalFile.delete()
            if (!partFile.renameTo(finalFile)) {
                partFile.copyTo(finalFile, overwrite = true)
                partFile.delete()
            }
        }
        Log.i(TAG, "[download] All ${specs.size} file(s) downloaded successfully into ${stagingDir.absolutePath}")
        progress?.invoke(1.0)
    }

    private fun downloadOne(
        spec: FileSpec,
        partFile: File,
        isCancelled: () -> Boolean,
        progress: ((Double) -> Unit)?,
    ) {
        var attempt = 0
        var lastError: Exception? = null
        while (attempt < maxRetries) {
            if (isCancelled()) throw AssetDownloadException.Cancelled
            try {
                // Re-create parent on every attempt — ENOSPC / prior cleanup can
                // remove the staging dir between retries (seen as ENOENT on .part).
                partFile.parentFile?.let { parent ->
                    if (!parent.mkdirs() && !parent.exists()) {
                        throw AssetDownloadException.DiskError(
                            "Could not create directory ${parent.absolutePath}",
                        )
                    }
                }
                var offset = if (partFile.exists()) partFile.length() else 0L
                if (offset > 0) {
                    Log.i(TAG, "[resume] ${spec.relativePath}: found existing .part file at $offset bytes — " +
                        "resuming via HTTP Range instead of restarting from 0.")
                } else {
                    Log.d(TAG, "[download] ${spec.relativePath}: starting fresh download from byte 0.")
                }
                var isComplete = false
                while (!isComplete) {
                    if (isCancelled()) throw AssetDownloadException.Cancelled
                    val chunk = transport.fetchAppending(spec.url, offset, partFile)
                    offset += chunk.bytesWritten
                    isComplete = chunk.isComplete
                    val totalSize = chunk.totalSize
                    if (totalSize != null && totalSize > 0) {
                        progress?.invoke(offset.toDouble() / totalSize.toDouble())
                        Log.d(TAG, "[download] ${spec.relativePath}: $offset / $totalSize bytes " +
                            "(${"%.1f".format(100.0 * offset / totalSize)}%)")
                    }
                }
                return
            } catch (e: AssetDownloadException.Cancelled) {
                throw e
            } catch (e: AssetDownloadException.InsufficientStorage) {
                // Don't burn retries on a full disk — surface immediately.
                throw e
            } catch (e: Exception) {
                lastError = e
                attempt += 1
                if (attempt < maxRetries) {
                    val delayMs = backoffMillis(attempt)
                    Log.w(TAG, "[retry] ${spec.relativePath}: attempt $attempt/$maxRetries failed " +
                        "(${e.message}) — retrying in ${delayMs}ms.")
                    Thread.sleep(delayMs)
                } else {
                    Log.e(TAG, "[retry] ${spec.relativePath}: exhausted $maxRetries attempts, giving up. " +
                        "Last error: ${e.message}")
                }
            }
        }
        throw lastError ?: AssetDownloadException.Network("Unknown download failure.")
    }

    private fun backoffMillis(attempt: Int): Long {
        // Capped exponential backoff, scaled small so retries stay fast in tests/CI
        // while still spacing out real network retries meaningfully in production.
        val seconds = minOf(Math.pow(2.0, attempt.toDouble()), 8.0) * 0.05
        return (seconds * 1000).toLong()
    }
}
