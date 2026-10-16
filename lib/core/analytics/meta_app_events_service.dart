import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';

/// Flutter facade for the official Meta/Facebook App Events SDK (Android + iOS).
///
/// Route all Meta tracking through this service. Purchase / Subscribe /
/// StartTrial must only be called after Superwall confirms success.
class MetaAppEventsService {
  MetaAppEventsService._();

  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/meta_app_events',
  );

  static const int _maxDedupeEntries = 200;
  static final LinkedHashSet<String> _sentEventIds = LinkedHashSet<String>();

  static Future<bool>? _initializeFuture;
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  /// Initializes the native Meta SDK when credentials are present.
  /// Safe to call multiple times; never throws.
  static Future<bool> initialize() {
    return _initializeFuture ??= _initializeInternal();
  }

  static Future<bool> _initializeInternal() async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;

    final appId = AppConfig.metaAppId.trim();
    final clientToken = AppConfig.metaClientToken.trim();
    final displayName = AppConfig.metaDisplayName.trim().isEmpty
        ? 'Deen Focus'
        : AppConfig.metaDisplayName.trim();

    if (appId.isEmpty || clientToken.isEmpty) {
      debugPrint(
        '[Meta] Skipping init; provide META_APP_ID and META_CLIENT_TOKEN '
        'via --dart-define / dart_defines.json (and matching native config)',
      );
      return false;
    }

    try {
      final result = await _channel.invokeMethod<dynamic>('initialize', {
        'appId': appId,
        'clientToken': clientToken,
        'displayName': displayName,
        'debug': kDebugMode,
      });
      final ok = result is Map && result['ok'] == true;
      _initialized = ok || (result is Map && result['initialized'] == true);
      debugPrint('[Meta] initialize ok=$_initialized');
      return _initialized;
    } catch (e, st) {
      debugPrint('[Meta] initialize failed safely: $e');
      debugPrintStack(stackTrace: st);
      return false;
    }
  }

  /// Activates the app / records a launch signal (in addition to auto logging).
  static Future<void> trackAppLaunch() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    try {
      await initialize();
      await _channel.invokeMethod<dynamic>('trackAppLaunch');
    } catch (e, st) {
      debugPrint('[Meta] trackAppLaunch failed safely: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  /// Standard event: Purchase (`fb_mobile_purchase` / logPurchase).
  static Future<void> trackPurchase({
    required String eventId,
    required double value,
    required String currency,
    String? contentId,
    String contentType = 'product',
  }) {
    return _trackDeduped(
      eventName: 'Purchase',
      eventId: eventId,
      invoke: () => _channel.invokeMethod<dynamic>('trackPurchase', {
        'eventId': eventId,
        'value': value,
        'currency': currency,
        if (contentId != null && contentId.isNotEmpty) 'contentId': contentId,
        'contentType': contentType,
      }),
    );
  }

  /// Standard event: Subscribe.
  static Future<void> trackSubscribe({
    required String eventId,
    String? contentId,
    String? currency,
    double? value,
  }) {
    return _trackDeduped(
      eventName: 'Subscribe',
      eventId: eventId,
      invoke: () => _channel.invokeMethod<dynamic>('trackSubscribe', {
        'eventId': eventId,
        if (contentId != null && contentId.isNotEmpty) 'contentId': contentId,
        if (currency != null && currency.isNotEmpty) 'currency': currency,
        ?value: value,
      }),
    );
  }

  /// Standard event: StartTrial.
  static Future<void> trackStartTrial({
    required String eventId,
    String? contentId,
    String? currency,
    double? value,
  }) {
    return _trackDeduped(
      eventName: 'StartTrial',
      eventId: eventId,
      invoke: () => _channel.invokeMethod<dynamic>('trackStartTrial', {
        'eventId': eventId,
        if (contentId != null && contentId.isNotEmpty) 'contentId': contentId,
        if (currency != null && currency.isNotEmpty) 'currency': currency,
        ?value: value,
      }),
    );
  }

  /// Updates Meta advertiser tracking after an ATT decision (iOS).
  static Future<void> setAdvertiserTrackingEnabled(bool enabled) async {
    if (!Platform.isIOS) return;
    try {
      await _channel.invokeMethod<dynamic>('setAdvertiserTrackingEnabled', {
        'enabled': enabled,
      });
    } catch (e, st) {
      debugPrint('[Meta] setAdvertiserTrackingEnabled failed safely: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static Future<void> _trackDeduped({
    required String eventName,
    required String eventId,
    required Future<dynamic> Function() invoke,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    final key = '$eventName:${eventId.trim()}';
    if (eventId.trim().isEmpty || _sentEventIds.contains(key)) {
      debugPrint('[Meta] skip duplicate/empty $key');
      return;
    }

    _remember(key);

    try {
      await initialize();
      await invoke();
      debugPrint('[Meta] tracked $key');
    } catch (e, st) {
      _sentEventIds.remove(key);
      debugPrint('[Meta] track $eventName failed safely: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  static void _remember(String key) {
    _sentEventIds.add(key);
    while (_sentEventIds.length > _maxDedupeEntries) {
      _sentEventIds.remove(_sentEventIds.first);
    }
  }
}
