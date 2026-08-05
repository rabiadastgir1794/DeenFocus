import Foundation

/// Shadow canonical lexical evaluator — logs diffs only; never changes production score.
enum CanonicalLexicalShadow {
  struct ShadowOp: Equatable {
    let op: String
    let expectedWordId: String?
    let hypIndex: Int?
    let expectedCanonical: String?
    let hypCanonical: String?
  }

  struct DiffRow: Equatable {
    let index: Int
    let legacyOp: String
    let shadowOp: String
    let expectedWordId: String?
    let legacyReason: String?
    let note: String
  }

  struct Result: Equatable {
    let enabled: Bool
    let lexiconVersion: String?
    let shadowWordAccuracy: Double?
    let legacyWordAccuracy: Double
    let identical: Bool
    let shadowOps: [ShadowOp]
    let diffs: [DiffRow]
  }

  static func compare(
    surah: Int,
    ayah: Int,
    hypWords: [String],
    legacyOps: [TajweedLexicalScoring.WordAlignOp],
    legacyWordAccuracy: Double
  ) -> Result {
    guard CanonicalLexiconStore.shadowEnabled else {
      return Result(
        enabled: false,
        lexiconVersion: nil,
        shadowWordAccuracy: nil,
        legacyWordAccuracy: legacyWordAccuracy,
        identical: true,
        shadowOps: [],
        diffs: []
      )
    }

    guard let ayahLex = CanonicalLexiconStore.ayah(surah: surah, ayah: ayah) else {
      NSLog("[TajweedCanonicalShadow] ref=%d:%d missing from lexicon", surah, ayah)
      return Result(
        enabled: true,
        lexiconVersion: CanonicalLexiconStore.manifestInfo()?.lexiconVersion,
        shadowWordAccuracy: nil,
        legacyWordAccuracy: legacyWordAccuracy,
        identical: false,
        shadowOps: [],
        diffs: [DiffRow(
          index: 0,
          legacyOp: "n/a",
          shadowOp: "n/a",
          expectedWordId: nil,
          legacyReason: nil,
          note: "lexicon_miss"
        )]
      )
    }

    let expectedCanonical = ayahLex.words.map(\.canonical)
    let expectedIds = ayahLex.words.map(\.id)
    let hypCanonical = normalizeHypothesisWords(hypWords)
    let shadowOps = alignCanonical(expected: expectedCanonical, expectedIds: expectedIds, hypothesis: hypCanonical)
    let shadowAcc = wordAccuracy(shadowOps, expectedCount: expectedCanonical.count)
    let diffs = buildDiffs(legacyOps: legacyOps, shadowOps: shadowOps, expectedIds: expectedIds)
    let identical = diffs.isEmpty

    NSLog(
      "[TajweedCanonicalShadow] ref=%d:%d legacyAcc=%.4f shadowAcc=%.4f identical=%@ diffs=%d",
      surah,
      ayah,
      legacyWordAccuracy,
      shadowAcc,
      identical ? "YES" : "NO",
      diffs.count
    )
    for row in diffs.prefix(8) {
      NSLog(
        "[TajweedCanonicalShadow] diff[%d] legacy=%@ shadow=%@ id=%@ note=%@",
        row.index,
        row.legacyOp,
        row.shadowOp,
        row.expectedWordId ?? "-",
        row.note
      )
    }

    return Result(
      enabled: true,
      lexiconVersion: CanonicalLexiconStore.manifestInfo()?.lexiconVersion,
      shadowWordAccuracy: shadowAcc,
      legacyWordAccuracy: legacyWordAccuracy,
      identical: identical,
      shadowOps: shadowOps,
      diffs: diffs
    )
  }

  static func normalizeHypothesisWords(_ words: [String]) -> [String] {
    splitAttachedWaw(words)
      .map { CanonicalStage2.word($0) }
      .filter { !$0.isEmpty }
  }

  private static func splitAttachedWaw(_ words: [String]) -> [String] {
    var out: [String] = []
    for word in words {
      let peeled = peelLeadingWaw(word)
      if let waw = peeled.waw, !peeled.rest.isEmpty {
        out.append(CanonicalStage2.word(waw))
        out.append(peeled.rest)
      } else {
        out.append(word)
      }
    }
    return out
  }

  private static func peelLeadingWaw(_ word: String) -> (waw: String?, rest: String) {
    let scalars = Array(word.unicodeScalars)
    var i = 0
    while i < scalars.count && isIgnorableMark(scalars[i]) { i += 1 }
    guard i < scalars.count, scalars[i].value == 0x0648 else { return (nil, word) }
    var j = i + 1
    while j < scalars.count && isIgnorableMark(scalars[j]) { j += 1 }
    let rest = String(String.UnicodeScalarView(scalars[j...]))
    if rest.isEmpty { return (nil, word) }
    let wawToken = String(String.UnicodeScalarView(scalars[..<j]))
    return (wawToken, rest)
  }

  private static func isIgnorableMark(_ scalar: UnicodeScalar) -> Bool {
    let v = scalar.value
    if (0x064B...0x0652).contains(v) || v == 0x0615 || v == 0x06E1 { return true }
    if v == 0x0640 { return true }
    if (0x06D6...0x06ED).contains(v) { return true }
    return false
  }

