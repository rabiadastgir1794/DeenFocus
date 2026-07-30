import Foundation

/// Restores a previously-active asset directory if a newer install fails partway
/// through activation. Used by `AssetAtomicInstaller`; factored out as its own type
/// so a future consumer can reuse just the rollback semantics if it composes
/// activation differently. Generic — no Tajweed/AI knowledge.
final class AssetRollbackManager {
  private let fm = FileManager.default

  /// Moves any existing `activeDir` out of the way into `previousDir` so activation
  /// can proceed. Call this before attempting to move a new staging dir into place.
  func snapshotBeforeActivation(activeDir: URL, previousDir: URL) throws {
    try? fm.removeItem(at: previousDir)
    if fm.fileExists(atPath: activeDir.path) {
      try fm.moveItem(at: activeDir, to: previousDir)
    }
  }

  /// Restores `previousDir` back to `activeDir` after a failed activation.
  func rollback(activeDir: URL, previousDir: URL) {
    guard fm.fileExists(atPath: previousDir.path) else { return }
    try? fm.removeItem(at: activeDir)
    try? fm.moveItem(at: previousDir, to: activeDir)
  }

  /// Called after a successful activation — the rollback point is no longer needed.
  func discardPrevious(previousDir: URL) {
    try? fm.removeItem(at: previousDir)
  }
}
