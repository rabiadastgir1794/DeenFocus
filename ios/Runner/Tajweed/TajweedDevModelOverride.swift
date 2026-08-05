import Foundation

/// CoreML pack selector for local iPhone/simulator development.
///
/// Release/TestFlight never apply an override (`isAllowed == false`) — they
/// always use production `catalog.json` (Official HF CoreML v1.2.0 multifunction
/// as of 2026-08-03). Debug builds allow Official / DIY / catalog via
/// Settings → iOS CoreML override (Debug).
///
/// DIY palette-8 remains on R2 at `ios/tajweed/v1.1.0/` for rollback / Debug.
enum TajweedDevModelSource: String, CaseIterable {
  case catalog
  case official
  case diy

  var displayName: String {
    switch self {
    case .catalog: return "Production catalog"
    case .official: return "Official CoreML"
    case .diy: return "DIY CoreML"
    }
  }
}

enum TajweedDevModelOverride {
  private static let defaultsKey = "deenfocus.tajweed.devCoreMlSource"
  private static let pendingResyncKey = "deenfocus.tajweed.devCoreMlPendingResync"
  private static let r2Base = "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev"

  /// True only in Debug compiles. Release/Profile/TestFlight → always false.
  static var isAllowed: Bool {
    #if DEBUG
    true
    #else
    false
    #endif
  }

  /// Debug default: Official. Release never reads this (always `.catalog`).
  static var preferredSource: TajweedDevModelSource {
    get {
      guard isAllowed else { return .catalog }
      if let raw = UserDefaults.standard.string(forKey: defaultsKey),
         let value = TajweedDevModelSource(rawValue: raw)
      {
        return value
      }
      return .official
    }
    set {
      guard isAllowed else { return }
      UserDefaults.standard.set(newValue.rawValue, forKey: defaultsKey)
      UserDefaults.standard.set(true, forKey: pendingResyncKey)
    }
  }

  static func applyToAssetManager() {
    guard isAllowed else {
      AIAssetManager.shared.catalogURL = TajweedAssetDistributionConfig.catalogURL
      return
    }
    AIAssetManager.shared.catalogURL = effectiveCatalogURL()
  }

  static func effectiveCatalogURL() -> URL? {
    guard isAllowed else { return TajweedAssetDistributionConfig.catalogURL }
    switch preferredSource {
    case .catalog:
      return TajweedAssetDistributionConfig.catalogURL
    case .official:
      // Local file catalog (models still download from R2 over HTTPS).
      return materializeCatalogFile(
        name: "dev_catalog_official.json", payload: officialCatalogJSON
      )
    case .diy:
      return materializeCatalogFile(name: "dev_catalog_diy.json", payload: diyCatalogJSON)
    }
  }

  static func consumePendingForceResync() -> Bool {
    guard isAllowed else { return false }
    let pending = UserDefaults.standard.bool(forKey: pendingResyncKey)
    if pending {
      UserDefaults.standard.set(false, forKey: pendingResyncKey)
    }
    return pending
  }

  static func markForceResync() {
    guard isAllowed else { return }
    UserDefaults.standard.set(true, forKey: pendingResyncKey)
  }

  static func activePackMatchesSelection(manifest: [String: Any]?) -> Bool {
    guard isAllowed else { return true }
    guard let manifest else { return false }
    let api = (manifest["encoderApi"] as? String) ?? "multifunction"
    switch preferredSource {
    case .catalog:
      return true
    case .official:
      return api != "single_function_fixed"
    case .diy:
      return api == "single_function_fixed"
    }
  }

  private static func materializeCatalogFile(name: String, payload: [String: Any]) -> URL? {
    let dir = ModelStore.shared.rootURL
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let url = dir.appendingPathComponent(name)
    guard let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted])
    else { return nil }
    try? data.write(to: url, options: .atomic)
    return url
  }

  static var officialCatalogJSON: [String: Any] {
    [
      "catalogVersion": 1,
      "updatedAt": "2026-07-30T00:00:00Z",
      "recommendedCheckIntervalHours": 24,
      "packs": [
        [
          "packId": TajweedAssetDistributionConfig.assetId,
          "kind": "tajweed_model",
          "displayName": "Hafs (Arabic) + English feedback (DEV Official)",
          "language": "en",
          "riwayah": "Hafs",
          "isDefault": true,
          "latestVersion": "1.2.0",
          "minimumAppVersion": "1.0.0",
          "manifestUrl": [
            "ios": "\(r2Base)/ios/tajweed/v1.2.0/model_manifest.json",
          ],
          "approxSizeBytes": [
            "ios": 260_911_038,
          ],
        ],
      ],
    ]
  }

  static var diyCatalogJSON: [String: Any] {
    [
      "catalogVersion": 1,
      "updatedAt": "2026-07-30T00:00:00Z",
      "recommendedCheckIntervalHours": 24,
      "packs": [
        [
          "packId": TajweedAssetDistributionConfig.assetId,
          "kind": "tajweed_model",
          "displayName": "Hafs (Arabic) + English feedback (DEV DIY)",
          "language": "en",
          "riwayah": "Hafs",
          "isDefault": true,
          "latestVersion": "1.1.0",
          "minimumAppVersion": "1.0.0",
          "manifestUrl": [
            "ios": "\(r2Base)/ios/tajweed/v1.1.0/model_manifest.json",
          ],
          "approxSizeBytes": [
            "ios": 158_789_625,
          ],
        ],
      ],
    ]
  }
}
