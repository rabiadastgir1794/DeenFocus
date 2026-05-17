package com.rnr.deenfocus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Restores focus transition alarms after reboot or clock/timezone changes.
 * Prayer notifications are rescheduled by flutter_local_notifications; focus
 * alarms must be restored from the persisted transition list separately.
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
        if (maps.isEmpty()) return
        FocusScheduleManager.sync(context, maps, force = true)
    }
}
