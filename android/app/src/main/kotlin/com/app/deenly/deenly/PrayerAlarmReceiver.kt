package com.rnr.deenfocus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class PrayerAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        val action = intent?.action ?: return
        when (action) {
            PrayerAlarmScheduler.ACTION_FIRE -> {
                PrayerAlarmScheduler.fireNow(context, intent)
            }
            PrayerAlarmScheduler.ACTION_SNOOZE -> {
                PrayerAlarmScheduler.snooze(context, intent)
            }
            PrayerAlarmScheduler.ACTION_DISMISS -> {
                val alarmId = intent.getStringExtra(PrayerAlarmScheduler.EXTRA_ALARM_ID)
                if (!alarmId.isNullOrBlank()) {
                    PrayerAlarmScheduler.cancelOne(context, alarmId)
                }
            }
        }
    }
}
