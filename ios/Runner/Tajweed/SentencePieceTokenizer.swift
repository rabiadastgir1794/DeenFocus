import Foundation

/// Lightweight SentencePiece-compatible encode/decode using `tokens.txt`.
/// Decode matches SP piece join; encode uses greedy longest-match over the vocab
/// (adequate for Phase 2; golden tests should compare diacritic-insensitive text).
final class SentencePieceTokenizer {
  private var idToPiece: [String] = []
  private var pieceToId: [String: Int] = [:]
  private var piecesByLength: [String] = []

  init(tokensFileURL: URL) throws {
    let text = try String(contentsOf: tokensFileURL, encoding: .utf8)
    var pieces: [String] = []
    for line in text.split(whereSeparator: \.isNewline) {
      let parts = line.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false)
      guard parts.count >= 1 else { continue }
      let piece = String(parts[0])
      let id = pieces.count
      pieces.append(piece)
      pieceToId[piece] = id
    }
    guard !pieces.isEmpty else {
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "Empty tokens.txt")
    }
    idToPiece = pieces
    piecesByLength = pieces.sorted { $0.count > $1.count }
  }

  func decode(_ ids: [Int]) -> String {
    var raw = ""
    for id in ids {
      guard id >= 0, id < idToPiece.count else { continue }
      raw += idToPiece[id]
    }
    // SentencePiece: ▁ marks word boundary / space
    return raw.replacingOccurrences(of: "▁", with: " ").trimmingCharacters(in: .whitespaces)
  }

  func encode(_ text: String) -> [Int] {
    // Mirror SP: leading ▁ for word starts.
    var normalized = text.trimmingCharacters(in: .whitespacesAndNewlines)
    if !normalized.isEmpty, !normalized.hasPrefix("▁") {
      normalized = "▁" + normalized.replacingOccurrences(of: " ", with: "▁")
    }
    var ids: [Int] = []
    var i = normalized.startIndex
    while i < normalized.endIndex {
      var matched = false
      for piece in piecesByLength {
        if normalized[i...].hasPrefix(piece), let id = pieceToId[piece] {
          ids.append(id)
          i = normalized.index(i, offsetBy: piece.count)
          matched = true
          break
        }
      }
      if !matched {
        // Skip unknown scalar
        i = normalized.index(after: i)
      }
    }
    return ids
  }

  func piece(for id: Int) -> String {
    guard id >= 0, id < idToPiece.count else { return "" }
    return idToPiece[id].replacingOccurrences(of: "▁", with: "")
  }

  /// True when `id`'s raw piece carries the SentencePiece "▁" word-start marker — i.e. this
  /// piece begins a new Quran word rather than continuing the previous one. Used to group
  /// per-piece forced-align intervals back into whole-word tokens.
  func startsNewWord(_ id: Int) -> Bool {
    guard id >= 0, id < idToPiece.count else { return false }
    return idToPiece[id].hasPrefix("▁")
  }
}
