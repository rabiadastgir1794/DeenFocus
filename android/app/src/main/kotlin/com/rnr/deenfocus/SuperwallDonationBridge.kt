package com.rnr.deenfocus

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.superwall.sdk.Superwall
import com.superwall.sdk.config.models.ConfigurationStatus
import com.superwall.sdk.delegate.PurchaseResult
import com.superwall.sdk.store.abstractions.product.StoreProduct
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/**
 * Direct purchases for one-time donations on Android.
 *
 * Mirrors iOS: Superwall `getProducts` + `purchase` only. No app-owned
 * [com.android.billingclient.api.BillingClient] — Superwall's SDK owns the
 * Play Billing lifecycle (query, launch, consume/finish). Never presents a
 * paywall and must never grant subscription entitlements.
 */
class SuperwallDonationBridge : MethodChannel.MethodCallHandler {
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "fetchProduct" -> {
                val productId = productId(call, result) ?: return
                runAsync(result) { fetchProductPayload(productId) }
            }
            "purchase" -> {
                val productId = productId(call, result) ?: return
                runAsync(result) { purchaseProduct(productId) }
            }
            else -> result.notImplemented()
        }
    }

    private fun productId(call: MethodCall, result: MethodChannel.Result): String? {
        val raw = call.argument<String>("productId")?.trim().orEmpty()
        if (raw.isEmpty()) {
            result.error("INVALID_ARGS", "productId is required", null)
            return null
        }
        if (raw !in ALLOWED_PRODUCT_IDS) {
            result.error("PRODUCT_NOT_FOUND", "Donation product not allowed: $raw", raw)
            return null
        }
        return raw
    }

    private fun runAsync(
        result: MethodChannel.Result,
        block: suspend () -> Map<String, Any>,
    ) {
        CoroutineScope(Dispatchers.Main.immediate).launch {
            try {
                deliverSuccess(result, block())
            } catch (error: DonationBridgeException) {
                Log.e(TAG, "Donation bridge error ${error.code}: ${error.message}")
                deliverError(result, error.code, error.message, error.details)
            } catch (error: Exception) {
                Log.e(TAG, "Donation bridge failed", error)
                deliverError(
                    result,
                    "PURCHASE_FAILED",
                    error.message ?: "Donation purchase failed",
                    null,
                )
            }
        }
    }

    private suspend fun fetchProductPayload(productId: String): Map<String, Any> {
        val product = requireSuperwallProduct(productId)
        return mapOf(
            "productId" to product.productIdentifier,
            "localizedPrice" to product.localizedPrice,
        )
    }

    private suspend fun purchaseProduct(productId: String): Map<String, Any> {
        val product = requireSuperwallProduct(productId)
        Log.i(TAG, "purchasing via Superwall id=$productId")

        val outcome = Superwall.instance.purchase(product)
        val purchaseResult = outcome.getOrElse { error ->
            throw DonationBridgeException(
                "PURCHASE_FAILED",
                error.message ?: "Superwall purchase failed",
                null,
            )
        }

        return when (purchaseResult) {
            is PurchaseResult.Purchased -> statusPayload("purchased", productId)
            is PurchaseResult.Cancelled -> statusPayload("cancelled", productId)
            is PurchaseResult.Pending -> statusPayload("pending", productId)
            is PurchaseResult.Failed -> throw DonationBridgeException(
                "PURCHASE_FAILED",
                purchaseResult.errorMessage,
                null,
            )
        }
    }

    private suspend fun requireSuperwallProduct(productId: String): StoreProduct {
        if (!isSuperwallReady) {
            throw DonationBridgeException(
                "PRODUCT_NOT_FOUND",
                "Superwall is not configured",
                productId,
            )
        }

        val products = try {
            Superwall.instance.getProducts(productId).getOrElse { error ->
                throw DonationBridgeException(
                    "PRODUCT_NOT_FOUND",
                    error.message ?: "Superwall getProducts failed",
                    productId,
                )
            }
        } catch (error: DonationBridgeException) {
            throw error
        } catch (error: Exception) {
            throw DonationBridgeException(
                "PRODUCT_NOT_FOUND",
                error.message ?: "Superwall getProducts failed",
                productId,
            )
        }

        return products[productId]
            ?: products.values.firstOrNull { it.productIdentifier == productId }
            ?: throw DonationBridgeException(
                "PRODUCT_NOT_FOUND",
                "Superwall product not found: $productId",
                productId,
            )
    }

    private val isSuperwallReady: Boolean
        get() {
            if (!Superwall.initialized) {
                Log.w(TAG, "Superwall not ready: initialized=false")
                return false
            }
            return try {
                val state = Superwall.instance.configurationState
                val ready = state == ConfigurationStatus.Configured
                if (!ready) {
                    Log.w(TAG, "Superwall not ready: initialized=true state=$state")
                }
                ready
            } catch (error: Exception) {
                Log.w(TAG, "Superwall readiness check failed: ${error.message}")
                false
            }
        }

    private fun statusPayload(status: String, productId: String): Map<String, Any> {
        return mapOf("status" to status, "productId" to productId)
    }

    private fun deliverSuccess(result: MethodChannel.Result, payload: Map<String, Any>) {
        mainHandler.post { result.success(payload) }
    }

    private fun deliverError(
        result: MethodChannel.Result,
        code: String,
        message: String?,
        details: Any?,
    ) {
        mainHandler.post { result.error(code, message, details) }
    }

    private class DonationBridgeException(
        val code: String,
        override val message: String?,
        val details: Any?,
    ) : Exception(message)

    companion object {
        const val CHANNEL = "com.app.deenly.deenly/superwall_donations"

        val ALLOWED_PRODUCT_IDS: Set<String> = setOf(
            "com.deenfocus.donation.10",
            "com.deenfocus.donation.25",
            "com.deenfocus.donation.50",
            "com.deenfocus.donation.100",
            "com.deenfocus.donation.250",
        )

        private const val TAG = "DeenFocusDonation"
    }
}
