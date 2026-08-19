import 'package:hive_flutter/hive_flutter.dart';

import '../model/tajweed_models.dart';

/// Local-only practice history (score summaries, never PCM).
/// Future optional sync for signed-in users may upload summaries only.
class TajweedHistoryStore {
  TajweedHistoryStore._();

  static const _boxName = 'tajweed_history';
  static const _defaultMaxEntries = 200;

  static Box<Map>? _box;

  static Future<Box<Map>> _ensureBox() async {
    final existing = _box;
    if (existing != null && existing.isOpen) return existing;
    final opened = await Hive.openBox<Map>(_boxName);
    _box = opened;
    return opened;
  }

  static Future<void> add(TajweedHistoryEntry entry) async {
    final box = await _ensureBox();
    await box.put(entry.id, entry.toJson());
    await _pruneIfNeeded(box);
  }

  static Future<List<TajweedHistoryEntry>> list({int? limit}) async {
    final box = await _ensureBox();
    final entries = box.values
        .map((raw) => TajweedHistoryEntry.fromJson(Map<String, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.practicedAt.compareTo(a.practicedAt));
    if (limit == null || limit >= entries.length) return entries;
    return entries.take(limit).toList();
  }

  static Future<void> clear() async {
    final box = await _ensureBox();
    await box.clear();
  }

  static Future<void> _pruneIfNeeded(
    Box<Map> box, {
    int maxEntries = _defaultMaxEntries,
  }) async {
    if (box.length <= maxEntries) return;
    final entries = box.values
        .map((raw) => TajweedHistoryEntry.fromJson(Map<String, dynamic>.from(raw)))
        .toList()
      ..sort((a, b) => b.practicedAt.compareTo(a.practicedAt));
    for (final stale in entries.skip(maxEntries)) {
      await box.delete(stale.id);
    }
  }
}
