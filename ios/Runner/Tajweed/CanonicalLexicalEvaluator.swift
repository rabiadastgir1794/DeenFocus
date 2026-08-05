import Foundation

/// ADR-010 M3 production lexical authority.
/// Expected side = lexicon canonical IDs only (display Mushaf never consulted).
/// Hypothesis = Stage-2 + M2.5 و/ف rematerialization, then exact DP on canonical strings.
enum CanonicalLexicalEvaluator {
  struct Evaluation {
    let ops: [TajweedLexicalScoring.WordAlignOp]
    let expectedCount: Int
    let lexiconVersion: String?
    let hypCanonical: [String]
    let expectedCanonical: [String]
  }

  private struct TrackedToken {
    let canonical: String
    /// Index into ``TajweedLexicalScoring.prepareHypothesisWords`` (pronunciation FA space).
    let pronIndex: Int
  }

  /// - Parameter hypothesisWords: ``prepareHypothesisWords`` output so `hypIndex` stays
  ///   in the same space pronunciation FA already uses (head model unchanged).
  /// Returns `nil` when the ayah is missing from the pack (fail closed — caller
  /// must not fall back to display-script expected words while the flag is on).
  static func evaluate(
    surah: Int,
    ayah: Int,
    hypothesisWords: [String]
  ) -> Evaluation? {
    CanonicalLexiconStore.loadIfNeeded()
    guard let ayahLex = CanonicalLexiconStore.ayah(surah: surah, ayah: ayah),
          !ayahLex.words.isEmpty
    else {
      NSLog("[TajweedCanonical] ref=%d:%d lexicon miss — fail closed", surah, ayah)
      return nil
    }

    let expectedCanonical = ayahLex.words.map(\.canonical)
    let expectedIds = ayahLex.words.map(\.id)
    let tracked = rematerializeClitics(
      normalizeHypothesisWords(hypothesisWords),
      expectedCanonical: expectedCanonical
    )
    let hypCanonical = tracked.map(\.canonical)
    let shadowOps = CanonicalLexicalShadow.alignCanonical(
      expected: expectedCanonical,
      expectedIds: expectedIds,
      hypothesis: hypCanonical
    )
    let ops = toLegacyOps(shadowOps, words: ayahLex.words, tracked: tracked)
    NSLog(
      "[TajweedCanonical] ref=%d:%d lexicon=%@ expected=%d hyp=%d ops=%@",
      surah,
      ayah,
      CanonicalLexiconStore.manifestInfo()?.lexiconVersion ?? "",
      expectedCanonical.count,
      hypCanonical.count,
      ops.map { TajweedLexicalScoring.formatOpForLog($0) }.description
    )
    return Evaluation(
      ops: ops,
      expectedCount: expectedCanonical.count,
      lexiconVersion: CanonicalLexiconStore.manifestInfo()?.lexiconVersion,
      hypCanonical: hypCanonical,
      expectedCanonical: expectedCanonical
    )
  }

  /// Stage-2 fold; peel attached و/ف into provisional tokens (M2.5).
  private static func normalizeHypothesisWords(_ words: [String]) -> [TrackedToken] {
    var out: [TrackedToken] = []
    for (i, word) in words.enumerated() {
      let peeled = peelLeadingClitic(word)
      if let clitic = peeled.clitic, !peeled.rest.isEmpty {
        let cFold = CanonicalStage2.word(clitic)
        let rFold = CanonicalStage2.word(peeled.rest)
        if !cFold.isEmpty { out.append(TrackedToken(canonical: cFold, pronIndex: i)) }
        if !rFold.isEmpty { out.append(TrackedToken(canonical: rFold, pronIndex: i)) }
      } else {
        let folded = CanonicalStage2.word(word)
        if !folded.isEmpty { out.append(TrackedToken(canonical: folded, pronIndex: i)) }
      }
    }
    return out
  }

