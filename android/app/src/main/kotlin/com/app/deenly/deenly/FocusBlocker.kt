package com.rnr.deenfocus

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.ContentValues
import android.content.pm.ApplicationInfo
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.os.Build
import android.os.SystemClock
import android.provider.MediaStore
import android.provider.Settings
import android.view.accessibility.AccessibilityEvent
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayOutputStream
import java.io.File
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import kotlin.math.abs

private const val focusPrefsName = "focus_enforcement"
private const val selectedPackagesKey = "selected_packages"
private const val isLockedKey = "is_locked"
private const val activeModeKey = "active_mode"
private const val lockReasonKey = "lock_reason"
private const val nextChangeAtKey = "next_change_at"
private const val syncGenerationKey = "sync_generation"
private const val scheduledTransitionsKey = "scheduled_transitions"
private const val focusScheduleAction = "com.app.deenly.deenly.FOCUS_SCHEDULE"
private const val focusScheduleIdBase = 6100
private const val focusScheduleMaxCount = 160
private const val focusDebugFileName = "deenly_focus_debug_log.txt"
private const val focusDebugSectionPrefs = "focus_debug_log_sections"
private const val focusDebugKeyLastDate = "last_section_date"
private const val focusDebugKeyLastHour = "last_section_hour"
private const val focusDebugDownloadsUriKey = "debug_log_downloads_content_uri"

private const val nightDisciplineEnabledKey = "night_discipline_enabled"
private const val nightStartHourKey = "night_start_hour"
private const val nightStartMinuteKey = "night_start_minute"
private const val nightEndHourKey = "night_end_hour"
private const val nightEndMinuteKey = "night_end_minute"

