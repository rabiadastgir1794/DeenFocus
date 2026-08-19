import Foundation

/// Pure Arabic text + word-alignment helpers for lexical-first Tajweed scoring (ADR-006).
/// Mirrors `TajweedLexicalScoring.kt` — keep behaviourally identical.
enum TajweedLexicalScoring {
  enum LexicalOp {
    case match
    case sub
    case miss
    case extra
  }

  /// Instrumentation tags for remaining lexical mismatches — logged as `sub(reason=model)`.
  enum MismatchReason {
    static let attachedWaw = "attached_waw"
    static let daggerAlif = "dagger_alif"
    static let hamzaVariant = "hamza_variant"
    static let quranicMark = "quranic_mark"
    static let model = "model"
  }

  struct WordAlignOp {
    let op: LexicalOp
    let expectedIndex: Int?
    let hypIndex: Int?
    let text: String
    /// Set for sub/miss/extra — see `MismatchReason`.
    let reason: String?
  }

  private static let diacritics = CharacterSet(charactersIn:
    "\u{064B}\u{064C}\u{064D}\u{064E}\u{064F}\u{0650}\u{0651}\u{0652}\u{0615}" +
    "\u{0653}\u{0654}\u{0655}\u{0656}\u{0657}\u{0658}\u{0659}\u{065A}\u{065B}\u{065C}\u{065D}\u{065E}\u{065F}\u{06E1}"
  )
  private static let nonLexicalMarks = CharacterSet(charactersIn: "\u{066D}")
  private static let formatControls = CharacterSet(charactersIn:
    "\u{200B}\u{200C}\u{200D}\u{FEFF}\u{00A0}\u{202F}\u{2009}\u{200A}\u{2060}\u{061C}"
  )

  static func splitWords(_ text: String) -> [String] {
    let asciiWS = CharacterSet(charactersIn: " \t\n\r\u{000B}\u{000C}")
    return text
      .components(separatedBy: asciiWS)
      .map { $0.trimmingCharacters(in: asciiWS) }
      .filter { !$0.isEmpty && !normalizeArabic($0).isEmpty }
  }

  static func lexicalWords(_ text: String, referenceText: String? = nil) -> [String] {
    let reference = referenceText ?? text
    let canonical = splitWords(reference).map(normalizeArabic).filter { !$0.isEmpty }
    let stream = normalizeArabic(text)
    var i = stream.startIndex
    var out: [String] = []
    out.reserveCapacity(canonical.count)
    for word in canonical {
      guard let end = stream.index(i, offsetBy: word.count, limitedBy: stream.endIndex),
            stream[i..<end] == word
      else {
        return splitWords(text).map(normalizeArabic).filter { !$0.isEmpty }
      }
      out.append(word)
      i = end
    }
    if i != stream.endIndex {
      return splitWords(text).map(normalizeArabic).filter { !$0.isEmpty }
    }
    return out
  }

  static func prepareExpectedWords(_ text: String, referenceText: String? = nil) -> [String] {
    let reference = referenceText ?? text
    return filterLexicalExpectedWords(lexicalWords(text, referenceText: reference))
  }

  static func prepareHypothesisWords(_ hypothesis: String) -> [String] {
    splitAttachedWawHypothesisWords(splitWords(hypothesis))
  }

  static func filterLexicalExpectedWords(_ words: [String]) -> [String] {
    words.filter { !isNonLexicalAnnotationToken($0) }
  }

  static func isNonLexicalAnnotationToken(_ text: String) -> Bool {
    if text.isEmpty { return true }
    for scalar in text.unicodeScalars {
      if CharacterSet.whitespacesAndNewlines.contains(scalar) { continue }
      if isFormatControlScalar(scalar) { continue }
      if isIgnorableMarkScalar(scalar) || nonLexicalMarks.contains(scalar) { continue }
      return false
    }
    return true
  }

  static func splitAttachedWawHypothesisWords(_ words: [String]) -> [String] {
    var out: [String] = []
    out.reserveCapacity(words.count + 4)
    for word in words {
      let (waw, rest) = peelLeadingWaw(word)
      if let waw, !rest.isEmpty {
        out.append(waw)
        out.append(rest)
      } else {
        out.append(word)
      }
    }
    return out
  }

