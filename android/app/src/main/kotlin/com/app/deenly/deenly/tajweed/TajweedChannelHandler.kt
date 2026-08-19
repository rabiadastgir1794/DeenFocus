package com.rnr.deenfocus.tajweed

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * MethodChannel + EventChannel wiring for Tajweed (ADR-006).
 * Port of ios/Runner/Tajweed/TajweedChannelHandler.swift — same channel names,
 * same method names, same JSON/error shape; only the native engine underneath differs.
 */
class TajweedChannelHandler(private val context: Context) : EventChannel.StreamHandler {
    /** Lazy — constructing [TajweedEngine] at FlutterEngine configure hung launch when
     * the engine eagerly parsed the 12MB canonical lexicon. */
    private val engine by lazy { TajweedEngine.getInstance(context) }
    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null
    private var didBindEngineEvents = false

    fun attach(methodChannel: MethodChannel, eventChannel: EventChannel) {
        eventChannel.setStreamHandler(this)
        methodChannel.setMethodCallHandler { call, result -> handle(call, result) }
    }

    private fun bindEngineEventsIfNeeded() {
        if (didBindEngineEvents) return
        didBindEngineEvents = true
        engine.onEvent = { payload -> eventSink?.success(payload) }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        // Do not construct TajweedEngine here — listen alone must stay cheap
        // at launch / Settings; engine is created on the first method that needs it.
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun onMemoryTrim() {
        if (didBindEngineEvents) engine.onMemoryWarning()
    }

    fun onAppBackground() {
        if (didBindEngineEvents) engine.onAppBackground()
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            // Flag get/set must NOT construct TajweedEngine (Settings loads this at launch).
            "getCanonicalLexicalProductionEnabled" -> {
                CanonicalLexicalAuthority.init(context)
                mainHandler.post {
                    result.success(
                        mapOf(
                            "enabled" to CanonicalLexicalAuthority.productionEnabled,
                            "defaultsKey" to CanonicalLexicalAuthority.KEY,
                        ),
                    )
                }
            }
            "setCanonicalLexicalProductionEnabled" -> {
                CanonicalLexicalAuthority.init(context)
                val enabled = CanonicalLexicalAuthority.parseEnabledArgument(call.argument("enabled"))
                    ?: CanonicalLexicalAuthority.parseEnabledArgument(
                        (call.arguments as? Map<*, *>)?.get("enabled"),
                    )
                if (enabled == null) {
                    mainHandler.post {
                        result.error(
                            TajweedErrorCode.INVALID_ARGS,
                            "enabled: Bool required (got ${call.argument<Any>("enabled")})",
                            null,
                        )
                    }
                    return
                }
                CanonicalLexicalAuthority.productionEnabled = enabled
                mainHandler.post {
                    result.success(
                        mapOf(
                            "enabled" to CanonicalLexicalAuthority.productionEnabled,
                            "defaultsKey" to CanonicalLexicalAuthority.KEY,
                        ),
                    )
                }
            }
            "isAvailable" -> {
                bindEngineEventsIfNeeded()
                result.success(engine.isAvailable())
            }
            "getRecordingState" -> {
                bindEngineEventsIfNeeded()
                result.success(engine.getRecordingState())
            }
            "ensureModel" -> {
                bindEngineEventsIfNeeded()
                engine.ensureModel { outcome -> deliver(outcome, result) }
            }
            "prepareModel" -> {
                bindEngineEventsIfNeeded()
                engine.prepareModel { outcome -> deliver(outcome, result) }
            }
            "startRecording" -> {
                bindEngineEventsIfNeeded()
                val surah = call.argument<Int>("surah")
                val ayah = call.argument<Int>("ayah")
                val expected = call.argument<String>("expectedArabic")
                val lexicalRef = call.argument<String>("lexicalReferenceArabic")
                if (surah == null || ayah == null || expected == null) {
                    mainHandler.post {
                        result.error(TajweedErrorCode.INVALID_ARGS, "surah, ayah, expectedArabic required", null)
                    }
                    return
                }
                engine.startRecording(
                    surah,
                    ayah,
                    expected,
                    lexicalReferenceArabic = lexicalRef,
                ) { outcome -> deliver(outcome, result) }
            }
            "stopRecordingAndScore" -> {
                bindEngineEventsIfNeeded()
                engine.stopRecordingAndScore { outcome -> deliverJson(outcome, result) }
            }
            "cancelRecording" -> {
                bindEngineEventsIfNeeded()
                engine.cancelRecording { outcome -> deliver(outcome, result) }
            }
            "dispose" -> {
                if (didBindEngineEvents) engine.dispose()
                mainHandler.post { result.success(null) }
            }
            "getActiveCoreMlInfo" -> {
                val store = ModelStore(context.applicationContext)
                val info = mutableMapOf<String, Any?>(
                    "available" to store.isAvailable(),
                    "version" to store.activeManifestVersion(),
                    "manifestVersion" to store.activeManifestVersion(),
                    "encoderSha256" to store.activeEncoderSha256(),
                )
                mainHandler.post { result.success(info) }
            }
            else -> mainHandler.post { result.notImplemented() }
        }
    }

    /** Every native completion crosses back to the main thread exactly once here —
     * Flutter's platform channels require MethodChannel.Result to be invoked on the main thread. */
    private fun deliver(outcome: Result<Unit>, result: MethodChannel.Result) {
        mainHandler.post {
            outcome.fold(
                onSuccess = { result.success(null) },
                onFailure = { e -> result.error(flutterCode(e), e.message, null) },
            )
        }
    }

    private fun deliverJson(outcome: Result<Map<String, Any?>>, result: MethodChannel.Result) {
        mainHandler.post {
            outcome.fold(
                onSuccess = { json -> result.success(json) },
                onFailure = { e -> result.error(flutterCode(e), e.message, null) },
            )
        }
    }

    companion object {
        fun flutterCode(e: Throwable): String = (e as? TajweedNativeException)?.code ?: TajweedErrorCode.INFERENCE_FAILED
    }
}