object FocusDebugLogger {
    private val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.US)
    private val dateKeyFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
    private val hourKeyFormat = SimpleDateFormat("yyyy-MM-dd-HH", Locale.US)
    private val dateBannerFormat = SimpleDateFormat("dd MMMM, yyyy", Locale.US)
    private val hourBannerFormat = SimpleDateFormat("HH:mm", Locale.US)

    /** Canonical copy — always writable, survives MediaStore quirks. */
    private fun logFile(context: Context): File = File(context.filesDir, focusDebugFileName)

    private fun sectionPrefs(context: Context): SharedPreferences {
        return context.getSharedPreferences(focusDebugSectionPrefs, Context.MODE_PRIVATE)
    }

    /**
     * Public Downloads copy (API 29+): one MediaStore row; URI cached in prefs so we never
     * `insert` on every line (that caused hundreds of duplicate files).
     */
    private fun appendPublicDownloadsMirror(context: Context, text: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appendPublicDownloadsMirrorQ(context, text)
        } else {
            runCatching {
                val file =
                    File(
                        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                        focusDebugFileName,
                    )
                file.parentFile?.mkdirs()
                file.appendText(text)
            }
        }
    }

    private fun appendPublicDownloadsMirrorQ(context: Context, text: String) {
        val resolver = context.contentResolver
        val prefs = sectionPrefs(context)
        val uriStr = prefs.getString(focusDebugDownloadsUriKey, null)
        val existing = uriStr?.let { Uri.parse(it) }
        if (existing != null) {
            val ok =
                runCatching {
                    resolver.openOutputStream(existing, "wa")?.use { out ->
                        out.write(text.toByteArray(Charsets.UTF_8))
                    } != null
                }.getOrDefault(false)
            if (ok) return
            runCatching { resolver.delete(existing, null, null) }
            prefs.edit().remove(focusDebugDownloadsUriKey).apply()
        }
        val full =
            runCatching { logFile(context).readText(Charsets.UTF_8) }.getOrElse { text }
        createNewDownloadsDocument(context, full, prefs)
    }

    private fun createNewDownloadsDocument(
        context: Context,
        contents: String,
        prefs: SharedPreferences,
    ) {
        val resolver = context.contentResolver
        val values =
            ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, focusDebugFileName)
                put(MediaStore.Downloads.MIME_TYPE, "text/plain")
                put(MediaStore.Downloads.RELATIVE_PATH, "${Environment.DIRECTORY_DOWNLOADS}/")
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
        val doc = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values) ?: return
        try {
            resolver.openOutputStream(doc, "wt")?.use { out ->
                out.write(contents.toByteArray(Charsets.UTF_8))
            } ?: run {
                resolver.delete(doc, null, null)
                return
            }
            resolver.update(
                doc,
                ContentValues().apply { put(MediaStore.Downloads.IS_PENDING, 0) },
                null,
                null,
            )
            prefs.edit().putString(focusDebugDownloadsUriKey, doc.toString()).apply()
        } catch (_: Throwable) {
            runCatching { resolver.delete(doc, null, null) }
        }
    }

    private fun clearPublicDownloadsMirror(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val prefs = sectionPrefs(context)
            prefs.getString(focusDebugDownloadsUriKey, null)?.let { s ->
                runCatching { context.contentResolver.delete(Uri.parse(s), null, null) }
            }
            prefs.edit().remove(focusDebugDownloadsUriKey).apply()
        } else {
            runCatching {
                File(
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                    focusDebugFileName,
                ).delete()
            }
        }
    }

    /**
     * Builds optional date / hour banners, then the log line. Appends to existing file or creates it.
     */
    @Synchronized
    fun append(context: Context, tag: String, message: String) {
        runCatching {
            val now = Date()
            val prefs = sectionPrefs(context)
            val dateKey = dateKeyFormat.format(now)
            val hourKey = hourKeyFormat.format(now)
            val lastDate = prefs.getString(focusDebugKeyLastDate, null)
            val lastHour = prefs.getString(focusDebugKeyLastHour, null)

            val chunk = StringBuilder()
            if (lastDate != dateKey) {
                val banner = dateBannerFormat.format(now).uppercase(Locale.US)
                chunk.append("-------- $banner -------\n\n")
                prefs.edit()
                    .putString(focusDebugKeyLastDate, dateKey)
                    .putString(focusDebugKeyLastHour, hourKey)
                    .apply()
                val hm = hourBannerFormat.format(now)
                chunk.append("------ $hm ---\n")
            } else if (lastHour != hourKey) {
                val hm = hourBannerFormat.format(now)
                chunk.append("------ $hm ---\n")
                prefs.edit().putString(focusDebugKeyLastHour, hourKey).apply()
            }

            chunk.append("${formatter.format(now)} [$tag] $message\n")
            val text = chunk.toString()

            val file = logFile(context)
            file.parentFile?.mkdirs()
            file.appendText(text)
            appendPublicDownloadsMirror(context, text)
        }
    }

    @Synchronized
    fun clear(context: Context) {
        runCatching {
            sectionPrefs(context).edit()
                .remove(focusDebugKeyLastDate)
                .remove(focusDebugKeyLastHour)
                .apply()

            val now = Date()
            val banner = dateBannerFormat.format(now).uppercase(Locale.US)
            val hm = hourBannerFormat.format(now)
            val line =
                "-------- $banner -------\n\n------ $hm ---\n${formatter.format(now)} [logger] cleared\n"
            sectionPrefs(context).edit()
                .putString(focusDebugKeyLastDate, dateKeyFormat.format(now))
                .putString(focusDebugKeyLastHour, hourKeyFormat.format(now))
                .apply()

            clearPublicDownloadsMirror(context)
            val file = logFile(context)
            file.parentFile?.mkdirs()
            file.writeText(line)
            appendPublicDownloadsMirror(context, line)
        }
    }

    fun path(context: Context): String {
        val internal = logFile(context).absolutePath
        val publicHint =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                "${Environment.DIRECTORY_DOWNLOADS}/$focusDebugFileName"
            } else {
                File(
                    Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
                    focusDebugFileName,
                ).absolutePath
            }
        return "$internal | Public: $publicHint"
    }
}

object FocusBlockerStore {
    @Volatile
    private var lastWallClockMillis: Long? = null

    @Volatile
    private var lastElapsedRealtimeMillis: Long? = null

    private const val clockJumpThresholdMillis: Long = 90_000L

