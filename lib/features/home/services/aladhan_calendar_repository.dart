import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/logger/trace_helpers.dart';
import '../../../core/services/storage_service.dart';

/// Shared Aladhan `gToHCalendar` month payloads — one fetch serves Hijri grid + events.
class AladhanCalendarRepository {
  AladhanCalendarRepository._();

  static final Map<String, List<Map<String, dynamic>>> _memory =
      <String, List<Map<String, dynamic>>>{};
  static final Map<String, Future<List<Map<String, dynamic>>>> _inFlight =
      <String, Future<List<Map<String, dynamic>>>>{};

  static String _key(int year, int month) => '${year}_$month';

  static String _diskKey(int year, int month) => 'aladhan_gtoh_${year}_$month';

  /// Cached or in-flight month data; empty list on hard failure.
  static Future<List<Map<String, dynamic>>> monthDays({
    required int year,
    required int month,
    bool forceRefresh = false,
  }) async {
    final key = _key(year, month);
    if (!forceRefresh && _memory.containsKey(key)) {
      return _memory[key]!;
    }

    if (!forceRefresh) {
      final disk = await _loadDisk(year, month);
      if (disk != null && disk.isNotEmpty) {
        _memory[key] = disk;
        return disk;
      }
    }

    final existing = _inFlight[key];
    if (existing != null) return existing;

    final future = _fetchNetwork(year, month);
    _inFlight[key] = future;
    try {
      final result = await future;
      _memory[key] = result;
      return result;
    } finally {
      _inFlight.remove(key);
    }
  }

  static Future<List<Map<String, dynamic>>> _fetchNetwork(
    int year,
    int month,
  ) async {
    try {
      final uri = Uri.parse(
        'https://api.aladhan.com/v1/gToHCalendar/$month/$year',
      );
      final response = await TraceHelpers.traceApi(
        'GET aladhan.com/v1/gToHCalendar/$month/$year',
        () => http.get(uri).timeout(const Duration(seconds: 15)),
      );
      if (response.statusCode != 200) {
        TraceHelpers.traceNetworkFailure(
          'AladhanCalendarRepository.monthDays',
          'HTTP ${response.statusCode}',
        );
        return _memory[_key(year, month)] ?? const <Map<String, dynamic>>[];
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (decoded['data'] as List<dynamic>?) ?? const <dynamic>[];
      final rows = data
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList(growable: false);

      await StorageService.setString(_diskKey(year, month), jsonEncode(rows));
      return rows;
    } catch (e, st) {
      TraceHelpers.traceNetworkFailure(
        'AladhanCalendarRepository.monthDays',
        e,
        stackTrace: st,
      );
      final disk = await _loadDisk(year, month);
      return disk ?? const <Map<String, dynamic>>[];
    }
  }

  static Future<List<Map<String, dynamic>>?> _loadDisk(int year, int month) async {
    final raw = await StorageService.getString(_diskKey(year, month));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .map((row) => Map<String, dynamic>.from(row as Map))
          .toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  static void clearMemory() => _memory.clear();
}
