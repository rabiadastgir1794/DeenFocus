import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firebase Crashlytics error reporting service.
///
/// Captures Flutter framework errors and uncaught async errors. Preserves
/// existing error handling (LoggerService) while sending crash reports to
/// Firebase for release builds.
///
/// Never sends sensitive data: no Quran content, credentials, or FCM tokens.
class FirebaseCrashlyticsService {
  FirebaseCrashlyticsService._();

  static final FirebaseCrashlyticsService instance =
      FirebaseCrashlyticsService._();

  FirebaseCrashlytics? _crashlytics;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  /// Initializes Crashlytics. Safe to call multiple times.
  /// Only enables crash collection in release/profile builds.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _crashlytics = FirebaseCrashlytics.instance;

      // Only enable crash collection in release/profile builds.
      await _crashlytics!.setCrashlyticsCollectionEnabled(!kDebugMode);

      _initialized = true;
      debugPrint('[Crashlytics] Initialized (collection=${!kDebugMode})');
    } catch (e, st) {
      debugPrint('[Crashlytics] Initialization failed: $e');
      debugPrintStack(stackTrace: st);
      // Never block app startup on crashlytics failure
    }
  }

  /// Records a non-fatal error. Safe to call before initialization.
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    if (!_initialized || _crashlytics == null) {
      debugPrint('[Crashlytics] Error skipped (not initialized): $exception');
      return;
    }

    try {
      await _crashlytics!.recordError(
        exception,
        stack,
        reason: reason,
        fatal: fatal,
      );
    } catch (e) {
      debugPrint('[Crashlytics] recordError failed: $e');
      // Never throw — crash reporting failures must not interrupt app
    }
  }

  /// Records a FlutterErrorDetails from the framework error handler.
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    if (!_initialized || _crashlytics == null) return;

    try {
      await _crashlytics!.recordFlutterError(details);
    } catch (e) {
      debugPrint('[Crashlytics] recordFlutterError failed: $e');
    }
  }

  /// Records a fatal error (crashes the app after reporting).
  Future<void> recordFatalError(
    dynamic exception,
    StackTrace stack, {
    dynamic reason,
  }) async {
    await recordError(exception, stack, reason: reason, fatal: true);
  }

  /// Sets a custom key-value pair for the current session.
  /// Useful for debugging context (e.g., current screen, feature flags).
  Future<void> setCustomKey(String key, Object value) async {
    if (!_initialized || _crashlytics == null) return;

    try {
      await _crashlytics!.setCustomKey(key, value);
    } catch (e) {
      debugPrint('[Crashlytics] setCustomKey failed: $e');
    }
  }

  /// Sets a user identifier (non-sensitive, e.g., anonymized ID).
  /// Never set email, name, or other PII.
  Future<void> setUserIdentifier(String identifier) async {
    if (!_initialized || _crashlytics == null) return;

    try {
      await _crashlytics!.setUserIdentifier(identifier);
    } catch (e) {
      debugPrint('[Crashlytics] setUserIdentifier failed: $e');
    }
  }

  /// Logs a message to the crash report (breadcrumb trail).
  Future<void> log(String message) async {
    if (!_initialized || _crashlytics == null) return;

    try {
      await _crashlytics!.log(message);
    } catch (e) {
      debugPrint('[Crashlytics] log failed: $e');
    }
  }
}
