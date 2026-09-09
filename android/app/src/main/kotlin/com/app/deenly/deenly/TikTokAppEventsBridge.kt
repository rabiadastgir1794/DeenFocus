package com.rnr.deenfocus

import android.app.Application
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.tiktok.TikTokBusinessSdk
import com.tiktok.appevents.base.EventName
import com.tiktok.appevents.base.TTBaseEvent
import com.tiktok.appevents.contents.TTContentsEventConstants
import com.tiktok.appevents.contents.TTPurchaseEvent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * MethodChannel bridge for the official TikTok App Events Android SDK.
 *
 * All TikTok calls are wrapped so tracking never crashes or blocks the app.
 */
object TikTokAppEventsBridge : MethodChannel.MethodCallHandler {
    const val CHANNEL = "com.app.deenly.deenly/tiktok_app_events"

    private const val TAG = "TikTokAppEvents"
    private val mainHandler = Handler(Looper.getMainLooper())

    @Volatile
    private var initialized = false

    @Volatile
    private var appContext: Context? = null

    fun attach(context: Context) {
        appContext = context.applicationContext
    }

    /**
     * Early Application-time init from BuildConfig / local.properties.
     * Safe no-op when credentials are missing.
     */
    fun initializeFromBuildConfig(application: Application) {
        val secret = BuildConfig.TIKTOK_APP_SECRET.trim()
        val ttAppId = BuildConfig.TIKTOK_TT_APP_ID.trim()
        val appId = BuildConfig.TIKTOK_APP_ID.trim().ifEmpty {
            application.packageName
        }
        if (secret.isEmpty() || ttAppId.isEmpty()) {
            Log.i(TAG, "Skipping early init; TikTok credentials not configured")
            return
        }
        initializeInternal(
            application = application,
            appId = appId,
            ttAppId = ttAppId,
            appSecret = secret,
            debug = BuildConfig.DEBUG,
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "initialize" -> {
                    val appId = call.argument<String>("appId").orEmpty().trim()
                    val ttAppId = call.argument<String>("ttAppId").orEmpty().trim()
                    val appSecret = call.argument<String>("appSecret").orEmpty().trim()
                    val debug = call.argument<Boolean>("debug") ?: false
                    val context = appContext
                    if (context == null) {
                        result.success(mapOf("ok" to false, "reason" to "no_context"))
                        return
                    }
                    val ok = initializeInternal(
                        application = context.applicationContext as Application,
                        appId = appId.ifEmpty { context.packageName },
                        ttAppId = ttAppId,
                        appSecret = appSecret,
                        debug = debug,
                    )
                    result.success(mapOf("ok" to ok, "initialized" to initialized))
                }
                "isInitialized" -> result.success(initialized)
                "trackPurchase" -> {
                    trackPurchase(call.argumentsAsMap())
                    result.success(true)
                }
                "trackSubscribe" -> {
                    trackStandardEvent(EventName.SUBSCRIBE, call.argumentsAsMap())
                    result.success(true)
                }
                "trackStartTrial" -> {
                    trackStandardEvent(EventName.START_TRIAL, call.argumentsAsMap())
                    result.success(true)
                }
                "trackEvent" -> {
                    val name = call.argument<String>("eventName").orEmpty().trim()
                    if (name.isEmpty()) {
                        result.success(false)
                        return
                    }
                    trackNamedEvent(name, call.argumentsAsMap())
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        } catch (t: Throwable) {
            Log.w(TAG, "MethodChannel ${call.method} failed safely", t)
            // Never fail the Flutter call with an error that could break purchase UX.
            result.success(false)
        }
    }

    private fun initializeInternal(
        application: Application,
        appId: String,
        ttAppId: String,
        appSecret: String,
        debug: Boolean,
    ): Boolean {
        if (initialized) return true
        if (appSecret.isEmpty() || ttAppId.isEmpty() || appId.isEmpty()) {
            Log.i(TAG, "Initialize skipped; missing appId/ttAppId/appSecret")
            return false
        }

        return try {
            val config = TikTokBusinessSdk.TTConfig(application, appSecret)
                .setAppId(appId)
                .setTTAppId(ttAppId)
                // Manual Purchase/Subscribe/StartTrial after confirmed Superwall success.
                .disableAutoIapTrack()

            if (debug) {
                config.setLogLevel(TikTokBusinessSdk.LogLevel.DEBUG)
            }

            TikTokBusinessSdk.initializeSdk(
                config,
                object : TikTokBusinessSdk.TTInitCallback {
                    override fun success() {
                        Log.i(TAG, "TikTok SDK initialized")
                    }

                    override fun fail(code: Int, msg: String?) {
                        Log.w(TAG, "TikTok SDK init failed code=$code msg=$msg")
                    }
                },
            )
            initialized = true
            true
        } catch (t: Throwable) {
            Log.w(TAG, "TikTok SDK initialize threw; continuing without tracking", t)
            false
        }
    }

    private fun trackPurchase(args: Map<String, Any?>) {
        if (!initialized) return
        try {
            val eventId = stringArg(args, "eventId")
            val contentId = stringArg(args, "contentId")
            val contentType = stringArg(args, "contentType").ifEmpty { "product" }
            val description = stringArg(args, "description")
            val currencyCode = stringArg(args, "currency")
            val value = doubleArg(args, "value")

            val builder = if (eventId.isEmpty()) {
                TTPurchaseEvent.newBuilder()
            } else {
                TTPurchaseEvent.newBuilder(eventId)
            }
            builder.setContentType(contentType)
            if (contentId.isNotEmpty()) builder.setContentId(contentId)
            if (description.isNotEmpty()) builder.setDescription(description)
            if (value != null) builder.setValue(value)
            currencyOf(currencyCode)?.let { builder.setCurrency(it) }

            TikTokBusinessSdk.trackTTEvent(builder.build())
        } catch (t: Throwable) {
            Log.w(TAG, "trackPurchase failed safely", t)
        }
    }

    private fun trackStandardEvent(eventName: EventName, args: Map<String, Any?>) {
        if (!initialized) return
        try {
            val eventId = stringArg(args, "eventId")
            val contentId = stringArg(args, "contentId")
            val currencyCode = stringArg(args, "currency")
            val value = doubleArg(args, "value")
            val hasProps = contentId.isNotEmpty() || currencyCode.isNotEmpty() || value != null

            if (!hasProps) {
                if (eventId.isEmpty()) {
                    TikTokBusinessSdk.trackTTEvent(eventName)
                } else {
                    TikTokBusinessSdk.trackTTEvent(eventName, eventId)
                }
                return
            }

            val builder = if (eventId.isEmpty()) {
                TTBaseEvent.newBuilder(eventName.toString())
            } else {
                TTBaseEvent.newBuilder(eventName.toString(), eventId)
            }
            if (contentId.isNotEmpty()) {
                builder.addProperty(
                    TTContentsEventConstants.Params.EVENT_PROPERTY_CONTENT_ID,
                    contentId,
                )
            }
            if (value != null) {
                builder.addProperty(
                    TTContentsEventConstants.Params.EVENT_PROPERTY_VALUE,
                    value,
                )
            }
            if (currencyCode.isNotEmpty()) {
                builder.addProperty(
                    TTContentsEventConstants.Params.EVENT_PROPERTY_CURRENCY,
                    currencyCode,
                )
            }
            TikTokBusinessSdk.trackTTEvent(builder.build())
        } catch (t: Throwable) {
            Log.w(TAG, "trackStandardEvent ${eventName} failed safely", t)
        }
    }

    private fun trackNamedEvent(name: String, args: Map<String, Any?>) {
        if (!initialized) return
        try {
            val eventId = stringArg(args, "eventId")
            val builder = if (eventId.isEmpty()) {
                TTBaseEvent.newBuilder(name)
            } else {
                TTBaseEvent.newBuilder(name, eventId)
            }
            val contentId = stringArg(args, "contentId")
            val currencyCode = stringArg(args, "currency")
            val value = doubleArg(args, "value")
            if (contentId.isNotEmpty()) {
                builder.addProperty(
                    TTContentsEventConstants.Params.EVENT_PROPERTY_CONTENT_ID,
                    contentId,
                )
            }
            if (value != null) {
                builder.addProperty(
                    TTContentsEventConstants.Params.EVENT_PROPERTY_VALUE,
                    value,
                )
            }
            if (currencyCode.isNotEmpty()) {
                builder.addProperty(
                    TTContentsEventConstants.Params.EVENT_PROPERTY_CURRENCY,
                    currencyCode,
                )
            }
            TikTokBusinessSdk.trackTTEvent(builder.build())
        } catch (t: Throwable) {
            Log.w(TAG, "trackNamedEvent $name failed safely", t)
        }
    }

    private fun currencyOf(code: String): TTContentsEventConstants.Currency? {
        if (code.isEmpty()) return null
        return try {
            TTContentsEventConstants.Currency.valueOf(code.uppercase())
        } catch (_: Throwable) {
            null
        }
    }

    private fun MethodCall.argumentsAsMap(): Map<String, Any?> {
        val raw = arguments
        if (raw is Map<*, *>) {
            val out = HashMap<String, Any?>()
            for ((k, v) in raw) {
                if (k is String) out[k] = v
            }
            return out
        }
        return emptyMap()
    }

    private fun stringArg(args: Map<String, Any?>, key: String): String {
        val value = args[key] ?: return ""
        return value.toString().trim()
    }

    private fun doubleArg(args: Map<String, Any?>, key: String): Double? {
        val value = args[key] ?: return null
        return when (value) {
            is Number -> value.toDouble()
            is String -> value.toDoubleOrNull()
            else -> null
        }
    }

    @Suppress("unused")
    private fun replyOnMain(result: MethodChannel.Result, value: Any?) {
        if (Looper.myLooper() == Looper.getMainLooper()) {
            result.success(value)
        } else {
            mainHandler.post { result.success(value) }
        }
    }
}
