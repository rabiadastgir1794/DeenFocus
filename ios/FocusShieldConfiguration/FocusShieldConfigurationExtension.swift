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
    case .salah:
      return "Salah Time - Stay Focused"
    case .child:
      return "Child Focus Mode"
    case .nightDiscipline:
      return "Night Focus Mode"
    }
  }

  var subtitle: String {
    switch self {
    case .salah:
      return """
      Step away from distractions and answer the call to prayer.
      Take this moment to connect with Allah.

      Return after completing your Salah in DeenFocus.

      "Establish prayer for My remembrance."
      (Quran 20:14)
      """
    case .child:
      return """
      This device is currently in child focus mode to help maintain a safe and balanced digital experience.

      Some apps are temporarily unavailable.

      "Teach your children prayer when they are seven."
      (Hadith - Abu Dawood)
      """
    case .nightDiscipline:
      return """
      It's time to rest and disconnect from digital distractions.

      Put your device aside and enjoy a peaceful night.

      "And We made your sleep a means for rest."
      (Quran 78:9)
      """
    }
  }

  var primaryButton: String {
    switch self {
    case .salah:
      return "Start My Salah"
    case .child:
      return "Continue in Safe Mode"
    case .nightDiscipline:
      return "Good Night 🌙"
    }
  }
}

@available(iOSApplicationExtension 16.0, *)
final class FocusShieldConfigurationExtension: ShieldConfigurationDataSource {
  private struct ThemePalette {
    let blurStyle: UIBlurEffect.Style?
    let backgroundColor: UIColor
    let titleColor: UIColor
    let subtitleColor: UIColor
    let buttonBackgroundColor: UIColor
    let buttonTextColor: UIColor
  }

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
    let palette = themePalette()

    return ShieldConfiguration(
      backgroundBlurStyle: palette.blurStyle,
      backgroundColor: palette.backgroundColor,
      icon: nil,
      title: ShieldConfiguration.Label(
        text: mode.title,
        color: palette.titleColor
      ),
      subtitle: ShieldConfiguration.Label(
        text: mode.subtitle,
        color: palette.subtitleColor
      ),
      primaryButtonLabel: ShieldConfiguration.Label(
        text: mode.primaryButton,
        color: palette.buttonTextColor
      ),
      primaryButtonBackgroundColor: palette.buttonBackgroundColor,
      secondaryButtonLabel: nil
    )
  }

  private func themePalette() -> ThemePalette {
    let screenStyle = UIScreen.main.traitCollection.userInterfaceStyle
    let currentStyle = screenStyle == .unspecified
      ? UITraitCollection.current.userInterfaceStyle
      : screenStyle
    let isDarkMode = currentStyle != .light
    if isDarkMode {
      return ThemePalette(
        blurStyle: .dark,
        backgroundColor: .black,
        titleColor: .white,
        subtitleColor: UIColor(white: 0.92, alpha: 1.0),
        buttonBackgroundColor: UIColor(red: 0.306, green: 0.604, blue: 0.486, alpha: 1.0),  // #4E9A7C
        buttonTextColor: .white
      )
    }

    return ThemePalette(
      blurStyle: nil,
      backgroundColor: UIColor(red: 0.969, green: 0.961, blue: 0.941, alpha: 1.0),  // #F7F5F0
      titleColor: UIColor(red: 0.110, green: 0.239, blue: 0.180, alpha: 1.0),  // #1C2E24
      subtitleColor: UIColor(red: 0.290, green: 0.271, blue: 0.224, alpha: 1.0),  // #4A4539
      buttonBackgroundColor: UIColor(red: 0.306, green: 0.604, blue: 0.486, alpha: 1.0),  // #4E9A7C
      buttonTextColor: .white
    )
  }
}
