import CryptoKit
import XCTest

@testable import Runner

/// ADR-008/ADR-009: end-to-end tests for the Tajweed `AIAssetPlugin`
/// (`TajweedAssetSync`) driven through a real `AIAssetManager` instance and
/// wired to the real `ModelStore.shared` — proves the production
/// model-distribution path (catalog -> manifest -> download -> ModelStore's
/// own unmodified verify/activate/rollback) behaves correctly for every
/// required scenario, entirely offline via `FakeAssetTransport`.
final class TajweedAssetSyncTests: XCTestCase {
  private let assetId = TajweedAssetDistributionConfig.assetId
  private let catalogURL = URL(string: "https://cdn.test/tajweed/catalog.json")!
  private let manifestURLV1 = URL(string: "https://cdn.test/tajweed/packs/hafs-en-v1/1.0.0/ios/model_manifest.json")!
  private let manifestURLV2 = URL(string: "https://cdn.test/tajweed/packs/hafs-en-v1/1.1.0/ios/model_manifest.json")!
  private let artifactBaseV1 = URL(string: "https://cdn.test/tajweed/packs/hafs-en-v1/1.0.0/ios/")!
  private let artifactBaseV2 = URL(string: "https://cdn.test/tajweed/packs/hafs-en-v1/1.1.0/ios/")!

  // Every test here drives either its own `AIAssetManager` (with
  // `FakeAssetTransport`) or, for the one test that exercises the real
  // `.shared` singleton (`testEnsureModelFallsBackToModelMissingWhenCatalogUnavailable`),
  // expects the network path to be unconfigured. `TajweedAssetDistributionConfig
  // .catalogURL` now points at the real production Cloudflare R2 bucket (see
  // ADR-009 migration), so it — and the live `AIAssetManager.shared.catalogURL`,
  // in case the lazy `ModelStore` registration already ran earlier in this
  // process — must be forced off here to keep this suite fully offline.
  private var previousConfigCatalogURL: URL?
  private var previousManagerCatalogURL: URL?

  override func setUp() {
    super.setUp()
    try? FileManager.default.removeItem(at: ModelStore.shared.rootURL)
    previousConfigCatalogURL = TajweedAssetDistributionConfig.catalogURL
    previousManagerCatalogURL = AIAssetManager.shared.catalogURL
    TajweedAssetDistributionConfig.catalogURL = nil
    AIAssetManager.shared.catalogURL = nil
  }

  override func tearDown() {
    try? FileManager.default.removeItem(at: ModelStore.shared.rootURL)
    TajweedAssetDistributionConfig.catalogURL = previousConfigCatalogURL
    AIAssetManager.shared.catalogURL = previousManagerCatalogURL
    super.tearDown()
  }

  private func sha256Hex(_ data: Data) -> String {
    SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
  }

  private func catalogJSON(version: String, approxSizeBytes: Int64? = nil) -> Data {
    var pack: [String: Any] = [
      "packId": "hafs-en-v1",
      "kind": "tajweed_model",
      "isDefault": true,
      "latestVersion": version,
      "manifestUrl": ["ios": (version == "1.0.0" ? manifestURLV1 : manifestURLV2).absoluteString],
    ]
    if let approxSizeBytes { pack["approxSizeBytes"] = ["ios": approxSizeBytes] }
    let obj: [String: Any] = ["catalogVersion": 1, "packs": [pack]]
    return try! JSONSerialization.data(withJSONObject: obj)
  }

