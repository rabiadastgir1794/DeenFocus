package com.rnr.deenfocus.tajweed

import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.exp
import kotlin.math.floor
import kotlin.math.ln
import kotlin.math.sqrt

data class MelResult(val features: FloatArray, val time: Int)
data class MelBucketResult(val padded: FloatArray, val bucketT: Int)

/**
 * NeMo-compatible log-mel frontend (see tajweed-lab/web/asr/mel.py + COREML_CONTRACT.md).
 * Port of ios/Runner/Tajweed/MelFrontend.swift, but implemented with a plain radix-2
 * FFT instead of Accelerate/vDSP — no vDSP-specific scale factors here, this follows
 * the reference numpy `rfft` formulation directly (see mel.py).
 */
object MelFrontend {
    const val SAMPLE_RATE = 16_000
    const val N_FFT = 512
    const val HOP_LEN = 160
    const val N_MELS = 80
    const val PREEMPH = 0.97f
    const val LOG_EPS = 1e-5f

    private val BUCKETS = intArrayOf(80, 160, 320, 640, 1280, 2560, 4800)
    private val melFilterbank: Array<FloatArray> by lazy { makeMelFilterbank() }
    private val hannWindow: DoubleArray by lazy { makeHannWindow(N_FFT) }

    /** Returns mel features shaped as flat `[80 * T]` in row-major (mel, time), plus time `T`. */
    fun logMel(pcm: FloatArray): MelResult {
        if (pcm.size <= N_FFT) {
            throw TajweedNativeException(TajweedErrorCode.AUDIO_TOO_SHORT, "Audio too short for mel features.")
        }

        val wav = FloatArray(pcm.size)
        wav[0] = pcm[0]
        for (i in 1 until pcm.size) {
            wav[i] = pcm[i] - PREEMPH * pcm[i - 1]
        }

        val pad = N_FFT / 2
        val padded = FloatArray(wav.size + pad * 2)
        for (i in 0 until pad) {
            padded[pad - 1 - i] = wav[minOf(i + 1, wav.size - 1)]
            padded[pad + wav.size + i] = wav[maxOf(0, wav.size - 2 - i)]
        }
        System.arraycopy(wav, 0, padded, pad, wav.size)

        val nFrames = 1 + (padded.size - N_FFT) / HOP_LEN
        if (nFrames <= 0) {
            throw TajweedNativeException(TajweedErrorCode.AUDIO_TOO_SHORT, "No mel frames.")
        }

        val bins = N_FFT / 2 + 1
        val powerSpec = Array(nFrames) { DoubleArray(bins) }
        val re = DoubleArray(N_FFT)
        val im = DoubleArray(N_FFT)
        for (t in 0 until nFrames) {
            val start = t * HOP_LEN
            for (i in 0 until N_FFT) {
                re[i] = padded[start + i] * hannWindow[i]
                im[i] = 0.0
            }
            Fft.forward(re, im)
            for (k in 0 until bins) {
                powerSpec[t][k] = re[k] * re[k] + im[k] * im[k]
            }
        }

        val mel = FloatArray(N_MELS * nFrames)
        for (m in 0 until N_MELS) {
            val fbRow = melFilterbank[m]
            for (t in 0 until nFrames) {
                var sum = 0.0
                val ps = powerSpec[t]
                for (k in 0 until bins) {
                    sum += fbRow[k] * ps[k]
                }
                mel[m * nFrames + t] = ln(sum + LOG_EPS).toFloat()
            }
        }

        for (m in 0 until N_MELS) {
            val offset = m * nFrames
            var mean = 0.0
            for (t in 0 until nFrames) mean += mel[offset + t]
            mean /= nFrames
            var variance = 0.0
            for (t in 0 until nFrames) {
                val d = mel[offset + t] - mean
                variance += d * d
            }
            variance /= nFrames
            val invStd = 1.0 / (sqrt(variance) + 1e-5)
            for (t in 0 until nFrames) {
                mel[offset + t] = ((mel[offset + t] - mean) * invStd).toFloat()
            }
        }

        return MelResult(mel, nFrames)
    }

