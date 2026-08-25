package com.rnr.deenfocus

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Process
import android.provider.Settings
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale
import kotlin.math.min

class AppUsageChannelHandler(
    private val context: Context,
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getAvailability" -> result.success(mapOf("status" to currentStatus()))
            "requestAccess" -> {
                openUsageAccessSettings()
                result.success(mapOf("status" to currentStatus()))
            }
            "queryUsage" -> {
                Thread {
                    runCatching {
                        queryUsage(
                            startDate = call.argument<String>("startDate"),
                            endDate = call.argument<String>("endDate"),
                        )
                    }.onSuccess { payload ->
                        android.os.Handler(context.mainLooper).post { result.success(payload) }
                    }.onFailure { error ->
                        android.os.Handler(context.mainLooper).post {
                            result.error(
                                "QUERY_USAGE_FAILED",
                                error.message ?: "Unable to read app usage.",
                                null,
                            )
                        }
                    }
                }.start()
            }
            else -> result.notImplemented()
        }
    }

    private fun currentStatus(): String {
        return if (hasUsageAccess()) "granted" else "denied"
    }

    private fun hasUsageAccess(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as? AppOpsManager
            ?: return false
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName,
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName,
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun openUsageAccessSettings() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    private fun deniedPayload(): Map<String, Any?> {
        return mapOf(
            "status" to "denied",
            "apps" to emptyMap<String, Any>(),
            "days" to emptyList<Any>(),
        )
    }

    private fun queryUsage(startDate: String?, endDate: String?): Map<String, Any?> {
        if (!hasUsageAccess()) return deniedPayload()

        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager
            ?: return deniedPayload()

        val range = dateRange(startDate, endDate)
        val dayFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)

        // UsageEvents is near-realtime and lets us bucket by local calendar day.
        // queryUsageStats(INTERVAL_DAILY) over a multi-day range often mis-stamps
        // firstTimeStamp (everything lands on the range start → "today" is 0m) and
        // lags recent foreground time until the system flushes.
        val dayUsage = aggregateFromEvents(
            usageStatsManager = usageStatsManager,
            startMs = range.first,
            endMs = range.second,
            dayFormat = dayFormat,
        )

        val totals = if (dayUsage.values.any { it.isNotEmpty() }) {
            dayUsage
        } else {
            // Some OEMs return empty events; fall back to one INTERVAL_DAILY
            // query per calendar day using the known day key (never firstTimeStamp).
            aggregateFromDailyStats(
                usageStatsManager = usageStatsManager,
                startMs = range.first,
                endMs = range.second,
                dayFormat = dayFormat,
            )
        }

        return buildPayload(totals)
    }

    private fun aggregateFromEvents(
        usageStatsManager: UsageStatsManager,
        startMs: Long,
        endMs: Long,
        dayFormat: SimpleDateFormat,
    ): MutableMap<String, MutableMap<String, Long>> {
        val days = linkedMapOf<String, MutableMap<String, Long>>()
        val events = usageStatsManager.queryEvents(startMs, endMs)
        val event = UsageEvents.Event()
        // App-level MOVE_TO_* events (still emitted on modern APIs) avoid
        // per-activity ACTIVITY_RESUMED/PAUSED noise that under/over-counts.
        var currentPackage: String? = null
        var currentStart = 0L

        fun closeSession(packageName: String, fromMs: Long, toMs: Long) {
            addDurationAcrossDays(
                days = days,
                packageName = packageName,
                fromMs = fromMs.coerceAtLeast(startMs),
                toMs = toMs.coerceAtMost(endMs),
                dayFormat = dayFormat,
            )
        }

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            val packageName = event.packageName ?: continue
            @Suppress("DEPRECATION")
            when (event.eventType) {
                UsageEvents.Event.MOVE_TO_FOREGROUND -> {
                    val previous = currentPackage
                    if (previous != null && previous != packageName) {
                        closeSession(previous, currentStart, event.timeStamp)
                    }
                    if (previous != packageName) {
                        currentPackage = packageName
                        currentStart = event.timeStamp
                    }
                }
                UsageEvents.Event.MOVE_TO_BACKGROUND -> {
                    if (currentPackage == packageName) {
                        closeSession(packageName, currentStart, event.timeStamp)
                        currentPackage = null
                    }
                }
            }
        }

        // Still-open foreground session (no MOVE_TO_BACKGROUND yet): credit
        // elapsed time up to now. Safe vs later BACKGROUND / re-query because
        // every queryUsage rebuilds `days` from scratch — this provisional
        // slice is replaced, never stored and added again on top.
        val active = currentPackage
        if (active != null) {
            closeSession(active, currentStart, min(endMs, System.currentTimeMillis()))
        }

        return days
    }

    private fun aggregateFromDailyStats(
        usageStatsManager: UsageStatsManager,
        startMs: Long,
        endMs: Long,
        dayFormat: SimpleDateFormat,
    ): MutableMap<String, MutableMap<String, Long>> {
        val days = linkedMapOf<String, MutableMap<String, Long>>()
        var cursor = startOfDay(startMs)
        val last = endMs
        while (cursor <= last) {
            val next = nextDayStart(cursor)
            val dayEnd = min(next - 1L, last)
            val dayKey = dayFormat.format(Date(cursor))
            val stats = usageStatsManager.queryUsageStats(
                UsageStatsManager.INTERVAL_DAILY,
                cursor,
                dayEnd,
            ).orEmpty()
            for (stat in stats) {
                val usageMs = stat.totalTimeInForeground
                if (usageMs < 1_000L) continue
                val packageName = stat.packageName ?: continue
                val usageForDay = days.getOrPut(dayKey) { linkedMapOf() }
                usageForDay[packageName] =
                    (usageForDay[packageName] ?: 0L) + usageMs
            }
            cursor = next
        }
        return days
    }

    private fun addDurationAcrossDays(
        days: MutableMap<String, MutableMap<String, Long>>,
        packageName: String,
        fromMs: Long,
        toMs: Long,
        dayFormat: SimpleDateFormat,
    ) {
        if (toMs <= fromMs) return
        var start = fromMs
        while (start < toMs) {
            val boundary = nextDayStart(start)
            val sliceEnd = min(toMs, boundary)
            val duration = sliceEnd - start
            if (duration > 0L) {
                val dayKey = dayFormat.format(Date(start))
                val usageForDay = days.getOrPut(dayKey) { linkedMapOf() }
                usageForDay[packageName] =
                    (usageForDay[packageName] ?: 0L) + duration
            }
            start = sliceEnd
        }
    }

    private fun buildPayload(
        dayUsage: Map<String, MutableMap<String, Long>>,
    ): Map<String, Any?> {
        val packageManager = context.packageManager
        val apps = linkedMapOf<String, MutableMap<String, Any?>>()
        val days = mutableListOf<Map<String, Any?>>()

        for ((date, usage) in dayUsage) {
            val filtered = linkedMapOf<String, Long>()
            for ((packageName, usageMs) in usage) {
                if (usageMs < 1_000L) continue
                val isOurs = packageName == context.packageName
                val launchable =
                    packageManager.getLaunchIntentForPackage(packageName) != null
                if (!isOurs && !launchable) continue
                filtered[packageName] = usageMs
                if (!apps.containsKey(packageName)) {
                    val label = runCatching {
                        val info = packageManager.getApplicationInfo(packageName, 0)
                        packageManager.getApplicationLabel(info).toString()
                    }.getOrDefault(packageName)
                    val icon = runCatching {
                        scaledPngBytes(packageManager.getApplicationIcon(packageName))
                    }.getOrNull()
                    apps[packageName] = mutableMapOf(
                        "appName" to label,
                        "isDeenFocus" to isOurs,
                        "iconBytes" to icon,
                    )
                }
            }
            if (filtered.isNotEmpty()) {
                days.add(
                    mapOf(
                        "date" to date,
                        "usage" to filtered,
                    ),
                )
            }
        }

        return mapOf(
            "status" to "granted",
            "apps" to apps,
            "days" to days,
        )
    }

    private fun dateRange(startDate: String?, endDate: String?): Pair<Long, Long> {
        val start = parseDayStart(startDate) ?: defaultStart()
        val end = parseDayEnd(endDate) ?: System.currentTimeMillis()
        return start to end.coerceAtLeast(start + 1)
    }

    private fun parseDayStart(raw: String?): Long? {
        val parts = raw?.split("-") ?: return null
        if (parts.size != 3) return null
        val year = parts[0].toIntOrNull() ?: return null
        val month = parts[1].toIntOrNull() ?: return null
        val day = parts[2].toIntOrNull() ?: return null
        return Calendar.getInstance().apply {
            set(year, month - 1, day, 0, 0, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
    }

    private fun parseDayEnd(raw: String?): Long? {
        val start = parseDayStart(raw) ?: return null
        // Inclusive end of the calendar day, capped at "now" so open sessions close.
        val endOfDay = start + 24L * 60L * 60L * 1000L - 1L
        return min(endOfDay, System.currentTimeMillis())
    }

    private fun defaultStart(): Long {
        return Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            add(Calendar.DAY_OF_YEAR, -13)
        }.timeInMillis
    }

    private fun startOfDay(millis: Long): Long {
        return Calendar.getInstance().apply {
            timeInMillis = millis
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
    }

    private fun nextDayStart(millis: Long): Long {
        return Calendar.getInstance().apply {
            timeInMillis = startOfDay(millis)
            add(Calendar.DAY_OF_YEAR, 1)
        }.timeInMillis
    }

    private fun scaledPngBytes(drawable: Drawable, size: Int = 72): ByteArray {
        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, size, size)
        drawable.draw(canvas)
        return ByteArrayOutputStream().use { output ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 90, output)
            output.toByteArray()
        }
    }
}
