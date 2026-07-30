package com.rnr.deenfocus.assetdownload

import java.io.File

/**
 * Generic atomic staging -> active swap with automatic rollback on failure.
 *
 * **Not used by Tajweed today.** Tajweed's `ModelStore.installFromDirectory`
 * already implements this exact pattern and is intentionally left unmodified
 * (ADR-008 requirement: do not touch ModelStore verification/activation/rollback).
 * This type exists so a *future* asset consumer without its own
 * ModelStore-equivalent (translations, TTS voices, OCR, ...) gets the same
 * atomic-install safety for free, as the first non-Tajweed use of this framework.
 */
class AssetAtomicInstaller(
    private val rollbackManager: AssetRollbackManager = AssetRollbackManager(),
) {
    /**
     * Moves [stagingDir] to [activeDir], keeping [previousDir] as a rollback point.
     * If the move fails, restores whatever was previously active and rethrows — an
     * interrupted or failed activation can never leave the currently active asset
     * in a corrupted or missing state.
     */
    fun activate(stagingDir: File, activeDir: File, previousDir: File) {
        activeDir.parentFile?.mkdirs()
        rollbackManager.snapshotBeforeActivation(activeDir, previousDir)
        try {
            if (!stagingDir.renameTo(activeDir)) {
                stagingDir.copyRecursively(activeDir, overwrite = true)
                stagingDir.deleteRecursively()
            }
        } catch (e: Exception) {
            rollbackManager.rollback(activeDir, previousDir)
            throw AssetDownloadException.DiskError("Activation failed: ${e.message}")
        }
        rollbackManager.discardPrevious(previousDir)
    }
}