  @discardableResult
  private func seedTransport(
    _ transport: FakeAssetTransport,
    manifestURL: URL,
    artifactBase: URL,
    encoder: Data,
    head: Data,
    tokenizer: Data,
    tokens: Data,
    version: String,
    corruptEncoderSha: Bool = false
  ) -> [String: Any] {
    transport.fileBytes[artifactBase.appendingPathComponent("model.mlpackage")] = encoder
    transport.fileBytes[artifactBase.appendingPathComponent("pronunciation-head.mlpackage")] = head
    transport.fileBytes[artifactBase.appendingPathComponent("tokenizer.model")] = tokenizer
    transport.fileBytes[artifactBase.appendingPathComponent("tokens.txt")] = tokens
    let manifest: [String: Any] = [
      "version": version,
      "encoder": "model.mlpackage",
      "pronunciationHead": "pronunciation-head.mlpackage",
      "tokenizer": "tokenizer.model",
      "tokens": "tokens.txt",
      "artifactBaseUrl": artifactBase.absoluteString,
      "minimumAppVersion": "1.0.0",
      "sha256": [
        "encoder": corruptEncoderSha ? String(repeating: "0", count: 64) : sha256Hex(encoder),
        "pronunciationHead": sha256Hex(head),
        "tokenizer": sha256Hex(tokenizer),
      ],
    ]
    transport.jsonResponses[manifestURL] = try! JSONSerialization.data(withJSONObject: manifest)
    return manifest
  }

  private func makeManager(_ transport: FakeAssetTransport) -> AIAssetManager {
    let manager = AIAssetManager(
      fetcher: AssetManifestFetcher(transport: transport),
      downloader: AssetDownloadManager(transport: transport)
    )
    manager.register(TajweedAssetSync.shared)
    return manager
  }

  private func stateVersion() -> String? {
    guard
      let data = try? Data(contentsOf: ModelStore.shared.rootURL.appendingPathComponent("update_state.json")),
      let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { return nil }
    return obj["installedVersion"] as? String
  }

  func testPerformFirstInstallDownloadsAndActivatesRealModel() throws {
    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    let encoder = Data((0..<2000).map { UInt8($0 % 256) })
    seedTransport(
      transport, manifestURL: manifestURLV1, artifactBase: artifactBaseV1,
      encoder: encoder, head: Data([1, 2, 3]), tokenizer: Data([4, 5, 6]), tokens: Data([7, 8]),
      version: "1.0.0"
    )
    let manager = makeManager(transport)

    try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)

