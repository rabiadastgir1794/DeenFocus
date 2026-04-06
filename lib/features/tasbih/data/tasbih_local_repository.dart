import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/services/storage_service.dart';

/// Serializes async updates per [tasbihId] so rapid taps don't lose counts.
class _AsyncMutex {
  Future<void> _lock = Future<void>.value();

  Future<T> run<T>(Future<T> Function() action) async {
    final previous = _lock;
    final completer = Completer<void>();
    _lock = completer.future;
    await previous;
    try {
      return await action();
    } finally {
      completer.complete();
    }
  }
}

class TasbihItem {
  const TasbihItem({
    required this.id,
    required this.label,
    required this.transliteration,
    required this.meaning,
    required this.isCustom,
    required this.isPinned,
    required this.order,
    required this.totalCount,
  });

  final String id;
  final String label;
  final String transliteration;
  final String meaning;
  final bool isCustom;
  final bool isPinned;
  final int order;
  final int totalCount;

  factory TasbihItem.fromMap(Map<dynamic, dynamic> map) {
    return TasbihItem(
      id: map['id'] as String,
      label: map['label'] as String,
      transliteration: map['transliteration'] as String,
      meaning: map['meaning'] as String,
      isCustom: map['isCustom'] as bool,
      isPinned: (map['isPinned'] as bool?) ?? false,
      order: (map['order'] as num).toInt(),
      totalCount: (map['totalCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'transliteration': transliteration,
      'meaning': meaning,
      'isCustom': isCustom,
      'isPinned': isPinned,
      'order': order,
      'totalCount': totalCount,
    };
  }

  TasbihItem copyWith({
    String? label,
    String? transliteration,
    String? meaning,
    bool? isPinned,
    int? order,
    int? totalCount,
  }) {
    return TasbihItem(
      id: id,
      label: label ?? this.label,
      transliteration: transliteration ?? this.transliteration,
      meaning: meaning ?? this.meaning,
      isCustom: isCustom,
      isPinned: isPinned ?? this.isPinned,
      order: order ?? this.order,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class TasbihSession {
  const TasbihSession({
    required this.id,
    required this.tasbihId,
    required this.count,
    required this.createdAtIso,
  });

  final String id;
  final String tasbihId;
  final int count;
  final String createdAtIso;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tasbihId': tasbihId,
      'count': count,
      'createdAtIso': createdAtIso,
    };
  }
}

class TasbihLocalRepository {
  TasbihLocalRepository._();

  static final TasbihLocalRepository instance = TasbihLocalRepository._();

  static const String _itemsBoxName = 'tasbih_items';
  static const String _sessionsBoxName = 'tasbih_sessions';
  static const int _seedVersion = 2;

  bool _initialized = false;
  late final Box<Map> _itemsBox;
  late final Box<Map> _sessionsBox;
  Future<void>? _opening;
  final Map<String, _AsyncMutex> _tapMutexById = <String, _AsyncMutex>{};

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    _opening ??= _openBoxesAndSeed();
    try {
      await _opening!;
    } finally {
      _opening = null;
    }
  }

  Future<void> _openBoxesAndSeed() async {
    _itemsBox = await Hive.openBox<Map>(_itemsBoxName);
    _sessionsBox = await Hive.openBox<Map>(_sessionsBoxName);

    final seedVersion = await StorageService.tasbihSeedVersion;
    final needsSeed = _itemsBox.isEmpty || seedVersion < _seedVersion;
    if (needsSeed) {
      await _seedDefaults();
      await StorageService.setTasbihSeedVersion(_seedVersion);
    }

    await _reconcileTotalsFromSessions();

    _initialized = true;
  }

  Future<List<TasbihItem>> getItems() async {
    await ensureInitialized();
    final items =
        _itemsBox.values.map(TasbihItem.fromMap).toList(growable: false)
          ..sort((a, b) {
            if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
            return a.order.compareTo(b.order);
          });
    return items;
  }

  Future<void> addCustomItem({
    required String label,
    String transliteration = '',
    String meaning = '',
  }) async {
    await ensureInitialized();
    final items = await getItems();
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final item = TasbihItem(
      id: id,
      label: label,
      transliteration: transliteration,
      meaning: meaning,
      isCustom: true,
      isPinned: false,
      order: items.length,
      totalCount: 0,
    );
    await _itemsBox.put(id, item.toMap());
  }

  Future<void> updateCustomItem({
    required String id,
    required String label,
    required String transliteration,
    required String meaning,
  }) async {
    await ensureInitialized();
    final raw = _itemsBox.get(id);
    if (raw == null) return;
    final current = TasbihItem.fromMap(raw);
    if (!current.isCustom) return;
    final updated = current.copyWith(
      label: label,
      transliteration: transliteration,
      meaning: meaning,
    );
    await _itemsBox.put(id, updated.toMap());
  }

  Future<void> deleteCustomItem(String id) async {
    await ensureInitialized();
    final raw = _itemsBox.get(id);
    if (raw == null) return;
    if (!(raw['isCustom'] as bool)) return;
    await _itemsBox.delete(id);
    await _deleteSessionsForTasbih(id);
    await _reindexOrders();
  }

  Future<void> reorderItems(List<TasbihItem> reordered) async {
    await ensureInitialized();
    for (var i = 0; i < reordered.length; i++) {
      final item = reordered[i].copyWith(order: i);
      await _itemsBox.put(item.id, item.toMap());
    }
  }

  Future<void> togglePin(String id) async {
    await ensureInitialized();
    final raw = _itemsBox.get(id);
    if (raw == null) return;
    final item = TasbihItem.fromMap(raw);
    await _itemsBox.put(id, item.copyWith(isPinned: !item.isPinned).toMap());
  }

  /// Persists one tap to this dhikr's running total (call from the counter UI).
  Future<int> incrementTap(String tasbihId) async {
    await ensureInitialized();
    final mutex = _tapMutexById.putIfAbsent(tasbihId, _AsyncMutex.new);
    return mutex.run(() async {
      final raw = _itemsBox.get(tasbihId);
      if (raw == null) return 0;
      final current = TasbihItem.fromMap(raw);
      final next = current.totalCount + 1;
      await _itemsBox.put(
        tasbihId,
        current.copyWith(totalCount: next).toMap(),
      );
      await _itemsBox.flush();
      return next;
    });
  }

  /// Records a completed session batch for history (does not change totals;
  /// totals are updated per tap via [incrementTap]).
  Future<void> recordSessionBatch({
    required String tasbihId,
    required int sessionCount,
  }) async {
    await ensureInitialized();
    if (sessionCount <= 0) return;
    final session = TasbihSession(
      id: '${tasbihId}_${DateTime.now().millisecondsSinceEpoch}',
      tasbihId: tasbihId,
      count: sessionCount,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
    );
    await _sessionsBox.put(session.id, session.toMap());
    await _sessionsBox.flush();
  }

  Future<void> resetTotal(String tasbihId) async {
    await ensureInitialized();
    final raw = _itemsBox.get(tasbihId);
    if (raw == null) return;
    final item = TasbihItem.fromMap(raw);
    await _itemsBox.put(tasbihId, item.copyWith(totalCount: 0).toMap());
    await _itemsBox.flush();
    await _deleteSessionsForTasbih(tasbihId);
  }

  Future<void> _reindexOrders() async {
    final items = await getItems();
    for (var i = 0; i < items.length; i++) {
      final item = items[i].copyWith(order: i);
      await _itemsBox.put(item.id, item.toMap());
    }
  }

  Future<void> _seedDefaults() async {
    final existingTotals = <String, int>{};
    final existingCustom = <TasbihItem>[];
    for (final raw in _itemsBox.values) {
      final item = TasbihItem.fromMap(raw);
      existingTotals[item.id] = item.totalCount;
      if (item.isCustom) existingCustom.add(item);
    }

    await _itemsBox.clear();
    var order = 0;
    for (final item in _defaultTasbihs) {
      final preserved = existingTotals[item.id] ?? 0;
      await _itemsBox.put(
        item.id,
        item.copyWith(order: order++, totalCount: preserved).toMap(),
      );
    }

    for (final custom in existingCustom) {
      await _itemsBox.put(
        custom.id,
        custom.copyWith(order: order++, totalCount: custom.totalCount).toMap(),
      );
    }
  }

  /// Restores each item's [TasbihItem.totalCount] from saved sessions when
  /// they drift (e.g. preset totals cleared on re-seed while session log remained).
  ///
  /// Only **increases** counts from the session log. Never overwrites a stored
  /// total with 0 when there are no sessions (sessions are optional history).
  Future<void> _reconcileTotalsFromSessions() async {
    final sumByTasbih = <String, int>{};
    for (final raw in _sessionsBox.values) {
      final id = raw['tasbihId'] as String;
      final c = (raw['count'] as num).toInt();
      sumByTasbih[id] = (sumByTasbih[id] ?? 0) + c;
    }
    for (final key in _itemsBox.keys) {
      final id = key as String;
      final raw = _itemsBox.get(id);
      if (raw == null) continue;
      final item = TasbihItem.fromMap(raw);
      final fromSessions = sumByTasbih[id] ?? 0;
      if (fromSessions > item.totalCount) {
        await _itemsBox.put(
          id,
          item.copyWith(totalCount: fromSessions).toMap(),
        );
      }
    }
  }

  Future<void> _deleteSessionsForTasbih(String tasbihId) async {
    final toDelete = <dynamic>[];
    for (final key in _sessionsBox.keys) {
      final m = _sessionsBox.get(key);
      if (m == null) continue;
      if (m['tasbihId'] == tasbihId) toDelete.add(key);
    }
    for (final k in toDelete) {
      await _sessionsBox.delete(k);
    }
  }
}

const List<TasbihItem> _defaultTasbihs = <TasbihItem>[
  TasbihItem(
    id: 'subhanallah',
    label: 'سبحان الله',
    transliteration: 'SubhanAllah',
    meaning: 'Glory be to Allah',
    isCustom: false,
    isPinned: false,
    order: 0,
    totalCount: 0,
  ),
  TasbihItem(
    id: 'alhamdulillah',
    label: 'الحمد لله',
    transliteration: 'Alhamdulillah',
    meaning: 'Praise be to Allah',
    isCustom: false,
    isPinned: false,
    order: 1,
    totalCount: 0,
  ),
  TasbihItem(
    id: 'allahu_akbar',
    label: 'الله أكبر',
    transliteration: 'Allahu Akbar',
    meaning: 'Allah is the Greatest',
    isCustom: false,
    isPinned: false,
    order: 2,
    totalCount: 0,
  ),
  TasbihItem(
    id: 'la_ilaha_illallah',
    label: 'لا إله إلا الله',
    transliteration: 'La ilaha illallah',
    meaning: 'There is no god but Allah',
    isCustom: false,
    isPinned: false,
    order: 3,
    totalCount: 0,
  ),
  TasbihItem(
    id: 'astaghfirullah',
    label: 'أستغفر الله',
    transliteration: 'Astaghfirullah',
    meaning: 'I seek forgiveness from Allah',
    isCustom: false,
    isPinned: false,
    order: 4,
    totalCount: 0,
  ),
  TasbihItem(
    id: 'la_hawla',
    label: 'لا حول ولا قوة إلا بالله',
    transliteration: 'La hawla wa la quwwata illa billah',
    meaning: 'There is no power except with Allah',
    isCustom: false,
    isPinned: false,
    order: 5,
    totalCount: 0,
  ),
  TasbihItem(
    id: 'subhanallahi_wa_bihamdihi',
    label: 'سبحان الله وبحمده',
    transliteration: 'SubhanAllahi wa bihamdihi',
    meaning: 'Glory and praise be to Allah',
    isCustom: false,
    isPinned: false,
    order: 6,
    totalCount: 0,
  ),
  TasbihItem(
    id: 'hasbunallahu',
    label: 'حسبنا الله ونعم الوكيل',
    transliteration: "Hasbunallahu wa ni'mal wakeel",
    meaning: 'Allah is sufficient for us',
    isCustom: false,
    isPinned: false,
    order: 7,
    totalCount: 0,
  ),
];
