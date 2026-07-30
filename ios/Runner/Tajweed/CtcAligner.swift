import Foundation

/// `tokenIndex` is the position within the `tokenIds` sequence passed to `forcedAlign` —
/// needed (in addition to `tokenId`, the vocab id, which can repeat) to map an interval back
/// to which expected word it belongs to.
struct TokenInterval {
  let tokenId: Int
  let tokenIndex: Int
  let startFrame: Int
  let endFrame: Int
  var startSec: Double { Double(startFrame) * 0.08 }
  var endSec: Double { Double(endFrame) * 0.08 }
}

/// CTC forced alignment (port of vendor/tajweed/aligner.py::ctc_forced_align).
enum CtcAligner {
  static let blankId = 1024
  private static let negInf = -1e18

  static func forcedAlign(logprobs: [[Float]], tokenIds: [Int]) throws -> [TokenInterval] {
    let T = logprobs.count
    guard T > 0, let V = logprobs.first?.count, V > blankId else {
      throw TajweedNativeError(TajweedErrorCode.inferenceFailed, "Invalid logprobs.")
    }
    guard !tokenIds.isEmpty else { return [] }

    var seq: [Int] = [blankId]
    for t in tokenIds {
      seq.append(t)
      seq.append(blankId)
    }
    let S = seq.count
    guard T >= S / 2 else {
      throw TajweedNativeError(
        TajweedErrorCode.audioTooShort,
        "Audio too short for alignment (T=\(T), need >= \(S / 2))."
      )
    }

    var alpha = Array(repeating: Array(repeating: negInf, count: S), count: T)
    var back = Array(repeating: Array(repeating: Int8(0), count: S), count: T)

    var skipOk = Array(repeating: false, count: S)
    if S >= 3 {
      for s in 2..<S {
        skipOk[s] = seq[s] != blankId && seq[s] != seq[s - 2]
      }
    }

    func emit(_ t: Int, _ s: Int) -> Double {
      Double(logprobs[t][seq[s]])
    }

    alpha[0][0] = emit(0, 0)
    if S > 1 { alpha[0][1] = emit(0, 1) }

    for t in 1..<T {
      for s in 0..<S {
        var best = alpha[t - 1][s]
        var bestIdx: Int8 = 0
        if s >= 1, alpha[t - 1][s - 1] > best {
          best = alpha[t - 1][s - 1]
          bestIdx = 1
        }
        if s >= 2, skipOk[s], alpha[t - 1][s - 2] > best {
          best = alpha[t - 1][s - 2]
          bestIdx = 2
        }
        alpha[t][s] = best + emit(t, s)
        back[t][s] = -bestIdx
      }
    }

    var s = S - 1
    if S >= 2, alpha[T - 1][S - 2] > alpha[T - 1][S - 1] {
      s = S - 2
    }

    var path = Array(repeating: 0, count: T)
    path[T - 1] = s
    for t in stride(from: T - 1, through: 1, by: -1) {
      s = s + Int(back[t][s])
      path[t - 1] = s
    }

    var intervals: [TokenInterval] = []
    var tokenIndex = 0
    var start: Int?
    for t in 0..<T {
      let state = path[t]
      let isToken = state % 2 == 1
      if isToken {
        let thisToken = state / 2
        if start == nil {
          start = t
          tokenIndex = thisToken
        } else if thisToken != tokenIndex {
          intervals.append(
            TokenInterval(tokenId: tokenIds[tokenIndex], tokenIndex: tokenIndex, startFrame: start!, endFrame: t)
          )
          start = t
          tokenIndex = thisToken
        }
      } else if let st = start {
        intervals.append(
          TokenInterval(tokenId: tokenIds[tokenIndex], tokenIndex: tokenIndex, startFrame: st, endFrame: t)
        )
        start = nil
      }
    }
    if let st = start, tokenIndex < tokenIds.count {
      intervals.append(
        TokenInterval(tokenId: tokenIds[tokenIndex], tokenIndex: tokenIndex, startFrame: st, endFrame: T)
      )
    }
    return intervals
  }
}
