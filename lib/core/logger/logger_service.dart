import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

import 'log_level.dart';

/// Central file logger: one append-only log. On Android this uses [getDownloadsDirectory],
/// which is **app-scoped** (`Android/data/<package>/files/.../Deen Focus/logs/stack_logs.txt`),
/// not the public Downloads folder — native `FocusDebugLogger` + [FocusEnforcementService.appendDebugLog]
/// mirror lines there (including ANR) for testers.
///
/// **Why file logging on device:** low-end OEMs often strip or delay crash
/// reports; a local file survives many process deaths and can be pulled via
/// file managers for support. **Why a single file:** avoids scattering state
/// across hourly shards that users cannot find or that fill storage silently.
///
/// **Production safety:** writes never throw to callers; failures degrade to
/// a one-time [debugPrint]. A re-entrancy guard avoids infinite loops if logging
/// itself throws. All I/O runs in `async`/`await` chains so the UI isolate is
/// not blocked by `dart:io` buffering (flush still schedules work; we never
/// call heavy synchronous disk APIs on the UI thread beyond short `open`).
///
/// **Startup:** [initialize] is fire-and-forget. Launch must never await file
/// create / trim / flush — first [log] also opens the sink lazily.
class LoggerService {
  LoggerService._();

  static final LoggerService instance = LoggerService._();

  /// Exact folder name required by product/support.
  static const String kLogRootFolderName = 'Deen Focus';

  static const String kLogSubFolder = 'logs';
  static const String kLogFileName = 'stack_logs.txt';

  /// When the log grows too large on cheap devices, trim the **start** of the
  /// file and keep a tail so storage does not grow without bound.
  static const int _maxLogBytes = 10 * 1024 * 1024;
  static const int _trimKeepBytes = 6 * 1024 * 1024;

  static final DateFormat _timestampFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  final Lock _fileLock = Lock();

  IOSink? _sink;
  File? _logFile;
  bool _initialized = false;
  bool _initScheduled = false;
  bool _writeFailureLogged = false;
  bool _recursiveLogGuard = false;
  int _writesSinceTrim = 0;

  /// Best-effort route or screen label for every line (navigation observer updates this).
  String? currentScreen;

  /// Kick off background file open. Safe to call multiple times; never blocks
  /// the caller — do not `await` this from `main` / first-frame paths.
  Future<void> initialize() async {
    if (_initialized || _initScheduled) return;
    _initScheduled = true;
    try {
      await _fileLock.synchronized(() async {
        if (_initialized) return;
        try {
          await _ensureOpenUnlocked();
          _initialized = true;
          _recursiveLogGuard = true;
          try {
            _sink!.writeln(
              _formatLine(
                LogLevel.info,
                'LOGGER',
                'LoggerService initialized path=${_logFile?.path ?? '(none)'}',
              ),
            );
            // Do not flush/trim here — both are deferred to later writes so
            // cold start never pays disk sync cost on the launch path.
          } finally {
            _recursiveLogGuard = false;
          }
        } catch (e) {
          _noteWriteFailure(e);
        }
      });
    } catch (e) {
      _noteWriteFailure(e);
    }
  }

  Future<void> dispose() async {
    await _fileLock.synchronized(() async {
      try {
        await _sink?.flush();
        await _sink?.close();
      } catch (_) {}
      _sink = null;
      _initialized = false;
      _initScheduled = false;
    });
  }

  // --- Public level helpers (async fire-and-forget by default) ---

  void debug(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    unawaited(log(LogLevel.debug, tag, message, error: error, stackTrace: stackTrace));
  }

  void info(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    unawaited(log(LogLevel.info, tag, message, error: error, stackTrace: stackTrace));
  }

  void warning(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    unawaited(log(LogLevel.warning, tag, message, error: error, stackTrace: stackTrace));
  }

  void error(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    unawaited(log(LogLevel.error, tag, message, error: error, stackTrace: stackTrace));
  }

  void critical(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    unawaited(log(LogLevel.critical, tag, message, error: error, stackTrace: stackTrace));
  }

  /// Awaitable when you must guarantee ordering before exit (rare).
  Future<void> log(
    LogLevel level,
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) async {
    if (_recursiveLogGuard) return;

    final buffer = StringBuffer(_formatLine(level, tag, _singleLine(message)));
    if (error != null) {
      buffer.write(' | error: ${_singleLine(error.toString())}');
    }
    if (stackTrace != null) {
      buffer.write(' | stack:\n');
      buffer.write(_trimStackTrace(stackTrace));
    }

    await _appendLine(buffer.toString());
  }

