package com.rnr.deenfocus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Restores focus transition alarms after reboot or clock/timezone changes.
 *
 * Soft prayer reminders + native prayer alarms:
 * - TIMEZONE_CHANGED → clear stale absolute triggers (Flutter rebuilds on resume)
 * - TIME_CHANGED (NTP/auto-time) → keep pending Fajr→Isha; only mark dirty
 * - BOOT / package replace → restore native alarms from store
 */
class FocusBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val action = intent?.action ?: return
        if (action != Intent.ACTION_BOOT_COMPLETED &&
            action != Intent.ACTION_MY_PACKAGE_REPLACED &&
            action != Intent.ACTION_TIME_CHANGED &&
            action != Intent.ACTION_TIMEZONE_CHANGED
        ) {
            return
        }
        FocusDebugLogger.append(context, "boot.reschedule", "action=$action")
        val maps = FocusBlockerStore.scheduledTransitionMaps(context)
        if (maps.isNotEmpty()) {
            FocusScheduleManager.sync(context, maps, force = true)
        }
        when (action) {
            Intent.ACTION_TIMEZONE_CHANGED -> {
                // Wall-clock prayer times move with the zone. Absolute epoch
                // triggers from the previous zone are wrong — clear and rebuild
                // when Flutter resumes.
                PrayerAlarmScheduler.cancelAll(context, clearStore = true)
                SoftPrayerNotificationInvalidator.invalidateAfterTimeChange(context)
                FocusDebugLogger.append(
                    context,
                    "prayer_alarm.tz_clear",
                    "cleared soft+native prayer schedules after timezone change",
                )
            }
            Intent.ACTION_TIME_CHANGED -> {
                // NTP / auto-time tweaks fire TIME_CHANGED constantly. Absolute
                // epoch triggers remain correct — do NOT wipe pending Fajr→Isha
                // alarms (that silently drops the next prayer until the app opens).
                SoftPrayerNotificationInvalidator.markNeedsRescheduleOnly(context)
                FocusDebugLogger.append(
                    context,
                    "prayer_alarm.time_changed",
                    "kept pending prayer schedules; marked soft rebuild on resume",
                )
            }
            else -> {
                // BOOT / package replace: restore surviving setAlarmClock entries.
                PrayerAlarmScheduler.restoreFromStore(context)
            }
        }
    }
}