  static func peelLeadingWaw(_ word: String) -> (String?, String) {
    let scalars = Array(word.unicodeScalars)
    var i = 0
    while i < scalars.count && isIgnorableMarkScalar(scalars[i]) { i += 1 }
    guard i < scalars.count, scalars[i].value == 0x0648 else { return (nil, word) }
    var j = i + 1
    while j < scalars.count && isIgnorableMarkScalar(scalars[j]) { j += 1 }
    let rest = String(String.UnicodeScalarView(scalars[j...]))
    if rest.isEmpty { return (nil, word) }
    let wawToken = String(String.UnicodeScalarView(scalars[..<j]))
    return (wawToken, rest)
  }

  static func normalizeArabic(_ text: String) -> String {
    let scalars = Array(text.unicodeScalars)
    var out = String.UnicodeScalarView()
    var i = 0

    while i < scalars.count {
      let scalar = scalars[i]
      let v = scalar.value
      if CharacterSet.whitespacesAndNewlines.contains(scalar) {
        i += 1
        continue
      }
      if v == 0x0670 {
        var j = i + 1
        while j < scalars.count && isIgnorableMarkScalar(scalars[j]) { j += 1 }
        let next: Int
        if j >= scalars.count || CharacterSet.whitespacesAndNewlines.contains(scalars[j]) {
          next = -1
        } else {
          next = Int(scalars[j].value)
        }
        let prev = previousBaseCode(scalars: scalars, index: i)
        // Mirror Kotlin Int-based family checks — never UInt32(-1) (fatal on iOS).
        let dropDagger: Bool
        if next >= 0 {
          let nu = UInt32(next)
          dropDagger = isHehFamily(nu) || isYaFamily(nu) || isKaf(nu)
        } else {
          dropDagger = prev >= 0 && isYaFamily(UInt32(prev))
        }
        if !dropDagger {
          out.append(UnicodeScalar(0x0627)!)
        }
        i += 1
        continue
      }
      if v == 0x0671 {
        out.append(UnicodeScalar(0x0627)!)
        i += 1
        continue
      }
      if isIgnorableMarkScalar(scalar) {
        i += 1
        continue
      }
      if isHehFamily(v) {
        out.append(UnicodeScalar(0x0647)!)
        i += 1
        continue
      }
      out.append(scalar)
      i += 1
    }
    return String(String.UnicodeScalarView(out))
      .replacingOccurrences(of: "أ", with: "ا")
      .replacingOccurrences(of: "إ", with: "ا")
      .replacingOccurrences(of: "آ", with: "ا")
      .replacingOccurrences(of: "ى", with: "ي")
      .replacingOccurrences(of: "ک", with: "ك")
      .replacingOccurrences(of: "ی", with: "ي")
      .replacingOccurrences(of: "الائك", with: "الئك")
      .replacingOccurrences(of: "اولائك", with: "اولئك")
      .trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private static func isIgnorableMarkScalar(_ scalar: UnicodeScalar) -> Bool {
    let v = scalar.value
    return diacritics.contains(scalar) || v == 0x0640 || (0x06D6...0x06ED).contains(v)
      || nonLexicalMarks.contains(scalar) || formatControls.contains(scalar)
  }

  private static func isFormatControlScalar(_ scalar: UnicodeScalar) -> Bool {
    formatControls.contains(scalar)
  }

  private static func previousBaseCode(scalars: [UnicodeScalar], index: Int) -> Int {
    var k = index - 1
    while k >= 0 && isIgnorableMarkScalar(scalars[k]) { k -= 1 }
    if k >= 0 && !CharacterSet.whitespacesAndNewlines.contains(scalars[k]) {
      return Int(scalars[k].value)
    }
    return -1
  }

  private static func isHehFamily(_ code: UInt32) -> Bool {
    switch code {
    case 0x0647, 0x06C1, 0x06BE, 0x0629, 0x06D5, 0x06C2, 0x06C3: return true
    default: return false
    }
  }

  private static func isYaFamily(_ code: UInt32) -> Bool {
    switch code {
    case 0x064A, 0x0649, 0x06CC: return true
    default: return false
    }
  }

  private static func isKaf(_ code: UInt32) -> Bool {
    switch code {
    case 0x0643, 0x06A9: return true
    default: return false
    }
  }

  static func alignWords(expected: [String], hypothesis: [String]) -> [WordAlignOp] {
    let n = expected.count
    let m = hypothesis.count
    let expN = expected.map(normalizeArabic)
    let hypN = hypothesis.map(normalizeArabic)

    var dp = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
    if n >= 1 { for i in 1...n { dp[i][0] = i } }
    if m >= 1 { for j in 1...m { dp[0][j] = j } }
    if n >= 1 && m >= 1 {
      for i in 1...n {
        for j in 1...m {
          let cost = expN[i - 1] == hypN[j - 1] ? 0 : 1
          dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)
        }
      }
    }

    var ops: [WordAlignOp] = []
    var i = n
    var j = m
    while i > 0 || j > 0 {
      if i > 0, j > 0, expN[i - 1] == hypN[j - 1], dp[i][j] == dp[i - 1][j - 1] {
        ops.append(WordAlignOp(op: .match, expectedIndex: i - 1, hypIndex: j - 1, text: expected[i - 1], reason: nil))
        i -= 1; j -= 1
      } else if i > 0, j > 0, dp[i][j] == dp[i - 1][j - 1] + 1 {
        ops.append(WordAlignOp(
          op: .sub, expectedIndex: i - 1, hypIndex: j - 1, text: expected[i - 1],
          reason: classifyMismatchReason(
            op: .sub, expectedWord: expected[i - 1], hypWord: hypothesis[j - 1],
            expectedNorm: expN[i - 1], hypNorm: hypN[j - 1]
          )
        ))
        i -= 1; j -= 1
      } else if i > 0, dp[i][j] == dp[i - 1][j] + 1 {
        ops.append(WordAlignOp(
          op: .miss, expectedIndex: i - 1, hypIndex: nil, text: expected[i - 1],
          reason: classifyMismatchReason(
            op: .miss, expectedWord: expected[i - 1], hypWord: nil,
            expectedNorm: expN[i - 1], hypNorm: nil
          )
        ))
        i -= 1
      } else if j > 0, dp[i][j] == dp[i][j - 1] + 1 {
        ops.append(WordAlignOp(
          op: .extra, expectedIndex: nil, hypIndex: j - 1, text: hypothesis[j - 1],
          reason: MismatchReason.model
        ))
        j -= 1
      } else if i > 0 {
        ops.append(WordAlignOp(
          op: .miss, expectedIndex: i - 1, hypIndex: nil, text: expected[i - 1],
          reason: classifyMismatchReason(
            op: .miss, expectedWord: expected[i - 1], hypWord: nil,
            expectedNorm: expN[i - 1], hypNorm: nil
          )
        ))
        i -= 1
      } else {
        ops.append(WordAlignOp(
          op: .extra, expectedIndex: nil, hypIndex: j - 1, text: hypothesis[j - 1],
          reason: MismatchReason.model
        ))
        j -= 1
      }
    }
    return ops.reversed()
  }