  /// [FlutterErrorDetails] from [FlutterError.onError] — captures layout/render failures.
  Future<void> logFlutterFrameworkError(FlutterErrorDetails details) async {
    if (_recursiveLogGuard) return;
    final buffer = StringBuffer(
      _formatLine(
        LogLevel.error,
        'FLUTTER',
        _singleLine(details.exceptionAsString()),
      ),
    );
    if (details.stack != null) {
      buffer.write(' | stack:\n');
      buffer.write(_trimStackTrace(details.stack!));
    }
    await _appendLine(buffer.toString());
  }

  Future<void> _ensureOpenUnlocked() async {
    if (_sink != null) return;
    _logFile = await _resolveLogFile();
    final dir = _logFile!.parent;
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _sink = _logFile!.openWrite(mode: FileMode.append);
  }

  Future<void> _appendLine(String line) async {
    await _fileLock.synchronized(() async {
      if (_recursiveLogGuard) return;
      try {
        if (_sink == null) {
          await _ensureOpenUnlocked();
          _initialized = true;
          _initScheduled = true;
        }
        if (_sink == null) return;
        _recursiveLogGuard = true;
        try {
          _sink!.writeln(line);
          await _sink!.flush();
        } finally {
          _recursiveLogGuard = false;
        }
        _writesSinceTrim++;
        if (_writesSinceTrim >= 80) {
          _writesSinceTrim = 0;
          await _maybeTrimFileUnlocked();
        }
      } catch (e) {
        _noteWriteFailure(e);
      }
    });
  }

  void _noteWriteFailure(Object e) {
    if (_writeFailureLogged) return;
    _writeFailureLogged = true;
    debugPrint('LoggerService: persistent logging disabled: $e');
  }

  String _formatLine(LogLevel level, String tag, String message) {
    final ts = _timestampFormat.format(DateTime.now());
    final isolateLabel = _isolateLabel();
    final screen = currentScreen ?? '-';
    final safeTag = _singleLine(tag);
    return '[$ts][${level.label}][$safeTag][$isolateLabel][$screen] $message';
  }

  String _isolateLabel() {
    final name = Isolate.current.debugName;
    if (name != null && name.isNotEmpty) return name;
    return 'main';
  }

  String _singleLine(String input) {
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _trimStackTrace(StackTrace st, {int maxLines = 40}) {
    final lines = st.toString().split('\n');
    final take = lines.length > maxLines ? lines.sublist(0, maxLines) : lines;
    return take.map(_singleLine).join('\n');
  }

  Future<File> _resolveLogFile() async {
    if (Platform.isAndroid) {
      try {
        final downloads = await getDownloadsDirectory();
        if (downloads != null) {
          final dir = Directory('${downloads.path}/$kLogRootFolderName/$kLogSubFolder');
          return File('${dir.path}/$kLogFileName');
        }
      } catch (_) {}
      final fallback = await getApplicationDocumentsDirectory();
      final dir = Directory('${fallback.path}/$kLogRootFolderName/$kLogSubFolder');
      return File('${dir.path}/$kLogFileName');
    }

    final support = await getApplicationSupportDirectory();
    final dir = Directory('${support.path}/$kLogRootFolderName/$kLogSubFolder');
    return File('${dir.path}/$kLogFileName');
  }

  Future<void> _maybeTrimFileUnlocked() async {
    final file = _logFile;
    if (file == null) return;
    if (!await file.exists()) return;
    try {
      final len = await file.length();
      if (len <= _maxLogBytes) return;

      await _sink?.flush();
      await _sink?.close();
      _sink = null;

      var readFrom = len > _trimKeepBytes ? len - _trimKeepBytes : 0;
      final raf = await file.open(mode: FileMode.read);
      try {
        await raf.setPosition(readFrom);
        final tail = await raf.read(len - readFrom);

        // Align to the next full line so we do not split UTF-8 code units badly
        // when cutting mid-file (common when logs are multi-line stacks).
        var start = 0;
        if (readFrom > 0) {
          final nl = tail.indexOf(0x0A);
          if (nl >= 0 && nl + 1 < tail.length) {
            start = nl + 1;
          }
        }
        final kept = tail.sublist(start);

        final trimmedSink = file.openWrite(mode: FileMode.writeOnly);
        trimmedSink.writeln(
          _formatLine(
            LogLevel.warning,
            'LOGGER',
            'Log file trimmed: previousBytes=$len keptBytes=${kept.length}',
          ),
        );
        trimmedSink.add(kept);
        await trimmedSink.flush();
        await trimmedSink.close();
      } finally {
        await raf.close();
      }

      _sink = file.openWrite(mode: FileMode.append);
    } catch (e) {
      _noteWriteFailure(e);
      try {
        _sink = _logFile?.openWrite(mode: FileMode.append);
      } catch (_) {}
    }
  }
}
