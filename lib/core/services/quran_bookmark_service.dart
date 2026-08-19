import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'storage_service.dart';

enum QuranBookmarkKind { surah, ayah, page, juz }

class QuranBookmark {
  const QuranBookmark({
    required this.id,
    required this.kind,
    required this.label,
    required this.surah,
    this.ayah,
    this.page,
    this.juz,
    required this.createdAtMs,
  });

  final String id;
  final QuranBookmarkKind kind;
  final String label;
  final int surah;
  final int? ayah;
  final int? page;
  final int? juz;
  final int createdAtMs;

  Map<String, dynamic> toMap() => {
    'id': id,
    'kind': kind.name,
    'label': label,
    'surah': surah,
    if (ayah != null) 'ayah': ayah,
    if (page != null) 'page': page,
    if (juz != null) 'juz': juz,
    'createdAtMs': createdAtMs,
  };

  factory QuranBookmark.fromMap(Map<String, dynamic> map) {
    return QuranBookmark(
      id: map['id'] as String,
      kind: QuranBookmarkKind.values.firstWhere(
        (k) => k.name == map['kind'],
        orElse: () => QuranBookmarkKind.ayah,
      ),
      label: map['label'] as String,
      surah: (map['surah'] as num).toInt(),
      ayah: (map['ayah'] as num?)?.toInt(),
      page: (map['page'] as num?)?.toInt(),
      juz: (map['juz'] as num?)?.toInt(),
      createdAtMs: (map['createdAtMs'] as num).toInt(),
    );
  }
}

/// Lightweight bookmark store (SharedPreferences JSON). Supports surah, ayah,
/// page, and juz bookmarks without changing the Hive Quran repository.
abstract final class QuranBookmarkService {
  /// Bumped whenever bookmarks are added, removed, or cleared.
  static final ValueNotifier<int> revision = ValueNotifier<int>(0);

  static void _bumpRevision() {
    revision.value++;
  }

  static Future<List<QuranBookmark>> list() async {
    final raw = await StorageService.quranBookmarksJson;
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((e) => QuranBookmark.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  static Future<void> _save(List<QuranBookmark> items) async {
    final payload = jsonEncode(items.map((b) => b.toMap()).toList());
    await StorageService.setQuranBookmarksJson(payload);
  }

  static Future<void> add(QuranBookmark bookmark) async {
    final items = await list();
    if (items.any((b) => b.id == bookmark.id)) return;
    await _save([bookmark, ...items]);
    _bumpRevision();
  }

  static Future<void> remove(String id) async {
    final items = await list();
    final next = items.where((b) => b.id != id).toList(growable: false);
    if (next.length == items.length) return;
    await _save(next);
    _bumpRevision();
  }

  static Future<void> clearAll() async {
    await _save(const []);
    _bumpRevision();
  }

  static Future<bool> contains({
    required QuranBookmarkKind kind,
    required int surah,
    int? ayah,
    int? page,
    int? juz,
  }) async {
    final items = await list();
    return items.any((b) {
      if (b.kind != kind || b.surah != surah) return false;
      return switch (kind) {
        QuranBookmarkKind.surah => true,
        QuranBookmarkKind.ayah => b.ayah == ayah,
        QuranBookmarkKind.page => b.page == page,
        QuranBookmarkKind.juz => b.juz == juz,
      };
    });
  }

  static String idFor({
    required QuranBookmarkKind kind,
    required int surah,
    int? ayah,
    int? page,
    int? juz,
  }) {
    return switch (kind) {
      QuranBookmarkKind.surah => 'surah:$surah',
      QuranBookmarkKind.ayah => 'ayah:$surah:$ayah',
      QuranBookmarkKind.page => 'page:$page',
      QuranBookmarkKind.juz => 'juz:$juz',
    };
  }
}
