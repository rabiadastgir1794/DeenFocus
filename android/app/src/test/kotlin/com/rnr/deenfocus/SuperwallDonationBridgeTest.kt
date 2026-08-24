package com.rnr.deenfocus

import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Test

class SuperwallDonationBridgeTest {
    @Test
    fun allowedProductIdsMatchPlayConsoleConsumables() {
        assertEquals(
            setOf(
                "com.deenfocus.donation.10",
                "com.deenfocus.donation.25",
                "com.deenfocus.donation.50",
                "com.deenfocus.donation.100",
                "com.deenfocus.donation.250",
            ),
            SuperwallDonationBridge.ALLOWED_PRODUCT_IDS,
        )
    }

    @Test
    fun donationIdsDoNotIncludeSubscriptionSkus() {
        val subscriptionIds = setOf(
            "premium.yearly",
            "com.rnr.deenfocus.premium.monthly",
            "com.rnr.deenfocus.premium.yearly",
        )
        assertFalse(
            SuperwallDonationBridge.ALLOWED_PRODUCT_IDS.any(subscriptionIds::contains),
        )
    }
}
