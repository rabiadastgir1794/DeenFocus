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
            -> PrayerLiveActivityBridge.refreshFromStorage(context)
        }
    }

    companion object {
        const val ACTION_REFRESH = "com.rnr.deenfocus.PRAYER_LIVE_ACTIVITY_REFRESH"
    }
}
