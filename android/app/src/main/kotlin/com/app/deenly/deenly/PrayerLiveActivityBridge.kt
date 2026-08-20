package com.rnr.deenfocus

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import org.json.JSONArray
import org.json.JSONObject

/**
 * Android analogue of iOS Live Activities: an ongoing low-noise notification
 * showing current/next prayer, refreshed from Flutter and at prayer transitions.
 */
object PrayerLiveActivityBridge {
    private const val channelId = "prayer_live_activity"
    private const val notificationId = 7601
    private const val prefsName = "deenly_live_activity"
    private const val payloadKey = "payload_json"
    private const val enabledKey = "enabled"
    private const val alarmRequestCode = 7602
    private const val alarmCount = 8

    fun getCapabilities(context: Context): Map<String, Any?> {
        return mapOf(
            "platform" to "android",
            "implementation" to "ongoing_notification",
            "supportsLiveActivity" to true,
            "areActivitiesEnabled" to NotificationManagerCompat.from(context).areNotificationsEnabled(),
            "androidSdk" to Build.VERSION.SDK_INT,
        )
    }

    fun areActivitiesEnabled(context: Context): Boolean {
        return NotificationManagerCompat.from(context).areNotificationsEnabled()
    }

    fun startOrUpdate(context: Context, args: Map<*, *>) {
        ensureChannel(context)
        val payload = toJsonObject(args)
        context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(enabledKey, true)
            .putString(payloadKey, payload.toString())
            .apply()
        showNotification(context, payload)
        scheduleNextRefresh(context, payload)
    }

    fun stop(context: Context) {
        context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(enabledKey, false)
            .remove(payloadKey)
            .apply()
        NotificationManagerCompat.from(context).cancel(notificationId)
        cancelRefreshAlarm(context)
    }

    fun refreshFromStorage(context: Context) {
        val prefs = context.getSharedPreferences(prefsName, Context.MODE_PRIVATE)
        if (!prefs.getBoolean(enabledKey, false)) return
        val raw = prefs.getString(payloadKey, null) ?: return
        runCatching {
            val payload = JSONObject(raw)
            val advanced = advancePayloadIfNeeded(payload)
            prefs.edit().putString(payloadKey, advanced.toString()).apply()
            showNotification(context, advanced)
            scheduleNextRefresh(context, advanced)
        }
    }

