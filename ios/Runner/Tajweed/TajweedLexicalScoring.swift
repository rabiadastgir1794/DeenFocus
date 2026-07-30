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

  struct WordAlignOp {
    let op: LexicalOp
    let expectedIndex: Int?
    let hypIndex: Int?
    let text: String
  }

  static func splitWords(_ text: String) -> [String] {
    text.split { $0.isWhitespace || $0.isNewline }.map(String.init).filter { !$0.isEmpty }
  }

  /// Canonical Arabic for lexical equality (Uthmani mushaf ↔ Imlaei ASR).
  /// Mirrors `TajweedLexicalScoring.normalizeArabic` in Kotlin — keep identical.
  ///
  /// Rules (order matters):
  /// 1. Map dagger alif U+0670 and alef wasla U+0671 → alef U+0627.
  /// 2. Drop tashkeel / sukun (including Quranic sukun U+06E1) and Quranic
  ///    annotation marks U+06D6...U+06ED; drop tatweel U+0640.
  /// 3. Fold hamza-bearing alefs أ/إ/آ → ا and alif maqsura ى → ي.
  static func normalizeArabic(_ text: String) -> String {
    // Combining marks / sukun (U+0670 dagger alif is mapped to alef, not stripped).
    let diacritics = CharacterSet(charactersIn: "\u{064B}\u{064C}\u{064D}\u{064E}\u{064F}\u{0650}\u{0651}\u{0652}\u{0615}\u{0653}\u{0654}\u{06E1}")
    var out = String.UnicodeScalarView()
    for scalar in text.unicodeScalars {
      let v = scalar.value
      if v == 0x0670 || v == 0x0671 {
        out.append(UnicodeScalar(0x0627)!) // ٰ / ٱ → ا
        continue
      }
      if v == 0x0640 { continue } // tatweel
      if diacritics.contains(scalar) { continue }
      if (0x06D6...0x06ED).contains(v) { continue } // Quranic annotation signs
      out.append(scalar)
    }
    return String(String.UnicodeScalarView(out))
      .replacingOccurrences(of: "أ", with: "ا")
      .replacingOccurrences(of: "إ", with: "ا")
      .replacingOccurrences(of: "آ", with: "ا")
      .replacingOccurrences(of: "ى", with: "ي")
      .trimmingCharacters(in: .whitespacesAndNewlines)
  }

  static func alignWords(expected: [String], hypothesis: [String]) -> [WordAlignOp] {
    let n = expected.count
    let m = hypothesis.count
    let expN = expected.map(normalizeArabic)
    let hypN = hypothesis.map(normalizeArabic)

    var dp = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
    if n >= 1 {
      for i in 1...n { dp[i][0] = i }
    }
    if m >= 1 {
      for j in 1...m { dp[0][j] = j }
    }
    if n >= 1 && m >= 1 {
      for i in 1...n {
        for j in 1...m {
          let cost = expN[i - 1] == hypN[j - 1] ? 0 : 1
          dp[i][j] = min(
            dp[i - 1][j] + 1,
            dp[i][j - 1] + 1,
            dp[i - 1][j - 1] + cost
          )
        }
      }
    }

    var ops: [WordAlignOp] = []
    var i = n
    var j = m
    while i > 0 || j > 0 {
      if i > 0, j > 0, expN[i - 1] == hypN[j - 1], dp[i][j] == dp[i - 1][j - 1] {
        ops.append(WordAlignOp(op: .match, expectedIndex: i - 1, hypIndex: j - 1, text: expected[i - 1]))
        i -= 1
        j -= 1
      } else if i > 0, j > 0, dp[i][j] == dp[i - 1][j - 1] + 1 {
        ops.append(WordAlignOp(op: .sub, expectedIndex: i - 1, hypIndex: j - 1, text: expected[i - 1]))
        i -= 1
        j -= 1
      } else if i > 0, dp[i][j] == dp[i - 1][j] + 1 {
        ops.append(WordAlignOp(op: .miss, expectedIndex: i - 1, hypIndex: nil, text: expected[i - 1]))
        i -= 1
      } else if j > 0, dp[i][j] == dp[i][j - 1] + 1 {
        ops.append(WordAlignOp(op: .extra, expectedIndex: nil, hypIndex: j - 1, text: hypothesis[j - 1]))
        j -= 1
      } else if i > 0 {
        ops.append(WordAlignOp(op: .miss, expectedIndex: i - 1, hypIndex: nil, text: expected[i - 1]))
        i -= 1
      } else {
        ops.append(WordAlignOp(op: .extra, expectedIndex: nil, hypIndex: j - 1, text: hypothesis[j - 1]))
        j -= 1
      }
    }
    return ops.reversed()
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
        return tokenMap(text: op.text, status: "sub", lexical: "sub", pronunciation: nil, prob: 0.0)
      case .miss:
        return tokenMap(text: op.text, status: "miss", lexical: "miss", pronunciation: nil, prob: 0.0)
      case .extra:
        return tokenMap(text: op.text, status: "extra", lexical: "extra", pronunciation: nil, prob: 0.0)
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
    endSec: Double? = nil
  ) -> [String: Any] {
    [
      "text": text,
      "status": status,
      "lexical": lexical,
      "pronunciation": pronunciation as Any,
      "prob": prob,
      "startSec": startSec as Any,
      "endSec": endSec as Any,
    ]
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
