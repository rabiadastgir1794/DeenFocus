import Foundation

/// Generic atomic staging -> active swap with automatic rollback on failure.
///
/// **Not used by Tajweed today.** Tajweed's `ModelStore.installFromDirectory`
/// already implements this exact pattern and is intentionally left unmodified
/// (ADR-008 requirement: do not touch ModelStore verification/activation/rollback).
/// This type exists so a *future* asset consumer without its own
/// ModelStore-equivalent (translations, TTS voices, OCR, ...) gets the same
/// atomic-install safety for free, as the first non-Tajweed use of this framework.
final class AssetAtomicInstaller {
  private let fm = FileManager.default
  private let rollbackManager: AssetRollbackManager

  init(rollbackManager: AssetRollbackManager = AssetRollbackManager()) {
    self.rollbackManager = rollbackManager
  }

  /// Moves `stagingDir` to `activeDir`, keeping `previousDir` as a rollback point.
  /// If the move fails, restores whatever was previously active and rethrows —
  /// an interrupted or failed activation can never leave the currently active
  /// asset in a corrupted or missing state.
  func activate(stagingDir: URL, activeDir: URL, previousDir: URL) throws {
    try fm.createDirectory(at: activeDir.deletingLastPathComponent(), withIntermediateDirectories: true)
    try rollbackManager.snapshotBeforeActivation(activeDir: activeDir, previousDir: previousDir)
    do {
      try fm.moveItem(at: stagingDir, to: activeDir)
    } catch {
      rollbackManager.rollback(activeDir: activeDir, previousDir: previousDir)
      throw AssetDownloadError.diskError("Activation failed: \(error.localizedDescription)")
    }
    rollbackManager.discardPrevious(previousDir: previousDir)
  }
}
