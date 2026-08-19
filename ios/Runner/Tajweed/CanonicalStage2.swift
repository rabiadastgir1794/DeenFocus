import Foundation

/// Stage-2 spoken-letter fold for ADR-010 canonical lexicon (shadow path only).
/// Independent of ``TajweedLexicalScoring.normalizeArabic``.
enum CanonicalStage2 {
  private static let diacritics = CharacterSet(charactersIn:
    "\u{064B}\u{064C}\u{064D}\u{064E}\u{064F}\u{0650}\u{0651}\u{0652}\u{0615}\u{06E1}" +
    "\u{0653}\u{0654}\u{0655}\u{0656}\u{0657}\u{0658}\u{0659}\u{065A}\u{065B}\u{065C}\u{065D}\u{065E}\u{065F}"
  )
  private static let formatControls = CharacterSet(charactersIn:
    "\u{200B}\u{200C}\u{200D}\u{FEFF}\u{00A0}\u{202F}\u{2009}\u{200A}\u{2060}\u{061C}\u{066D}"
  )

  static func letterstream(_ text: String) -> String {
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
        while j < scalars.count && isIgnorableMark(scalars[j]) { j += 1 }
        let next: Int
        if j >= scalars.count || CharacterSet.whitespacesAndNewlines.contains(scalars[j]) {
          next = -1
        } else {
          next = Int(scalars[j].value)
        }
        let drop: Bool
        if next >= 0 {
          let nu = UInt32(next)
          drop = isHehFamily(nu) || isYaFamily(nu) || isKafFamily(nu) || nu == 0x0644
        } else {
          let prev = previousBaseCode(scalars: scalars, index: i)
          drop = prev >= 0 && isYaFamily(UInt32(prev))
        }
        if !drop {
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
      if isIgnorableMark(scalar) {
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

    var s = String(out)
    for (a, b) in [
      ("أ", "ا"), ("إ", "ا"), ("آ", "ا"), ("ى", "ي"), ("ک", "ك"), ("ی", "ي"),
      ("الائك", "الئك"), ("اولائك", "اولئك"),
    ] {
      s = s.replacingOccurrences(of: a, with: b)
    }
    s = s.replacingOccurrences(of: "صلوه", with: "صلاه")
    return s
  }

  static func word(_ text: String) -> String {
    letterstream(text)
  }

  static func splitWords(_ text: String) -> [String] {
    text
      .split(whereSeparator: { $0.isWhitespace })
      .map(String.init)
      .filter { !$0.isEmpty && !word($0).isEmpty }
  }

  private static func isIgnorableMark(_ scalar: UnicodeScalar) -> Bool {
    let v = scalar.value
    if diacritics.contains(scalar) { return true }
    if v == 0x0640 { return true }
    if (0x06D6...0x06ED).contains(v) { return true }
    if formatControls.contains(scalar) { return true }
    return false
  }

  private static func previousBaseCode(scalars: [UnicodeScalar], index: Int) -> Int {
    var k = index - 1
    while k >= 0 {
      let s = scalars[k]
      if CharacterSet.whitespacesAndNewlines.contains(s) { k -= 1; continue }
      if isIgnorableMark(s) { k -= 1; continue }
      return Int(s.value)
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

  private static func isKafFamily(_ code: UInt32) -> Bool {
    switch code {
    case 0x0643, 0x06A9: return true
    default: return false
    }
  }
}
