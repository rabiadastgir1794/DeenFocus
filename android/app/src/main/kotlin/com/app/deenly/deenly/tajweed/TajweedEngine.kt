package com.rnr.deenfocus.tajweed

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/**
 * Orchestrates native record -> mel -> ONNX ASR -> CTC -> align -> head -> JSON.
 * Port of ios/Runner/Tajweed/TajweedEngine.swift — must stay behaviourally identical
 * (state machine, error codes, JSON schema) per ADR-006.
 */
class TajweedEngine private constructor(context: Context) {
    private val appContext = context.applicationContext
    private val workExecutor: ExecutorService = Executors.newSingleThreadExecutor { r ->
        Thread(r, "tajweed-engine").apply { priority = Thread.NORM_PRIORITY + 1 }
    }
    private val mainHandler = Handler(Looper.getMainLooper())
    private val stateLock = ReentrantLock()

    private val recorder = TajweedAudioRecorder(appContext)
    private val asr = OnnxAsrModel()
    private val head = PronunciationHeadModel()
    private val modelStore = ModelStore(appContext)
    private var tokenizer: SentencePieceTokenizer? = null

    private var state: TajweedRecordingState = TajweedRecordingState.IDLE
    private var expectedArabic: String = ""
    private var surah: Int = 0
    private var ayah: Int = 0
    @Volatile private var cancelled = false

    var onEvent: ((Map<String, Any?>) -> Unit)? = null

    init {
        recorder.onInterrupted = { reason -> handleInterruption(reason) }
    }

    fun getRecordingState(): String = stateLock.withLock { state.wireValue }

    /** Debug/test visibility only — true once ASR + head + tokenizer are warm-loaded. */
    val isWarmedUpForTesting: Boolean
        get() = tokenizer != null && asr.isLoaded && head.isLoaded

    fun isAvailable(): Boolean = modelStore.isAvailable()

    fun ensureModel(completion: (Result<Unit>) -> Unit) {
        workExecutor.execute {
            try {
                modelStore.ensureModel { p -> emit(mapOf("type" to "downloadProgress", "progress" to p)) }
                completion(Result.success(Unit))
            } catch (e: TajweedNativeException) {
                completion(Result.failure(e))
            } catch (e: Exception) {
                completion(
                    Result.failure(
                        TajweedNativeException(TajweedErrorCode.MODEL_DOWNLOAD_FAILED, e.message ?: "Download failed."),
                    ),
                )
            }
        }
    }

    fun prepareModel(completion: (Result<Unit>) -> Unit) {
        workExecutor.execute {
            try {
                warmLoadLocked()
                completion(Result.success(Unit))
            } catch (e: TajweedNativeException) {
                completion(Result.failure(e))
            } catch (e: Exception) {
                completion(
                    Result.failure(
                        TajweedNativeException(TajweedErrorCode.MODEL_LOAD_FAILED, e.message ?: "Load failed."),
                    ),
                )
            }
        }
    }

    fun startRecording(
        surah: Int,
        ayah: Int,
        expectedArabic: String,
        completion: (Result<Unit>) -> Unit,
    ) {
        workExecutor.execute {
            val notIdle = stateLock.withLock { state != TajweedRecordingState.IDLE }
            if (notIdle) {
                completion(Result.failure(TajweedNativeException(TajweedErrorCode.ALREADY_RECORDING, "Not idle.")))
                return@execute
            }

            try {
                warmLoadLocked()
            } catch (e: TajweedNativeException) {
                Log.e("TajweedEngine", "startRecording: warmLoadLocked failed (native code=${e.code})", e)
                completion(Result.failure(e))
                return@execute
            } catch (e: Exception) {
                Log.e("TajweedEngine", "startRecording: warmLoadLocked threw unexpected ${e.javaClass.simpleName}", e)
                completion(
                    Result.failure(
                        TajweedNativeException(TajweedErrorCode.MODEL_LOAD_FAILED, e.message ?: "Load failed."),
                    ),
                )
                return@execute
            }

            try {
                cancelled = false
                this.surah = surah
                this.ayah = ayah
                this.expectedArabic = expectedArabic
                recorder.start()
                setState(TajweedRecordingState.RECORDING)
                completion(Result.success(Unit))
            } catch (e: TajweedNativeException) {
                completion(Result.failure(e))
            } catch (e: Exception) {
                completion(Result.failure(TajweedNativeException(TajweedErrorCode.MIC_BUSY, e.message ?: "Mic busy.")))
            }
        }
    }

