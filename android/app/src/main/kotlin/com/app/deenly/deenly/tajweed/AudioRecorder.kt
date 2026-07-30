package com.rnr.deenfocus.tajweed

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioRecord
import android.media.MediaRecorder
import androidx.core.content.ContextCompat
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/**
 * Native PCM capture at 16 kHz mono via android.media.AudioRecord.
 * Port of ios/Runner/Tajweed/AudioRecorder.swift.
 */
class TajweedAudioRecorder(private val context: Context) {
    companion object {
        private const val TARGET_SAMPLE_RATE = 16_000
    }

    private val lock = ReentrantLock()
    private var audioRecord: AudioRecord? = null
    private var recordThread: Thread? = null
    private val samples = ArrayList<Float>()
    @Volatile private var isRecordingFlag = false
    var onInterrupted: ((String) -> Unit)? = null

    val isRecording: Boolean get() = isRecordingFlag

    private var audioManager: AudioManager? = null
    private val focusListener = AudioManager.OnAudioFocusChangeListener { change ->
        if (change == AudioManager.AUDIOFOCUS_LOSS ||
            change == AudioManager.AUDIOFOCUS_LOSS_TRANSIENT
        ) {
            cancel()
            onInterrupted?.invoke("audio_focus_loss")
        }
    }

    fun start() {
        lock.withLock {
            if (isRecordingFlag) {
                throw TajweedNativeException(TajweedErrorCode.ALREADY_RECORDING, "Already recording.")
            }
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) !=
                PackageManager.PERMISSION_GRANTED
            ) {
                throw TajweedNativeException(
                    TajweedErrorCode.MIC_PERMISSION_DENIED,
                    "Microphone permission denied.",
                )
            }

            val minBuf = AudioRecord.getMinBufferSize(
                TARGET_SAMPLE_RATE,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT,
            )
            if (minBuf == AudioRecord.ERROR || minBuf == AudioRecord.ERROR_BAD_VALUE) {
                throw TajweedNativeException(TajweedErrorCode.MIC_BUSY, "Unsupported audio config.")
            }
            val bufferSize = minBuf * 2

            val record = AudioRecord(
                MediaRecorder.AudioSource.VOICE_RECOGNITION,
                TARGET_SAMPLE_RATE,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT,
                bufferSize,
            )
            if (record.state != AudioRecord.STATE_INITIALIZED) {
                record.release()
                throw TajweedNativeException(TajweedErrorCode.MIC_BUSY, "AudioRecord failed to initialize.")
            }

            samples.clear()
            audioRecord = record

            val am = context.getSystemService(Context.AUDIO_SERVICE) as? AudioManager
            audioManager = am
            am?.requestAudioFocus(
                focusListener,
                AudioManager.STREAM_VOICE_CALL,
                AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_EXCLUSIVE,
            )

            try {
                record.startRecording()
            } catch (e: IllegalStateException) {
                record.release()
                audioRecord = null
                throw TajweedNativeException(TajweedErrorCode.MIC_BUSY, e.message ?: "Failed to start recording.")
            }
            isRecordingFlag = true

            val thread = Thread {
                val shortBuffer = ShortArray(bufferSize / 2)
                while (isRecordingFlag) {
                    val read = record.read(shortBuffer, 0, shortBuffer.size)
                    if (read > 0) {
                        lock.withLock {
                            for (i in 0 until read) {
                                samples.add(shortBuffer[i] / 32768.0f)
                            }
                        }
                    }
                }
            }
            thread.name = "tajweed-audio-record"
            thread.start()
            recordThread = thread
        }
    }

    fun stop(): FloatArray {
        lock.withLock {
            if (isRecordingFlag) {
                isRecordingFlag = false
                try {
                    audioRecord?.stop()
                } catch (_: IllegalStateException) {
                    // Already stopped/uninitialized — ignore.
                }
            }
        }
        recordThread?.join(2000)
        recordThread = null
        lock.withLock {
            audioRecord?.release()
            audioRecord = null
        }
        audioManager?.abandonAudioFocus(focusListener)
        audioManager = null
        return lock.withLock { samples.toFloatArray() }
    }

    fun cancel() {
        stop()
        lock.withLock { samples.clear() }
    }
}
