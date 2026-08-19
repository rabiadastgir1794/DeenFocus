package com.rnr.deenfocus.tajweed

/** Stable Flutter MethodChannel error codes (ADR-006). Add-only. Mirrors TajweedErrors.swift. */
object TajweedErrorCode {
    const val FEATURE_DISABLED = "FEATURE_DISABLED"
    const val MIC_PERMISSION_DENIED = "MIC_PERMISSION_DENIED"
    const val MIC_BUSY = "MIC_BUSY"
    const val NOT_RECORDING = "NOT_RECORDING"
    const val ALREADY_RECORDING = "ALREADY_RECORDING"
    const val AUDIO_TOO_SHORT = "AUDIO_TOO_SHORT"
    const val AUDIO_TOO_LONG = "AUDIO_TOO_LONG"
    const val AUDIO_QUALITY_POOR = "AUDIO_QUALITY_POOR"
    const val MODEL_MISSING = "MODEL_MISSING"
    const val MODEL_DOWNLOAD_FAILED = "MODEL_DOWNLOAD_FAILED"
    const val MODEL_LOAD_FAILED = "MODEL_LOAD_FAILED"
    const val INFERENCE_FAILED = "INFERENCE_FAILED"
    const val INFERENCE_CANCELLED = "INFERENCE_CANCELLED"
    const val INTERRUPTED = "INTERRUPTED"
    const val UNSUPPORTED = "UNSUPPORTED"
    const val INVALID_ARGS = "INVALID_ARGS"
}

enum class TajweedRecordingState(val wireValue: String) {
    IDLE("idle"),
    RECORDING("recording"),
    SCORING("scoring"),
    CANCELLING("cancelling"),
}

/** Native-side exception carrying a stable [TajweedErrorCode]; never leaks a raw Kotlin exception to Flutter. */
class TajweedNativeException(
    val code: String,
    override val message: String,
) : Exception(message)
