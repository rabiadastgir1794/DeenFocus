package com.app.deenly.deenly

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.os.Build
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent
import java.io.ByteArrayOutputStream
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

private const val focusPrefsName = "focus_enforcement"
private const val selectedPackagesKey = "selected_packages"
private const val isLockedKey = "is_locked"
private const val activeModeKey = "active_mode"
private const val lockReasonKey = "lock_reason"
private const val nextChangeAtKey = "next_change_at"
private const val syncGenerationKey = "sync_generation"
private const val focusScheduleAction = "com.app.deenly.deenly.FOCUS_SCHEDULE"
private const val focusScheduleIdBase = 6100
private const val focusScheduleMaxCount = 64
private const val focusDebugFileName = "deenly_focus_debug_log.txt"

object FocusDebugLogger {
    private val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.US)

    @Synchronized
    fun append(context: Context, tag: String, message: String) {
        runCatching {
            val file = file(context)
            file.parentFile?.mkdirs()
            file.appendText("${formatter.format(Date())} [$tag] $message\n")
        }
    }

    @Synchronized
    fun clear(context: Context) {
        runCatching {
            val file = file(context)
            if (file.exists()) {
                file.writeText("")
            } else {
                file.parentFile?.mkdirs()
                file.createNewFile()
            }
            file.appendText("${formatter.format(Date())} [logger] cleared\n")
        }
    }

    fun path(context: Context): String {
        return file(context).absolutePath
    }

    private fun file(context: Context): File {
        val baseDir =
            context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS) ?: context.filesDir
        return File(baseDir, focusDebugFileName)
    }
}

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
        FocusDebugLogger.append(
            context,
            "store.save",
            "packages=${selectedPackages.size} activeMode=$activeMode isLocked=$isLocked nextChangeAt=$nextChangeAt reason=$lockReason",
        )
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

    val enabled = enabledServices.split(':').any {
        ComponentName.unflattenFromString(it) == expectedComponent
    }
    FocusDebugLogger.append(
        context,
        "permission.enabled",
        "enabled=$enabled raw=$enabledServices",
    )
    return enabled
}

fun isFocusAccessibilityServiceReady(context: Context): Boolean {
    val ready = isFocusAccessibilityServiceEnabled(context) && FocusAccessibilityService.isConnected
    FocusDebugLogger.append(
        context,
        "permission.ready",
        "ready=$ready connected=${FocusAccessibilityService.isConnected}",
    )
    return ready
}

fun openFocusAccessibilitySettings(context: Context) {
    FocusDebugLogger.append(context, "permission.settings", "opening accessibility settings")
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
    companion object {
        @Volatile
        var isConnected: Boolean = false
            private set
    }

    private var lastBlockedPackage: String? = null
    private var lastBlockedAtMillis: Long = 0L
    private var lastSeenSyncGeneration: Long = 0L
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onServiceConnected() {
        super.onServiceConnected()
        isConnected = true
        FocusDebugLogger.append(applicationContext, "service.connected", "accessibility service connected")
        serviceInfo = serviceInfo.apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                AccessibilityEvent.TYPE_WINDOWS_CHANGED or
                AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            notificationTimeout = 100
        }
    }

    override fun onDestroy() {
        isConnected = false
        FocusDebugLogger.append(applicationContext, "service.destroy", "accessibility service destroyed")
        super.onDestroy()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        val packageName = event?.packageName?.toString() ?: return
        if (packageName == applicationContext.packageName) return
        if (packageName == "com.android.settings") return

        val state = FocusBlockerStore.currentState(applicationContext)
        FocusDebugLogger.append(
            applicationContext,
            "service.event",
            "type=${event.eventType} package=$packageName locked=${state.isLocked} selected=${state.selectedPackages.contains(packageName)} mode=${state.activeMode}",
        )
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

        FocusDebugLogger.append(
            applicationContext,
            "service.block",
            "blocking package=$packageName mode=${state.activeMode} nextChangeAt=${state.nextChangeAt}",
        )
        performGlobalAction(GLOBAL_ACTION_HOME)

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
        mainHandler.postDelayed({
            FocusDebugLogger.append(
                applicationContext,
                "service.block",
                "showing blocked activity for package=$packageName",
            )
            startActivity(intent)
        }, 120L)
    }

    override fun onInterrupt() {
        FocusDebugLogger.append(applicationContext, "service.interrupt", "accessibility service interrupted")
    }
}

