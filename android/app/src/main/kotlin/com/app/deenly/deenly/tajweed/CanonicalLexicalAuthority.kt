package com.rnr.deenfocus.tajweed

import android.content.Context
import android.util.Log

/**
 * ADR-010 canonical lexicon is the **production** lexical authority on all
 * builds. Legacy display-string alignment is no longer selectable.
 */
object CanonicalLexicalAuthority {
    const val PREFS_NAME = "tajweed_canonical"
    const val KEY = "canonicalLexicalProductionEnabled"

    @Volatile
    private var prefs: android.content.SharedPreferences? = null

    @Synchronized
    fun init(context: Context) {
        if (prefs == null) {
            prefs = context.applicationContext.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        }
    }

    /** Always `true` — Canonical is the production lexical scorer. */
    var productionEnabled: Boolean
        get() = true
        set(value) {
            // Ignored — Canonical is always on. Kept so older MethodChannel
            // clients that assign the flag do not crash.
            Log.i(
                "TajweedCanonical",
                "set productionEnabled=$value ignored (Canonical is always on)",
            )
        }

    fun clearOverride() {
        prefs?.edit()?.remove(KEY)?.commit()
    }

    fun parseEnabledArgument(raw: Any?): Boolean? {
        return when (raw) {
            is Boolean -> raw
            is Number -> raw.toInt() != 0
            else -> null
        }
    }
}
