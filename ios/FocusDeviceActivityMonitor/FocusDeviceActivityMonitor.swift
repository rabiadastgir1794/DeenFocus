import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings

@available(iOS 16.0, *)
final class FocusDeviceActivityMonitor: DeviceActivityMonitor {
  private let store = ManagedSettingsStore(
    named: ManagedSettingsStore.Name("FocusShield")
  )
  private static let appGroupId = "group.com.rnr.deenfocus"
  private static let selectionKey = "focus_device_activity_selection_b64"

  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
    applyShield()
  }

  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
    store.clearAllSettings()
  }

  private func applyShield() {
    guard
      let b64 = UserDefaults(suiteName: Self.appGroupId)?.string(forKey: Self.selectionKey),
      let data = Data(base64Encoded: b64),
      let sel = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
    else {
      return
    }
    store.shield.applications = sel.applicationTokens
    store.shield.applicationCategories = sel.categoryTokens.isEmpty
      ? nil
      : ShieldSettings.ActivityCategoryPolicy.specific(sel.categoryTokens)
    store.shield.webDomains = sel.webDomainTokens
    store.shield.webDomainCategories = nil
  }
}
