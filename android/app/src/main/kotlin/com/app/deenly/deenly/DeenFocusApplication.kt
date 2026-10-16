package com.rnr.deenfocus

import android.app.Application
import android.util.Log

/**
 * Custom Application so TikTok App Events can initialize before the first Flutter frame
 * (InstallApp / LaunchAPP auto events). Embedding v2 does not require FlutterApplication.
 */
class DeenFocusApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        try {
            TikTokAppEventsBridge.attach(this)
            TikTokAppEventsBridge.initializeFromBuildConfig(this)
        } catch (t: Throwable) {
            Log.w("DeenFocusApplication", "TikTok early init failed safely", t)
        }
        try {
            MetaAppEventsBridge.attach(this)
            MetaAppEventsBridge.initializeFromBuildConfig(this)
        } catch (t: Throwable) {
            Log.w("DeenFocusApplication", "Meta early init failed safely", t)
        }
    }
}
