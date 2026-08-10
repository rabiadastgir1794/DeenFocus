package com.rnr.deenfocus.qurantranslation

/** Same shared R2 `catalog.json` as Tajweed. Languages come from catalog entries. */
object TranslationAssetDistributionConfig {
    const val TRANSLATION_KIND = "translation_pack"
    const val CHECK_INTERVAL_HOURS = 24.0
    var catalogUrl: String? = "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json"
}
