package com.rnr.deenfocus.qurantranslation

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/** MethodChannel + EventChannel for downloadable Quran translations (ADR-009). */
class QuranTranslationChannelHandler(context: Context) : EventChannel.StreamHandler {
    private val appContext = context.applicationContext
    private val mainHandler = Handler(Looper.getMainLooper())
    private var eventSink: EventChannel.EventSink? = null

    private val store get() = TranslationStore.getInstance(appContext)
    private val catalogCache get() = TranslationCatalogCache(File(appContext.filesDir, "QuranTranslations"))

    fun attach(methodChannel: MethodChannel, eventChannel: EventChannel) {
        eventChannel.setStreamHandler(this)
        methodChannel.setMethodCallHandler { call, result -> handle(call, result) }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun emitProgress(progress: Double) {
        mainHandler.post {
            eventSink?.success(
                mapOf(
                    "type" to "downloadProgress",
                    "progress" to progress,
                ),
            )
        }
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "listAvailableTranslations" -> runAsync(result) {
                val forceRefresh = call.argument<Boolean>("forceRefresh") ?: true
                val entries = if (forceRefresh) {
                    try {
                        catalogCache.translationEntries(forceRefresh = true)
                    } catch (_: Exception) {
                        // Offline / transient — show last known catalog rather than empty.
                        try {
                            catalogCache.translationEntries(forceRefresh = false)
                        } catch (_: Exception) {
                            emptyList()
                        }
                    }
                } else {
                    catalogCache.translationEntries(forceRefresh = false)
                }
                entries.map { entry ->
                    buildMap<String, Any?> {
                        put("language", entry.language)
                        put("packId", entry.packId)
                        put("displayName", entry.displayName)
                        put("installed", store.isAvailable(entry.language))
                        entry.approxSizeBytes?.let { put("approxSizeBytes", it) }
                    }
                }
            }
            "hasTranslationPack" -> {
                val languageCode = languageArg(call) ?: run {
                    result.error("INVALID_ARGS", "languageCode required", null)
                    return
                }
                runAsync(result) { catalogCache.entryForLanguage(languageCode) != null }
            }
            "isTranslationAvailable" -> {
                val languageCode = languageArg(call) ?: run {
                    result.error("INVALID_ARGS", "languageCode required", null)
                    return
                }
                result.success(store.isAvailable(languageCode))
            }
            "getTranslationPath" -> {
                val languageCode = languageArg(call) ?: run {
                    result.error("INVALID_ARGS", "languageCode required", null)
                    return
                }
                val file = store.translationFile(languageCode)
                result.success(if (file.exists()) file.absolutePath else null)
            }
            "ensureTranslation" -> {
                val languageCode = languageArg(call) ?: run {
                    result.error("INVALID_ARGS", "languageCode required", null)
                    return
                }
                runAsync(result) {
                    store.ensureTranslation(languageCode) { progress -> emitProgress(progress) }
                    true
                }
            }
            "refreshCatalog" -> runAsync(result) {
                catalogCache.catalog(forceRefresh = true)
                true
            }
            else -> result.notImplemented()
        }
    }

    private fun languageArg(call: MethodCall): String? =
        call.argument<String>("languageCode")
            ?: (call.arguments as? Map<*, *>)?.get("languageCode") as? String

    private fun <T> runAsync(result: MethodChannel.Result, block: () -> T) {
        Thread {
            try {
                val value = block()
                mainHandler.post { result.success(value) }
            } catch (e: Exception) {
                mainHandler.post { result.error("DOWNLOAD_FAILED", e.message, null) }
            }
        }.start()
    }
}
