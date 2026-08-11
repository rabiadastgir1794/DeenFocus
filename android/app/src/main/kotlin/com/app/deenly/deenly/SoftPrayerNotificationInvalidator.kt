package com.rnr.deenfocus

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver
import org.json.JSONArray

/**
 * Soft prayer reminders (flutter_local_notifications IDs 1000–1199).
 *
 * Timezone changes invalidate absolute triggers for the previous zone — clear
 * them and let Flutter rebuild. Plain [Intent.ACTION_TIME_CHANGED] (NTP / auto
 * clock) must NOT clear pending Fajr→Isha alarms; only mark a resume rebuild.
 */
object SoftPrayerNotificationInvalidator {
    private const val PRAYER_ID_START = 1000
    private const val PRAYER_ID_END = 1199
    private const val FLN_PREFS = "scheduled_notifications"
    private const val FLN_KEY = "scheduled_notifications"
    private const val FLUTTER_PREFS = "FlutterSharedPreferences"
    private const val NEEDS_RESCHEDULE_KEY = "flutter.needs_prayer_notification_reschedule"

    fun invalidateAfterTimeChange(context: Context) {
        cancelAlarmManagerEntries(context)
        stripFromFlutterLocalNotificationsCache(context)
        markNeedsReschedule(context)
        FocusDebugLogger.append(
            context,
            "prayer_notif.tz_clear",
            "cleared soft prayer notification schedule for recalculation",
        )
    }

    /** Marks Flutter to force-reschedule without cancelling pending soft alarms. */
    fun markNeedsRescheduleOnly(context: Context) {
        markNeedsReschedule(context)
        FocusDebugLogger.append(
            context,
            "prayer_notif.mark_dirty",
            "marked soft prayer schedule dirty without clearing pending alarms",
        )
    }

    private fun cancelAlarmManagerEntries(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val flags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        for (id in PRAYER_ID_START..PRAYER_ID_END) {
            val intent = Intent(context, ScheduledNotificationReceiver::class.java)
            val pending = PendingIntent.getBroadcast(context, id, intent, flags)
            alarmManager.cancel(pending)
            pending.cancel()
        }
    }

    private fun stripFromFlutterLocalNotificationsCache(context: Context) {
        runCatching {
            val prefs = context.getSharedPreferences(FLN_PREFS, Context.MODE_PRIVATE)
            val raw = prefs.getString(FLN_KEY, null) ?: return
            val array = JSONArray(raw)
            val kept = JSONArray()
            for (i in 0 until array.length()) {
                val item = array.optJSONObject(i) ?: continue
                val id = item.optInt("id", Int.MIN_VALUE)
                if (id in PRAYER_ID_START..PRAYER_ID_END) continue
                kept.put(item)
            }
            prefs.edit().putString(FLN_KEY, kept.toString()).apply()
        }
    }

    private fun markNeedsReschedule(context: Context) {
        context
            .getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
            .edit()
            .putBoolean(NEEDS_RESCHEDULE_KEY, true)
            .apply()
    }
}
