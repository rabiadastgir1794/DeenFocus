import Foundation

@testable import Runner

/// Deterministic, network-free `AssetTransport` double for unit tests. Lets tests
/// simulate: normal success, a one-time mid-transfer failure (to exercise retry +
/// resume), and missing/erroring JSON endpoints (catalog/manifest unavailable).
final class FakeAssetTransport: AssetTransport {
  var jsonResponses: [URL: Data] = [:]
  var jsonErrors: [URL: Error] = [:]
  var fileBytes: [URL: Data] = [:]

  /// If set for a URL, the first `fetchAppending` call writes up to this many bytes then throws.
  var failFirstNBytesFor: [URL: Int] = [:]
  private var failedOnce: Set<URL> = []

  /// Records every (url, rangeStart) pair passed to `fetchAppending`, in order.
  var rangeCallLog: [(URL, Int64)] = []

  func fetchJSON(url: URL, timeout: TimeInterval) throws -> Data {
    if let error = jsonErrors[url] { throw error }
    guard let data = jsonResponses[url] else { throw AssetDownloadError.badStatusCode(404) }
    return data
  }

  func fetchAppending(url: URL, rangeStart: Int64, destination: URL) throws -> AssetTransportChunk {
    rangeCallLog.append((url, rangeStart))
    guard let full = fileBytes[url] else { throw AssetDownloadError.badStatusCode(404) }

    if let cutoff = failFirstNBytesFor[url], !failedOnce.contains(url) {
      failedOnce.insert(url)
      let end = min(cutoff, full.count)
      let partial = full.subdata(in: Int(rangeStart)..<end)
      appendBytes(partial, to: destination)
      throw AssetDownloadError.network("simulated interruption")
    }

    let remaining = full.subdata(in: Int(rangeStart)..<full.count)
    appendBytes(remaining, to: destination)
    return AssetTransportChunk(
      totalSize: Int64(full.count),
      isComplete: true,
      bytesWritten: Int64(remaining.count)
    )
  }

  private func appendBytes(_ bytes: Data, to destination: URL) {
    let fm = FileManager.default
    if !fm.fileExists(atPath: destination.path) {
      fm.createFile(atPath: destination.path, contents: nil)
    }
    guard let handle = try? FileHandle(forWritingTo: destination) else { return }
    defer { try? handle.close() }
    handle.seekToEndOfFile()
    handle.write(bytes)
  }
}
