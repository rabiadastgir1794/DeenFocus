const _preservedLibraryKeys = {
  'arabic',
  'transliteration',
  'id',
  'index',
  'itemCount',
  'version',
  'titleKey',
};

/// Overlays localized strings onto the English library JSON.
/// Arabic text and Latin transliteration stay on the English source.
Map<String, dynamic> mergeLibraryLocale(
  Map<String, dynamic> base,
  Map<String, dynamic> overlay,
) {
  final merged = _merge(base, overlay);
  if (merged is Map<String, dynamic>) return merged;
  return base;
}

Object? _merge(Object? base, Object? overlay) {
  if (overlay == null) return base;
  if (base is Map && overlay is Map) {
    final out = Map<String, dynamic>.from(base);
    overlay.forEach((key, value) {
      if (key is! String || _preservedLibraryKeys.contains(key)) return;
      if (!out.containsKey(key)) return;
      final merged = _merge(out[key], value);
      if (merged != null) out[key] = merged;
    });
    return out;
  }
  if (base is List && overlay is List) {
    final out = List<dynamic>.from(base);
    final count = out.length < overlay.length ? out.length : overlay.length;
    for (var i = 0; i < count; i++) {
      final merged = _merge(out[i], overlay[i]);
      if (merged != null) out[i] = merged;
    }
    return out;
  }
  if (base is String && overlay is String) {
    if (overlay.trim().isEmpty) return base;
    return overlay;
  }
  return base;
}
