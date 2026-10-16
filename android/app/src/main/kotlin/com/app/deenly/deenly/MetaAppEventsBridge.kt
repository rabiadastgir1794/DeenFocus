package com.rnr.deenfocus

import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import com.facebook.FacebookSdk
import com.facebook.LoggingBehavior
import com.facebook.appevents.AppEventsConstants
import com.facebook.appevents.AppEventsLogger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.math.BigDecimal
import java.util.Currency

/**
 * MethodChannel bridge for the official Meta/Facebook App Events Android SDK.
 * Failures are swallowed so tracking never crashes the app.
 */
object MetaAppEventsBridge : MethodChannel.MethodCallHandler {
    const val CHANNEL = "com.app.deenly.deenly/meta_app_events"

    private const val TAG = "MetaAppEvents"

    @Volatile
    private var initialized = false

    @Volatile
    private var appContext: Context? = null

    @Volatile
    private var logger: AppEventsLogger? = null

    fun attach(context: Context) {
        appContext = context.applicationContext
    }

    /** Early Application init from BuildConfig when credentials are present. */
    fun initializeFromBuildConfig(application: Application) {
        val appId = BuildConfig.META_APP_ID.trim()
        val clientToken = BuildConfig.META_CLIENT_TOKEN.trim()
        if (appId.isEmpty() || clientToken.isEmpty()) {
            Log.i(TAG, "Skipping early Meta init; credentials not configured")
            return
        }
        initializeInternal(
            application = application,
            appId = appId,
            clientToken = clientToken,
            displayName = BuildConfig.META_DISPLAY_NAME.trim().ifEmpty { "Deen Focus" },
            debug = BuildConfig.DEBUG,
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "initialize" -> {
                    val context = appContext
                    if (context == null) {
                        result.success(mapOf("ok" to false, "reason" to "no_context"))
                        return
                    }
                    val ok = initializeInternal(
                        application = context.applicationContext as Application,
                        appId = call.argument<String>("appId").orEmpty().trim(),
                        clientToken = call.argument<String>("clientToken").orEmpty().trim(),
                        displayName = call.argument<String>("displayName").orEmpty().trim()
                            .ifEmpty { "Deen Focus" },
                        debug = call.argument<Boolean>("debug") ?: false,
                    )
                    result.success(mapOf("ok" to ok, "initialized" to initialized))
                }
                "isInitialized" -> result.success(initialized)
                "trackAppLaunch" -> {
                    trackAppLaunch()
                    result.success(true)
                }
                "trackPurchase" -> {
                    trackPurchase(call)
                    result.success(true)
                }
                "trackSubscribe" -> {
                    trackStandard(
                        eventName = AppEventsConstants.EVENT_NAME_SUBSCRIBE,
                        call = call,
                    )
                    result.success(true)
                }
                "trackStartTrial" -> {
                    trackStandard(
                        eventName = AppEventsConstants.EVENT_NAME_START_TRIAL,
                        call = call,
                    )
                    result.success(true)
                }
                "setAdvertiserTrackingEnabled" -> {
                    // Android uses AdvertiserIDCollectionEnabled; no ATT equivalent.
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        } catch (t: Throwable) {
            Log.w(TAG, "MethodChannel ${call.method} failed safely", t)
            result.success(false)
        }
    }

    private fun initializeInternal(
        application: Application,
        appId: String,
        clientToken: String,
        displayName: String,
        debug: Boolean,
    ): Boolean {
        if (initialized) return true
        if (appId.isEmpty() || clientToken.isEmpty()) {
            Log.i(TAG, "Initialize skipped; missing META_APP_ID / META_CLIENT_TOKEN")
            return false
        }

        return try {
            FacebookSdk.setApplicationId(appId)
            FacebookSdk.setClientToken(clientToken)
            FacebookSdk.setApplicationName(displayName)
            // Keep Install/Launch auto-logging; conversion events are manual after Superwall.
            FacebookSdk.setAutoInitEnabled(true)
            FacebookSdk.setAutoLogAppEventsEnabled(true)
            FacebookSdk.setAdvertiserIDCollectionEnabled(true)
            FacebookSdk.sdkInitialize(application)
            FacebookSdk.fullyInitialize()

            if (debug) {
                FacebookSdk.setIsDebugEnabled(true)
                FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS)
            }

            logger = AppEventsLogger.newLogger(application)
            // ActivateApp / launch is also auto-logged; this reinforces session start.
            AppEventsLogger.activateApp(application)
            initialized = true
            Log.i(TAG, "Meta SDK initialized")
            true
        } catch (t: Throwable) {
            Log.w(TAG, "Meta SDK initialize threw; continuing without tracking", t)
            false
        }
    }

    private fun trackAppLaunch() {
        if (!initialized) return
        try {
            val application = appContext?.applicationContext as? Application ?: return
            AppEventsLogger.activateApp(application)
        } catch (t: Throwable) {
            Log.w(TAG, "trackAppLaunch failed safely", t)
        }
    }

    private fun trackPurchase(call: MethodCall) {
        if (!initialized) return
        try {
            val value = (call.argument<Number>("value") ?: return).toDouble()
            val currencyCode = call.argument<String>("currency").orEmpty().trim()
            if (currencyCode.isEmpty()) return

            val params = Bundle()
            val contentId = call.argument<String>("contentId").orEmpty().trim()
            val contentType = call.argument<String>("contentType").orEmpty().trim()
                .ifEmpty { "product" }
            val eventId = call.argument<String>("eventId").orEmpty().trim()
            if (contentId.isNotEmpty()) {
                params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, contentId)
            }
            params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_TYPE, contentType)
            if (eventId.isNotEmpty()) {
                params.putString(AppEventsConstants.EVENT_PARAM_ORDER_ID, eventId)
            }

            logger?.logPurchase(
                BigDecimal.valueOf(value),
                Currency.getInstance(currencyCode.uppercase()),
                params,
            )
        } catch (t: Throwable) {
            Log.w(TAG, "trackPurchase failed safely", t)
        }
    }

    private fun trackStandard(eventName: String, call: MethodCall) {
        if (!initialized) return
        try {
            val params = Bundle()
            val contentId = call.argument<String>("contentId").orEmpty().trim()
            val currencyCode = call.argument<String>("currency").orEmpty().trim()
            val eventId = call.argument<String>("eventId").orEmpty().trim()
            val value = call.argument<Number>("value")?.toDouble()

            if (contentId.isNotEmpty()) {
                params.putString(AppEventsConstants.EVENT_PARAM_CONTENT_ID, contentId)
            }
            if (currencyCode.isNotEmpty()) {
                params.putString(AppEventsConstants.EVENT_PARAM_CURRENCY, currencyCode.uppercase())
            }
            if (eventId.isNotEmpty()) {
                params.putString(AppEventsConstants.EVENT_PARAM_ORDER_ID, eventId)
            }

            if (value != null) {
                logger?.logEvent(eventName, value, params)
            } else {
                logger?.logEvent(eventName, params)
            }
        } catch (t: Throwable) {
            Log.w(TAG, "trackStandard $eventName failed safely", t)
        }
    }
}
