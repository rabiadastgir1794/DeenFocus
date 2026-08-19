import Foundation

/// Combines progress from multiple weighted phases (e.g. catalog fetch, manifest
/// fetch, file downloads, install) into a single 0...1 callback. Generic and
/// reusable by any future consumer of this framework — no Tajweed/AI knowledge.
final class AssetProgressNotifier {
  private struct Phase {
    let weight: Double
    var fraction: Double = 0
  }

  private var phases: [String: Phase]
  private let onProgress: (Double) -> Void
  private let lock = NSLock()

  init(phaseWeights: [(name: String, weight: Double)], onProgress: @escaping (Double) -> Void) {
    self.phases = Dictionary(uniqueKeysWithValues: phaseWeights.map { ($0.name, Phase(weight: $0.weight)) })
    self.onProgress = onProgress
  }

  func update(_ phaseName: String, fraction: Double) {
    lock.lock()
    phases[phaseName]?.fraction = min(max(fraction, 0), 1)
    let totalWeight = phases.values.reduce(0) { $0 + $1.weight }
    let weighted = phases.values.reduce(0.0) { $0 + $1.weight * $1.fraction }
    let overall = totalWeight > 0 ? weighted / totalWeight : 0
    lock.unlock()
    onProgress(overall)
  }
}
