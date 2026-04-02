import FamilyControls
import ManagedSettings
import ManagedSettingsUI
import UIKit

private enum FocusShieldSharedState {
  static let appGroupId = "group.com.rnr.deenfocus"
  static let activeModeKey = "focus_shield_active_mode"
}

private enum FocusShieldMode: String {
  case child
  case nightDiscipline
  case salah

  init(rawMode: String?) {
    switch rawMode {
    case "child", "childMode":
      self = .child
    case "nightDiscipline", "night", "sleep", "sleepLock":
      self = .nightDiscipline
    case "salah", "prayer", "prayerLock":
      self = .salah
    default:
      self = .salah
    }
  }

  var title: String {
    switch self {
    case .child:
      return "Child Mode Active"
    case .nightDiscipline:
      return "Sleep Lock Mode Active"
    case .salah:
      return "Prayer Lock Mode Active"
    }
  }
}

@available(iOSApplicationExtension 16.0, *)
final class FocusShieldConfigurationExtension: ShieldConfigurationDataSource {
  private var sharedDefaults: UserDefaults? {
    UserDefaults(suiteName: FocusShieldSharedState.appGroupId)
  }

  override func configuration(shielding application: Application) -> ShieldConfiguration {
    makeConfiguration()
  }

  override func configuration(
    shielding application: Application,
    in category: ActivityCategory
  ) -> ShieldConfiguration {
    makeConfiguration()
  }

  override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
    makeConfiguration()
  }

  override func configuration(
    shielding webDomain: WebDomain,
    in category: ActivityCategory
  ) -> ShieldConfiguration {
    makeConfiguration()
  }

  private func makeConfiguration() -> ShieldConfiguration {
    let modeRawValue = sharedDefaults?.string(forKey: FocusShieldSharedState.activeModeKey)
    let mode = FocusShieldMode(rawMode: modeRawValue)

    return ShieldConfiguration(
      backgroundBlurStyle: .systemChromeMaterialDark,
      backgroundColor: .black,
      icon: nil,
      title: ShieldConfiguration.Label(
        text: mode.title,
        color: .white
      ),
      subtitle: ShieldConfiguration.Label(
        text: "Deen Focus has locked selected apps",
        color: UIColor.white.withAlphaComponent(0.86)
      ),
      primaryButtonLabel: ShieldConfiguration.Label(
        text: "OK",
        color: .white
      ),
      primaryButtonBackgroundColor: UIColor.white.withAlphaComponent(0.18),
      secondaryButtonLabel: nil
    )
  }
}
