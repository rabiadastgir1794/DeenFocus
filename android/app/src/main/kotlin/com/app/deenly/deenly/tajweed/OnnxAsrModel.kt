package com.rnr.deenfocus.tajweed

import ai.onnxruntime.OnnxTensor
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import java.io.File
import java.nio.FloatBuffer
import java.nio.LongBuffer
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

data class AsrInferenceResult(
    val logprobs: Array<FloatArray>,
    val encoderOutput: Array<FloatArray>,
)

/**
 * Loads the ONNX FastConformer-Quran encoder (see tajweed-lab/web/asr/session.py for the
 * reference contract: input `audio_signal` (1, 80, T) + `length` int64[1], outputs
 * `logprobs` and optional `encoder_output`). Port of ios/Runner/Tajweed/OfflineAsrModel.swift,
 * using ONNX Runtime Mobile instead of CoreML — model is loaded once and reused (ADR-007).
 */
class OnnxAsrModel {
    private val lock = ReentrantLock()
    private var session: OrtSession? = null

    // Lazy: touching OrtEnvironment loads the native ONNX Runtime library. Deferring this
    // until load()/predict() keeps TajweedEngine constructible in plain-JVM unit tests
    // (Robolectric has no native libs) and avoids paying the native-load cost for callers
    // that only ever check isAvailable()/getRecordingState().
    private val env: OrtEnvironment by lazy { OrtEnvironment.getEnvironment() }

    val isLoaded: Boolean
        get() = lock.withLock { session != null }

    fun load(modelPath: File) {
        lock.withLock {
            session?.close()
            val options = OrtSession.SessionOptions()
            var accelerated = false
            try {
                // Prefer NNAPI (may route to GPU/DSP internally depending on device vendor).
                options.addNnapi()
                accelerated = true
            } catch (_: Throwable) {
                // NNAPI unavailable on this device/ORT build — fall through.
            }
            if (!accelerated) {
                try {
                    // No standalone GPU delegate ships in the stock onnxruntime-android AAR;
                    // XNNPACK is the best available CPU-side acceleration fallback.
                    options.addXnnpack(emptyMap())
                } catch (_: Throwable) {
                    // Fall back to plain CPU execution provider (default).
                }
            }
            session = env.createSession(modelPath.absolutePath, options)
        }
    }

    fun unload() {
        lock.withLock {
            session?.close()
            session = null
        }
    }

    fun predict(melFeatures: FloatArray, time: Int): AsrInferenceResult {
        val activeSession = lock.withLock { session }
            ?: throw TajweedNativeException(TajweedErrorCode.MODEL_LOAD_FAILED, "ASR model not loaded.")

        OnnxTensor.createTensor(env, FloatBuffer.wrap(melFeatures), longArrayOf(1, MelFrontend.N_MELS.toLong(), time.toLong())).use { audioTensor ->
            OnnxTensor.createTensor(env, LongBuffer.wrap(longArrayOf(time.toLong())), longArrayOf(1)).use { lengthTensor ->
                val inputs = mapOf("audio_signal" to audioTensor, "length" to lengthTensor)
                activeSession.run(inputs).use { result ->
                    val logprobsValue = result.get("logprobs").orElseThrow {
                        TajweedNativeException(TajweedErrorCode.INFERENCE_FAILED, "Missing logprobs output.")
                    }
                    val logprobs = extract3D(logprobsValue.value)

                    var encoder: Array<FloatArray> = arrayOf()
                    val encoderOpt = result.get("encoder_output")
                    if (encoderOpt.isPresent) {
                        // Official FastConformer ONNX export layout is (B, 512, T_out),
                        // not (B, T_out, 512). Transpose to time-major (T, 512) so the
                        // rest of the pipeline (CtcAligner frame indices, head pooling)
                        // matches iOS / the Python lab contract.
                        encoder = transposeEncoderToTimeMajor(extract3D(encoderOpt.get().value))
                    }
                    return AsrInferenceResult(logprobs, encoder)
                }
            }
        }
    }

    /** ORT Java returns nested arrays for rank>=2 tensors; unwrap the leading batch dim of 1. */
    @Suppress("UNCHECKED_CAST")
    private fun extract3D(value: Any): Array<FloatArray> {
        return when (value) {
            is Array<*> -> {
                val first = value.firstOrNull()
                when (first) {
                    is Array<*> -> (first as Array<FloatArray>)
                    is FloatArray -> value as Array<FloatArray>
                    else -> throw TajweedNativeException(
                        TajweedErrorCode.INFERENCE_FAILED,
                        "Unexpected tensor shape from ONNX output.",
                    )
                }
            }
            else -> throw TajweedNativeException(
                TajweedErrorCode.INFERENCE_FAILED,
                "Unexpected tensor type from ONNX output.",
            )
        }
    }

    /**
     * Convert encoder_output from ONNX layout (512, T) to time-major (T, 512).
     * If the tensor is already time-major (rows != 512, or cols == 512), leave it alone.
     */
    private fun transposeEncoderToTimeMajor(encoder: Array<FloatArray>): Array<FloatArray> {
        if (encoder.isEmpty()) return encoder
        val rows = encoder.size
        val cols = encoder[0].size
        // (512, T) → (T, 512)
        if (rows == 512 && cols != 512) {
            val out = Array(cols) { FloatArray(512) }
            for (d in 0 until 512) {
                val row = encoder[d]
                for (t in 0 until cols) {
                    out[t][d] = row[t]
                }
            }
            return out
        }
        return encoder
    }
}