    fun save(
        context: Context,
        selectedPackages: List<String>,
        activeMode: String?,
        isLocked: Boolean,
        lockReason: String?,
        nextChangeAt: String?,
        nightDisciplineEnabled: Boolean? = null,
        nightStartHour: Int? = null,
        nightStartMinute: Int? = null,
        nightEndHour: Int? = null,
        nightEndMinute: Int? = null,
    ) {
        val syncGeneration = System.currentTimeMillis()
        val p = prefs(context)
        val prevLocked = p.getBoolean(isLockedKey, false)
        val prevMode = p.getString(activeModeKey, null)
        FocusDebugLogger.append(
            context,
            "store.save",
            "packages=${selectedPackages.size} activeMode=$activeMode isLocked=$isLocked nextChangeAt=$nextChangeAt reason=$lockReason",
        )
        val edit =
            p.edit()
                .putStringSet(selectedPackagesKey, selectedPackages.toSet())
                .putString(activeModeKey, activeMode)
                .putBoolean(isLockedKey, isLocked)
                .putString(lockReasonKey, lockReason)
                .putString(nextChangeAtKey, nextChangeAt)
                .putLong(syncGenerationKey, syncGeneration)
        if (nightDisciplineEnabled != null) {
            edit.putBoolean(nightDisciplineEnabledKey, nightDisciplineEnabled)
        }
        if (nightStartHour != null) edit.putInt(nightStartHourKey, nightStartHour)
        if (nightStartMinute != null) edit.putInt(nightStartMinuteKey, nightStartMinute)
        if (nightEndHour != null) edit.putInt(nightEndHourKey, nightEndHour)
        if (nightEndMinute != null) edit.putInt(nightEndMinuteKey, nightEndMinute)
        edit.commit()
        if (prevLocked != isLocked || prevMode != activeMode) {
            FocusDebugLogger.append(
                context,
                "store.lockTransition",
                "locked $prevLocked->$isLocked activeMode $prevMode->$activeMode reason=$lockReason nextChangeAt=$nextChangeAt",
            )
        }
    }

    fun isPackageBlocked(context: Context, packageName: String): Boolean {
        val state = currentState(context)
        if (!state.isLocked) return false
        return state.selectedPackages.contains(packageName)
    }

    /**
     * Matches iOS DeviceActivity monitor behavior: scheduled transitions (prayer / night windows) are
     * resolved against wall-clock time even after sleep/wake. We must not skip resolution when a
     * clock jump is detected — that previously left stored lock state stale and blocked apps after wake.
     */
    fun currentState(context: Context): FocusBlockState {
        val prefs = prefs(context)
        val storedState = FocusBlockState(
            selectedPackages =
                prefs.getStringSet(selectedPackagesKey, emptySet()).orEmpty(),
            isLocked = prefs.getBoolean(isLockedKey, false),
            activeMode = prefs.getString(activeModeKey, null),
            lockReason = prefs.getString(lockReasonKey, null),
            nextChangeAt = prefs.getString(nextChangeAtKey, null),
            syncGeneration = prefs.getLong(syncGenerationKey, 0L),
        )
        if (didClockJump(context)) {
            FocusDebugLogger.append(
                context,
                "store.resolve",
                "clock jump detected; still resolving scheduled transitions (wake/sleep must apply unlocks)",
            )
        }
        return correctNightDisciplineNextChangeOnAndroid(context, resolveScheduledState(context, storedState))
    }

    private fun didClockJump(context: Context): Boolean {
        val nowWall = System.currentTimeMillis()
        val nowElapsed = SystemClock.elapsedRealtime()
        val previousWall = lastWallClockMillis
        val previousElapsed = lastElapsedRealtimeMillis
        lastWallClockMillis = nowWall
        lastElapsedRealtimeMillis = nowElapsed

        if (previousWall == null || previousElapsed == null) return false

        val elapsedDelta = nowElapsed - previousElapsed
        if (elapsedDelta < 0L) return false

        val expectedWall = previousWall + elapsedDelta
        val skew = abs(nowWall - expectedWall)
        val jumped = skew > clockJumpThresholdMillis
        if (jumped) {
            FocusDebugLogger.append(
                context,
                "store.clock",
                "wall=$nowWall expected=$expectedWall skewMs=$skew elapsedDeltaMs=$elapsedDelta",
            )
        }
        return jumped
    }

