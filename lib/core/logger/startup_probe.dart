import 'package:flutter/foundation.dart';

/// Measurement-only startup markers for the Flutter side of cold launch.
/// Does not change control flow.
abstract final class StartupProbe {
  static final Stopwatch _watch = Stopwatch();
  static final Map<String, int> _marks = <String, int>{};
  static final List<String> _order = <String>[];

  /// Nested detail lines under a parent investigation (Logger / Splash / etc.).
  static final List<String> _detailLog = <String>[];

  static void start() {
    if (!_watch.isRunning) {
      _watch.start();
      mark('0_Dart main() entered');
    }
  }

  static int get ms => _watch.elapsedMilliseconds;

  static void mark(String name) {
    final t = ms;
    _marks[name] = t;
    _order.add(name);
    debugPrint('[STARTUP] $name ${t}ms');
  }

  /// Like [mark] but only records the first time [name] is seen (rebuild-safe).
  static void markOnce(String name) {
    if (_marks.containsKey(name)) {
      detail('$name (repeat, skipped mark)');
      return;
    }
    mark(name);
  }

  static T timeSync<T>(String name, T Function() fn) {
    final t0 = _watch.elapsedMilliseconds;
    final result = fn();
    final elapsed = _watch.elapsedMilliseconds - t0;
    final line =
        '[STARTUP] $name +${elapsed}ms (abs ${_watch.elapsedMilliseconds}ms)';
    _detailLog.add(line);
    debugPrint(line);
    _marks['$name (delta)'] = elapsed;
    return result;
  }

  /// Time an async step (every `await` under investigation). Logs delta only.
  static Future<T> timeAsync<T>(String name, Future<T> Function() fn) async {
    final t0 = _watch.elapsedMilliseconds;
    final result = await fn();
    final elapsed = _watch.elapsedMilliseconds - t0;
    final line =
        '[STARTUP][detail] $name +${elapsed}ms (abs ${_watch.elapsedMilliseconds}ms)';
    _detailLog.add(line);
    debugPrint(line);
    return result;
  }

  static void detail(String message) {
    final line = '[STARTUP][detail] $message (abs ${ms}ms)';
    _detailLog.add(line);
    debugPrint(line);
  }

  /// Print a compact table once the first frame lands.
  static void dumpSummary() {
    final buf = StringBuffer()
      ..writeln('[STARTUP] ===== Flutter launch breakdown (ms from main) =====');
    var prev = 0;
    var maxGap = 0;
    var maxGapName = '';
    for (final name in _order) {
      final t = _marks[name] ?? 0;
      final gap = t - prev;
      if (gap > maxGap) {
        maxGap = gap;
        maxGapName = name;
      }
      buf.writeln(
        '[STARTUP]   ${t.toString().padLeft(6)}  (+${gap.toString().padLeft(5)})  $name',
      );
      prev = t;
    }
    final first = _marks['6_first Flutter frame'];
    final runApp = _marks['5_runApp'];
    if (first != null && runApp != null) {
      buf.writeln(
        '[STARTUP]   gap runApp → first frame: ${first - runApp}ms',
      );
    }
    if (maxGapName.isNotEmpty) {
      buf.writeln(
        '[STARTUP]   largest mark gap: +${maxGap}ms ending at "$maxGapName"',
      );
    }
    final deltas = _marks.entries
        .where((e) => e.key.endsWith('(delta)'))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (deltas.isNotEmpty) {
      buf.writeln('[STARTUP] ----- sync deltas (slowest first) -----');
      for (final e in deltas.take(15)) {
        buf.writeln(
          '[STARTUP]   ${e.value.toString().padLeft(6)}ms  ${e.key}',
        );
      }
    }
    if (_detailLog.isNotEmpty) {
      buf.writeln('[STARTUP] ----- awaited / nested details -----');
      for (final line in _detailLog) {
        buf.writeln(line);
      }
    }
    buf.writeln('[STARTUP] =====================================================');
    debugPrint(buf.toString());
  }
}
