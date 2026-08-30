package com.rnr.deenfocus

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

class FocusBlockedOverlaySuppressTest {
    @Before
    fun clearSuppress() {
        FocusAccessibilityService.clearOverlaySuppressForTest()
    }

    @Test
    fun userDismissSuppressesSamePackageOnly() {
        FocusAccessibilityService.noteUserDismissedOverlay("com.instagram.android")
        assertTrue(
            FocusAccessibilityService.isOverlaySuppressed("com.instagram.android"),
        )
        assertFalse(
            FocusAccessibilityService.isOverlaySuppressed("com.twitter.android"),
        )
    }

    @Test
    fun nullPackageSuppressesAllWhileWindowActive() {
        FocusAccessibilityService.noteUserDismissedOverlay(null)
        assertTrue(FocusAccessibilityService.isOverlaySuppressed("com.instagram.android"))
        assertTrue(FocusAccessibilityService.isOverlaySuppressed("com.twitter.android"))
    }

    @Test
    fun notSuppressedAfterClear() {
        FocusAccessibilityService.noteUserDismissedOverlay("com.example.app")
        assertTrue(FocusAccessibilityService.isOverlaySuppressed("com.example.app"))
        FocusAccessibilityService.clearOverlaySuppressForTest()
        assertFalse(FocusAccessibilityService.isOverlaySuppressed("com.example.app"))
    }
}