    /**
     * Parity with Flutter FocusController._nextNightBoundary: after midnight and before wake on an
     * overnight sleep range, the next boundary is wake time, not tonight's sleep start. Older
     * persisted nextChangeAt values could still show tonight's start; correct them for the blocked
     * overlay and accessibility path when we detect that pattern.
     */
    private fun correctNightDisciplineNextChangeOnAndroid(
        context: Context,
        state: FocusBlockState,
    ): FocusBlockState {
        val prefs = prefs(context)
        if (!prefs.getBoolean(nightDisciplineEnabledKey, false)) return state
        if (state.activeMode != "nightDiscipline") return state
        if (!state.isLocked) return state
        val nextIso = state.nextChangeAt ?: return state

        val sh = prefs.getInt(nightStartHourKey, 22)
        val sm = prefs.getInt(nightStartMinuteKey, 0)
        val eh = prefs.getInt(nightEndHourKey, 6)
        val em = prefs.getInt(nightEndMinuteKey, 0)
        val startTotal = sh * 60 + sm
        val endTotal = eh * 60 + em
        if (startTotal < endTotal) return state

        val tz = TimeZone.getDefault()
        val nowCal = Calendar.getInstance(tz)
        nowCal.timeInMillis = System.currentTimeMillis()

        fun todayAt(h: Int, m: Int): Calendar {
            val c = Calendar.getInstance(tz)
            c.timeInMillis = nowCal.timeInMillis
            c.set(Calendar.HOUR_OF_DAY, h)
            c.set(Calendar.MINUTE, m)
            c.set(Calendar.SECOND, 0)
            c.set(Calendar.MILLISECOND, 0)
            return c
        }

        val todayStart = todayAt(sh, sm)
        val todayEnd = todayAt(eh, em)
        val todayEndAdjusted =
            if (!todayEnd.after(todayStart)) {
                (todayEnd.clone() as Calendar).apply { add(Calendar.DAY_OF_MONTH, 1) }
            } else {
                todayEnd
            }
        val previousStart = (todayStart.clone() as Calendar).apply { add(Calendar.DAY_OF_MONTH, -1) }
        val previousEnd = (todayEndAdjusted.clone() as Calendar).apply { add(Calendar.DAY_OF_MONTH, -1) }

        if (nowCal.before(todayStart) &&
            !nowCal.before(previousStart) &&
            nowCal.before(previousEnd)
        ) {
            val parsedNext = parseIsoLocalToCalendar(nextIso, tz) ?: return state
            if (sameCalendarMinute(parsedNext, todayStart)) {
                val fixed = formatIsoLocalMatchFlutter(previousEnd.timeInMillis, tz)
                if (fixed != nextIso) {
                    prefs.edit().putString(nextChangeAtKey, fixed).commit()
                    FocusDebugLogger.append(
                        context,
                        "store.night.nextChange",
                        "corrected overnight nextChangeAt=$fixed (was $nextIso)",
                    )
                    return state.copy(nextChangeAt = fixed)
                }
            }
        }
        return state
    }

    private fun sameCalendarMinute(a: Calendar, b: Calendar): Boolean {
        return a.get(Calendar.YEAR) == b.get(Calendar.YEAR) &&
            a.get(Calendar.MONTH) == b.get(Calendar.MONTH) &&
            a.get(Calendar.DAY_OF_MONTH) == b.get(Calendar.DAY_OF_MONTH) &&
            a.get(Calendar.HOUR_OF_DAY) == b.get(Calendar.HOUR_OF_DAY) &&
            a.get(Calendar.MINUTE) == b.get(Calendar.MINUTE)
    }

    private fun parseIsoLocalToCalendar(iso: String, tz: TimeZone): Calendar? {
        val millis = runCatching { iso.toLong() }.getOrNull()
        if (millis != null) {
            return Calendar.getInstance(tz).apply { timeInMillis = millis }
        }
        val isoPatterns =
            listOf(
                "yyyy-MM-dd'T'HH:mm:ss.SSSX",
                "yyyy-MM-dd'T'HH:mm:ssX",
                "yyyy-MM-dd'T'HH:mm:ss.SSS",
                "yyyy-MM-dd'T'HH:mm:ss",
            )
        for (pattern in isoPatterns) {
            val cal =
                runCatching {
                    val sdf = SimpleDateFormat(pattern, Locale.US)
                    sdf.timeZone = tz
                    val d = sdf.parse(iso) ?: return@runCatching null
                    Calendar.getInstance(tz).apply { time = d }
                }.getOrNull()
            if (cal != null) return cal
        }
        return null
    }

