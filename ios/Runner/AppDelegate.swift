import Flutter
import UIKit
import FamilyControls
import DeviceActivity
import ManagedSettings
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let screenTimeChannelName = "com.app.deenly.deenly/screen_time"
  private let qiblaMethodChannelName = "com.app.deenly.deenly/qibla_compass_method"
  private let qiblaEventChannelName = "com.app.deenly.deenly/qibla_compass_events"
  private let qiblaHeadingStreamHandler = QiblaHeadingStreamHandler()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let registrar = self.registrar(forPlugin: "QiblaCompassPlugin") {
      let messenger = registrar.messenger()
      let screenTimeChannel = FlutterMethodChannel(
        name: screenTimeChannelName,
        binaryMessenger: messenger
      )
      let qiblaMethodChannel = FlutterMethodChannel(
        name: qiblaMethodChannelName,
        binaryMessenger: messenger
      )
      let qiblaEventChannel = FlutterEventChannel(
        name: qiblaEventChannelName,
        binaryMessenger: messenger
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

      qiblaMethodChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "setLocation":
          result(nil)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      qiblaEventChannel.setStreamHandler(qiblaHeadingStreamHandler)
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

final class QiblaHeadingStreamHandler: NSObject, FlutterStreamHandler, CLLocationManagerDelegate {
  private let locationManager = CLLocationManager()
  private var eventSink: FlutterEventSink?

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.headingFilter = 1
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    guard CLLocationManager.headingAvailable() else {
      events(FlutterEndOfEventStream)
      return nil
    }

    eventSink = events
    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    locationManager.stopUpdatingHeading()
    locationManager.stopUpdatingLocation()
    return nil
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
    eventSink?(normalizedHeading(heading))
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    eventSink?(FlutterEndOfEventStream)
  }

  func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
    return true
  }

  private func normalizedHeading(_ value: CLLocationDirection) -> Double {
    let normalized = value.truncatingRemainder(dividingBy: 360)
    return normalized >= 0 ? normalized : normalized + 360
  }
}
