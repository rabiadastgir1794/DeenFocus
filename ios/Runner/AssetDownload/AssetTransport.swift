import Foundation

/// Result of one ranged fetch performed by an `AssetTransport`.
struct AssetTransportChunk {
  /// Total size of the remote resource if known (from `Content-Length`/`Content-Range`).
  let totalSize: Int64?
  /// True when this response is known to cover the resource through EOF.
  let isComplete: Bool
  /// Number of bytes written to `destination` by this call.
  let bytesWritten: Int64
}

/// Abstracts the actual network transport so `AssetDownloadManager`/`AssetManifestFetcher`
/// are unit-testable without real network access, and so this framework stays reusable
/// for future consumers that might need a different transport (e.g. signed URLs).
protocol AssetTransport {
  /// Fetches bytes for `url` starting at byte offset `rangeStart`, appending them to
  /// the file at `destination` (creating it if needed; truncating first only if the
  /// server ignores the requested range and returns the full body from byte 0).
  func fetchAppending(url: URL, rangeStart: Int64, destination: URL) throws -> AssetTransportChunk

  /// Fetches a small JSON document in full (used for `catalog.json` / `model_manifest.json`).
  func fetchJSON(url: URL, timeout: TimeInterval) throws -> Data
}

/// Production transport: HTTP Range requests over `URLSession`. Presents a
/// synchronous API (via a semaphore) because every call site in this framework
/// already dispatches onto its own background queue — see `AssetDownloadManager`
/// and `TajweedAssetSync` — never the main thread.
///
/// Completions run on a `userInitiated` queue so a caller at that QoS is not
/// waiting on `URLSession.shared`'s default/utility threads (priority inversion).
final class URLSessionAssetTransport: AssetTransport {
  private let session: URLSession

  init(session: URLSession? = nil) {
    if let session {
      self.session = session
    } else {
      let queue = OperationQueue()
      queue.name = "com.rnr.deenfocus.assetdownload.urlsession"
      queue.qualityOfService = .userInitiated
      queue.maxConcurrentOperationCount = 4
      self.session = URLSession(configuration: .default, delegate: nil, delegateQueue: queue)
    }
  }

  func fetchJSON(url: URL, timeout: TimeInterval) throws -> Data {
    // Local file catalogs (DEBUG CoreML Official/DIY override) are not HTTP —
    // read them directly. Remote HTTPS catalogs keep the status-code check.
    if url.isFileURL {
      do {
        return try Data(contentsOf: url)
      } catch {
        throw AssetDownloadError.network(
          "Failed to read local catalog at \(url.path): \(error.localizedDescription)"
        )
      }
    }
    var request = URLRequest(url: url)
    request.timeoutInterval = timeout
    request.cachePolicy = .reloadIgnoringLocalCacheData
    let (data, response) = try syncDataTask(request)
    guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
      let code = (response as? HTTPURLResponse)?.statusCode ?? -1
      throw AssetDownloadError.badStatusCode(code)
    }
    return data
  }

  /// Bounded per-request chunk size. Artifacts can be several hundred MB (the
  /// DIY iOS CoreML encoder is ~590MB — see `memory/features/tajweed/`) — an
  /// open-ended `bytes=N-` Range request lets the server return the *entire*
  /// remaining object in one HTTP response, which can easily exceed
  /// `timeoutInterval` on a slow connection even though the transfer itself
  /// is still healthy. Requesting fixed-size chunks instead means each
  /// individual request comfortably fits the timeout regardless of total
  /// artifact size — `AssetDownloadManager`'s existing `while !isComplete`
  /// resume loop already handles multi-chunk transfers correctly; this was
  /// simply never exercised before because every response used to arrive as
  /// a single chunk.
  private static let chunkSizeBytes: Int64 = 8 * 1024 * 1024

  func fetchAppending(url: URL, rangeStart: Int64, destination: URL) throws -> AssetTransportChunk {
    var request = URLRequest(url: url)
    request.timeoutInterval = 30
    let rangeEnd = rangeStart + Self.chunkSizeBytes - 1
    request.setValue("bytes=\(rangeStart)-\(rangeEnd)", forHTTPHeaderField: "Range")
    let (data, response) = try syncDataTask(request)
    guard let http = response as? HTTPURLResponse else {
      throw AssetDownloadError.network("No HTTP response.")
    }
    guard (200..<300).contains(http.statusCode) else {
      throw AssetDownloadError.badStatusCode(http.statusCode)
    }

    let fm = FileManager.default
    if http.statusCode == 200, rangeStart > 0 {
      // Server ignored our Range header; response is the full file from byte 0.
      try? fm.removeItem(at: destination)
    }
    if !fm.fileExists(atPath: destination.path) {
      fm.createFile(atPath: destination.path, contents: nil)
    }
    let handle = try FileHandle(forWritingTo: destination)
    defer { try? handle.close() }
    handle.seekToEndOfFile()
    handle.write(data)

    let totalSize: Int64? = {
      if let contentRange = http.value(forHTTPHeaderField: "Content-Range"),
        let slashIdx = contentRange.lastIndex(of: "/")
      {
        return Int64(contentRange[contentRange.index(after: slashIdx)...])
      }
      if http.expectedContentLength > 0 {
        return http.expectedContentLength + (http.statusCode == 206 ? rangeStart : 0)
      }
      return nil
    }()

    let newSize = (try? fm.attributesOfItem(atPath: destination.path)[.size] as? Int64) ?? nil
    let isComplete: Bool
    if let totalSize, let newSize {
      isComplete = newSize >= totalSize
    } else {
      // No length info from the server: a single successful fetch is treated as
      // complete (matches static object storage, which always returns the full
      // remaining body per request rather than arbitrary partial chunks).
      isComplete = true
    }
    return AssetTransportChunk(totalSize: totalSize, isComplete: isComplete, bytesWritten: Int64(data.count))
  }

  private func syncDataTask(_ request: URLRequest) throws -> (Data, URLResponse) {
    let semaphore = DispatchSemaphore(value: 0)
    var result: Result<(Data, URLResponse), Error> = .failure(AssetDownloadError.timeout)
    let task = session.dataTask(with: request) { data, response, error in
      if let error {
        result = .failure(AssetDownloadError.network(error.localizedDescription))
      } else if let data, let response {
        result = .success((data, response))
      } else {
        result = .failure(AssetDownloadError.network("Empty response."))
      }
      semaphore.signal()
    }
    task.resume()
    let waitResult = semaphore.wait(timeout: .now() + request.timeoutInterval + 5)
    if waitResult == .timedOut {
      task.cancel()
      throw AssetDownloadError.timeout
    }
    return try result.get()
  }
}
