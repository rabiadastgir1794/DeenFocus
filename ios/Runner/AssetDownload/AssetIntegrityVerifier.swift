import CryptoKit
import Foundation

/// Generic SHA-256 integrity checker, independent of any consumer's manifest shape.
///
/// Tajweed's `ModelStore.verifySHA` (ADR-007) keeps its own copy of this logic and
/// is intentionally left unmodified per ADR-008 — this type exists for *future*
/// asset consumers (translations, TTS voices, OCR, ...) that don't have their own
/// ModelStore-equivalent yet, so they get the same integrity guarantee for free.
enum AssetIntegrityVerifier {
  static func sha256Hex(of fileURL: URL) throws -> String {
    guard let stream = InputStream(url: fileURL) else {
      throw AssetDownloadError.diskError("Cannot open \(fileURL.lastPathComponent) for hashing.")
    }
    stream.open()
    defer { stream.close() }
    var hasher = SHA256()
    let bufferSize = 1 << 20
    var buffer = [UInt8](repeating: 0, count: bufferSize)
    while stream.hasBytesAvailable {
      let read = stream.read(&buffer, maxLength: bufferSize)
      if read < 0 { throw AssetDownloadError.diskError("Read error while hashing \(fileURL.lastPathComponent).") }
      if read == 0 { break }
      hasher.update(data: Data(buffer[0..<read]))
    }
    return hasher.finalize().map { String(format: "%02x", $0) }.joined()
  }

  static func verify(fileURL: URL, expectedHex: String?) throws {
    guard let expectedHex, !expectedHex.isEmpty else { return }
    let actual = try sha256Hex(of: fileURL)
    if actual.lowercased() != expectedHex.lowercased() {
      throw AssetDownloadError.integrityMismatch(fileName: fileURL.lastPathComponent)
    }
  }
}
