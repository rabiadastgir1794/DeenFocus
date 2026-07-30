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
class TajweedChannelHandler(context: Context) : EventChannel.StreamHandler {
    private val engine = TajweedEngine.getInstance(context)
    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null

    fun attach(methodChannel: MethodChannel, eventChannel: EventChannel) {
        eventChannel.setStreamHandler(this)
        engine.onEvent = { payload -> eventSink?.success(payload) }
        methodChannel.setMethodCallHandler { call, result -> handle(call, result) }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun onMemoryTrim() = engine.onMemoryWarning()
    fun onAppBackground() = engine.onAppBackground()

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAvailable" -> result.success(engine.isAvailable())
            "getRecordingState" -> result.success(engine.getRecordingState())
            "ensureModel" -> engine.ensureModel { outcome -> deliver(outcome, result) }
            "prepareModel" -> engine.prepareModel { outcome -> deliver(outcome, result) }
            "startRecording" -> {
                val surah = call.argument<Int>("surah")
                val ayah = call.argument<Int>("ayah")
                val expected = call.argument<String>("expectedArabic")
                if (surah == null || ayah == null || expected == null) {
                    mainHandler.post {
                        result.error(TajweedErrorCode.INVALID_ARGS, "surah, ayah, expectedArabic required", null)
                    }
                    return
                }
                engine.startRecording(surah, ayah, expected) { outcome -> deliver(outcome, result) }
            }
            "stopRecordingAndScore" -> engine.stopRecordingAndScore { outcome -> deliverJson(outcome, result) }
            "cancelRecording" -> engine.cancelRecording { outcome -> deliver(outcome, result) }
            "dispose" -> {
                engine.dispose()
                mainHandler.post { result.success(null) }
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
