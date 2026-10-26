package com.rnr.deenfocus

import android.annotation.SuppressLint
import android.content.Context
import android.location.Address
import android.location.Geocoder
import android.os.Build
import android.os.Handler
import android.os.Looper
import java.util.Locale
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

data class LocationSearchOutcome(
    val results: List<Map<String, Any?>>,
    val wasNetworkError: Boolean,
)

object LocationSearchHelper {
    private const val DEFAULT_TIMEOUT_MS = 25_000L
    private const val MAX_RETRIES = 2
    private const val INITIAL_RETRY_DELAY_MS = 500L

    private val mainHandler = Handler(Looper.getMainLooper())
    private val worker: ExecutorService = Executors.newCachedThreadPool { runnable ->
        Thread(runnable, "location-search").apply { isDaemon = true }
    }

    /**
     * Geocodes [query] without blocking the caller.
     *
     * The callback runs on the main thread and is invoked exactly once, including
     * empty queries, missing geocoder, errors, and timeout.
     */
    fun search(
        context: Context,
        query: String,
        timeoutMs: Long = DEFAULT_TIMEOUT_MS,
        callback: (LocationSearchOutcome) -> Unit,
    ) {
        val session = SearchSession(mainHandler, timeoutMs, callback)
        val trimmed = query.trim()
        if (trimmed.isEmpty() || !Geocoder.isPresent()) {
            session.finish(LocationSearchOutcome(emptyList(), false))
            return
        }

        session.armTimeout()
        val appContext = context.applicationContext
        // The platform thread handles Flutter method calls. Geocoder's binder
        // call, including the API 33+ listener API, runs on this worker.
        worker.execute {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                searchAsync(
                    appContext,
                    trimmed,
                    session,
                    retry = 0,
                    delayMs = INITIAL_RETRY_DELAY_MS,
                )
            } else {
                session.finish(performSearch(appContext, trimmed))
            }
        }
    }

    @SuppressLint("NewApi")
    private fun searchAsync(
        context: Context,
        query: String,
        session: SearchSession,
        retry: Int,
        delayMs: Long,
    ) {
        if (session.isFinished()) return
        try {
            val geocoder = Geocoder(context, Locale.getDefault())
            geocoder.getFromLocationName(
                query,
                10,
                object : Geocoder.GeocodeListener {
                    override fun onGeocode(addresses: MutableList<Address>) {
                        session.finish(LocationSearchOutcome(addressesToResults(addresses), false))
                    }

                    override fun onError(errorMessage: String?) {
                        if (retry >= MAX_RETRIES || session.isFinished()) {
                            session.finish(
                                LocationSearchOutcome(emptyList(), isNetworkMessage(errorMessage)),
                            )
                            return
                        }
                        scheduleRetry(context, query, session, retry + 1, delayMs)
                    }
                },
            )
        } catch (e: Exception) {
            if (retry >= MAX_RETRIES || session.isFinished()) {
                session.finish(
                    LocationSearchOutcome(emptyList(), isNetworkOrTimeoutError(e)),
                )
                return
            }
            scheduleRetry(context, query, session, retry + 1, delayMs)
        }
    }

    private fun scheduleRetry(
        context: Context,
        query: String,
        session: SearchSession,
        retry: Int,
        delayMs: Long,
    ) {
        mainHandler.postDelayed({
            worker.execute {
                searchAsync(context, query, session, retry, delayMs * 2)
            }
        }, delayMs)
    }

    private fun performSearch(context: Context, query: String): LocationSearchOutcome {
        var retryCount = 0
        var currentDelay = INITIAL_RETRY_DELAY_MS
        var lastWasNetworkError = false

        while (retryCount <= MAX_RETRIES) {
            try {
                val geocoder = Geocoder(context, Locale.getDefault())
                @Suppress("DEPRECATION")
                val addresses = geocoder.getFromLocationName(query, 10)
                return LocationSearchOutcome(addressesToResults(addresses), false)
            } catch (e: Exception) {
                lastWasNetworkError = isNetworkOrTimeoutError(e)
                if (retryCount >= MAX_RETRIES) break
                retryCount++
                try {
                    Thread.sleep(currentDelay)
                } catch (_: InterruptedException) {
                    break
                }
                currentDelay *= 2
            }
        }
        return LocationSearchOutcome(emptyList(), lastWasNetworkError)
    }

    internal fun addressesToResults(addresses: List<Address>?): List<Map<String, Any?>> {
        if (addresses == null) return emptyList()
        val results = mutableListOf<Map<String, Any?>>()
        for (address in addresses) {
            val locationName = address.getAddressLine(0) ?: address.featureName ?: "Unknown"
            val subtitle = listOfNotNull(address.locality, address.countryName)
                .filter { it.isNotBlank() }
                .joinToString(", ")
            val latitude = address.latitude
            val longitude = address.longitude
            if (latitude != 0.0 && longitude != 0.0) {
                results.add(
                    mapOf(
                        "title" to locationName,
                        "subtitle" to subtitle,
                        "latitude" to latitude,
                        "longitude" to longitude,
                    ),
                )
            }
        }
        return results
    }

    private fun isNetworkOrTimeoutError(e: Exception): Boolean {
        return isNetworkMessage(e.javaClass.simpleName) || isNetworkMessage(e.message)
    }

    private fun isNetworkMessage(message: String?): Boolean {
        if (message.isNullOrBlank()) return false
        return message.contains("Network", ignoreCase = true) ||
            message.contains("Timeout", ignoreCase = true) ||
            message.contains("UnknownHost", ignoreCase = true)
    }
}

/**
 * Completes one location search exactly once, on the main thread.
 * A late geocoder callback after timeout is ignored.
 */
internal class SearchSession(
    private val handler: Handler,
    private val timeoutMs: Long,
    private val onResult: (LocationSearchOutcome) -> Unit,
) {
    private val delivered = AtomicBoolean(false)
    private val timeoutRunnable = Runnable {
        finish(LocationSearchOutcome(emptyList(), true))
    }

    fun isFinished(): Boolean = delivered.get()

    fun armTimeout() {
        if (timeoutMs <= 0L || isFinished()) return
        handler.postDelayed(timeoutRunnable, timeoutMs)
    }

    fun finish(outcome: LocationSearchOutcome) {
        if (!delivered.compareAndSet(false, true)) return
        handler.removeCallbacks(timeoutRunnable)
        if (Looper.myLooper() == handler.looper) {
            onResult(outcome)
        } else {
            handler.post { onResult(outcome) }
        }
    }
}
