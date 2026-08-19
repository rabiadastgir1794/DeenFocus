import Foundation

/// ADR-010 canonical lexicon is the **production** lexical authority on all
/// builds (Debug / Profile / Release). Legacy display-string alignment is no
/// longer selectable.
enum CanonicalLexicalAuthority {
  static let defaultsKey = "canonicalLexicalProductionEnabled"

  /// Always `true` — Canonical is the production lexical scorer.
  static var productionEnabled: Bool {
    get { true }
    set {
      // Ignored — Canonical is always on. Kept so older MethodChannel clients
      // and tests that assign the flag do not crash.
      NSLog(
        "[TajweedCanonical] set productionEnabled=%@ ignored (Canonical is always on)",
        newValue ? "YES" : "NO"
      )
    }
  }

  static func clearOverride() {
    UserDefaults.standard.removeObject(forKey: defaultsKey)
    UserDefaults.standard.synchronize()
  }

  /// Flutter MethodChannel may deliver Bool as NSNumber — accept both.
  static func parseEnabledArgument(_ raw: Any?) -> Bool? {
    if let b = raw as? Bool { return b }
    if let n = raw as? NSNumber { return n.boolValue }
    if let i = raw as? Int { return i != 0 }
    return nil
  }
}
