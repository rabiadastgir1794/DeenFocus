import 'dart:async';

import 'package:flutter/widgets.dart';

import 'logger_service.dart';

/// Reusable tracing helpers — keep call sites tiny so teams actually use them.
///
/// **Why:** sporadic `print` debugging is lost on release builds; structured tags
/// (`API`, `DB`, `SCREEN`) make logs grep-friendly when users send `stack_logs.txt`
/// from a file manager on Android 10+.
abstract final class TraceHelpers {
  /// Async work: I/O, awaits, long computations off the UI thread.
  static Future<T> traceAsync<T>(
    String tag,
    String label,
    Future<T> Function() run, {
    bool logSuccess = false,
  }) async {
    final sw = Stopwatch()..start();
    try {
      final result = await run();
      sw.stop();
      if (logSuccess) {
        LoggerService.instance.debug(tag, '$label ok ${sw.elapsedMilliseconds}ms');
      }
      return result;
    } catch (e, st) {
      sw.stop();
      LoggerService.instance.error(
        tag,
        '$label failed after ${sw.elapsedMilliseconds}ms',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Synchronous CPU work — keep **short**; logging itself is async and safe.
  static T traceSync<T>(
    String tag,
    String label,
    T Function() run, {
    bool logSuccess = false,
  }) {
    final sw = Stopwatch()..start();
    try {
      final result = run();
      sw.stop();
      if (logSuccess) {
        LoggerService.instance.debug(tag, '$label ok ${sw.elapsedMilliseconds}ms');
      }
      return result;
    } catch (e, st) {
      sw.stop();
      LoggerService.instance.error(
        tag,
        '$label failed after ${sw.elapsedMilliseconds}ms',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Screen-level navigation / flow timing (pair with GoRouter names).
  static Future<T> traceScreen<T>(
    String screenName,
    Future<T> Function() run,
  ) async {
    final previous = LoggerService.instance.currentScreen;
    LoggerService.instance.currentScreen = screenName;
    final sw = Stopwatch()..start();
    try {
      final r = await run();
      sw.stop();
      LoggerService.instance.info(
        'SCREEN',
        '$screenName completed in ${sw.elapsedMilliseconds}ms',
      );
      return r;
    } catch (e, st) {
      sw.stop();
      LoggerService.instance.error(
        'SCREEN',
        '$screenName failed after ${sw.elapsedMilliseconds}ms',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      LoggerService.instance.currentScreen = previous;
    }
  }

  /// HTTP / RPC — pass method + sanitized path (no secrets).
  static Future<T> traceApi<T>(
    String label,
    Future<T> Function() run, {
    bool logSuccess = false,
  }) {
    return traceAsync('API', label, run, logSuccess: logSuccess);
  }

  /// Local DB (Hive/SQLite/etc.).
  static Future<T> traceDatabase<T>(
    String label,
    Future<T> Function() run, {
    bool logSuccess = false,
  }) {
    return traceAsync('DB', label, run, logSuccess: logSuccess);
  }

  /// Network failure helper when you already caught the error (non-throwing paths).
  static void traceNetworkFailure(
    String label,
    Object error, {
    StackTrace? stackTrace,
  }) {
    LoggerService.instance.warning(
      'NETWORK',
      label,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// [ImageProvider] resolution (decode + GPU upload) — expensive on Mali GPUs.
  static Future<void> traceImageLoad(
    String label,
    BuildContext context,
    ImageProvider provider,
  ) {
    return traceAsync(
      'IMAGE',
      label,
      () async {
        final config = createLocalImageConfiguration(context);
        final completer = Completer<void>();
        final stream = provider.resolve(config);
        late ImageStreamListener listener;
        listener = ImageStreamListener(
          (ImageInfo image, bool sync) {
            stream.removeListener(listener);
            if (!completer.isCompleted) completer.complete();
          },
          onError: (Object error, StackTrace? st) {
            stream.removeListener(listener);
            if (!completer.isCompleted) completer.completeError(error, st);
          },
        );
        stream.addListener(listener);
        return completer.future;
      },
    );
  }
}
