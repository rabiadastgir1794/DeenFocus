package com.rnr.deenfocus

import android.location.Address
import android.os.Looper
import androidx.test.core.app.ApplicationProvider
import java.util.Locale
import java.util.concurrent.atomic.AtomicInteger
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.Shadows.shadowOf
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [34])
class LocationSearchHelperTest {

    @Test
    fun addressesToResults_keepsNamedPlacesAndDropsMissingCoordinates() {
        val valid = Address(Locale.US).apply {
            setAddressLine(0, "Lahore, Pakistan")
            locality = "Lahore"
            countryName = "Pakistan"
            latitude = 31.5204
            longitude = 74.3587
        }
        val missing = Address(Locale.US).apply {
            setAddressLine(0, "Nowhere")
            latitude = 0.0
            longitude = 0.0
        }

        val results = LocationSearchHelper.addressesToResults(listOf(valid, missing))

        assertEquals(1, results.size)
        assertEquals("Lahore, Pakistan", results[0]["title"])
        assertEquals("Lahore, Pakistan", results[0]["subtitle"])
        assertEquals(31.5204, results[0]["latitude"])
        assertEquals(74.3587, results[0]["longitude"])
    }

    @Test
    fun emptyQuery_completesOnceWithoutBlocking() {
        val calls = AtomicInteger(0)
        val started = System.nanoTime()
        LocationSearchHelper.search(
            ApplicationProvider.getApplicationContext(),
            "   ",
            timeoutMs = 25_000L,
        ) {
            calls.incrementAndGet()
            assertTrue(it.results.isEmpty())
            assertFalse(it.wasNetworkError)
        }
        assertTrue(System.nanoTime() - started < 1_000_000_000L)
        assertEquals(1, calls.get())
        shadowOf(Looper.getMainLooper()).idle()
        assertEquals(1, calls.get())
    }

    @Test
    fun session_timeoutAndLateSuccess_completeExactlyOnce() {
        val handler = android.os.Handler(Looper.getMainLooper())
        val calls = mutableListOf<LocationSearchOutcome>()
        val session = SearchSession(handler, timeoutMs = 40L) { calls.add(it) }
        session.armTimeout()
        shadowOf(Looper.getMainLooper()).idleFor(100, java.util.concurrent.TimeUnit.MILLISECONDS)
        session.finish(LocationSearchOutcome(listOf(mapOf("title" to "late")), false))

        assertEquals(1, calls.size)
        assertTrue(calls[0].results.isEmpty())
        assertTrue(calls[0].wasNetworkError)
    }

    @Test
    fun session_successThenTimeout_keepsTheSuccess() {
        val handler = android.os.Handler(Looper.getMainLooper())
        val calls = mutableListOf<LocationSearchOutcome>()
        val session = SearchSession(handler, timeoutMs = 40L) { calls.add(it) }
        session.armTimeout()
        session.finish(
            LocationSearchOutcome(
                listOf(mapOf("title" to "Makkah")),
                false,
            ),
        )
        shadowOf(Looper.getMainLooper()).idleFor(100, java.util.concurrent.TimeUnit.MILLISECONDS)
        session.finish(LocationSearchOutcome(emptyList(), true))

        assertEquals(1, calls.size)
        assertEquals("Makkah", calls[0].results[0]["title"])
        assertFalse(calls[0].wasNetworkError)
    }

    @Test
    fun search_returnsToCallerBeforeGeocoderFinishes() {
        val calls = AtomicInteger(0)
        val started = System.nanoTime()
        LocationSearchHelper.search(
            ApplicationProvider.getApplicationContext(),
            "Lahore",
            timeoutMs = 200L,
        ) {
            calls.incrementAndGet()
        }
        assertTrue(
            "search() blocked the caller",
            System.nanoTime() - started < 1_000_000_000L,
        )
        shadowOf(Looper.getMainLooper()).idleFor(1, java.util.concurrent.TimeUnit.SECONDS)
        assertEquals(1, calls.get())
    }
}
