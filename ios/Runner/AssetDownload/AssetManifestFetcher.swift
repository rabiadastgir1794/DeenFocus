import Foundation

/// Fetches the tiny top-level catalog and per-pack manifests over HTTPS (ADR-008).
/// Knows nothing about what a "pack" is used for (Tajweed, translations, TTS voices,
/// OCR, ...) — callers decode the per-pack manifest into whatever shape they need.
final class AssetManifestFetcher {
  private let transport: AssetTransport

  init(transport: AssetTransport = URLSessionAssetTransport()) {
    self.transport = transport
  }

  func fetchCatalog(url: URL, timeout: TimeInterval = 5) throws -> AssetCatalog {
    let data = try transport.fetchJSON(url: url, timeout: timeout)
    do {
      return try JSONDecoder().decode(AssetCatalog.self, from: data)
    } catch {
      throw AssetDownloadError.decodeFailed("catalog.json: \(error.localizedDescription)")
    }
  }

  /// Fetches a per-pack manifest as a raw dictionary — the consumer (e.g. Tajweed's
  /// `TajweedAssetSync`) interprets its own keys (`encoder`, `pronunciationHead`,
  /// `sha256`, ...), matching the existing ADR-007 manifest shape exactly.
  func fetchManifestJSON(url: URL, timeout: TimeInterval = 10) throws -> [String: Any] {
    let data = try transport.fetchJSON(url: url, timeout: timeout)
    guard let obj = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      throw AssetDownloadError.decodeFailed("manifest is not a JSON object")
    }
    return obj
  }
}
