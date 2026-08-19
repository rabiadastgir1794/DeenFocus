import Foundation

/// Downloads a set of files into a staging directory: resumable (via HTTP Range +
/// on-disk `.part` files), retried with backoff, cancellable, off-main-thread, and
/// storage-checked before starting. Generic — has no knowledge of Tajweed, CoreML,
/// or any specific manifest shape; consumers hand it plain `(url, relativePath)`
/// pairs (ADR-008 "Native Asset Downloader" framework).
final class AssetDownloadManager {
  struct FileSpec {
    let url: URL
    let relativePath: String
    let expectedSizeBytes: Int64?

    init(url: URL, relativePath: String, expectedSizeBytes: Int64? = nil) {
      self.url = url
      self.relativePath = relativePath
      self.expectedSizeBytes = expectedSizeBytes
    }
  }

  private let transport: AssetTransport
  private let maxRetries: Int
  /// Injectable for tests; defaults to the real volume free-space check.
  private let freeSpaceProvider: (URL) -> Int64?

  init(
    transport: AssetTransport = URLSessionAssetTransport(),
    maxRetries: Int = 3,
    freeSpaceProvider: ((URL) -> Int64?)? = nil
  ) {
    self.transport = transport
    self.maxRetries = max(1, maxRetries)
    self.freeSpaceProvider = freeSpaceProvider ?? { directory in
      guard
        let values = try? directory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey]),
        let available = values.volumeAvailableCapacityForImportantUsage
      else { return nil }
      return available
    }
  }

  /// Downloads every file in `specs` into `stagingDir`, resuming any partially
  /// written `.part` file left over from a previous interrupted attempt (including
  /// across app relaunches, as long as the caller reuses the same `stagingDir` for
  /// the same pack version). Runs on the calling thread so a higher-QoS waiter
  /// (e.g. translation/tajweed `userInitiated` queues) is not blocked on this
  /// manager's former `.utility` hop — that pattern is a Thread Performance
  /// Checker priority inversion. Callers already hop off main (channel handlers,
  /// `TajweedEngine.workQueue`); do not invoke from the main thread.
  func downloadFiles(
    _ specs: [FileSpec],
    into stagingDir: URL,
    isCancelled: @escaping () -> Bool = { false },
    progress: ((Double) -> Void)? = nil
  ) throws {
    let required = specs.compactMap { $0.expectedSizeBytes }.reduce(0, +)
    if required > 0, let available = freeSpaceProvider(stagingDir.deletingLastPathComponent()), available < required {
      throw AssetDownloadError.insufficientStorage(requiredBytes: required, availableBytes: available)
    }
    try downloadFilesSync(specs, into: stagingDir, isCancelled: isCancelled, progress: progress)
  }

  private func downloadFilesSync(
    _ specs: [FileSpec],
    into stagingDir: URL,
    isCancelled: @escaping () -> Bool,
    progress: ((Double) -> Void)?
  ) throws {
    let fm = FileManager.default
    try fm.createDirectory(at: stagingDir, withIntermediateDirectories: true)
    let total = Double(max(specs.count, 1))
    for (index, spec) in specs.enumerated() {
      if isCancelled() { throw AssetDownloadError.cancelled }
      let finalURL = stagingDir.appendingPathComponent(spec.relativePath)
      try fm.createDirectory(at: finalURL.deletingLastPathComponent(), withIntermediateDirectories: true)
      let partURL = finalURL.appendingPathExtension("part")
      try downloadOne(spec: spec, partURL: partURL, isCancelled: isCancelled) { fileFraction in
        progress?((Double(index) + fileFraction) / total)
      }
      // Only rename `.part` -> the manifest-expected final name once fully
      // downloaded, so a half-written file can never be mistaken for a complete
      // artifact by a later verify/install pass (interrupted downloads never
      // replace or corrupt anything the installer will read).
      try? fm.removeItem(at: finalURL)
      try fm.moveItem(at: partURL, to: finalURL)
    }
    progress?(1.0)
  }

  private func downloadOne(
    spec: FileSpec,
    partURL: URL,
    isCancelled: @escaping () -> Bool,
    progress: ((Double) -> Void)?
  ) throws {
    var attempt = 0
    var lastError: Error?
    while attempt < maxRetries {
      if isCancelled() { throw AssetDownloadError.cancelled }
      let startOffset = currentSize(of: partURL)
      do {
        var offset = startOffset
        var isComplete = false
        while !isComplete {
          if isCancelled() { throw AssetDownloadError.cancelled }
          let chunk = try transport.fetchAppending(url: spec.url, rangeStart: offset, destination: partURL)
          offset += chunk.bytesWritten
          isComplete = chunk.isComplete
          if let totalSize = chunk.totalSize, totalSize > 0 {
            progress?(Double(offset) / Double(totalSize))
          }
        }
        return
      } catch AssetDownloadError.cancelled {
        throw AssetDownloadError.cancelled
      } catch {
        lastError = error
        attempt += 1
        if attempt < maxRetries {
          Thread.sleep(forTimeInterval: backoffSeconds(attempt: attempt))
        }
      }
    }
    throw lastError ?? AssetDownloadError.network("Unknown download failure.")
  }

  private func currentSize(of url: URL) -> Int64 {
    guard let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
      let size = attrs[.size] as? Int64
    else { return 0 }
    return size
  }

  private func backoffSeconds(attempt: Int) -> TimeInterval {
    // Capped exponential backoff; scaled small so retries stay fast in tests/CI
    // while still spacing out real network retries meaningfully in production.
    min(pow(2.0, Double(attempt)), 8.0) * 0.05
  }
}
