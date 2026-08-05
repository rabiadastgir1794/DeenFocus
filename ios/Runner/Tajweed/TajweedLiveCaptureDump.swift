import Foundation

/// Debug dump of Tajweed captures for cross-platform comparison.
/// Always overwrites `last.wav` + `last_stages.json` (compatibility), and also
/// archives a uniquely named `{surah}_{ayah}_attempt_NNNN.{wav,json}` so history
/// is never overwritten.
enum TajweedLiveCaptureDump {
  static var enabled: Bool = true

  private static let lock = NSLock()

  static var directory: URL {
    let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return docs.appendingPathComponent("TajweedLiveCompare", isDirectory: true)
  }

  static func dump(pcm: [Float], stages: [String: Any]) {
    guard enabled else { return }
    lock.lock()
    defer { lock.unlock() }

    let fm = FileManager.default
    let dir = directory
    do {
      try fm.createDirectory(at: dir, withIntermediateDirectories: true)

      // Compatibility path (existing tooling / pull scripts).
      let lastWav = dir.appendingPathComponent("last.wav")
      let lastJson = dir.appendingPathComponent("last_stages.json")
      try writeWavMono16k(pcm: pcm, to: lastWav)

      let (surah, ayah) = parseRef(stages)
      let attempt = nextAttemptIndex(in: dir, surah: surah, ayah: ayah)
      let basename = String(format: "%d_%d_attempt_%04d", surah, ayah, attempt)
      let archived = enrichStages(
        stages,
        surah: surah,
        ayah: ayah,
        attemptIndex: attempt,
        basename: basename
      )
      let jsonData = try JSONSerialization.data(
        withJSONObject: archived,
        options: [.prettyPrinted, .sortedKeys]
      )
      try jsonData.write(to: lastJson, options: .atomic)

      let archiveWav = dir.appendingPathComponent("\(basename).wav")
      let archiveJson = dir.appendingPathComponent("\(basename).json")
      try writeWavMono16k(pcm: pcm, to: archiveWav)
      try jsonData.write(to: archiveJson, options: .atomic)

      NSLog(
        "[TajweedLiveCompare] wrote last.wav + %@ (%d samples) attempt=%d",
        basename,
        pcm.count,
        attempt
      )
    } catch {
      NSLog("[TajweedLiveCompare] dump failed: \(error.localizedDescription)")
    }
  }

  private static func parseRef(_ stages: [String: Any]) -> (Int, Int) {
    if let s = stages["surah"] as? Int, let a = stages["ayah"] as? Int {
      return (s, a)
    }
    if let s = stages["surah"] as? NSNumber, let a = stages["ayah"] as? NSNumber {
      return (s.intValue, a.intValue)
    }
    let ref = (stages["ref"] as? String) ?? ""
    let parts = ref.split(separator: ":")
    let surah = parts.count >= 1 ? Int(parts[0]) ?? 0 : 0
    let ayah = parts.count >= 2 ? Int(parts[1]) ?? 0 : 0
    return (surah, ayah)
  }

  /// Next 1-based attempt index for this surah:ayah (never reuses a basename).
  private static func nextAttemptIndex(in dir: URL, surah: Int, ayah: Int) -> Int {
    let prefix = String(format: "%d_%d_attempt_", surah, ayah)
    let fm = FileManager.default
    guard let names = try? fm.contentsOfDirectory(atPath: dir.path) else { return 1 }
    var maxN = 0
    for name in names {
      guard name.hasPrefix(prefix), name.hasSuffix(".wav") else { continue }
      let mid = name.dropFirst(prefix.count).dropLast(4) // strip .wav
      if let n = Int(mid) {
        maxN = max(maxN, n)
      }
    }
    return maxN + 1
  }

  private static func enrichStages(
    _ stages: [String: Any],
    surah: Int,
    ayah: Int,
    attemptIndex: Int,
    basename: String
  ) -> [String: Any] {
    var out = stages
    out["surah"] = surah
    out["ayah"] = ayah
    out["attemptIndex"] = attemptIndex
    out["attemptBasename"] = basename
    out["expectedRaw"] = stages["expected"] ?? stages["originalExpectedAyah"] ?? ""
    out["hypRaw"] = stages["hypothesis"] ?? stages["originalAsrHypothesis"] ?? ""
    out["accuracy"] = stages["wordAccuracy"] ?? 0.0
    out["ops"] = stages["lexicalOps"] ?? []
    let modelInfo = stages["modelInfo"] as? [String: Any]
    out["bucket"] = modelInfo?["bucketOrFixedT"] ?? stages["bucketT"] ?? 0
    out["coldLoad"] = modelInfo?["modelWasColdLoad"] ?? false
    out["timestamp"] = ISO8601DateFormatter().string(from: Date())
    return out
  }

  /// PCM float [-1,1] → 16-bit mono WAV @ 16 kHz.
  static func writeWavMono16k(pcm: [Float], to url: URL) throws {
    let sampleRate: Int = 16_000
    var int16 = [Int16](repeating: 0, count: pcm.count)
    for i in 0..<pcm.count {
      let clamped = max(-1.0, min(1.0, Double(pcm[i])))
      int16[i] = Int16((clamped * Double(Int16.max)).rounded())
    }
    let dataSize = UInt32(int16.count * 2)
    var header = Data()
    func append(_ s: String) { header.append(contentsOf: s.utf8) }
    func appendU32(_ v: UInt32) {
      var le = v.littleEndian
      withUnsafeBytes(of: &le) { header.append(contentsOf: $0) }
    }
    func appendU16(_ v: UInt16) {
      var le = v.littleEndian
      withUnsafeBytes(of: &le) { header.append(contentsOf: $0) }
    }
    append("RIFF")
    appendU32(36 + dataSize)
    append("WAVE")
    append("fmt ")
    appendU32(16)
    appendU16(1) // PCM
    appendU16(1) // mono
    appendU32(UInt32(sampleRate))
    appendU32(UInt32(sampleRate * 2))
    appendU16(2) // block align
    appendU16(16) // bits
    append("data")
    appendU32(dataSize)
    var body = Data(count: int16.count * 2)
    body.withUnsafeMutableBytes { raw in
      let dest = raw.bindMemory(to: Int16.self)
      for i in 0..<int16.count {
        dest[i] = int16[i].littleEndian
      }
    }
    try (header + body).write(to: url, options: .atomic)
  }
}
