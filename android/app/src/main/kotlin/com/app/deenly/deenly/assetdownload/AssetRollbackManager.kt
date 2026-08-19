package com.rnr.deenfocus.assetdownload

import java.io.File

/**
 * Restores a previously-active asset directory if a newer install fails partway
 * through activation. Used by [AssetAtomicInstaller]; factored out as its own type
 * so a future consumer can reuse just the rollback semantics if it composes
 * activation differently. Generic — no Tajweed/AI knowledge.
 */
class AssetRollbackManager {

    /**
     * Moves any existing [activeDir] out of the way into [previousDir] so
     * activation can proceed. Call this before moving a new staging dir into place.
     */
    fun snapshotBeforeActivation(activeDir: File, previousDir: File) {
        previousDir.deleteRecursively()
        if (activeDir.exists()) {
            if (!activeDir.renameTo(previousDir)) {
                activeDir.copyRecursively(previousDir, overwrite = true)
                activeDir.deleteRecursively()
            }
        }
    }

    /** Restores [previousDir] back to [activeDir] after a failed activation. */
    fun rollback(activeDir: File, previousDir: File) {
        if (!previousDir.exists()) return
        activeDir.deleteRecursively()
        previousDir.renameTo(activeDir)
    }

    /** Called after a successful activation — the rollback point is no longer needed. */
    fun discardPrevious(previousDir: File) {
        previousDir.deleteRecursively()
    }
}