    fun stopRecordingAndScore(completion: (Result<Map<String, Any?>>) -> Unit) {
        workExecutor.execute {
            val wasRecording = stateLock.withLock {
                if (state != TajweedRecordingState.RECORDING) {
                    false
                } else {
                    state = TajweedRecordingState.SCORING
                    true
                }
            }
            if (!wasRecording) {
                completion(Result.failure(TajweedNativeException(TajweedErrorCode.NOT_RECORDING, "Not recording.")))
                return@execute
            }
            emit(mapOf("type" to "recordingState", "state" to "scoring"))

            val pcm = recorder.stop()
            if (cancelled) {
                setState(TajweedRecordingState.IDLE)
                completion(Result.failure(TajweedNativeException(TajweedErrorCode.INFERENCE_CANCELLED, "Cancelled.")))
                return@execute
            }

            try {
                validateAudioQuality(pcm)
                // A low-memory trim (onTrimMemory -> onMemoryWarning) can unload the ASR/head
                // sessions while the user was mid-recording — startRecording()'s warm-load is
                // no guarantee they're still resident by the time we get here. Re-warm before
                // scoring rather than losing the audio the user already captured.
                if (!asr.isLoaded || !head.isLoaded || tokenizer == null) {
                    Log.d(
                        "TajweedEngine",
                        "stopRecordingAndScore: model was unloaded mid-recording " +
                            "(asr.isLoaded=${asr.isLoaded} head.isLoaded=${head.isLoaded} " +
                            "tokenizer=${tokenizer != null}) — re-warming before scoring",
                    )
                    warmLoadLocked()
                }
                val report = score(pcm)
                setState(TajweedRecordingState.IDLE)
                completion(Result.success(report))
            } catch (e: TajweedNativeException) {
                Log.e("TajweedEngine", "stopRecordingAndScore: failed (native code=${e.code})", e)
                setState(TajweedRecordingState.IDLE)
                completion(Result.failure(e))
            } catch (e: Exception) {
                Log.e("TajweedEngine", "stopRecordingAndScore: unexpected ${e.javaClass.simpleName}", e)
                setState(TajweedRecordingState.IDLE)
                completion(
                    Result.failure(
                        TajweedNativeException(TajweedErrorCode.INFERENCE_FAILED, e.message ?: "Inference failed."),
                    ),
                )
            }
        }
    }

    fun cancelRecording(completion: (Result<Unit>) -> Unit) {
        workExecutor.execute {
            val current = stateLock.withLock {
                val c = state
                state = TajweedRecordingState.CANCELLING
                c
            }
            emit(mapOf("type" to "recordingState", "state" to "cancelling"))
            cancelled = true
            recorder.cancel()
            setState(TajweedRecordingState.IDLE)
            if (current == TajweedRecordingState.IDLE) {
                completion(Result.failure(TajweedNativeException(TajweedErrorCode.NOT_RECORDING, "Not recording.")))
            } else {
                completion(Result.success(Unit))
            }
        }
    }

    fun dispose() {
        workExecutor.execute {
            cancelled = true
            recorder.cancel()
            asr.unload()
            head.unload()
            tokenizer = null
            setState(TajweedRecordingState.IDLE)
            emit(mapOf("type" to "modelUnloaded"))
        }
    }

