package com.rnr.deenfocus

import android.content.Context
import android.location.Geocoder
import java.util.Locale
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

data class LocationSearchOutcome(
    val results: List<Map<String, Any?>>,
    val wasNetworkError: Boolean,
)

object LocationSearchHelper {

    fun search(context: Context, query: String): LocationSearchOutcome {
        val trimmed = query.trim()
        if (trimmed.isEmpty()) {
            return LocationSearchOutcome(emptyList(), false)
        }

        if (!Geocoder.isPresent()) {
            return LocationSearchOutcome(emptyList(), false)
        }

        val appContext = context.applicationContext
        val latch = CountDownLatch(1)
        val holder = arrayOfNulls<LocationSearchOutcome>(1)

        Thread {
            holder[0] = performSearch(appContext, trimmed)
            latch.countDown()
        }.start()

        try {
            if (!latch.await(25, TimeUnit.SECONDS)) {
                return LocationSearchOutcome(emptyList(), true)
            }
        } catch (_: InterruptedException) {
            return LocationSearchOutcome(emptyList(), true)
        }

        return holder[0] ?: LocationSearchOutcome(emptyList(), false)
    }

    private fun performSearch(context: Context, query: String): LocationSearchOutcome {
        val results = mutableListOf<Map<String, Any?>>()
        var retryCount = 0
        val maxRetries = 2
        var currentDelay = 500L
        var lastWasNetworkError = false

        while (retryCount <= maxRetries) {
            try {
                val geocoder = Geocoder(context, Locale.getDefault())
                @Suppress("DEPRECATION")
                val addresses = geocoder.getFromLocationName(query, 10)

                addresses?.forEach { address ->
                    val locationName =
                        address.getAddressLine(0) ?: address.featureName ?: "Unknown"
                    val locality = address.locality
                    val country = address.countryName
                    val latitude = address.latitude
                    val longitude = address.longitude
                    val subtitle = listOfNotNull(locality, country)
                        .filter { it.isNotBlank() }
                        .joinToString(", ")

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
                return LocationSearchOutcome(results, false)
            } catch (e: Exception) {
                lastWasNetworkError = isNetworkOrTimeoutError(e)
                if (retryCount >= maxRetries) {
                    break
                }
                retryCount++
                try {
                    Thread.sleep(currentDelay)
                } catch (_: InterruptedException) {
                    break
                }
                currentDelay *= 2
            }
        }

        return LocationSearchOutcome(results, lastWasNetworkError)
    }

    private fun isNetworkOrTimeoutError(e: Exception): Boolean {
        val name = e.javaClass.simpleName
        return name.contains("Network", ignoreCase = true) ||
            name.contains("Timeout", ignoreCase = true) ||
            name.contains("UnknownHost", ignoreCase = true)
    }
}