  static func alignCanonical(
    expected: [String],
    expectedIds: [String],
    hypothesis: [String]
  ) -> [ShadowOp] {
    let n = expected.count
    let m = hypothesis.count
    var dp = Array(repeating: Array(repeating: 0, count: m + 1), count: n + 1)
    if n >= 1 { for i in 1...n { dp[i][0] = i } }
    if m >= 1 { for j in 1...m { dp[0][j] = j } }
    if n >= 1 && m >= 1 {
      for i in 1...n {
        for j in 1...m {
          let cost = expected[i - 1] == hypothesis[j - 1] ? 0 : 1
          dp[i][j] = min(dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost)
        }
      }
    }

    var ops: [ShadowOp] = []
    var i = n
    var j = m
    while i > 0 || j > 0 {
      if i > 0, j > 0, expected[i - 1] == hypothesis[j - 1], dp[i][j] == dp[i - 1][j - 1] {
        ops.append(ShadowOp(
          op: "match",
          expectedWordId: expectedIds[i - 1],
          hypIndex: j - 1,
          expectedCanonical: expected[i - 1],
          hypCanonical: hypothesis[j - 1]
        ))
        i -= 1; j -= 1
      } else if i > 0, j > 0, dp[i][j] == dp[i - 1][j - 1] + 1 {
        ops.append(ShadowOp(
          op: "sub",
          expectedWordId: expectedIds[i - 1],
          hypIndex: j - 1,
          expectedCanonical: expected[i - 1],
          hypCanonical: hypothesis[j - 1]
        ))
        i -= 1; j -= 1
      } else if i > 0, dp[i][j] == dp[i - 1][j] + 1 {
        ops.append(ShadowOp(
          op: "miss",
          expectedWordId: expectedIds[i - 1],
          hypIndex: nil,
          expectedCanonical: expected[i - 1],
          hypCanonical: nil
        ))
        i -= 1
      } else if j > 0, dp[i][j] == dp[i][j - 1] + 1 {
        ops.append(ShadowOp(
          op: "extra",
          expectedWordId: nil,
          hypIndex: j - 1,
          expectedCanonical: nil,
          hypCanonical: hypothesis[j - 1]
        ))
        j -= 1
      } else if i > 0 {
        ops.append(ShadowOp(
          op: "miss",
          expectedWordId: expectedIds[i - 1],
          hypIndex: nil,
          expectedCanonical: expected[i - 1],
          hypCanonical: nil
        ))
        i -= 1
      } else {
        ops.append(ShadowOp(
          op: "extra",
          expectedWordId: nil,
          hypIndex: j - 1,
          expectedCanonical: nil,
          hypCanonical: hypothesis[j - 1]
        ))
        j -= 1
      }
    }
    return ops.reversed()
  }

  private static func wordAccuracy(_ ops: [ShadowOp], expectedCount: Int) -> Double {
    guard expectedCount > 0 else { return 0 }
    let matches = ops.filter { $0.op == "match" }.count
    return Double(matches) / Double(expectedCount)
  }

  private static func buildDiffs(
    legacyOps: [TajweedLexicalScoring.WordAlignOp],
    shadowOps: [ShadowOp],
    expectedIds: [String]
  ) -> [DiffRow] {
    let legacySig = legacyOps.map { opSignature($0) }
    let shadowSig = shadowOps.map { $0.op + ":" + ($0.expectedWordId ?? "-") }
    if legacySig == shadowSig { return [] }

    var rows: [DiffRow] = []
    let limit = max(legacyOps.count, shadowOps.count)
    for idx in 0..<limit {
      let legacy = idx < legacyOps.count ? legacyOps[idx] : nil
      let shadow = idx < shadowOps.count ? shadowOps[idx] : nil
      let legacyOp = legacy.map { String(describing: $0.op) } ?? "none"
      let shadowOp = shadow?.op ?? "none"
      if legacyOp == shadowOp,
         legacy?.expectedIndex == shadow?.expectedWordId.flatMap({ expectedIds.firstIndex(of: $0) }) {
        continue
      }
      let note: String
      if legacyOp == "sub", shadowOp == "match" {
        note = "legacy_false_sub"
      } else if legacyOp == "match", shadowOp == "sub" {
        note = "shadow_regression"
      } else if legacyOps.count != shadowOps.count {
        note = "op_count_mismatch"
      } else {
        note = "op_sequence_diff"
      }
      rows.append(DiffRow(
        index: idx,
        legacyOp: legacyOp,
        shadowOp: shadowOp,
        expectedWordId: shadow?.expectedWordId,
        legacyReason: legacy?.reason,
        note: note
      ))
    }
    return rows
  }

  private static func opSignature(_ op: TajweedLexicalScoring.WordAlignOp) -> String {
    let exp = op.expectedIndex.map(String.init) ?? "-"
    return "\(op.op):\(exp)"
  }

  static func toStagesPayload(_ result: Result) -> [String: Any] {
    [
      "enabled": result.enabled,
      "lexiconVersion": result.lexiconVersion as Any,
      "shadowWordAccuracy": result.shadowWordAccuracy as Any,
      "legacyWordAccuracy": result.legacyWordAccuracy,
      "identical": result.identical,
      "shadowOps": result.shadowOps.map { op in
        var row: [String: Any] = ["op": op.op]
        if let id = op.expectedWordId { row["expectedWordId"] = id }
        if let hi = op.hypIndex { row["hypIndex"] = hi }
        if let ec = op.expectedCanonical { row["expectedCanonical"] = ec }
        if let hc = op.hypCanonical { row["hypCanonical"] = hc }
        return row
      },
      "legacyVsShadowDiff": result.diffs.map { row in
        [
          "index": row.index,
          "legacyOp": row.legacyOp,
          "shadowOp": row.shadowOp,
          "expectedWordId": row.expectedWordId as Any,
          "legacyReason": row.legacyReason as Any,
          "note": row.note,
        ] as [String: Any]
      },
    ]
  }
}