object FocusScheduleManager {
    fun sync(
        context: Context,
        transitions: List<Map<String, Any?>>,
    ) {
        FocusDebugLogger.append(
            context,
            "schedule.sync",
            "received ${transitions.size} transitions path=${FocusDebugLogger.path(context)}",
        )
        cancelAll(context)

        transitions.take(focusScheduleMaxCount).forEachIndexed { index, transition ->
            val at = transition["at"] as? String ?: return@forEachIndexed
            val atMillis = (transition["atMillis"] as? Number)?.toLong() ?: return@forEachIndexed
            val isLocked = transition["isLocked"] as? Boolean ?: return@forEachIndexed
            val activeMode = transition["activeMode"] as? String
            val lockReason = transition["lockReason"] as? String
            val nextChangeAt = transition["nextChangeAt"] as? String
            schedule(
                context = context,
                requestCode = focusScheduleIdBase + index,
                at = at,
                atMillis = atMillis,
                isLocked = isLocked,
                activeMode = activeMode,
                lockReason = lockReason,
                nextChangeAt = nextChangeAt,
            )
        }
    }

    private fun schedule(
        context: Context,
        requestCode: Int,
        at: String,
        atMillis: Long,
        isLocked: Boolean,
        activeMode: String?,
        lockReason: String?,
        nextChangeAt: String?,
    ) {
        if (atMillis <= System.currentTimeMillis()) return
        FocusDebugLogger.append(
            context,
            "schedule.set",
            "requestCode=$requestCode at=$at atMillis=$atMillis isLocked=$isLocked mode=$activeMode nextChangeAt=$nextChangeAt",
        )

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pendingIntent = pendingIntent(
            context = context,
            requestCode = requestCode,
            at = at,
            isLocked = isLocked,
            activeMode = activeMode,
            lockReason = lockReason,
            nextChangeAt = nextChangeAt,
            flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        ) ?: return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && alarmManager.canScheduleExactAlarms()) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                atMillis,
                pendingIntent,
            )
            return
        }

        alarmManager.setAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            atMillis,
            pendingIntent,
        )
    }

    fun cancelAll(context: Context) {
        FocusDebugLogger.append(context, "schedule.clear", "clearing scheduled transitions")
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        repeat(focusScheduleMaxCount) { index ->
            val requestCode = focusScheduleIdBase + index
            val pendingIntent = pendingIntent(
                context = context,
                requestCode = requestCode,
                at = "",
                isLocked = false,
                activeMode = null,
                lockReason = null,
                nextChangeAt = null,
                flags = PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE,
            )
            if (pendingIntent != null) {
                alarmManager.cancel(pendingIntent)
                pendingIntent.cancel()
            }
        }
    }

    private fun pendingIntent(
        context: Context,
        requestCode: Int,
        at: String,
        isLocked: Boolean,
        activeMode: String?,
        lockReason: String?,
        nextChangeAt: String?,
        flags: Int,
    ): PendingIntent? {
        val intent = Intent(context, FocusScheduleReceiver::class.java).apply {
            action = focusScheduleAction
            putExtra("at", at)
            putExtra("isLocked", isLocked)
            putExtra("activeMode", activeMode)
            putExtra("lockReason", lockReason)
            putExtra("nextChangeAt", nextChangeAt)
        }
        return PendingIntent.getBroadcast(context, requestCode, intent, flags)
    }
}

class FocusScheduleReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action != focusScheduleAction) return

        FocusDebugLogger.append(
            context,
            "schedule.fire",
            "action=${intent.action} isLocked=${intent.getBooleanExtra("isLocked", false)} mode=${intent.getStringExtra("activeMode")} nextChangeAt=${intent.getStringExtra("nextChangeAt")}",
        )
        val current = FocusBlockerStore.currentState(context)
        FocusBlockerStore.save(
            context = context,
            selectedPackages = current.selectedPackages.toList(),
            activeMode = intent.getStringExtra("activeMode"),
            isLocked = intent.getBooleanExtra("isLocked", false),
            lockReason = intent.getStringExtra("lockReason"),
            nextChangeAt = intent.getStringExtra("nextChangeAt"),
        )
    }
}
