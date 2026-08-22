package com.rnr.deenfocus

import android.app.AppOpsManager
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

    private fun queryUsage(startDate: String?, endDate: String?): Map<String, Any?> {
        if (!hasUsageAccess()) {
            return mapOf(
                "status" to "denied",
                "apps" to emptyMap<String, Any>(),
                "days" to emptyList<Any>(),
            )
        }

        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager
            ?: return mapOf(
                "status" to "denied",
                "apps" to emptyMap<String, Any>(),
                "days" to emptyList<Any>(),
            )

        val range = dateRange(startDate, endDate)
        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            range.first,
            range.second,
        ).orEmpty()

        val packageManager = context.packageManager
        val dayFormat = SimpleDateFormat("yyyy-MM-dd", Locale.US)
        val apps = linkedMapOf<String, MutableMap<String, Any?>>()
        val days = linkedMapOf<String, MutableMap<String, Long>>()

        for (stat in stats) {
            val usageMs = stat.totalTimeInForeground
            if (usageMs < 1_000L) continue
            val packageName = stat.packageName ?: continue
            val isOurs = packageName == context.packageName
            val launchable = packageManager.getLaunchIntentForPackage(packageName) != null
            if (!isOurs && !launchable) continue

            val dayKey = dayFormat.format(Date(stat.firstTimeStamp))
            val usageForDay = days.getOrPut(dayKey) { linkedMapOf() }
            usageForDay[packageName] = (usageForDay[packageName] ?: 0L) + usageMs

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

        return mapOf(
            "status" to "granted",
            "apps" to apps,
            "days" to days.map { (date, usage) ->
                mapOf(
                    "date" to date,
                    "usage" to usage,
                )
            },
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
        return start + 24L * 60L * 60L * 1000L - 1L
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
