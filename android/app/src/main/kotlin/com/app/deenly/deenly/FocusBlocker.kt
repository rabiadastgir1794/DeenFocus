package com.app.deenly.deenly

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent
import java.io.ByteArrayOutputStream

private const val focusPrefsName = "focus_enforcement"
private const val selectedPackagesKey = "selected_packages"
private const val isLockedKey = "is_locked"
private const val activeModeKey = "active_mode"
private const val lockReasonKey = "lock_reason"
private const val nextChangeAtKey = "next_change_at"
private const val syncGenerationKey = "sync_generation"

object FocusBlockerStore {
    fun save(
        context: Context,
        selectedPackages: List<String>,
        activeMode: String?,
        isLocked: Boolean,
        lockReason: String?,
        nextChangeAt: String?,
    ) {
        val syncGeneration = System.currentTimeMillis()
        prefs(context).edit()
            .putStringSet(selectedPackagesKey, selectedPackages.toSet())
            .putString(activeModeKey, activeMode)
            .putBoolean(isLockedKey, isLocked)
            .putString(lockReasonKey, lockReason)
            .putString(nextChangeAtKey, nextChangeAt)
            .putLong(syncGenerationKey, syncGeneration)
            .commit()
    }

    fun isPackageBlocked(context: Context, packageName: String): Boolean {
        val prefs = prefs(context)
        if (!prefs.getBoolean(isLockedKey, false)) return false
        return prefs.getStringSet(selectedPackagesKey, emptySet()).orEmpty().contains(packageName)
    }

    fun currentState(context: Context): FocusBlockState {
        val prefs = prefs(context)
        return FocusBlockState(
            selectedPackages =
                prefs.getStringSet(selectedPackagesKey, emptySet()).orEmpty(),
            isLocked = prefs.getBoolean(isLockedKey, false),
            activeMode = prefs.getString(activeModeKey, null),
            lockReason = prefs.getString(lockReasonKey, null),
            nextChangeAt = prefs.getString(nextChangeAtKey, null),
            syncGeneration = prefs.getLong(syncGenerationKey, 0L),
        )
    }

    fun appLabel(context: Context, packageName: String): String {
        return runCatching {
            val pm = context.packageManager
            val info = pm.getApplicationInfo(packageName, 0)
            pm.getApplicationLabel(info).toString()
        }.getOrDefault(packageName)
    }

    private fun prefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(focusPrefsName, Context.MODE_PRIVATE)
    }
}

data class FocusBlockState(
    val selectedPackages: Set<String>,
    val isLocked: Boolean,
    val activeMode: String?,
    val lockReason: String?,
    val nextChangeAt: String?,
    val syncGeneration: Long,
)

fun isFocusAccessibilityServiceEnabled(context: Context): Boolean {
    val expectedComponent = ComponentName(context, FocusAccessibilityService::class.java)
    val enabledServices = Settings.Secure.getString(
        context.contentResolver,
        Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
    ).orEmpty()

    return enabledServices.split(':').any {
        ComponentName.unflattenFromString(it) == expectedComponent
    }
}

fun openFocusAccessibilitySettings(context: Context) {
    val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS).apply {
        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    }
    context.startActivity(intent)
}

fun drawableToPngBytes(drawable: Drawable): ByteArray {
    val bitmap = when (drawable) {
        is BitmapDrawable -> drawable.bitmap
        else -> {
            val width = drawable.intrinsicWidth.takeIf { it > 0 } ?: 96
            val height = drawable.intrinsicHeight.takeIf { it > 0 } ?: 96
            Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888).also { bitmap ->
                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)
            }
        }
    }

    return ByteArrayOutputStream().use { output ->
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, output)
        output.toByteArray()
    }
}

class FocusAccessibilityService : AccessibilityService() {
    private var lastBlockedPackage: String? = null
    private var lastBlockedAtMillis: Long = 0L
    private var lastSeenSyncGeneration: Long = 0L

    override fun onServiceConnected() {
        serviceInfo = serviceInfo.apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                AccessibilityEvent.TYPE_WINDOWS_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            notificationTimeout = 100
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        val packageName = event?.packageName?.toString() ?: return
        if (packageName == applicationContext.packageName) return
        if (packageName == "com.android.settings") return

        val state = FocusBlockerStore.currentState(applicationContext)
        if (state.syncGeneration != lastSeenSyncGeneration) {
            lastSeenSyncGeneration = state.syncGeneration
            lastBlockedPackage = null
            lastBlockedAtMillis = 0L
        }

        if (!state.isLocked || !state.selectedPackages.contains(packageName)) {
            if (lastBlockedPackage == packageName) {
                lastBlockedPackage = null
                lastBlockedAtMillis = 0L
            }
            return
        }

        val now = System.currentTimeMillis()
        if (lastBlockedPackage == packageName && now - lastBlockedAtMillis < 900) return
        lastBlockedPackage = packageName
        lastBlockedAtMillis = now

        val intent = Intent(applicationContext, FocusBlockedActivity::class.java).apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS,
            )
            putExtra("blockedPackage", packageName)
            putExtra("blockedAppName", FocusBlockerStore.appLabel(applicationContext, packageName))
            putExtra("activeMode", state.activeMode)
            putExtra("lockReason", state.lockReason)
            putExtra("nextChangeAt", state.nextChangeAt)
        }
        startActivity(intent)
    }

    override fun onInterrupt() = Unit
}