    // region Lifecycle callbacks (wired from MainActivity: onTrimMemory / onPause)

    fun onMemoryWarning() {
        workExecutor.execute {
            asr.unload()
            head.unload()
            emit(mapOf("type" to "modelUnloaded", "reason" to "memory"))
        }
    }

    fun onAppBackground() {
        workExecutor.execute {
            val recording = stateLock.withLock { state == TajweedRecordingState.RECORDING }
            if (recording) {
                cancelled = true
                recorder.cancel()
                setState(TajweedRecordingState.IDLE)
                emit(mapOf("type" to "interrupted", "reason" to "app_background"))
            }
        }
    }

    // endregion

    // region Scoring pipeline

    private fun score(pcm: FloatArray): Map<String, Any?> {
        val duration = pcm.size.toDouble() / MelFrontend.SAMPLE_RATE
        val melResult = MelFrontend.logMel(pcm)
        // ONNX encoder accepts dynamic T (unlike CoreML's fixed buckets). Passing the
        // unpadded mel avoids trailing silence frames that can leak into CTC decode
        // as spurious tokens (seen on 02_basfar_ikhlas during Phase 4B emulator QA).
        val asrOut = asr.predict(melResult.features, melResult.time)

        val argmax = asrOut.logprobs.map { row ->
            var best = 0
            var bestV = -Float.MAX_VALUE
            for (i in row.indices) {
                if (row[i] > bestV) {
                    bestV = row[i]
                    best = i
                }
            }
            best
        }
        val collapsed = CtcDecoder.collapse(argmax)
        val tok = tokenizer ?: run {
            Log.e(
                "TajweedEngine",
                "score: tokenizer is null at scoring time (asr.isLoaded=${asr.isLoaded} head.isLoaded=${head.isLoaded})",
            )
            throw TajweedNativeException(TajweedErrorCode.MODEL_LOAD_FAILED, "Tokenizer missing.")
        }
        val hypothesis = tok.decode(collapsed)
        val expectedWords = splitWords(expectedArabic)
        val hypWords = splitWords(hypothesis)

        // Lexical-first (ADR-006): word DP decides identity; pronunciation head runs
        // only on matched words using FA of the *hypothesis* (spoken) token path.
        val ops = TajweedLexicalScoring.alignWords(expectedWords, hypWords)
        val tokens = buildLexicalFirstTokens(ops, collapsed, asrOut, tok)

        // Lexical correctness only — pronunciation severity does not reduce this %.
        val wordAccuracy = TajweedLexicalScoring.wordAccuracyFromTokens(tokens, expectedWords.size)

        val exact = normalizeArabic(hypothesis) == normalizeArabic(expectedArabic) && expectedArabic.isNotEmpty()

        return mapOf(
            "ref" to "$surah:$ayah",
            "expected" to expectedArabic,
            "hypothesis" to hypothesis,
            "durationSec" to duration,
            "wordAccuracy" to wordAccuracy,
            "exactMatch" to exact,
            "tokens" to tokens,
        )
    }

