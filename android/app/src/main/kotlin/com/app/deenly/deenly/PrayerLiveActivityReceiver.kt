package com.rnr.deenfocus

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class PrayerLiveActivityReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        when (intent?.action) {
            ACTION_REFRESH,
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_MY_PACKAGE_REPLACED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_DATE_CHANGED,
            -> PrayerLiveActivityBridge.refreshFromStorage(context)
        }
    }

    companion object {
        const val ACTION_REFRESH = "com.rnr.deenfocus.PRAYER_LIVE_ACTIVITY_REFRESH"
    }
}
