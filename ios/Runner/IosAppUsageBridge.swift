import FamilyControls
import Flutter
import Foundation

/// Family Controls / Device Activity bridge for Digital Balance.
///
/// Inspected against the iPhoneOS 26.2 SDK shipped with Xcode 26.2:
/// - `AuthorizationCenter.requestAuthorization(for:)` exists and is already
///   used for Focus Mode.
/// - `DeviceActivityData.ApplicationActivity` exists, but only inside a
///   `DeviceActivityReport` extension (`makeConfiguration`). Apple sandboxes
///   that extension so usage numbers cannot be exported to Flutter.
/// - `FamilyActivityData`, `AuthorizationStatus.approvedWithDataAccess`, and
///   `DeviceActivityData.activityData(filteredBy:using:)` are documented as
///   iOS 26.4+ and are **not** in this SDK. Those APIs are also limited to
///   customer installs in the EU. Do not invent them here.
enum IosAppUsageBridge {
  static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getAvailability":
      result(availabilityPayload())
    case "requestAccess":
      requestAccess(result: result)
    case "queryUsage":
      result(queryPayload())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  static func availabilityPayload() -> [String: Any] {
    emptyPayload(status: currentStatus())
  }

  static func queryPayload() -> [String: Any] {
    emptyPayload(status: queryStatus())
  }

  private static func requestAccess(result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result(emptyPayload(status: "unsupported", reason: "os_unsupported"))
      return
    }

    Task { @MainActor in
      do {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        #if DEBUG
        NSLog("[DeenFocus][AppUsage] Family Controls authorization succeeded")
        #endif
        result(queryPayload())
      } catch {
        #if DEBUG
        NSLog(
          "[DeenFocus][AppUsage] Family Controls authorization failed code=\(iosAuthErrorCode(error))"
        )
        #endif
        result(
          emptyPayload(
            status: statusAfterFailedRequest(error),
            reason: iosAuthErrorCode(error),
          )
        )
      }
    }
  }

  private static func currentStatus() -> String {
    guard #available(iOS 16.0, *) else { return "unsupported" }
    switch AuthorizationCenter.shared.authorizationStatus {
    case .approved:
      // Authorized for shields / monitoring, but this SDK cannot export
      // per-app durations to the host app.
      return "unsupported"
    case .denied:
      return "denied"
    case .notDetermined:
      return "denied"
    @unknown default:
      return "unsupported"
    }
  }

  private static func queryStatus() -> String {
    currentStatus()
  }

  @available(iOS 16.0, *)
  private static func statusAfterFailedRequest(_ error: Error) -> String {
    let authError = error as? FamilyControlsError
    switch authError {
    case .restricted, .unavailable, .invalidAccountType, .authorizationConflict:
      return "unsupported"
    default:
      return "denied"
    }
  }

  @available(iOS 16.0, *)
  private static func iosAuthErrorCode(_ error: Error) -> String {
    let authError = error as? FamilyControlsError
    switch authError {
    case .authenticationMethodUnavailable:
      return "AUTHENTICATION_METHOD_UNAVAILABLE"
    case .authorizationCanceled:
      return "AUTHORIZATION_CANCELED"
    case .authorizationConflict:
      return "AUTHORIZATION_CONFLICT"
    case .invalidAccountType:
      return "INVALID_ACCOUNT_TYPE"
    case .networkError:
      return "NETWORK_ERROR"
    case .restricted:
      return "RESTRICTED"
    case .unavailable:
      return "UNAVAILABLE"
    case .invalidArgument:
      return "INVALID_ARGUMENT"
    case .none:
      return "SCREEN_TIME_AUTH_FAILED"
    @unknown default:
      return "SCREEN_TIME_AUTH_FAILED"
    }
  }

  /// Shared payload shape with Android. Never invent app rows.
  static func emptyPayload(
    status: String,
    reason: String? = nil,
  ) -> [String: Any] {
    var payload: [String: Any] = [
      "status": status,
      "apps": [String: Any](),
      "days": [Any](),
    ]
    if let reason, !reason.isEmpty {
      payload["reason"] = reason
    }
    return payload
  }

  /// Used when a future SDK can export `ManagedSettings.Application` rows.
  static func isDeenFocus(bundleIdentifier: String?) -> Bool {
    guard let bundleIdentifier, !bundleIdentifier.isEmpty else { return false }
    return bundleIdentifier == Bundle.main.bundleIdentifier
  }
}