    /**
     * Builds per-Quran-word tokens from word-level alignment. Forced-alignment +
     * pronunciation head run only for [TajweedLexicalScoring.LexicalOp.MATCH] ops,
     * using hypothesis CTC token ids (what was actually said) for frame spans.
     */
    private fun buildLexicalFirstTokens(
        ops: List<TajweedLexicalScoring.WordAlignOp>,
        hypIds: List<Int>,
        asrOut: AsrInferenceResult,
        tok: SentencePieceTokenizer,
    ): List<Map<String, Any?>> {
        val matchHypIndices = ops.mapNotNull { op ->
            if (op.op == TajweedLexicalScoring.LexicalOp.MATCH) op.hypIndex else null
        }.toSet()

        // Hyp word → (minProb, startSec, endSec) from head, only for matched hyp words.
        val matchPron = HashMap<Int, Triple<Float, Double?, Double?>>()
        if (matchHypIndices.isNotEmpty() && hypIds.isNotEmpty() && asrOut.logprobs.isNotEmpty()) {
            try {
                val intervals = CtcAligner.forcedAlign(asrOut.logprobs, hypIds)
                val pieceWordIndex = TajweedLexicalScoring.pieceWordIndices(hypIds) { tok.startsNewWord(it) }
                for (interval in intervals) {
                    val pieceIdx = interval.tokenIndex
                    if (pieceIdx !in pieceWordIndex.indices) continue
                    val hypWord = pieceWordIndex[pieceIdx]
                    if (hypWord !in matchHypIndices) continue

                    var prob = 1.0f
                    if (asrOut.encoderOutput.isNotEmpty()) {
                        prob = try {
                            head.score(
                                asrOut.encoderOutput,
                                interval.tokenId,
                                interval.startFrame,
                                interval.endFrame,
                            )
                        } catch (_: Exception) {
                            1.0f
                        }
                    }
                    val prev = matchPron[hypWord]
                    if (prev == null) {
                        matchPron[hypWord] = Triple(prob, interval.startSec, interval.endSec)
                    } else {
                        matchPron[hypWord] = Triple(
                            minOf(prev.first, prob),
                            prev.second,
                            interval.endSec,
                        )
                    }
                }
            } catch (_: Exception) {
                // Lexical statuses still stand; matched words keep default pronunciation ok.
            }
        }

        return ops.map { op ->
            when (op.op) {
                TajweedLexicalScoring.LexicalOp.MATCH -> {
                    val hypIdx = op.hypIndex
                    val scored = hypIdx?.let { matchPron[it] }
                    val prob = scored?.first ?: 1.0f
                    val pronStatus = PronunciationHeadModel.statusForProb(prob)
                    TajweedLexicalScoring.tokenMap(
                        text = op.text,
                        status = pronStatus,
                        lexical = "match",
                        pronunciation = pronStatus,
                        prob = prob,
                        startSec = scored?.second,
                        endSec = scored?.third,
                    )
                }
                TajweedLexicalScoring.LexicalOp.SUB -> TajweedLexicalScoring.tokenMap(
                    text = op.text,
                    status = "sub",
                    lexical = "sub",
                    pronunciation = null,
                    prob = 0.0f,
                )
                TajweedLexicalScoring.LexicalOp.MISS -> TajweedLexicalScoring.tokenMap(
                    text = op.text,
                    status = "miss",
                    lexical = "miss",
                    pronunciation = null,
                    prob = 0.0f,
                )
                TajweedLexicalScoring.LexicalOp.EXTRA -> TajweedLexicalScoring.tokenMap(
                    text = op.text,
                    status = "extra",
                    lexical = "extra",
                    pronunciation = null,
                    prob = 0.0f,
                )
            }
        }
    }

    private fun validateAudioQuality(pcm: FloatArray) {
        val minSamples = (0.3 * MelFrontend.SAMPLE_RATE).toInt()
        val maxSamples = (48.0 * MelFrontend.SAMPLE_RATE).toInt()
        if (pcm.size < minSamples) {
            throw TajweedNativeException(TajweedErrorCode.AUDIO_TOO_SHORT, "Recording shorter than 0.3s.")
        }
        if (pcm.size > maxSamples) {
            throw TajweedNativeException(TajweedErrorCode.AUDIO_TOO_LONG, "Recording longer than 48s.")
        }
        var sum = 0.0
        var peak = 0.0f
        for (x in pcm) {
            val a = kotlin.math.abs(x)
            sum += a
            if (a > peak) peak = a
        }
        val mean = sum / pcm.size
        Log.d(
            "TajweedEngine",
            "validateAudioQuality: samples=${pcm.size} durationSec=${pcm.size.toDouble() / MelFrontend.SAMPLE_RATE} " +
                "meanAbs=$mean peak=$peak",
        )
        if (mean < 0.005) {
            throw TajweedNativeException(TajweedErrorCode.AUDIO_QUALITY_POOR, "Mostly silence.")
        }
        if (peak > 0.99f) {
            throw TajweedNativeException(TajweedErrorCode.AUDIO_QUALITY_POOR, "Clipping detected.")
        }
    }

