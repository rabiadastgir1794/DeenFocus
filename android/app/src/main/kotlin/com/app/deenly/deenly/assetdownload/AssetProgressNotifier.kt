package com.rnr.deenfocus.assetdownload

/**
 * Combines progress from multiple weighted phases (e.g. catalog fetch, manifest
 * fetch, file downloads, install) into a single 0...1 callback. Generic and
 * reusable by any future consumer of this framework — no Tajweed/AI knowledge.
 */
class AssetProgressNotifier(
    phaseWeights: List<Pair<String, Double>>,
    private val onProgress: (Double) -> Unit,
) {
    private data class Phase(val weight: Double, var fraction: Double = 0.0)

    private val phases: MutableMap<String, Phase> =
        phaseWeights.associateTo(LinkedHashMap()) { (name, weight) -> name to Phase(weight) }
    private val lock = Any()

    fun update(phaseName: String, fraction: Double) {
        val overall: Double
        synchronized(lock) {
            phases[phaseName]?.fraction = fraction.coerceIn(0.0, 1.0)
            val totalWeight = phases.values.sumOf { it.weight }
            val weighted = phases.values.sumOf { it.weight * it.fraction }
            overall = if (totalWeight > 0) weighted / totalWeight else 0.0
        }
        onProgress(overall)
    }
}
