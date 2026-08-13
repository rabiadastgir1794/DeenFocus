import ActivityKit
import SwiftUI
import WidgetKit

@available(iOS 16.2, *)
struct PrayerLiveActivityWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: PrayerLiveActivityAttributes.self) { context in
      PrayerLiveActivityLockScreenView(
        attributes: context.attributes,
        state: context.state
      )
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          VStack(alignment: .leading, spacing: 2) {
            Text(context.state.nowLabel)
              .font(.caption2.weight(.semibold))
              .foregroundStyle(.secondary)
            Text(context.state.currentPrayerLabel)
              .font(.headline.weight(.bold))
          }
        }
        DynamicIslandExpandedRegion(.trailing) {
          Text(context.state.currentPrayerTimeLabel)
            .font(.title3.weight(.bold))
            .monospacedDigit()
        }
        DynamicIslandExpandedRegion(.bottom) {
          HStack {
            Text(context.state.nextPrayerLine)
              .font(.caption)
              .foregroundStyle(.secondary)
              .lineLimit(1)
            Spacer()
            Text(context.attributes.brandName)
              .font(.caption2.weight(.semibold))
          }
        }
      } compactLeading: {
        Text(context.state.currentPrayerLabel)
          .font(.caption2.weight(.bold))
      } compactTrailing: {
        Text(context.state.currentPrayerTimeLabel)
          .font(.caption2.weight(.semibold))
          .monospacedDigit()
      } minimal: {
        Image(systemName: "moon.stars.fill")
      }
    }
  }
}

@available(iOS 16.2, *)
private struct PrayerLiveActivityLockScreenView: View {
  let attributes: PrayerLiveActivityAttributes
  let state: PrayerLiveActivityAttributes.ContentState

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(spacing: 8) {
        Text(state.nowLabel.uppercased())
          .font(.caption2.weight(.bold))
          .padding(.horizontal, 8)
          .padding(.vertical, 3)
          .background(Capsule().fill(Color.white.opacity(0.14)))
        Text(state.currentPrayerLabel)
          .font(.subheadline.weight(.semibold))
        Spacer()
        Text(state.updatedAtLabel)
          .font(.caption2)
          .foregroundStyle(.white.opacity(0.7))
      }

      HStack(alignment: .bottom, spacing: 12) {
        VStack(alignment: .leading, spacing: 4) {
          Text(state.currentPrayerTimeLabel)
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .monospacedDigit()
          if !state.locationName.isEmpty {
            Text(state.locationName)
              .font(.caption)
              .foregroundStyle(.white.opacity(0.8))
          }
        }
        Spacer(minLength: 8)
        PrayerProgressCurve(progress: state.prayerProgress)
          .frame(width: 120, height: 44)
      }

      HStack {
        Text(state.nextPrayerLine)
          .font(.caption)
          .foregroundStyle(.white.opacity(0.8))
          .lineLimit(1)
        Spacer()
        Text(attributes.brandName.uppercased())
          .font(.caption2.weight(.bold))
          .tracking(0.6)
      }
    }
    .foregroundStyle(.white)
    .padding(16)
    .activityBackgroundTint(Color(red: 0.10, green: 0.18, blue: 0.16))
  }
}

@available(iOS 16.2, *)
private struct PrayerProgressCurve: View {
  let progress: Double

  var body: some View {
    GeometryReader { geo in
      let w = geo.size.width
      let h = geo.size.height
      let clamped = min(max(progress, 0), 1)

      ZStack {
        Path { path in
          path.move(to: CGPoint(x: 0, y: h * 0.75))
          path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.75),
            control: CGPoint(x: w * 0.5, y: h * 0.05)
          )
        }
        .stroke(Color.white.opacity(0.35), style: StrokeStyle(lineWidth: 2, lineCap: .round))

        ForEach(0..<5, id: \.self) { index in
          let t = Double(index) / 4.0
          let point = pointOnCurve(t: t, width: w, height: h)
          Circle()
            .fill(Color.white.opacity(index <= Int((clamped * 4).rounded()) ? 1 : 0.35))
            .frame(width: 6, height: 6)
            .position(point)
        }

        let current = pointOnCurve(t: clamped, width: w, height: h)
        Circle()
          .stroke(Color.white, lineWidth: 2)
          .background(Circle().fill(Color(red: 0.10, green: 0.18, blue: 0.16)))
          .frame(width: 10, height: 10)
          .position(current)
      }
    }
  }

  private func pointOnCurve(t: Double, width: CGFloat, height: CGFloat) -> CGPoint {
    // Approximate quadratic Bezier: P = (1-t)^2 P0 + 2(1-t)t P1 + t^2 P2
    let p0 = CGPoint(x: 0, y: height * 0.75)
    let p1 = CGPoint(x: width * 0.5, y: height * 0.05)
    let p2 = CGPoint(x: width, y: height * 0.75)
    let mt = 1 - t
    let x = mt * mt * p0.x + 2 * mt * t * p1.x + t * t * p2.x
    let y = mt * mt * p0.y + 2 * mt * t * p1.y + t * t * p2.y
    return CGPoint(x: x, y: y)
  }
}
