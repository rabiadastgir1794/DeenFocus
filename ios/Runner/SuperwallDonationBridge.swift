import Flutter
import Foundation
import StoreKit
import SuperwallKit

/// Direct purchases for one-time donations.
/// Prefers SuperwallKit `products(for:)` + `purchase(_:)` when Superwall is
/// configured. Falls back to StoreKit 2 with the same product IDs so simulator
/// / StoreKit-config testing works even if the Superwall API key is missing.
/// Never presents a paywall and must never grant subscription entitlements.
enum SuperwallDonationBridge {
  static let channelName = "com.app.deenly.deenly/superwall_donations"

  static func register(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "fetchProduct":
        fetchProduct(call: call, result: result)
      case "purchase":
        purchase(call: call, result: result)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func productId(from call: FlutterMethodCall) -> String? {
    guard let args = call.arguments as? [String: Any] else { return nil }
    let raw = (args["productId"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
    return (raw?.isEmpty == false) ? raw : nil
  }

  private static func fetchProduct(
    call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    guard let productId = productId(from: call) else {
      result(
        FlutterError(
          code: "INVALID_ARGS",
          message: "productId is required",
          details: nil
        )
      )
      return
    }

    Task {
      do {
        let payload = try await fetchProductPayload(productId: productId)
        NSLog("[DeenFocus][Donation] fetched product %@", payload.description)
        DispatchQueue.main.async { result(payload) }
      } catch let error as DonationBridgeError {
        NSLog("[DeenFocus][Donation] fetch error %@", error.flutterError.message ?? "")
        DispatchQueue.main.async { result(error.flutterError) }
      } catch {
        NSLog("[DeenFocus][Donation] fetch failed %@", error.localizedDescription)
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: "FETCH_FAILED",
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      }
    }
  }

  private static func purchase(
    call: FlutterMethodCall,
    result: @escaping FlutterResult
  ) {
    guard let productId = productId(from: call) else {
      result(
        FlutterError(
          code: "INVALID_ARGS",
          message: "productId is required",
          details: nil
        )
      )
      return
    }

    Task {
      do {
        let payload = try await purchaseProduct(productId: productId)
        NSLog("[DeenFocus][Donation] purchase result %@", payload.description)
        DispatchQueue.main.async { result(payload) }
      } catch let error as DonationBridgeError {
        NSLog("[DeenFocus][Donation] purchase error %@", error.flutterError.message ?? "")
        DispatchQueue.main.async { result(error.flutterError) }
      } catch {
        NSLog("[DeenFocus][Donation] purchase failed %@", error.localizedDescription)
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: "PURCHASE_FAILED",
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      }
    }
  }

  private static var isSuperwallReady: Bool {
    Superwall.isInitialized && Superwall.shared.configurationStatus == .configured
  }

  private static func purchaseProduct(productId: String) async throws -> [String: Any] {
    if isSuperwallReady, let product = await superwallProduct(productId: productId) {
      NSLog("[DeenFocus][Donation] purchasing via Superwall id=%@", productId)
      let purchaseResult = await Superwall.shared.purchase(product)
      switch purchaseResult {
      case .purchased:
        return ["status": "purchased", "productId": productId]
      case .cancelled:
        return ["status": "cancelled", "productId": productId]
      case .pending:
        return ["status": "pending", "productId": productId]
      case .failed(let error):
        NSLog(
          "[DeenFocus][Donation] Superwall purchase failed, trying StoreKit 2: %@",
          error.localizedDescription
        )
      }
    } else {
      NSLog(
        "[DeenFocus][Donation] Superwall not configured, using StoreKit 2 id=%@",
        productId
      )
    }

    if #available(iOS 15.0, *) {
      return try await purchaseWithStoreKit2(productId: productId)
    }
    throw DonationBridgeError.productNotFound(productId)
  }

  private static func fetchProductPayload(productId: String) async throws -> [String: Any] {
    if isSuperwallReady, let product = await superwallProduct(productId: productId) {
      return [
        "productId": product.productIdentifier,
        "localizedPrice": product.localizedPrice,
      ]
    }

    if #available(iOS 15.0, *) {
      let product = try await storeKit2Product(productId: productId)
      return [
        "productId": product.id,
        "localizedPrice": product.displayPrice,
      ]
    }

    throw DonationBridgeError.productNotFound(productId)
  }

  private static func superwallProduct(productId: String) async -> StoreProduct? {
    let products = await Superwall.shared.products(for: Set([productId]))
    return products.first(where: { $0.productIdentifier == productId })
  }

  @available(iOS 15.0, *)
  private static func storeKit2Product(productId: String) async throws -> StoreKit.Product {
    let products = try await StoreKit.Product.products(for: [productId])
    if let match = products.first(where: { $0.id == productId }) {
      return match
    }
    throw DonationBridgeError.productNotFound(productId)
  }

  @available(iOS 15.0, *)
  private static func purchaseWithStoreKit2(productId: String) async throws -> [String: Any] {
    let product = try await storeKit2Product(productId: productId)
    NSLog("[DeenFocus][Donation] StoreKit 2 sheet for %@", productId)
    let result = try await product.purchase()
    switch result {
    case .success(let verification):
      switch verification {
      case .verified(let transaction):
        await transaction.finish()
        return ["status": "purchased", "productId": productId]
      case .unverified(_, let error):
        throw error
      }
    case .userCancelled:
      return ["status": "cancelled", "productId": productId]
    case .pending:
      return ["status": "pending", "productId": productId]
    @unknown default:
      throw DonationBridgeError.purchaseFailed("Unknown StoreKit purchase result")
    }
  }
}

private enum DonationBridgeError: Error {
  case productNotFound(String)
  case purchaseFailed(String)

  var flutterError: FlutterError {
    switch self {
    case .productNotFound(let productId):
      return FlutterError(
        code: "PRODUCT_NOT_FOUND",
        message: "StoreKit product not found: \(productId)",
        details: productId
      )
    case .purchaseFailed(let message):
      return FlutterError(
        code: "PURCHASE_FAILED",
        message: message,
        details: nil
      )
    }
  }
}
