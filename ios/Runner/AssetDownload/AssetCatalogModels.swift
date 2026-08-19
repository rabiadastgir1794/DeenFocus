import Foundation

/// Reserved for future integrity upgrades (ADR-008): v1 never verifies these,
/// SHA-256 remains the sole authoritative check (unchanged `ModelStore` logic).
struct AssetCatalogSignature: Codable, Equatable {
  let algorithm: String
  let publicKeyId: String
  let signatureBase64: String
}

/// One downloadable pack entry in the catalog (packId/version/platform-based
/// layout, per ADR-008) — generic across any future asset type (Tajweed models,
/// translations, TTS voices, OCR packs, ...), not just Tajweed.
struct AssetCatalogEntry: Codable, Equatable {
  let packId: String
  /// Free-form asset category (ADR-009), e.g. `"tajweed_model"`, `"qari_audio"`,
  /// `"translation_pack"`, `"tafsir_pack"`. Optional/unvalidated by the
  /// framework — purely descriptive metadata for tooling/UI.
  let kind: String?
  let displayName: String?
  let language: String?
  let riwayah: String?
  let isDefault: Bool?
  let latestVersion: String
  let minimumAppVersion: String?
  /// Per-platform URL to that platform's `model_manifest.json` (keys: "ios"/"android").
  let manifestUrl: [String: String]
  let approxSizeBytes: [String: Int64]?
}

/// The tiny top-level `catalog.json` polled periodically by consumers.
struct AssetCatalog: Codable, Equatable {
  let catalogVersion: Int
  let updatedAt: String?
  let recommendedCheckIntervalHours: Double?
  let catalogSignature: AssetCatalogSignature?
  let packs: [AssetCatalogEntry]

  func entry(forPackId packId: String) -> AssetCatalogEntry? {
    packs.first { $0.packId == packId }
  }

  func defaultEntry() -> AssetCatalogEntry? {
    packs.first { $0.isDefault == true } ?? packs.first
  }
}
