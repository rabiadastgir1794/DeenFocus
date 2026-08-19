import Foundation

enum CtcDecoder {
  static let blankId = 1024

  static func collapse(_ ids: [Int], blankId: Int = blankId) -> [Int] {
    var out: [Int] = []
    var prev = -1
    for i in ids {
      if i == blankId {
        prev = -1
        continue
      }
      if i != prev {
        out.append(i)
      }
      prev = i
    }
    return out
  }
}
