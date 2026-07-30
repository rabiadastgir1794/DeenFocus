import XCTest

@testable import Runner

/// Pure tests for the generic `AssetDownloadManager` (ADR-008 "Native Asset
/// Downloader"). No Tajweed/CoreML dependency at all — this framework knows
/// nothing about AI inference.
final class AssetDownloadManagerTests: XCTestCase {

  private func tempDir() -> URL {
    let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    return dir
  }

  func testFirstInstallDownloadsAllFilesFully() throws {
    let transport = FakeAssetTransport()
    let urlA = URL(string: "https://cdn.example.com/a.bin")!
    let urlB = URL(string: "https://cdn.example.com/b.bin")!
    transport.fileBytes[urlA] = Data((0..<1000).map { UInt8($0 % 256) })
    transport.fileBytes[urlB] = Data((0..<500).map { UInt8(($0 * 2) % 256) })
    let manager = AssetDownloadManager(transport: transport)
    let staging = tempDir()

    var progressValues: [Double] = []
    try manager.downloadFiles(
      [
        .init(url: urlA, relativePath: "a.bin"),
        .init(url: urlB, relativePath: "b.bin"),
      ],
      into: staging,
      progress: { progressValues.append($0) }
    )

    XCTAssertEqual(transport.fileBytes[urlA], try Data(contentsOf: staging.appendingPathComponent("a.bin")))
    XCTAssertEqual(transport.fileBytes[urlB], try Data(contentsOf: staging.appendingPathComponent("b.bin")))
    let leftoverParts = try FileManager.default.contentsOfDirectory(atPath: staging.path)
      .filter { $0.hasSuffix(".part") }
    XCTAssertTrue(leftoverParts.isEmpty, "No leftover .part files")
    XCTAssertEqual(progressValues.last, 1.0)
  }

  func testInterruptedDownloadResumesFromExistingPartFileOnNextCall() throws {
    // Simulates: process killed mid-download (a `.part` file with 400/1000 bytes
    // already on disk from a previous app session), then the app relaunches and
    // calls downloadFiles again for the *same* staging directory.
    let url = URL(string: "https://cdn.example.com/encoder.bin")!
    let full = Data((0..<1000).map { UInt8($0 % 256) })
    let transport = FakeAssetTransport()
    transport.fileBytes[url] = full
    let staging = tempDir()
    let partURL = staging.appendingPathComponent("encoder.bin.part")
    try full.subdata(in: 0..<400).write(to: partURL)

    let manager = AssetDownloadManager(transport: transport)
    try manager.downloadFiles([.init(url: url, relativePath: "encoder.bin")], into: staging)

    XCTAssertEqual(transport.rangeCallLog.map { $0.1 }, [400])
    XCTAssertEqual(full, try Data(contentsOf: staging.appendingPathComponent("encoder.bin")))
  }

  func testTransientNetworkBlipRetriesAndResumesWithinSameCall() throws {
    let url = URL(string: "https://cdn.example.com/head.bin")!
    let full = Data((0..<300).map { UInt8($0 % 256) })
    let transport = FakeAssetTransport()
    transport.fileBytes[url] = full
    transport.failFirstNBytesFor[url] = 150

    let manager = AssetDownloadManager(transport: transport, maxRetries: 3)
    let staging = tempDir()
    try manager.downloadFiles([.init(url: url, relativePath: "head.bin")], into: staging)

    XCTAssertEqual(full, try Data(contentsOf: staging.appendingPathComponent("head.bin")))
    XCTAssertEqual(transport.rangeCallLog.map { $0.1 }, [0, 150])
  }

  private struct AlwaysFailingTransport: AssetTransport {
    func fetchJSON(url: URL, timeout: TimeInterval) throws -> Data { throw AssetDownloadError.network("n/a") }
    func fetchAppending(url: URL, rangeStart: Int64, destination: URL) throws -> AssetTransportChunk {
      throw AssetDownloadError.network("always fails")
    }
  }

  func testExhaustedRetriesThrowsAndNeverLeavesAFinalFile() {
    let manager = AssetDownloadManager(transport: AlwaysFailingTransport(), maxRetries: 2)
    let staging = tempDir()
    let url = URL(string: "https://cdn.example.com/flaky.bin")!

    XCTAssertThrowsError(
      try manager.downloadFiles([.init(url: url, relativePath: "flaky.bin")], into: staging)
    ) { error in
      guard case AssetDownloadError.network = error else {
        return XCTFail("Expected .network, got \(error)")
      }
    }
    XCTAssertFalse(FileManager.default.fileExists(atPath: staging.appendingPathComponent("flaky.bin").path))
  }

  func testInsufficientStorageThrowsBeforeAnyNetworkCall() {
    let transport = FakeAssetTransport()
    let url = URL(string: "https://cdn.example.com/huge.bin")!
    transport.fileBytes[url] = Data([0, 1, 2])
    let manager = AssetDownloadManager(transport: transport, freeSpaceProvider: { _ in 100 })
    let staging = tempDir()

    XCTAssertThrowsError(
      try manager.downloadFiles(
        [.init(url: url, relativePath: "huge.bin", expectedSizeBytes: 500_000_000)],
        into: staging
      )
    ) { error in
      guard case AssetDownloadError.insufficientStorage(let required, let available) = error else {
        return XCTFail("Expected .insufficientStorage, got \(error)")
      }
      XCTAssertEqual(required, 500_000_000)
      XCTAssertEqual(available, 100)
    }
    XCTAssertTrue(transport.rangeCallLog.isEmpty, "No network call should have been attempted")
  }

  func testCancellationStopsBeforeCompletingRemainingFiles() {
    let transport = FakeAssetTransport()
    let urlA = URL(string: "https://cdn.example.com/one.bin")!
    let urlB = URL(string: "https://cdn.example.com/two.bin")!
    transport.fileBytes[urlA] = Data([0])
    transport.fileBytes[urlB] = Data([0])
    let manager = AssetDownloadManager(transport: transport)
    let staging = tempDir()

    XCTAssertThrowsError(
      try manager.downloadFiles(
        [.init(url: urlA, relativePath: "one.bin"), .init(url: urlB, relativePath: "two.bin")],
        into: staging,
        isCancelled: { true }
      )
    ) { error in
      guard case AssetDownloadError.cancelled = error else {
        return XCTFail("Expected .cancelled, got \(error)")
      }
    }
    XCTAssertTrue(transport.rangeCallLog.isEmpty)
  }

  func testRunsOffTheMainThreadEvenWhenInvokedFromIt() throws {
    XCTAssertTrue(Thread.isMainThread, "This test must call the manager from the main thread to prove the point.")
    var transportThread: Thread?
    final class RecordingTransport: AssetTransport {
      var onFetch: (() -> Void)?
      func fetchJSON(url: URL, timeout: TimeInterval) throws -> Data { Data() }
      func fetchAppending(url: URL, rangeStart: Int64, destination: URL) throws -> AssetTransportChunk {
        onFetch?()
        try Data([0]).write(to: destination)
        return AssetTransportChunk(totalSize: 1, isComplete: true, bytesWritten: 1)
      }
    }
    let transport = RecordingTransport()
    transport.onFetch = { transportThread = Thread.current }
    let manager = AssetDownloadManager(transport: transport)
    let staging = tempDir()

    try manager.downloadFiles(
      [.init(url: URL(string: "https://cdn.example.com/x.bin")!, relativePath: "x.bin")],
      into: staging
    )

    XCTAssertNotNil(transportThread)
    XCTAssertFalse(transportThread!.isMainThread, "Network I/O must run off the main thread")
  }
}