  static func classifyMismatchReason(
    op: LexicalOp,
    expectedWord: String,
    hypWord: String?,
    expectedNorm: String,
    hypNorm: String?
  ) -> String {
    switch op {
    case .extra:
      return MismatchReason.model
    case .miss:
      if isNonLexicalAnnotationToken(expectedWord) { return MismatchReason.quranicMark }
      if expectedNorm == "و" { return MismatchReason.attachedWaw }
      return MismatchReason.model
    case .sub:
      guard let hyp = hypWord else { return MismatchReason.model }
      let hypN = hypNorm ?? normalizeArabic(hyp)
      if expectedNorm == "و" || (hypN.hasPrefix("و") && hypN.count > 1) {
        return MismatchReason.attachedWaw
      }
      if expectedWord.unicodeScalars.contains(where: { $0.value == 0x0670 })
        || hyp.unicodeScalars.contains(where: { $0.value == 0x0670 }) {
        return MismatchReason.daggerAlif
      }
      if isUlaaikVariant(expectedNorm: expectedNorm, hypNorm: hypN) {
        return MismatchReason.hamzaVariant
      }
      if isNonLexicalAnnotationToken(expectedWord) { return MismatchReason.quranicMark }
      return MismatchReason.model
    case .match:
      return MismatchReason.model
    }
  }

