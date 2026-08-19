package com.rnr.deenfocus.tajweed

import ai.onnxruntime.OnnxTensor
import ai.onnxruntime.OrtEnvironment
import ai.onnxruntime.OrtSession
import java.io.File
import java.nio.FloatBuffer
import java.nio.LongBuffer
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/**
 * Offline pronunciation head: pooled encoder + token id -> prob_correct.
 * Port of ios/Runner/Tajweed/PronunciationHeadModel.swift.
 */
class PronunciationHeadModel {
    private val lock = ReentrantLock()
    private var session: OrtSession? = null

    // Lazy — see OnnxAsrModel for rationale (keeps TajweedEngine constructible without
    // native libs present, e.g. under plain-JVM/Robolectric unit tests).
    private val env: OrtEnvironment by lazy { OrtEnvironment.getEnvironment() }

    val isLoaded: Boolean
        get() = lock.withLock { session != null }

    fun load(modelPath: File) {
        lock.withLock {
            session?.close()
            val options = OrtSession.SessionOptions()
            try {
                options.addNnapi()
            } catch (_: Throwable) {
                // CPU fallback (default).
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

    /** Mean-pool encoder frames [start, end) and score token. */
    fun score(encoder: Array<FloatArray>, tokenId: Int, startFrame: Int, endFrame: Int): Float {
        val activeSession = lock.withLock { session }
            ?: throw TajweedNativeException(TajweedErrorCode.MODEL_LOAD_FAILED, "Head model not loaded.")
        if (encoder.isEmpty()) return 1.0f

        val dim = encoder[0].size
        val s = maxOf(0, minOf(startFrame, encoder.size - 1))
        val e = maxOf(s + 1, minOf(endFrame, encoder.size))
        val pooled = FloatArray(dim)
        for (t in s until e) {
            for (d in 0 until dim) pooled[d] += encoder[t][d]
        }
        val count = (e - s).toFloat()
        for (d in 0 until dim) pooled[d] /= count

        val inputNames = activeSession.inputNames
        val encKey = inputNames.firstOrNull { it.lowercase().contains("enc") } ?: inputNames.firstOrNull()
        val tokKey = inputNames.firstOrNull {
            it.lowercase().contains("token") || it.lowercase().contains("id")
        } ?: inputNames.filterNot { it == encKey }.firstOrNull()

        // token_id must be int64 — matches the exported ONNX Embedding gather
        // (PyTorch Long) from tajweed-lab/scripts/export_pronunciation_head_onnx.py.
        OnnxTensor.createTensor(env, FloatBuffer.wrap(pooled), longArrayOf(1, dim.toLong())).use { encTensor ->
            OnnxTensor.createTensor(env, LongBuffer.wrap(longArrayOf(tokenId.toLong())), longArrayOf(1)).use { tokTensor ->
                val inputs = HashMap<String, OnnxTensor>()
                if (encKey != null) inputs[encKey] = encTensor
                if (tokKey != null) inputs[tokKey] = tokTensor
                activeSession.run(inputs).use { result ->
                    val outName = result.firstOrNull { it.key.lowercase().contains("prob") }?.key
                        ?: result.firstOrNull()?.key
                        ?: return 1.0f
                    val value = result.get(outName).orElse(null)?.value ?: return 1.0f
                    return when (value) {
                        is Array<*> -> {
                            val row = value.firstOrNull()
                            when (row) {
                                is FloatArray -> row.firstOrNull() ?: 1.0f
                                is Float -> row
                                else -> 1.0f
                            }
                        }
                        is FloatArray -> value.firstOrNull() ?: 1.0f
                        is Float -> value
                        is Double -> value.toFloat()
                        else -> 1.0f
                    }
                }
            }
        }
    }

    companion object {
        fun statusForProb(prob: Float): String = when {
            prob < 0.5f -> "major"
            prob < 0.85f -> "minor"
            else -> "ok"
        }
    }
}