    private fun formatIsoLocalMatchFlutter(millis: Long, tz: TimeZone): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US)
        sdf.timeZone = tz
        return sdf.format(Date(millis))
    }

    fun saveScheduledTransitions(
        context: Context,
        transitions: List<Map<String, Any?>>,
    ) {
        val serialized = JSONArray().apply {
            transitions.take(focusScheduleMaxCount).forEach { transition ->
                put(
                    JSONObject().apply {
                        put("at", transition["at"] as? String)
                        put("atMillis", (transition["atMillis"] as? Number)?.toLong())
                        put("isLocked", transition["isLocked"] as? Boolean ?: false)
                        put("activeMode", transition["activeMode"] as? String)
                        put("lockReason", transition["lockReason"] as? String)
                        put("nextChangeAt", transition["nextChangeAt"] as? String)
                        val nextEndMs = (transition["nextChangeAtMillis"] as? Number)?.toLong()
                        if (nextEndMs != null && nextEndMs > 0L) {
                            put("nextChangeAtMillis", nextEndMs)
                        }
                    },
                )
            }
        }.toString()
        prefs(context).edit().putString(scheduledTransitionsKey, serialized).commit()
        FocusDebugLogger.append(
            context,
            "store.transitions",
            "saved ${transitions.size.coerceAtMost(focusScheduleMaxCount)} transitions",
        )
    }

    fun scheduledTransitionMaps(context: Context): List<Map<String, Any?>> {
        val raw = prefs(context).getString(scheduledTransitionsKey, null) ?: return emptyList()
        return runCatching {
            val array = JSONArray(raw)
            buildList {
                for (index in 0 until array.length()) {
                    val item = array.optJSONObject(index) ?: continue
                    val atMillis = item.optLong("atMillis", -1L)
                    if (atMillis <= 0L) continue
                    val map = mutableMapOf<String, Any?>(
                        "at" to item.stringOrNull("at"),
                        "atMillis" to atMillis,
                        "isLocked" to item.optBoolean("isLocked", false),
                        "activeMode" to item.stringOrNull("activeMode"),
                        "lockReason" to item.stringOrNull("lockReason"),
                        "nextChangeAt" to item.stringOrNull("nextChangeAt"),
                    )
                    if (item.has("nextChangeAtMillis") && !item.isNull("nextChangeAtMillis")) {
                        val endMs = item.optLong("nextChangeAtMillis", 0L)
                        if (endMs > 0L) {
                            map["nextChangeAtMillis"] = endMs
                        }
                    }
                    add(map)
                }
            }.sortedBy { (it["atMillis"] as Long) }
        }.getOrElse { emptyList() }
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

    private fun resolveScheduledState(
        context: Context,
        storedState: FocusBlockState,
    ): FocusBlockState {
        val transitions = readScheduledTransitions(context)
        if (transitions.isEmpty()) return storedState

        val now = System.currentTimeMillis()
        val applied = transitions.lastOrNull { it.atMillis <= now } ?: return storedState
        val next = transitions.firstOrNull { it.atMillis > now }
        val resolved = storedState.copy(
            isLocked = applied.isLocked,
            activeMode = applied.activeMode ?: storedState.activeMode,
            lockReason = applied.lockReason ?: storedState.lockReason,
            nextChangeAt = applied.nextChangeAt ?: next?.nextChangeAt ?: next?.at,
        )

        if (resolved.isLocked != storedState.isLocked ||
            resolved.activeMode != storedState.activeMode ||
            resolved.nextChangeAt != storedState.nextChangeAt
        ) {
            prefs(context).edit()
                .putBoolean(isLockedKey, resolved.isLocked)
                .putString(activeModeKey, resolved.activeMode)
                .putString(lockReasonKey, resolved.lockReason)
                .putString(nextChangeAtKey, resolved.nextChangeAt)
                .commit()
            FocusDebugLogger.append(
                context,
                "store.resolve",
                "resolvedFromTransitions isLocked=${resolved.isLocked} activeMode=${resolved.activeMode} nextChangeAt=${resolved.nextChangeAt}",
            )
        }
        return resolved
    }

    private fun readScheduledTransitions(context: Context): List<StoredTransition> {
        val raw = prefs(context).getString(scheduledTransitionsKey, null) ?: return emptyList()
        return runCatching {
            val array = JSONArray(raw)
            buildList {
                for (index in 0 until array.length()) {
                    val item = array.optJSONObject(index) ?: continue
                    val atMillis = item.optLong("atMillis", -1L)
                    if (atMillis <= 0L) continue
                    add(
                        StoredTransition(
                            atMillis = atMillis,
                            at = item.stringOrNull("at"),
                            isLocked = item.optBoolean("isLocked", false),
                            activeMode = item.stringOrNull("activeMode"),
                            lockReason = item.stringOrNull("lockReason"),
                            nextChangeAt = item.stringOrNull("nextChangeAt"),
                        ),
                    )
                }
            }.sortedBy { it.atMillis }
        }.getOrElse { emptyList() }
    }
}