    /** Nearest supported inference bucket T80…T4800 (kept for CoreML/ONNX bucket parity, not a hard ORT requirement). */
    fun padToBucket(features: FloatArray, time: Int): MelBucketResult {
        val bucket = BUCKETS.firstOrNull { it >= time }
            ?: throw TajweedNativeException(TajweedErrorCode.AUDIO_TOO_LONG, "Audio exceeds 48s limit.")
        if (time == bucket) return MelBucketResult(features, bucket)
        val out = FloatArray(N_MELS * bucket)
        for (m in 0 until N_MELS) {
            System.arraycopy(features, m * time, out, m * bucket, time)
        }
        return MelBucketResult(out, bucket)
    }

    /**
     * Symmetric Hann window matching numpy's `np.hanning(N)` exactly (denominator N-1),
     * since the ONNX encoder was calibrated against tajweed-lab/web/asr/mel.py, which
     * this Android frontend must match bit-for-bit-equivalent (not the periodic/ANE-power-
     * normalized variant iOS's vDSP_HANN_NORM uses — that only "works" there because the
     * CMVN mean-subtraction step cancels a uniform per-frame scale factor; ONNX Runtime has
     * no such Accelerate convenience API, so we replicate the reference formula directly).
     */
    private fun makeHannWindow(n: Int): DoubleArray {
        val w = DoubleArray(n)
        for (i in 0 until n) {
            w[i] = 0.5 - 0.5 * cos(2.0 * PI * i / (n - 1))
        }
        return w
    }

    private fun makeMelFilterbank(): Array<FloatArray> {
        val sr = SAMPLE_RATE.toDouble()
        val melMax = 1127.0 * ln(1.0 + (sr / 2) / 700.0)
        val melPts = DoubleArray(N_MELS + 2) { melMax * it / (N_MELS + 1) }
        val hzPts = melPts.map { 700.0 * (exp(it / 1127.0) - 1.0) }
        val binPts = hzPts.map { floor((N_FFT + 1) * it / sr).toInt() }
        val bins = N_FFT / 2 + 1
        val fb = Array(N_MELS) { FloatArray(bins) }
        for (m in 1..N_MELS) {
            val left = binPts[m - 1]
            val center = binPts[m]
            val right = binPts[m + 1]
            if (center != left) {
                for (k in left until center) {
                    fb[m - 1][k] = ((k - left).toFloat() / (center - left))
                }
            }
            if (right != center) {
                for (k in center until right) {
                    fb[m - 1][k] = ((right - k).toFloat() / (right - center))
                }
            }
        }
        return fb
    }
}

/** Minimal iterative radix-2 Cooley-Tukey FFT, in place on parallel real/imag arrays. */
internal object Fft {
    fun forward(re: DoubleArray, im: DoubleArray) {
        val n = re.size
        require(n and (n - 1) == 0) { "FFT size must be a power of two, got $n" }

        var j = 0
        for (i in 1 until n) {
            var bit = n shr 1
            while (j and bit != 0) {
                j = j xor bit
                bit = bit shr 1
            }
            j = j or bit
            if (i < j) {
                val tr = re[i]; re[i] = re[j]; re[j] = tr
                val ti = im[i]; im[i] = im[j]; im[j] = ti
            }
        }

        var len = 2
        while (len <= n) {
            val ang = -2.0 * PI / len
            val wr = cos(ang)
            val wi = kotlin.math.sin(ang)
            var i = 0
            while (i < n) {
                var curWr = 1.0
                var curWi = 0.0
                for (k in 0 until len / 2) {
                    val uRe = re[i + k]
                    val uIm = im[i + k]
                    val vRe = re[i + k + len / 2] * curWr - im[i + k + len / 2] * curWi
                    val vIm = re[i + k + len / 2] * curWi + im[i + k + len / 2] * curWr
                    re[i + k] = uRe + vRe
                    im[i + k] = uIm + vIm
                    re[i + k + len / 2] = uRe - vRe
                    im[i + k + len / 2] = uIm - vIm
                    val nextWr = curWr * wr - curWi * wi
                    val nextWi = curWr * wi + curWi * wr
                    curWr = nextWr
                    curWi = nextWi
                }
                i += len
            }
            len = len shl 1
        }
    }
}
