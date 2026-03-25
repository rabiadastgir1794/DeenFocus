import Flutter
import UIKit
import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings
import CoreLocation

@available(iOS 16.0, *)
private enum ManagedSettingsStoreHolder {
  static let shared = ManagedSettingsStore()
}

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let focusMethodChannelName = "com.app.deenly.deenly/focus"
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
      let focusMethodChannel = FlutterMethodChannel(
        name: focusMethodChannelName,
        binaryMessenger: messenger
      )
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

      focusMethodChannel.setMethodCallHandler { call, result in
        switch call.method {
        case "presentFamilyActivityPicker":
          self.presentFamilyActivityPicker(result: result)
        case "syncFocusState":
          self.syncFocusState(call: call, result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

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

  private func presentFamilyActivityPicker(result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result(
        FlutterError(
          code: "IOS_VERSION_UNSUPPORTED",
          message: "FamilyActivityPicker requires iOS 16 or later.",
          details: nil
        )
      )
      return
    }

    DispatchQueue.main.async {
      guard let controller = self.topViewController() else {
        result(
          FlutterError(
            code: "PICKER_PRESENTATION_FAILED",
            message: "No active view controller available.",
            details: nil
          )
        )
        return
      }

      let presenter = FocusPickerPresenter { payload in
        result(payload)
      }
      presenter.present(from: controller)
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

  private func syncFocusState(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard #available(iOS 16.0, *) else {
      result(nil)
      return
    }

    guard let args = call.arguments as? [String: Any] else {
      result(nil)
      return
    }

    let isLocked = args["isLocked"] as? Bool ?? false
    let encodedSelection = args["iosSelectionData"] as? String

    let store = ManagedSettingsStoreHolder.shared

    if !isLocked {
      store.clearAllSettings()
      result(nil)
      return
    }

    guard
      let encodedSelection,
      let data = Data(base64Encoded: encodedSelection),
      let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    else {
      store.clearAllSettings()
      result(nil)
      return
    }

    store.shield.applications = selection.applicationTokens
    store.shield.applicationCategories = nil
    store.shield.webDomains = nil
    result(nil)
  }

  private func topViewController(
    from controller: UIViewController? = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first(where: { $0.isKeyWindow })?.rootViewController
  ) -> UIViewController? {
    if let navigation = controller as? UINavigationController {
      return topViewController(from: navigation.visibleViewController)
    }

    if let tab = controller as? UITabBarController {
      return topViewController(from: tab.selectedViewController)
    }

    if let presented = controller?.presentedViewController {
      return topViewController(from: presented)
    }

    return controller
  }
}

@available(iOS 16.0, *)
final class FocusPickerPresenter {
  private let onComplete: ([String: Any?]) -> Void

  init(onComplete: @escaping ([String: Any?]) -> Void) {
    self.onComplete = onComplete
  }

  func present(from controller: UIViewController) {
    let pickerController = FocusPickerViewController(onComplete: onComplete)
    pickerController.modalPresentationStyle = .pageSheet
    controller.present(pickerController, animated: true)
  }
}

@available(iOS 16.0, *)
private final class FocusPickerViewController: UIHostingController<FocusPickerRootView> {
  init(onComplete: @escaping ([String: Any?]) -> Void) {
    let rootView = FocusPickerRootView(onComplete: onComplete)
    super.init(rootView: rootView)
  }

  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

@available(iOS 16.0, *)
private struct FocusPickerRootView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var selection = FamilyActivitySelection()

  let onComplete: ([String: Any?]) -> Void

  var body: some View {
    NavigationStack {
      FamilyActivityPicker(selection: $selection)
        .navigationTitle("Select Apps")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
              dismiss()
              onComplete([
                "selectionData": nil,
                "applicationCount": selection.applicationTokens.count
              ])
            }
          }

          ToolbarItem(placement: .confirmationAction) {
            Button("Done") {
              let payload = serializeSelection(selection)
              dismiss()
              onComplete(payload)
            }
          }
        }
    }
  }

  private func serializeSelection(_ selection: FamilyActivitySelection) -> [String: Any?] {
    let encoded = try? JSONEncoder().encode(selection)
    return [
      "selectionData": encoded?.base64EncodedString(),
      "applicationCount": selection.applicationTokens.count
    ]
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