    private fun showNotification(context: Context, payload: JSONObject) {
        ensureChannel(context)
        val currentLabel = payload.optString("currentPrayerLabel", "Prayer")
        val currentTime = payload.optString("currentPrayerTimeLabel", "")
        val nextLine = payload.optString("nextPrayerLine", "")
        val location = payload.optString("locationName", "")
        val updated = payload.optString("updatedAtLabel", "")
        val phaseLabel = phaseLabel(payload)
        val brand = payload.optString("brandName", context.getString(R.string.app_name))

        val title = "$phaseLabel · $currentLabel"
        val body = buildString {
            append(currentTime)
            if (location.isNotBlank()) append(" · ").append(location)
            if (nextLine.isNotBlank()) append('\n').append(nextLine)
            if (updated.isNotBlank()) append('\n').append(updated)
        }

        val launchIntent = context.packageManager
            .getLaunchIntentForPackage(context.packageName)
            ?.apply { flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP }
        val contentIntent = PendingIntent.getActivity(
            context,
            notificationId,
            launchIntent ?: Intent(),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setCategory(NotificationCompat.CATEGORY_STATUS)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(contentIntent)
            .setSubText(brand)
            .build()

        NotificationManagerCompat.from(context).notify(notificationId, notification)
    }

    private fun phaseLabel(payload: JSONObject): String {
        val nowLabel = payload.optString("nowLabel", "Now")
        val upNextLabel = payload.optString("upNextLabel", nowLabel)
        return if (payload.optBoolean("beforeFirstPrayer", false)) {
            upNextLabel.ifBlank { nowLabel }
        } else {
            nowLabel
        }
    }

    private fun advancePayloadIfNeeded(payload: JSONObject): JSONObject {
        val prayers = payload.optJSONArray("prayers") ?: return payload
        if (prayers.length() == 0) return payload
        val now = System.currentTimeMillis()
        val firstMillis = parseIsoMillis(prayers.getJSONObject(0).optString("isoTime"))
        if (firstMillis != null && now < firstMillis) {
            // Still before Fajr: keep Flutter presentation, refresh at Fajr.
            payload.put("beforeFirstPrayer", true)
            payload.put("nextPrayerIso", prayers.getJSONObject(0).optString("isoTime"))
            return payload
        }

        payload.put("beforeFirstPrayer", false)
        var currentIndex = 0
        for (i in 0 until prayers.length()) {
            val iso = prayers.getJSONObject(i).optString("isoTime")
            val millis = parseIsoMillis(iso) ?: continue
            if (millis <= now) currentIndex = i
        }
        val current = prayers.getJSONObject(currentIndex)
        val next = if (currentIndex + 1 < prayers.length()) {
            prayers.getJSONObject(currentIndex + 1)
        } else {
            null
        }
        payload.put("currentPrayerId", current.optString("id"))
        payload.put("currentPrayerLabel", current.optString("label"))
        payload.put("currentPrayerTimeLabel", current.optString("timeLabel"))
        payload.put("currentPrayerIso", current.optString("isoTime"))
        if (next != null) {
            applyNextPrayer(
                payload,
                id = next.optString("id"),
                label = next.optString("label"),
                timeLabel = next.optString("timeLabel"),
                isoTime = next.optString("isoTime"),
            )
        } else {
            val tomorrowIso = payload.optString("tomorrowFajrIso", "")
            val tomorrowMillis = parseIsoMillis(tomorrowIso)
            if (tomorrowMillis != null && tomorrowMillis > now) {
                applyNextPrayer(
                    payload,
                    id = "fajr",
                    label = payload.optString("tomorrowFajrLabel", "Fajr"),
                    timeLabel = payload.optString("tomorrowFajrTimeLabel", ""),
                    isoTime = tomorrowIso,
                )
            } else {
                payload.put("nextPrayerId", JSONObject.NULL)
                payload.put("nextPrayerLabel", "")
                payload.put("nextPrayerTimeLabel", "")
                payload.put("nextPrayerIso", "")
                payload.put("nextPrayerLine", "")
            }
        }
        return payload
    }

    private fun applyNextPrayer(
        payload: JSONObject,
        id: String,
        label: String,
        timeLabel: String,
        isoTime: String,
    ) {
        payload.put("nextPrayerId", id)
        payload.put("nextPrayerLabel", label)
        payload.put("nextPrayerTimeLabel", timeLabel)
        payload.put("nextPrayerIso", isoTime)
        val template = payload.optString(
            "nextPrayerLineTemplate",
            "{prayer} at {time}",
        )
        payload.put(
            "nextPrayerLine",
            template.replace("{prayer}", label).replace("{time}", timeLabel),
        )
    }

    private fun scheduleNextRefresh(context: Context, payload: JSONObject) {
        cancelRefreshAlarm(context)
        val now = System.currentTimeMillis()
        val times = mutableListOf<Long>()
        val prayers = payload.optJSONArray("prayers")
        if (prayers != null) {
            for (i in 0 until prayers.length()) {
                parseIsoMillis(prayers.getJSONObject(i).optString("isoTime"))?.let(times::add)
            }
        }
        parseIsoMillis(payload.optString("tomorrowFajrIso", ""))?.let(times::add)
        parseIsoMillis(payload.optString("nextPrayerIso", ""))?.let(times::add)
        val upcoming = times.filter { it > now + 5_000L }.distinct().sorted().take(alarmCount)
        if (upcoming.isEmpty()) return
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        upcoming.forEachIndexed { index, triggerAt ->
            setRefreshAlarm(alarmManager, triggerAt, refreshPendingIntent(context, index))
        }
    }

    private fun setRefreshAlarm(
        alarmManager: AlarmManager,
        triggerAt: Long,
        pending: PendingIntent,
    ) {
        when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S &&
                alarmManager.canScheduleExactAlarms() -> {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAt,
                    pending,
                )
            }
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
                alarmManager.setAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAt,
                    pending,
                )
            }
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.M -> {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    triggerAt,
                    pending,
                )
            }
            else -> {
                @Suppress("DEPRECATION")
                alarmManager.setExact(AlarmManager.RTC_WAKEUP, triggerAt, pending)
            }
        }
    }

    private fun cancelRefreshAlarm(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        repeat(alarmCount) { index ->
            alarmManager.cancel(refreshPendingIntent(context, index))
        }
    }

    private fun refreshPendingIntent(context: Context, index: Int): PendingIntent {
        val intent = Intent(context, PrayerLiveActivityReceiver::class.java).apply {
            action = PrayerLiveActivityReceiver.ACTION_REFRESH
        }
        return PendingIntent.getBroadcast(
            context,
            alarmRequestCode + index,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val existing = manager.getNotificationChannel(channelId)
        if (existing != null) return
        val channel = NotificationChannel(
            channelId,
            "Prayer Live Updates",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Ongoing prayer status on your lock screen and notification shade"
            setShowBadge(false)
        }
        manager.createNotificationChannel(channel)
    }

    private fun parseIsoMillis(value: String?): Long? {
        if (value.isNullOrBlank()) return null
        return runCatching {
            java.time.OffsetDateTime.parse(value).toInstant().toEpochMilli()
        }.recoverCatching {
            java.time.LocalDateTime.parse(value).atZone(java.time.ZoneId.systemDefault())
                .toInstant()
                .toEpochMilli()
        }.getOrNull()
    }

    private fun toJsonObject(value: Map<*, *>): JSONObject {
        val json = JSONObject()
        for ((rawKey, rawValue) in value) {
            val key = rawKey?.toString() ?: continue
            json.put(key, toJsonValue(rawValue))
        }
        return json
    }

    private fun toJsonValue(value: Any?): Any {
        return when (value) {
            null -> JSONObject.NULL
            is Map<*, *> -> toJsonObject(value)
            is List<*> -> {
                val array = JSONArray()
                for (item in value) {
                    array.put(toJsonValue(item))
                }
                array
            }
            is Boolean, is Number, is String -> value
            else -> value.toString()
        }
    }
}
