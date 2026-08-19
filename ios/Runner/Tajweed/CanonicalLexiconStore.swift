import Foundation

/// Versioned canonical spoken-Quran lexicon (ADR-010).
enum CanonicalLexiconStore {
  struct CanonicalWord: Equatable {
    let id: String
    let canonical: String
    let surfaceUthmani: String
    let surfaceIndopak: String
    let surfaceImlaei: String

    /// UI chip text — Uthmani surface when present; never used for alignment.
    var uiText: String {
      if !surfaceUthmani.isEmpty { return surfaceUthmani }
      if !surfaceImlaei.isEmpty { return surfaceImlaei }
      return canonical
    }
  }

  struct AyahLexicon: Equatable {
    let ref: String
    let words: [CanonicalWord]
  }

  struct Manifest: Equatable {
    let lexiconVersion: String
    let linguisticSpecVersion: String
    let stage2FoldRevision: String
    let ayahCount: Int
  }

  static var shadowEnabled: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
  }

  private static var manifest: Manifest?
  private static var ayahIndex: [String: AyahLexicon]?
  private static let loadLock = NSLock()

  static func manifestInfo() -> Manifest? {
    loadIfNeeded()
    return manifest
  }

  static func ayah(surah: Int, ayah: Int) -> AyahLexicon? {
    loadIfNeeded()
    return ayahIndex?["\(surah):\(ayah)"]
  }

  private static func bundleResource(name: String, ext: String) -> URL? {
    for sub in ["canonical_lexicon", "Tajweed/canonical_lexicon", nil] {
      if let url = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: sub) {
        return url
      }
    }
    return nil
  }

  static func loadIfNeeded() {
    loadLock.lock()
    defer { loadLock.unlock() }
    if ayahIndex != nil { return }

    let t0 = CFAbsoluteTimeGetCurrent()
    guard let manifestURL = bundleResource(name: "manifest", ext: "json"),
          let ndjsonURL = bundleResource(name: "ayahs", ext: "ndjson")
    else {
      NSLog("[TajweedCanonical] lexicon bundle resources missing")
      ayahIndex = [:]
      return
    }

    do {
      let manifestData = try Data(contentsOf: manifestURL)
      let manifestJSON = try JSONSerialization.jsonObject(with: manifestData) as? [String: Any] ?? [:]
      manifest = Manifest(
        lexiconVersion: manifestJSON["lexiconVersion"] as? String ?? "",
        linguisticSpecVersion: manifestJSON["linguisticSpecVersion"] as? String ?? "",
        stage2FoldRevision: manifestJSON["stage2FoldRevision"] as? String ?? "",
        ayahCount: manifestJSON["ayahCount"] as? Int ?? 0
      )

      // Stream lines instead of loading ~12MB into one String + split (same JSON rows).
      let handle = try FileHandle(forReadingFrom: ndjsonURL)
      defer { try? handle.close() }
      var index: [String: AyahLexicon] = [:]
      index.reserveCapacity(manifest?.ayahCount ?? 6236)
      var carry = Data()
      while true {
        let chunk = handle.readData(ofLength: 64 * 1024)
        if chunk.isEmpty && carry.isEmpty { break }
        carry.append(chunk)
        while let nl = carry.firstIndex(of: UInt8(ascii: "\n")) {
          let lineData = carry.subdata(in: carry.startIndex..<nl)
          carry.removeSubrange(carry.startIndex...nl)
          if lineData.isEmpty { continue }
          guard let row = try JSONSerialization.jsonObject(with: lineData) as? [String: Any],
                let ref = row["ref"] as? String,
                let wordsRaw = row["words"] as? [[String: Any]]
          else { continue }
          let words = wordsRaw.compactMap { w -> CanonicalWord? in
            guard let id = w["id"] as? String, let canonical = w["canonical"] as? String else { return nil }
            let surfaces = w["surfaceForms"] as? [String: Any] ?? [:]
            return CanonicalWord(
              id: id,
              canonical: canonical,
              surfaceUthmani: surfaces["uthmani"] as? String ?? "",
              surfaceIndopak: surfaces["indopak"] as? String ?? "",
              surfaceImlaei: surfaces["imlaei"] as? String ?? ""
            )
          }
          index[ref] = AyahLexicon(ref: ref, words: words)
        }
        if chunk.isEmpty { break }
      }
      if !carry.isEmpty,
         let row = try JSONSerialization.jsonObject(with: carry) as? [String: Any],
         let ref = row["ref"] as? String,
         let wordsRaw = row["words"] as? [[String: Any]]
      {
        let words = wordsRaw.compactMap { w -> CanonicalWord? in
          guard let id = w["id"] as? String, let canonical = w["canonical"] as? String else { return nil }
          let surfaces = w["surfaceForms"] as? [String: Any] ?? [:]
          return CanonicalWord(
            id: id,
            canonical: canonical,
            surfaceUthmani: surfaces["uthmani"] as? String ?? "",
            surfaceIndopak: surfaces["indopak"] as? String ?? "",
            surfaceImlaei: surfaces["imlaei"] as? String ?? ""
          )
        }
        index[ref] = AyahLexicon(ref: ref, words: words)
      }
      ayahIndex = index
      NSLog(
        "[TajweedCanonical] loaded lexiconVersion=%@ ayahs=%d in %.0fms (must not run on launch/main)",
        manifest?.lexiconVersion ?? "",
        index.count,
        (CFAbsoluteTimeGetCurrent() - t0) * 1000
      )
    } catch {
      NSLog("[TajweedCanonical] lexicon load failed: \(error.localizedDescription)")
      ayahIndex = [:]
    }
  }

  /// Unit tests only — inject a minimal ayah map without reading the bundle.
  static func installForTesting(ayahs: [String: AyahLexicon], version: String = "test") {
    loadLock.lock()
    defer { loadLock.unlock() }
    manifest = Manifest(
      lexiconVersion: version,
      linguisticSpecVersion: "test",
      stage2FoldRevision: "test",
      ayahCount: ayahs.count
    )
    ayahIndex = ayahs
  }

  static func resetForTesting() {
    loadLock.lock()
    defer { loadLock.unlock() }
    manifest = nil
    ayahIndex = nil
  }
}
