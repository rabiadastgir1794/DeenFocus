import ActivityKit
import Foundation

/// Shared ActivityKit attributes for Prayer Live Activity (Runner + Widget extension).
@available(iOS 16.2, *)
public struct PrayerLiveActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    public var currentPrayerId: String
    public var currentPrayerLabel: String
    public var currentPrayerTimeLabel: String
    public var nextPrayerLine: String
    public var locationName: String
    public var updatedAtLabel: String
    public var nowLabel: String
    public var prayerProgress: Double

    public init(
      currentPrayerId: String,
      currentPrayerLabel: String,
      currentPrayerTimeLabel: String,
      nextPrayerLine: String,
      locationName: String,
      updatedAtLabel: String,
      nowLabel: String,
      prayerProgress: Double
    ) {
      self.currentPrayerId = currentPrayerId
      self.currentPrayerLabel = currentPrayerLabel
      self.currentPrayerTimeLabel = currentPrayerTimeLabel
      self.nextPrayerLine = nextPrayerLine
      self.locationName = locationName
      self.updatedAtLabel = updatedAtLabel
      self.nowLabel = nowLabel
      self.prayerProgress = prayerProgress
    }
  }

  public var brandName: String

  public init(brandName: String) {
    self.brandName = brandName
  }
}