    private fun warmLoadLocked() {
        if (!modelStore.isAvailable()) {
            throw TajweedNativeException(TajweedErrorCode.MODEL_MISSING, "Model pack not on disk.")
        }
        if (tokenizer == null) {
            Log.d("TajweedEngine", "warmLoadLocked: loading tokenizer")
            tokenizer = SentencePieceTokenizer(modelStore.tokensFile())
            Log.d("TajweedEngine", "warmLoadLocked: tokenizer loaded ok")
        }
        if (!asr.isLoaded) {
            Log.d("TajweedEngine", "warmLoadLocked: loading asr encoder (freeMemBytes=${Runtime.getRuntime().freeMemory()})")
            asr.load(modelStore.encoderFile())
            Log.d("TajweedEngine", "warmLoadLocked: asr encoder loaded ok")
        }
        if (!head.isLoaded) {
            Log.d("TajweedEngine", "warmLoadLocked: loading pronunciation head")
            head.load(modelStore.headFile())
            Log.d("TajweedEngine", "warmLoadLocked: pronunciation head loaded ok")
        }
    }

    private fun setState(new: TajweedRecordingState) {
        stateLock.withLock { state = new }
        emit(mapOf("type" to "recordingState", "state" to new.wireValue))
    }

    private fun emit(payload: Map<String, Any?>) {
        mainHandler.post { onEvent?.invoke(payload) }
    }

    private fun handleInterruption(reason: String) {
        workExecutor.execute {
            cancelled = true
            recorder.cancel()
            setState(TajweedRecordingState.IDLE)
            emit(mapOf("type" to "interrupted", "reason" to reason))
        }
    }

    // endregion

    // region Text helpers (delegated to TajweedLexicalScoring — identical logic to
    // the private helpers in TajweedEngine.swift, pulled out here for unit testability)

    private fun splitWords(text: String): List<String> = TajweedLexicalScoring.splitWords(text)
    private fun normalizeArabic(text: String): String = TajweedLexicalScoring.normalizeArabic(text)
    private fun lexicalTokenReport(expected: List<String>, hypothesis: List<String>): List<Map<String, Any?>> =
        TajweedLexicalScoring.lexicalTokenReport(expected, hypothesis)

    // endregion

    // region Debug helpers

    /** Score a PCM buffer without recording (for a native debug harness / instrumented tests). */
    fun scorePcmForDebug(
        pcm: FloatArray,
        surah: Int,
        ayah: Int,
        expectedArabic: String,
    ): Pair<Map<String, Any?>, Map<String, Double>> {
        val timings = HashMap<String, Double>()
        val t0 = System.nanoTime()
        warmLoadLocked()
        timings["warmOrReuseMs"] = (System.nanoTime() - t0) / 1_000_000.0

        this.surah = surah
        this.ayah = ayah
        this.expectedArabic = expectedArabic

        val t1 = System.nanoTime()
        val report = score(pcm)
        timings["inferenceMs"] = (System.nanoTime() - t1) / 1_000_000.0
        return report to timings
    }

    // endregion

    companion object {
        @Volatile private var instance: TajweedEngine? = null

        fun getInstance(context: Context): TajweedEngine =
            instance ?: synchronized(this) {
                instance ?: TajweedEngine(context).also { instance = it }
            }

        /** Test-only: forces a fresh singleton so tests don't leak state across methods. */
        @Suppress("unused")
        internal fun resetForTesting() {
            synchronized(this) { instance = null }
        }
    }
}