  /// Merge standalone و/ف + host when merge equals an expected Uthmani canonical.
  private static func rematerializeClitics(
    _ hyp: [TrackedToken],
    expectedCanonical: [String]
  ) -> [TrackedToken] {
    let expectedSet = Set(expectedCanonical)
    var out: [TrackedToken] = []
    var j = 0
    while j < hyp.count {
      let h = hyp[j]
      if (h.canonical == "و" || h.canonical == "ف"), j + 1 < hyp.count {
        let host = hyp[j + 1]
        let merged = h.canonical + host.canonical
        if expectedSet.contains(merged) {
          // Prefer host index for pronunciation FA (more phonetic content).
          out.append(TrackedToken(canonical: merged, pronIndex: host.pronIndex))
          j += 2
          continue
        }
      }
      out.append(h)
      j += 1
    }
    return out
  }

  private static func peelLeadingClitic(_ word: String) -> (clitic: String?, rest: String) {
    let scalars = Array(word.unicodeScalars)
    var i = 0
    while i < scalars.count && isIgnorableMark(scalars[i]) { i += 1 }
    guard i < scalars.count else { return (nil, word) }
    let cp = scalars[i].value
    guard cp == 0x0648 || cp == 0x0641 else { return (nil, word) }
    var j = i + 1
    while j < scalars.count && isIgnorableMark(scalars[j]) { j += 1 }
    let rest = String(String.UnicodeScalarView(scalars[j...]))
    if rest.isEmpty { return (nil, word) }
    let clitic = String(String.UnicodeScalarView(scalars[..<j]))
    return (clitic, rest)
  }

  private static func isIgnorableMark(_ scalar: UnicodeScalar) -> Bool {
    let v = scalar.value
    if (0x064B...0x0652).contains(v) || v == 0x0615 || v == 0x06E1 { return true }
    if v == 0x0640 { return true }
    if (0x06D6...0x06ED).contains(v) { return true }
    return false
  }

  /// Map canonical ops → legacy ``WordAlignOp`` so pronunciation + UI stay unchanged.
  /// `text` is lexicon Uthmani surface (UI only) — never used for alignment.
  private static func toLegacyOps(
    _ shadowOps: [CanonicalLexicalShadow.ShadowOp],
    words: [CanonicalLexiconStore.CanonicalWord],
    tracked: [TrackedToken]
  ) -> [TajweedLexicalScoring.WordAlignOp] {
    let byId = Dictionary(uniqueKeysWithValues: words.map { ($0.id, $0) })
    return shadowOps.map { op in
      let pronHyp: Int? = op.hypIndex.flatMap { hi in
        tracked.indices.contains(hi) ? tracked[hi].pronIndex : hi
      }
      switch op.op {
      case "match":
        let word = op.expectedWordId.flatMap { byId[$0] }
        return TajweedLexicalScoring.WordAlignOp(
          op: .match,
          expectedIndex: op.expectedWordId.flatMap { id in words.firstIndex(where: { $0.id == id }) },
          hypIndex: pronHyp,
          text: word?.uiText ?? op.expectedCanonical ?? "",
          reason: nil
        )
      case "sub":
        let word = op.expectedWordId.flatMap { byId[$0] }
        return TajweedLexicalScoring.WordAlignOp(
          op: .sub,
          expectedIndex: op.expectedWordId.flatMap { id in words.firstIndex(where: { $0.id == id }) },
          hypIndex: pronHyp,
          text: word?.uiText ?? op.expectedCanonical ?? "",
          reason: TajweedLexicalScoring.MismatchReason.model
        )
      case "miss":
        let word = op.expectedWordId.flatMap { byId[$0] }
        return TajweedLexicalScoring.WordAlignOp(
          op: .miss,
          expectedIndex: op.expectedWordId.flatMap { id in words.firstIndex(where: { $0.id == id }) },
          hypIndex: nil,
          text: word?.uiText ?? op.expectedCanonical ?? "",
          reason: TajweedLexicalScoring.MismatchReason.model
        )
      default:
        return TajweedLexicalScoring.WordAlignOp(
          op: .extra,
          expectedIndex: nil,
          hypIndex: pronHyp,
          text: op.hypCanonical ?? "",
          reason: TajweedLexicalScoring.MismatchReason.model
        )
      }
    }
  }
}