private fun JSONObject.stringOrNull(key: String): String? {
    if (!has(key) || isNull(key)) return null
    return optString(key, "")
}

data class FocusBlockState(
    val selectedPackages: Set<String>,
    val isLocked: Boolean,
    val activeMode: String?,
    val lockReason: String?,
    val nextChangeAt: String?,
    val syncGeneration: Long,
)

data class StoredTransition(
    val atMillis: Long,
    val at: String?,
    val isLocked: Boolean,
    val activeMode: String?,
    val lockReason: String?,
    val nextChangeAt: String?,
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

        val blockedLabel = FocusBlockerStore.appLabel(applicationContext, packageName)
        FocusDebugLogger.append(
            applicationContext,
            "service.block.attempt",
            "userOpenedBlockedApp package=$packageName label=$blockedLabel mode=${state.activeMode} reason=${state.lockReason} nextChangeAt=${state.nextChangeAt} eventType=${event.eventType}",
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
            putExtra("blockedAppName", blockedLabel)
            putExtra("activeMode", state.activeMode)
            putExtra("lockReason", state.lockReason)
            putExtra("nextChangeAt", state.nextChangeAt)
        }
        mainHandler.postDelayed({
            FocusDebugLogger.append(
                applicationContext,
                "service.block.show",
                "starting FocusBlockedActivity package=$packageName label=$blockedLabel",
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
        FocusBlockerStore.saveScheduledTransitions(context, transitions)
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

        when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                alarmManager.canScheduleExactAlarms() -> {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    atMillis,
                    pendingIntent,
                )
            }
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                !alarmManager.canScheduleExactAlarms() -> {
                alarmManager.setAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    atMillis,
                    pendingIntent,
                )
            }
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    atMillis,
                    pendingIntent,
                )
            }
            else -> {
                @Suppress("DEPRECATION")
                alarmManager.setExact(
                    AlarmManager.RTC_WAKEUP,
                    atMillis,
                    pendingIntent,
                )
            }
        }
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

        val alarmWantsLocked = intent.getBooleanExtra("isLocked", false)
        val before = FocusBlockerStore.currentState(context)
        FocusDebugLogger.append(
            context,
            "schedule.fire",
            "alarmWantsLocked=$alarmWantsLocked at=${intent.getStringExtra("at")} mode=${intent.getStringExtra("activeMode")} reason=${intent.getStringExtra("lockReason")} nextChangeAt=${intent.getStringExtra("nextChangeAt")} beforeLocked=${before.isLocked} beforeMode=${before.activeMode}",
        )
        FocusBlockerStore.save(
            context = context,
            selectedPackages = before.selectedPackages.toList(),
            activeMode = before.activeMode ?: intent.getStringExtra("activeMode"),
            isLocked = before.isLocked,
            lockReason = before.lockReason ?: intent.getStringExtra("lockReason"),
            nextChangeAt = before.nextChangeAt ?: intent.getStringExtra("nextChangeAt"),
        )
        val after = FocusBlockerStore.currentState(context)
        FocusDebugLogger.append(
            context,
            "schedule.afterSave",
            "persistedLocked=${after.isLocked} mode=${after.activeMode} reason=${after.lockReason} nextChangeAt=${after.nextChangeAt}",
        )
        if (!after.isLocked) {
            FocusDebugLogger.append(
                context,
                "schedule.unlock",
                "apps unlocked (persisted state no longer locked)",
            )
        } else if (!alarmWantsLocked) {
            FocusDebugLogger.append(
                context,
                "schedule.lockHeld",
                "alarm was unlock edge but schedule still locked mode=${after.activeMode}",
            )
        } else {
            FocusDebugLogger.append(
                context,
                "schedule.lock",
                "apps locked mode=${after.activeMode} reason=${after.lockReason}",
            )
        }
    }
}