    XCTAssertTrue(ModelStore.shared.isAvailable())
    XCTAssertEqual(sha256Hex(encoder), sha256Hex(try Data(contentsOf: ModelStore.shared.encoderURL())))
    XCTAssertEqual(stateVersion(), "1.0.0")
  }

  func testPerformFirstInstallCatalogUnavailableThrows() {
    let transport = FakeAssetTransport()  // no catalog response registered -> 404
    let manager = makeManager(transport)

    XCTAssertThrowsError(try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)) { error in
      guard case AssetDownloadError.badStatusCode(404) = error else {
        return XCTFail("Expected .badStatusCode(404), got \(error)")
      }
    }
    XCTAssertFalse(ModelStore.shared.isAvailable())
  }

  func testEnsureModelFallsBackToModelMissingWhenCatalogUnavailable() {
    // ModelStore.ensureModel() is the real adapter boundary: it must translate
    // any AIAssetManager failure (not configured / registered / unreachable)
    // into the stable TajweedErrorCode.modelMissing contract Flutter expects.
    XCTAssertThrowsError(try ModelStore.shared.ensureModel()) { error in
      guard let e = error as? TajweedNativeError else { return XCTFail("Expected TajweedNativeError") }
      XCTAssertEqual(e.code, TajweedErrorCode.modelMissing)
    }
  }

  func testCheckForUpdateNewerVersionAvailableDownloadsAndActivates() throws {
    let installTransport = FakeAssetTransport()
    installTransport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    seedTransport(
      installTransport, manifestURL: manifestURLV1, artifactBase: artifactBaseV1,
      encoder: Data([1, 1, 1]), head: Data([2, 2]), tokenizer: Data([3, 3]), tokens: Data([4]),
      version: "1.0.0"
    )
    try makeManager(installTransport).performFirstInstall(assetId: assetId, catalogURL: catalogURL)

    let updateTransport = FakeAssetTransport()
    updateTransport.jsonResponses[catalogURL] = catalogJSON(version: "1.1.0")
    let newEncoder = Data((0..<200).map { _ in UInt8(9) })
    seedTransport(
      updateTransport, manifestURL: manifestURLV2, artifactBase: artifactBaseV2,
      encoder: newEncoder, head: Data([8, 8]), tokenizer: Data([7, 7]), tokens: Data([6]),
      version: "1.1.0"
    )
    let manager = makeManager(updateTransport)
    try manager.checkForUpdateAndInstallIfNeeded(assetId: assetId, catalogURL: catalogURL)

    XCTAssertTrue(ModelStore.shared.isAvailable())
    XCTAssertEqual(sha256Hex(newEncoder), sha256Hex(try Data(contentsOf: ModelStore.shared.encoderURL())))
    XCTAssertEqual(stateVersion(), "1.1.0")
  }

  func testCheckForUpdateSameVersionDoesNotRedownload() throws {
    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    seedTransport(
      transport, manifestURL: manifestURLV1, artifactBase: artifactBaseV1,
      encoder: Data([1, 1, 1]), head: Data([2, 2]), tokenizer: Data([3, 3]), tokens: Data([4]),
      version: "1.0.0"
    )
    let manager = makeManager(transport)
    try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)
    transport.rangeCallLog.removeAll()

    try manager.checkForUpdateAndInstallIfNeeded(assetId: assetId, catalogURL: catalogURL)

    XCTAssertTrue(transport.rangeCallLog.isEmpty, "No file should be re-downloaded for an unchanged version")
  }

  func testChecksumMismatchOnFirstInstallNeverActivates() {
    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    seedTransport(
      transport, manifestURL: manifestURLV1, artifactBase: artifactBaseV1,
      encoder: Data([1, 1, 1]), head: Data([2, 2]), tokenizer: Data([3, 3]), tokens: Data([4]),
      version: "1.0.0",
      corruptEncoderSha: true
    )
    let manager = makeManager(transport)

    XCTAssertThrowsError(try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)) { error in
      guard let e = error as? TajweedNativeError else { return XCTFail("Expected TajweedNativeError") }
      XCTAssertEqual(e.code, TajweedErrorCode.modelDownloadFailed)
    }
    XCTAssertFalse(ModelStore.shared.isAvailable(), "A tampered/corrupt pack must never become active")
  }

  func testFailedUpdateRollsBackAndKeepsPreviousModelActive() throws {
    let goodEncoder = Data([1, 1, 1, 1])
    let installTransport = FakeAssetTransport()
    installTransport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    seedTransport(
      installTransport, manifestURL: manifestURLV1, artifactBase: artifactBaseV1,
      encoder: goodEncoder, head: Data([2, 2]), tokenizer: Data([3, 3]), tokens: Data([4]),
      version: "1.0.0"
    )
    try makeManager(installTransport).performFirstInstall(assetId: assetId, catalogURL: catalogURL)

    let badTransport = FakeAssetTransport()
    badTransport.jsonResponses[catalogURL] = catalogJSON(version: "1.1.0")
    seedTransport(
      badTransport, manifestURL: manifestURLV2, artifactBase: artifactBaseV2,
      encoder: Data((0..<200).map { _ in UInt8(9) }), head: Data([8, 8]), tokenizer: Data([7, 7]), tokens: Data([6]),
      version: "1.1.0",
      corruptEncoderSha: true
    )
    let manager = makeManager(badTransport)

    XCTAssertThrowsError(try manager.checkForUpdateAndInstallIfNeeded(assetId: assetId, catalogURL: catalogURL)) {
      error in
      guard let e = error as? TajweedNativeError else { return XCTFail("Expected TajweedNativeError") }
      XCTAssertEqual(e.code, TajweedErrorCode.modelDownloadFailed)
    }

    XCTAssertTrue(ModelStore.shared.isAvailable(), "The previously active model must still be available")
    XCTAssertEqual(
      sha256Hex(goodEncoder),
      sha256Hex(try Data(contentsOf: ModelStore.shared.encoderURL())),
      "A failed update must never replace the currently active model"
    )
  }

  func testCheckForUpdateCatalogUnreachableKeepsExistingModelSilently() throws {
    let installTransport = FakeAssetTransport()
    installTransport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    let encoder = Data([1, 1, 1])
    seedTransport(
      installTransport, manifestURL: manifestURLV1, artifactBase: artifactBaseV1,
      encoder: encoder, head: Data([2, 2]), tokenizer: Data([3, 3]), tokens: Data([4]),
      version: "1.0.0"
    )
    try makeManager(installTransport).performFirstInstall(assetId: assetId, catalogURL: catalogURL)

    let offlineTransport = FakeAssetTransport()
    offlineTransport.jsonErrors[catalogURL] = AssetDownloadError.network("no connectivity")
    let manager = makeManager(offlineTransport)

    try manager.checkForUpdateAndInstallIfNeeded(assetId: assetId, catalogURL: catalogURL)  // must not throw

    XCTAssertTrue(ModelStore.shared.isAvailable())
    XCTAssertEqual(sha256Hex(encoder), sha256Hex(try Data(contentsOf: ModelStore.shared.encoderURL())))
    XCTAssertTrue(offlineTransport.rangeCallLog.isEmpty, "No download should have been attempted while offline")
  }

  func testPerformFirstInstallInsufficientStorageDoesNotActivateAnything() {
    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0", approxSizeBytes: 500_000_000_000)
    seedTransport(
      transport, manifestURL: manifestURLV1, artifactBase: artifactBaseV1,
      encoder: Data([1, 1, 1]), head: Data([2, 2]), tokenizer: Data([3, 3]), tokens: Data([4]),
      version: "1.0.0"
    )
    let starvedDownloader = AssetDownloadManager(transport: transport, freeSpaceProvider: { _ in 1_000 })
    let manager = AIAssetManager(fetcher: AssetManifestFetcher(transport: transport), downloader: starvedDownloader)
    manager.register(TajweedAssetSync.shared)

    XCTAssertThrowsError(try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)) { error in
      guard case AssetDownloadError.insufficientStorage(let required, _) = error else {
        return XCTFail("Expected .insufficientStorage, got \(error)")
      }
      XCTAssertEqual(required, 500_000_000_000)
    }
    XCTAssertTrue(transport.rangeCallLog.isEmpty, "No network call should have been attempted")
    XCTAssertFalse(ModelStore.shared.isAvailable(), "Nothing must be activated when storage is insufficient")
  }

  /// Real iOS releases of the DIY self-generated pack ship the `.mlpackage`
  /// encoder/head as unzipped directory bundles, described in the manifest via
  /// `encoderFiles`/`pronunciationHeadFiles` (see `TajweedAssetSync
  /// .bundleFileSpecs`). Verifies the multi-file-per-artifact download +
  /// `ModelStore`'s directory-aware SHA-256 check (hashes `weight.bin`) both
  /// work end-to-end, exactly as the real R2-hosted DIY pack is laid out.
  func testPerformFirstInstallDownloadsMultiFileMlpackageBundle() throws {
    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    let manifestJson = "{}".data(using: .utf8)!
    let modelMlmodel = Data((0..<500).map { UInt8($0 % 256) })
    let weightBin = Data((0..<3000).map { UInt8(($0 * 7) % 256) })
    let headManifestJson = "{}".data(using: .utf8)!
    let headMlmodel = Data([10, 20, 30])
    let headWeightBin = Data([40, 50, 60, 70])
    let tokenizer = Data([4, 5, 6])
    let tokens = Data([7, 8])

    let bundleFiles = ["Manifest.json", "Data/com.apple.CoreML/model.mlmodel", "Data/com.apple.CoreML/weights/weight.bin"]
    transport.fileBytes[artifactBaseV1.appendingPathComponent("encoder.mlpackage/Manifest.json")] = manifestJson
    transport.fileBytes[artifactBaseV1.appendingPathComponent("encoder.mlpackage/Data/com.apple.CoreML/model.mlmodel")] =
      modelMlmodel
    transport.fileBytes[
      artifactBaseV1.appendingPathComponent("encoder.mlpackage/Data/com.apple.CoreML/weights/weight.bin")
    ] = weightBin
    transport.fileBytes[artifactBaseV1.appendingPathComponent("head.mlpackage/Manifest.json")] = headManifestJson
    transport.fileBytes[artifactBaseV1.appendingPathComponent("head.mlpackage/Data/com.apple.CoreML/model.mlmodel")] =
      headMlmodel
    transport.fileBytes[
      artifactBaseV1.appendingPathComponent("head.mlpackage/Data/com.apple.CoreML/weights/weight.bin")
    ] = headWeightBin
    transport.fileBytes[artifactBaseV1.appendingPathComponent("tokenizer.model")] = tokenizer
    transport.fileBytes[artifactBaseV1.appendingPathComponent("tokens.txt")] = tokens

    let manifest: [String: Any] = [
      "version": "1.0.0",
      "encoder": "encoder.mlpackage",
      "encoderFiles": bundleFiles,
      "pronunciationHead": "head.mlpackage",
      "pronunciationHeadFiles": bundleFiles,
      "tokenizer": "tokenizer.model",
      "tokens": "tokens.txt",
      "artifactBaseUrl": artifactBaseV1.absoluteString,
      "encoderApi": "single_function_fixed",
      "encoderFixedT": 4800,
      "minimumAppVersion": "1.0.0",
      "sha256": [
        "encoder": sha256Hex(weightBin),
        "pronunciationHead": sha256Hex(headWeightBin),
        "tokenizer": sha256Hex(tokenizer),
      ],
    ]
    transport.jsonResponses[manifestURLV1] = try! JSONSerialization.data(withJSONObject: manifest)
    let manager = makeManager(transport)

    try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)

    XCTAssertTrue(ModelStore.shared.isAvailable())
    let installedWeight = try Data(
      contentsOf: ModelStore.shared.encoderURL().appendingPathComponent("Data/com.apple.CoreML/weights/weight.bin")
    )
    XCTAssertEqual(sha256Hex(weightBin), sha256Hex(installedWeight))
    if case .singleFunctionFixedLength(let t) = ModelStore.shared.encoderApi() {
      XCTAssertEqual(t, 4800)
    } else {
      XCTFail("Expected singleFunctionFixedLength encoder API from manifest")
    }
  }

  /// Official HF multifunction pack: manifest declares `encoderBuckets` +
  /// optional `encoderFunctionPrefix`. Switching catalog to this pack must
  /// yield `.multifunction` without any Swift rebuild.
  func testPerformFirstInstallReadsOfficialMultifunctionEncoderApi() throws {
    let transport = FakeAssetTransport()
    transport.jsonResponses[catalogURL] = catalogJSON(version: "1.0.0")
    let weightBin = Data((0..<2000).map { UInt8(($0 * 3) % 256) })
    let headWeight = Data([1, 2, 3, 4])
    let tokenizer = Data([9, 9])
    let tokens = Data([8, 8])
    let bundleFiles = [
      "Manifest.json", "Data/com.apple.CoreML/model.mlmodel",
      "Data/com.apple.CoreML/weights/weight.bin",
    ]
    transport.fileBytes[artifactBaseV1.appendingPathComponent("fastconformer-quran-offline-ane.mlpackage/Manifest.json")] =
      Data("{}".utf8)
    transport.fileBytes[
      artifactBaseV1.appendingPathComponent(
        "fastconformer-quran-offline-ane.mlpackage/Data/com.apple.CoreML/model.mlmodel"
      )
    ] = Data([1])
    transport.fileBytes[
      artifactBaseV1.appendingPathComponent(
        "fastconformer-quran-offline-ane.mlpackage/Data/com.apple.CoreML/weights/weight.bin"
      )
    ] = weightBin
    transport.fileBytes[artifactBaseV1.appendingPathComponent("pronunciation-head.mlpackage/Manifest.json")] =
      Data("{}".utf8)
    transport.fileBytes[
      artifactBaseV1.appendingPathComponent(
        "pronunciation-head.mlpackage/Data/com.apple.CoreML/model.mlmodel"
      )
    ] = Data([2])
    transport.fileBytes[
      artifactBaseV1.appendingPathComponent(
        "pronunciation-head.mlpackage/Data/com.apple.CoreML/weights/weight.bin"
      )
    ] = headWeight
    transport.fileBytes[artifactBaseV1.appendingPathComponent("tokenizer.model")] = tokenizer
    transport.fileBytes[artifactBaseV1.appendingPathComponent("tokens.txt")] = tokens

    let manifest: [String: Any] = [
      "version": "1.2.0",
      "encoder": "fastconformer-quran-offline-ane.mlpackage",
      "encoderFiles": bundleFiles,
      "pronunciationHead": "pronunciation-head.mlpackage",
      "pronunciationHeadFiles": bundleFiles,
      "tokenizer": "tokenizer.model",
      "tokens": "tokens.txt",
      "artifactBaseUrl": artifactBaseV1.absoluteString,
      "encoderApi": "multifunction",
      "encoderBuckets": [80, 200, 400, 800, 1600, 2400, 4800],
      "encoderFunctionPrefix": "predict_T",
      "minimumAppVersion": "1.0.0",
      "sha256": [
        "encoder": sha256Hex(weightBin),
        "pronunciationHead": sha256Hex(headWeight),
        "tokenizer": sha256Hex(tokenizer),
      ],
    ]
    transport.jsonResponses[manifestURLV1] = try! JSONSerialization.data(withJSONObject: manifest)
    let manager = makeManager(transport)

    try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)

    XCTAssertTrue(ModelStore.shared.isAvailable())
    if case .multifunction(let buckets) = ModelStore.shared.encoderApi() {
      XCTAssertEqual(buckets, [80, 200, 400, 800, 1600, 2400, 4800])
    } else {
      XCTFail("Expected multifunction encoder API from official-style manifest")
    }
    XCTAssertEqual(ModelStore.shared.encoderFunctionPrefix(), "predict_T")
  }

  func testCatalogWithUnrelatedAssetEntryIsIgnored() {
    // A shared multi-asset catalog (ADR-009) may list other assets (e.g. a
    // future Qari pack) alongside Tajweed. Tajweed's own lookup must match
    // its assetId exactly and never fall back to an unrelated entry.
    let transport = FakeAssetTransport()
    let unrelatedPack: [String: Any] = [
      "packId": "qari-alafasy",
      "kind": "qari_audio",
      "isDefault": true,
      "latestVersion": "1.0.0",
      "manifestUrl": ["ios": "https://cdn.test/qari/alafasy/1.0.0/ios/model_manifest.json"],
    ]
    transport.jsonResponses[catalogURL] = try! JSONSerialization.data(withJSONObject: [
      "catalogVersion": 1,
      "packs": [unrelatedPack],
    ])
    let manager = makeManager(transport)

    XCTAssertThrowsError(try manager.performFirstInstall(assetId: assetId, catalogURL: catalogURL)) { error in
      guard case AssetDownloadError.invalidManifest = error else {
        return XCTFail("Expected .invalidManifest (no entry for this assetId), got \(error)")
      }
    }
    XCTAssertFalse(ModelStore.shared.isAvailable())
  }
}