  private static func isUlaaikVariant(expectedNorm: String, hypNorm: String) -> Bool {
    let pair = Set([expectedNorm, hypNorm])
    return pair == Set(["اولائك", "اولئك"]) || pair == Set(["الائك", "الئك"])
  }

  static func formatOpForLog(_ op: WordAlignOp) -> String {
    let name: String
    switch op.op {
    case .match: name = "match"
    case .sub: name = "sub"
    case .miss: name = "miss"
    case .extra: name = "extra"
    }
    guard let reason = op.reason else { return name }
    return "\(name)(reason=\(reason))"
  }

  static func wordAccuracyFromTokens(_ tokens: [[String: Any]], expectedWordCount: Int) -> Double {
    if expectedWordCount == 0 { return tokens.isEmpty ? 1.0 : 0.0 }
    let correct = tokens.filter(isLexicalMatch).count
    return Double(correct) / Double(expectedWordCount)
  }

  static func isExpectedToken(_ token: [String: Any]) -> Bool {
    if let lexical = token["lexical"] as? String { return lexical != "extra" }
    return (token["status"] as? String) != "extra"
  }

  static func isLexicalMatch(_ token: [String: Any]) -> Bool {
    if let lexical = token["lexical"] as? String { return lexical == "match" }
    let status = token["status"] as? String
    return status == "ok" || status == "minor" || status == "major"
  }

  static func tokensFromAlignment(_ ops: [WordAlignOp]) -> [[String: Any]] {
    ops.map { op in
      switch op.op {
      case .match:
        return tokenMap(text: op.text, status: "ok", lexical: "match", pronunciation: "ok", prob: 1.0)
      case .sub:
        return tokenMap(text: op.text, status: "sub", lexical: "sub", pronunciation: nil, prob: 0.0, reason: op.reason)
      case .miss:
        return tokenMap(text: op.text, status: "miss", lexical: "miss", pronunciation: nil, prob: 0.0, reason: op.reason)
      case .extra:
        return tokenMap(text: op.text, status: "extra", lexical: "extra", pronunciation: nil, prob: 0.0, reason: op.reason)
      }
    }
  }

  static func tokenMap(
    text: String,
    status: String,
    lexical: String,
    pronunciation: String?,
    prob: Float,
    startSec: Double? = nil,
    endSec: Double? = nil,
    reason: String? = nil
  ) -> [String: Any] {
    var map: [String: Any] = [
      "text": text,
      "status": status,
      "lexical": lexical,
      "pronunciation": pronunciation as Any,
      "prob": prob,
      "startSec": startSec as Any,
      "endSec": endSec as Any,
    ]
    if let reason { map["reason"] = reason }
    return map
  }

  static func pieceWordIndices(tokenIds: [Int], startsNewWord: (Int) -> Bool) -> [Int] {
    var out = Array(repeating: 0, count: tokenIds.count)
    var wordIdx = -1
    for i in tokenIds.indices {
      if i == 0 || startsNewWord(tokenIds[i]) { wordIdx += 1 }
      out[i] = max(wordIdx, 0)
    }
    return out
  }

  static func lexicalTokenReport(expected: [String], hypothesis: [String]) -> [[String: Any]] {
    tokensFromAlignment(alignWords(expected: expected, hypothesis: hypothesis))
  }

  static func wordAccuracyScore(expected: [String], hypothesis: [String]) -> Double {
    if expected.isEmpty { return hypothesis.isEmpty ? 1.0 : 0.0 }
    let matches = alignWords(expected: expected, hypothesis: hypothesis).filter { $0.op == .match }.count
    return Double(matches) / Double(expected.count)
  }
}
