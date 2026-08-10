import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../core/services/storage_service.dart';
import '../model/library_section_progress.dart';

class LibraryProgressService {
  LibraryProgressService._();

  static final LibraryProgressService instance = LibraryProgressService._();

  /// Bumped when bookmarks are added or removed.
  static final ValueNotifier<int> bookmarkRevision = ValueNotifier<int>(0);

  static void _bumpBookmarkRevision() {
    bookmarkRevision.value++;
  }

  Future<Map<String, LibrarySectionProgress>> loadAllProgress() => _loadAll();

  Future<Map<String, LibrarySectionProgress>> _loadAll() async {
    final raw = await StorageService.libraryProgressJson;
    if (raw == null || raw.isEmpty) return <String, LibrarySectionProgress>{};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(
          key,
          LibrarySectionProgress.fromJson(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return <String, LibrarySectionProgress>{};
    }
  }

  Future<void> _saveAll(Map<String, LibrarySectionProgress> all) async {
    final encoded = jsonEncode(
      all.map((key, value) => MapEntry(key, value.toJson())),
    );
    await StorageService.setLibraryProgressJson(encoded);
  }

  Future<LibrarySectionProgress> getProgress(String sectionId) async {
    final all = await _loadAll();
    return all[sectionId] ?? const LibrarySectionProgress();
  }

  Future<void> setLastIndex(String sectionId, int index) async {
    final all = await _loadAll();
    final current = all[sectionId] ?? const LibrarySectionProgress();
    all[sectionId] = current.copyWith(lastIndex: index);
    await _saveAll(all);
  }

  Future<void> setCompleted(String sectionId, bool completed) async {
    final all = await _loadAll();
    final current = all[sectionId] ?? const LibrarySectionProgress();
    all[sectionId] = current.copyWith(completed: completed);
    await _saveAll(all);
  }

  Future<bool> toggleBookmark(String sectionId, int cardIndex) async {
    final all = await _loadAll();
    final current = all[sectionId] ?? const LibrarySectionProgress();
    final bookmarks = Set<int>.from(current.bookmarks);
    final added = bookmarks.add(cardIndex);
    if (!added) bookmarks.remove(cardIndex);
    all[sectionId] = current.copyWith(bookmarks: bookmarks);
    await _saveAll(all);
    _bumpBookmarkRevision();
    return bookmarks.contains(cardIndex);
  }

  Future<void> removeBookmark(String sectionId, int cardIndex) async {
    final all = await _loadAll();
    final current = all[sectionId];
    if (current == null || !current.bookmarks.contains(cardIndex)) return;
    final bookmarks = Set<int>.from(current.bookmarks)..remove(cardIndex);
    all[sectionId] = current.copyWith(bookmarks: bookmarks);
    await _saveAll(all);
    _bumpBookmarkRevision();
  }

  Future<bool> isBookmarked(String sectionId, int cardIndex) async {
    final progress = await getProgress(sectionId);
    return progress.bookmarks.contains(cardIndex);
  }
}
