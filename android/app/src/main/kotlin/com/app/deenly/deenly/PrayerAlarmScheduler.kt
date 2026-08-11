package com.rnr.deenfocus

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

object PrayerAlarmScheduler {
    const val ACTION_FIRE = "com.rnr.deenfocus.action.PRAYER_ALARM_FIRE"
    const val ACTION_SNOOZE = "com.rnr.deenfocus.action.PRAYER_ALARM_SNOOZE"
    const val ACTION_DISMISS = "com.rnr.deenfocus.action.PRAYER_ALARM_DISMISS"

    const val EXTRA_ALARM_ID = "alarmId"
    const val EXTRA_PRAYER = "prayer"
    const val EXTRA_TITLE = "title"
    const val EXTRA_SUBTITLE = "subtitle"
    const val EXTRA_PRAYER_LABEL = "prayerLabel"
    const val EXTRA_BADGE = "badgeLabel"
    const val EXTRA_IVE_PRAYED = "ivePrayedLabel"
    const val EXTRA_DISMISS = "dismissLabel"
    const val EXTRA_SNOOZE = "snoozeLabel"
    const val EXTRA_SOUND = "sound"
    const val EXTRA_SNOOZE_MINUTES = "snoozeMinutes"
    const val EXTRA_FIRE_AT_MS = "fireAtMs"

    private const val CHANNEL_ADHAN = "prayer_alarm_adhan"
    private const val CHANNEL_BEEP = "prayer_alarm_beep"
    private const val CHANNEL_MUTE = "prayer_alarm_mute"
    private const val NOTIFICATION_BASE = 7000

    fun scheduleAll(context: Context, alarms: List<Map<String, Any?>>, replaceAll: Boolean) {
        ensureChannels(context)
        if (replaceAll) {
            cancelAll(context, clearStore = false)
        }
        PrayerAlarmStore.saveAlarms(context, alarms)
        val now = System.currentTimeMillis()
        for (alarm in alarms) {
            val fireAt = (alarm["fireAtMs"] as? Number)?.toLong() ?: continue
            if (fireAt <= now) continue
            scheduleOne(context, alarm, fireAt)
        }
    }

    fun restoreFromStore(context: Context) {
        ensureChannels(context)
        val alarms = PrayerAlarmStore.loadAlarms(context)
        if (alarms.isEmpty()) return
        val now = System.currentTimeMillis()
        val future = alarms.filter {
            ((it["fireAtMs"] as? Number)?.toLong() ?: 0L) > now
        }
        // Cancel first so reboot/package-replace never double-registers the same id.
        cancelAll(context, clearStore = false)
        PrayerAlarmStore.saveAlarms(context, future)
        for (alarm in future) {
            val fireAt = (alarm["fireAtMs"] as? Number)?.toLong() ?: continue
            scheduleOne(context, alarm, fireAt)
        }
    }

    fun cancelAll(context: Context, clearStore: Boolean = true) {
        val alarms = PrayerAlarmStore.loadAlarms(context)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        for (alarm in alarms) {
            val id = alarm["id"] as? String ?: continue
            alarmManager.cancel(firePendingIntent(context, id, alarm))
            NotificationManagerCompat.from(context).cancel(notificationIdFor(id))
        }
        if (clearStore) {
            PrayerAlarmStore.clearAlarms(context)
        }
    }

    fun cancelOne(context: Context, alarmId: String) {
        val alarms = PrayerAlarmStore.loadAlarms(context)
        val match = alarms.firstOrNull { it["id"] == alarmId }
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.cancel(
            firePendingIntent(context, alarmId, match ?: mapOf("id" to alarmId)),
        )
        NotificationManagerCompat.from(context).cancel(notificationIdFor(alarmId))
        if (match != null) {
            PrayerAlarmStore.saveAlarms(context, alarms.filterNot { it["id"] == alarmId })
        }
    }

    fun snooze(context: Context, extras: Intent) {
        val snoozeMinutes = extras.getIntExtra(EXTRA_SNOOZE_MINUTES, 10).coerceIn(1, 60)
        val fireAt = System.currentTimeMillis() + snoozeMinutes * 60_000L
        val alarm = mutableMapOf<String, Any?>(
            "id" to (extras.getStringExtra(EXTRA_ALARM_ID) ?: return),
            "prayer" to extras.getStringExtra(EXTRA_PRAYER),
            "title" to extras.getStringExtra(EXTRA_TITLE),
            "subtitle" to extras.getStringExtra(EXTRA_SUBTITLE),
            "prayerLabel" to extras.getStringExtra(EXTRA_PRAYER_LABEL),
            "badgeLabel" to extras.getStringExtra(EXTRA_BADGE),
            "ivePrayedLabel" to extras.getStringExtra(EXTRA_IVE_PRAYED),
            "dismissLabel" to extras.getStringExtra(EXTRA_DISMISS),
            "snoozeLabel" to extras.getStringExtra(EXTRA_SNOOZE),
            "sound" to extras.getStringExtra(EXTRA_SOUND),
            "snoozeMinutes" to snoozeMinutes,
            "fireAtMs" to fireAt,
        )
        val existing = PrayerAlarmStore.loadAlarms(context).filterNot { it["id"] == alarm["id"] }
        PrayerAlarmStore.saveAlarms(context, existing + alarm)
        scheduleOne(context, alarm, fireAt)
        NotificationManagerCompat.from(context)
            .cancel(notificationIdFor(alarm["id"] as String))
    }

