import Flutter
import UIKit
import FamilyControls
import DeviceActivity
import ManagedSettings

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let screenTimeChannelName = "com.app.deenly.deenly/screen_time"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let screenTimeChannel = FlutterMethodChannel(
        name: screenTimeChannelName,
        binaryMessenger: controller.binaryMessenger
      )

      screenTimeChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "requestScreenTime":
          self.requestScreenTimeAuthorization(result: result)
        case "openAppSettings":
          self.openAppSettings(result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func requestScreenTimeAuthorization(result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result(false)
      return
    }

    Task {
      do {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        result(true)
      } catch {
        result(
          FlutterError(
            code: "SCREEN_TIME_AUTH_FAILED",
            message: error.localizedDescription,
            details: nil
          )
        )
      }
    }
  }

  private func openAppSettings(result: @escaping FlutterResult) {
    guard let url = URL(string: UIApplication.openSettingsURLString) else {
      result(false)
      return
    }

    guard UIApplication.shared.canOpenURL(url) else {
      result(false)
      return
    }

    UIApplication.shared.open(url, options: [:]) { success in
      result(success)
    }
  }
}
