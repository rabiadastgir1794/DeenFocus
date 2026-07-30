import CryptoKit
import XCTest

@testable import Runner

/// ADR-009: proves `AIAssetManager` is genuinely generic — driving a fully
/// synthetic, non-Tajweed `AIAssetPlugin` end-to-end, and proving two unrelated
/// assets can share one catalog + manager without interfering with each other.
final class AIAssetManagerTests: XCTestCase {
  /// A minimal in-memory `AIAssetPlugin` standing in for a future asset kind
  /// (e.g. a Qari audio pack or translation pack) — has no knowledge of
  /// Tajweed, CoreML, or ModelStore, proving the manager doesn't either.
  private final class FakePlugin: AIAssetPlugin {
    let assetId: String
    let kind: String
    let workingDirectory: URL
    private(set) var installedFiles: [String: Data] = [:]
    var installCallCount = 0

    init(assetId: String, kind: String) {
      self.assetId = assetId
      self.kind = kind
      self.workingDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent("AIAssetManagerTests-\(assetId)-\(UUID().uuidString)", isDirectory: true)
    }

    func isAvailable() -> Bool { !installedFiles.isEmpty }

    func fileSpecs(manifest: [String: Any], artifactBase: URL) throws -> [AssetDownloadManager.FileSpec] {
      guard let files = manifest["files"] as? [String] else {
        throw AssetDownloadError.invalidManifest("FakePlugin manifest missing 'files'.")
      }
      return files.map { AssetDownloadManager.FileSpec(url: artifactBase.appendingPathComponent($0), relativePath: $0) }
    }

    func install(stagingDirectory: URL, manifestJSON: [String: Any], progress: ((Double) -> Void)?) throws {
      installCallCount += 1
      let files = manifestJSON["files"] as? [String] ?? []
      var result: [String: Data] = [:]
      for name in files {
        result[name] = try Data(contentsOf: stagingDirectory.appendingPathComponent(name))
      }
      installedFiles = result
      progress?(1.0)
    }
  }

  override func tearDown() {
    super.tearDown()
  }

  private func catalogJSON(entries: [[String: Any]]) -> Data {
    try! JSONSerialization.data(withJSONObject: ["catalogVersion": 1, "packs": entries])
  }

  func testEnsureAssetThrowsWhenPluginNotRegistered() {
    let manager = AIAssetManager()
    manager.catalogURL = URL(string: "https://cdn.test/catalog.json")

    XCTAssertThrowsError(try manager.ensureAsset(assetId: "unregistered-asset")) { error in
      guard case AssetDownloadError.invalidManifest = error else {
        return XCTFail("Expected .invalidManifest, got \(error)")
      }
    }
  }

  func testTwoIndependentAssetsShareOneCatalogWithoutInterference() throws {
    let catalogURL = URL(string: "https://cdn.test/catalog.json")!
    let pluginA = FakePlugin(assetId: "asset-a", kind: "qari_audio")
    let pluginB = FakePlugin(assetId: "asset-b", kind: "translation_pack")
    defer {
      try? FileManager.default.removeItem(at: pluginA.workingDirectory)
      try? FileManager.default.removeItem(at: pluginB.workingDirectory)
    }

    let manifestAURL = URL(string: "https://cdn.test/asset-a/1.0.0/manifest.json")!
    let manifestBURL = URL(string: "https://cdn.test/asset-b/1.0.0/manifest.json")!
    let artifactBaseA = URL(string: "https://cdn.test/asset-a/1.0.0/")!
    let artifactBaseB = URL(string: "https://cdn.test/asset-b/1.0.0/")!

    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(entries: [
      [
        "packId": "asset-a", "kind": "qari_audio", "latestVersion": "1.0.0",
        "manifestUrl": ["ios": manifestAURL.absoluteString],
      ],
      [
        "packId": "asset-b", "kind": "translation_pack", "latestVersion": "1.0.0",
        "manifestUrl": ["ios": manifestBURL.absoluteString],
      ],
    ])
    transport.jsonResponses[manifestAURL] = try! JSONSerialization.data(withJSONObject: [
      "files": ["a.mp3"], "artifactBaseUrl": artifactBaseA.absoluteString,
    ])
    transport.jsonResponses[manifestBURL] = try! JSONSerialization.data(withJSONObject: [
      "files": ["b.json"], "artifactBaseUrl": artifactBaseB.absoluteString,
    ])
    transport.fileBytes[artifactBaseA.appendingPathComponent("a.mp3")] = Data([1, 2, 3])
    transport.fileBytes[artifactBaseB.appendingPathComponent("b.json")] = Data([4, 5, 6, 7])

    let manager = AIAssetManager(
      fetcher: AssetManifestFetcher(transport: transport),
      downloader: AssetDownloadManager(transport: transport)
    )
    manager.register(pluginA)
    manager.register(pluginB)
    manager.catalogURL = catalogURL

    try manager.ensureAsset(assetId: "asset-a")
    try manager.ensureAsset(assetId: "asset-b")

    XCTAssertEqual(pluginA.installedFiles["a.mp3"], Data([1, 2, 3]))
    XCTAssertEqual(pluginB.installedFiles["b.json"], Data([4, 5, 6, 7]))
    XCTAssertEqual(pluginA.installCallCount, 1)
    XCTAssertEqual(pluginB.installCallCount, 1)

    // Re-running ensureAsset for the already-installed, still-fresh asset
    // must not touch the network again.
    transport.rangeCallLog.removeAll()
    try manager.ensureAsset(assetId: "asset-a")
    XCTAssertTrue(transport.rangeCallLog.isEmpty)
    XCTAssertEqual(pluginA.installCallCount, 1, "Fresh + already-available asset must not reinstall")
  }

  func testEnsureAssetPerformsFirstInstallWhenNotYetAvailable() throws {
    let catalogURL = URL(string: "https://cdn.test/catalog.json")!
    let plugin = FakePlugin(assetId: "asset-c", kind: "tafsir_pack")
    defer { try? FileManager.default.removeItem(at: plugin.workingDirectory) }

    let manifestURL = URL(string: "https://cdn.test/asset-c/1.0.0/manifest.json")!
    let artifactBase = URL(string: "https://cdn.test/asset-c/1.0.0/")!

    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(entries: [
      [
        "packId": "asset-c", "kind": "tafsir_pack", "latestVersion": "2.0.0",
        "manifestUrl": ["ios": manifestURL.absoluteString],
      ]
    ])
    transport.jsonResponses[manifestURL] = try! JSONSerialization.data(withJSONObject: [
      "files": ["c.json"], "artifactBaseUrl": artifactBase.absoluteString,
    ])
    transport.fileBytes[artifactBase.appendingPathComponent("c.json")] = Data([9, 9])

    let manager = AIAssetManager(
      fetcher: AssetManifestFetcher(transport: transport),
      downloader: AssetDownloadManager(transport: transport)
    )
    manager.register(plugin)
    manager.catalogURL = catalogURL

    XCTAssertFalse(plugin.isAvailable())
    try manager.ensureAsset(assetId: "asset-c")
    XCTAssertTrue(plugin.isAvailable())
    XCTAssertEqual(plugin.installedFiles["c.json"], Data([9, 9]))
  }
}