    fun fireNow(context: Context, intent: Intent) {
        ensureChannels(context)
        val alarmId = intent.getStringExtra(EXTRA_ALARM_ID) ?: return
        val title = intent.getStringExtra(EXTRA_TITLE)
            ?: context.getString(R.string.prayer_alarm_badge)
        val subtitle = intent.getStringExtra(EXTRA_SUBTITLE)
            ?: context.getString(R.string.prayer_alarm_subtitle)
        val sound = intent.getStringExtra(EXTRA_SOUND) ?: "fullAdhan"
        val activityIntent = PrayerAlarmActivity.intentFrom(context, intent).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val contentPendingIntent = PendingIntent.getActivity(
            context,
            notificationIdFor(alarmId),
            activityIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        // Official FSI behavior:
        // - locked / idle + FSI granted → system may launch full-screen activity
        // - unlocked / FSI denied → high-priority heads-up; user taps to open activity
        // Do NOT call startActivity() from the receiver; background launches are restricted.
        val useFsi = canUseFullScreenIntent(context)
        val builder = NotificationCompat.Builder(context, channelFor(sound))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(subtitle)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setAutoCancel(true)
            .setOngoing(true)
            .setContentIntent(contentPendingIntent)

        if (useFsi) {
            builder.setFullScreenIntent(contentPendingIntent, true)
        }

        runCatching {
            NotificationManagerCompat.from(context)
                .notify(notificationIdFor(alarmId), builder.build())
        }
    }

    fun canUseFullScreenIntent(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            return true
        }
        val manager = context.getSystemService(NotificationManager::class.java)
        return manager?.canUseFullScreenIntent() == true
    }

    fun openFullScreenIntentSettings(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            return false
        }
        return runCatching {
            val intent = Intent(android.provider.Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                data = Uri.parse("package:${context.packageName}")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(intent)
            true
        }.getOrDefault(false)
    }

    private fun scheduleOne(context: Context, alarm: Map<String, Any?>, fireAt: Long) {
        val alarmId = alarm["id"] as? String ?: return
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val operation = firePendingIntent(context, alarmId, alarm)
        val showIntent = PendingIntent.getActivity(
            context,
            notificationIdFor(alarmId) + 100_000,
            Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val info = AlarmManager.AlarmClockInfo(fireAt, showIntent)
        alarmManager.setAlarmClock(info, operation)
    }

    private fun firePendingIntent(
        context: Context,
        alarmId: String,
        alarm: Map<String, Any?>,
    ): PendingIntent {
        val intent = Intent(context, PrayerAlarmReceiver::class.java).apply {
            action = ACTION_FIRE
            putExtra(EXTRA_ALARM_ID, alarmId)
            putExtra(EXTRA_PRAYER, alarm["prayer"] as? String)
            putExtra(EXTRA_TITLE, alarm["title"] as? String)
            putExtra(EXTRA_SUBTITLE, alarm["subtitle"] as? String)
            putExtra(EXTRA_PRAYER_LABEL, alarm["prayerLabel"] as? String)
            putExtra(EXTRA_BADGE, alarm["badgeLabel"] as? String)
            putExtra(EXTRA_IVE_PRAYED, alarm["ivePrayedLabel"] as? String)
            putExtra(EXTRA_DISMISS, alarm["dismissLabel"] as? String)
            putExtra(EXTRA_SNOOZE, alarm["snoozeLabel"] as? String)
            putExtra(EXTRA_SOUND, alarm["sound"] as? String)
            putExtra(
                EXTRA_SNOOZE_MINUTES,
                ((alarm["snoozeMinutes"] as? Number)?.toInt() ?: 10),
            )
            putExtra(
                EXTRA_FIRE_AT_MS,
                ((alarm["fireAtMs"] as? Number)?.toLong() ?: 0L),
            )
        }
        return PendingIntent.getBroadcast(
            context,
            requestCodeFor(alarmId),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun requestCodeFor(alarmId: String): Int {
        // Stable 31-bit positive code; avoid tiny 12-bit masks that collide across days.
        return 50_000 + (alarmId.hashCode() and 0x3FFF_FFFF)
    }

    fun notificationIdFor(alarmId: String): Int {
        return NOTIFICATION_BASE + (alarmId.hashCode() and 0x3FFF_FFFF)
    }

    private fun channelFor(sound: String): String {
        return when (sound) {
            "beep" -> CHANNEL_BEEP
            "mute" -> CHANNEL_MUTE
            else -> CHANNEL_ADHAN
        }
    }

    private fun ensureChannels(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(NotificationManager::class.java) ?: return
        val adhanUri = Uri.parse("android.resource://${context.packageName}/${R.raw.azan}")
        val beepUri = Uri.parse("android.resource://${context.packageName}/${R.raw.beep}")
        val audioAttrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()

        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_ADHAN,
                context.getString(R.string.prayer_alarm_channel_adhan),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                setSound(adhanUri, audioAttrs)
                enableVibration(true)
                setBypassDnd(true)
            },
        )
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_BEEP,
                context.getString(R.string.prayer_alarm_channel_beep),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                setSound(beepUri, audioAttrs)
                enableVibration(true)
                setBypassDnd(true)
            },
        )
        manager.createNotificationChannel(
            NotificationChannel(
                CHANNEL_MUTE,
                context.getString(R.string.prayer_alarm_channel_mute),
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                setSound(null, null)
                enableVibration(true)
            },
        )
    }
}
