import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';

/// Flutter facade for the official TikTok App Events Android SDK.
///
/// UI / paywall code must not call native TikTok APIs directly — route through
/// this service. Purchase / Subscribe / StartTrial should only be invoked after
/// the existing Superwall / Play Billing flow confirms success.
class TikTokAppEventsService {
  TikTokAppEventsService._();

  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/tiktok_app_events',
  );

  static const int _maxDedupeEntries = 200;
  static final LinkedHashSet<String> _sentEventIds = LinkedHashSet<String>();

  static Future<bool>? _initializeFuture;
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  /// Initializes the native TikTok SDK when Android credentials are present.
  /// Safe to call multiple times; never throws.
  static Future<bool> initialize() {
    return _initializeFuture ??= _initializeInternal();
  }

  static Future<bool> _initializeInternal() async {
    if (!Platform.isAndroid) return false;

    final ttAppId = AppConfig.tiktokTtAppId.trim();
    final appSecret = AppConfig.tiktokAppSecret.trim();
    final appId = AppConfig.tiktokAppId.trim().isEmpty
        ? 'com.rnr.deenfocus'
        : AppConfig.tiktokAppId.trim();

    if (ttAppId.isEmpty || appSecret.isEmpty) {
      debugPrint(
        '[TikTok] Skipping Flutter init; provide TIKTOK_TT_APP_ID and '
        'TIKTOK_APP_SECRET via --dart-define / dart_defines.json '
        '(or android/local.properties for early Application init)',
      );
      return false;
    }

    try {
      final result = await _channel.invokeMethod<dynamic>('initialize', {
        'appId': appId,
        'ttAppId': ttAppId,
        'appSecret': appSecret,
        'debug': kDebugMode,
      });
      final ok = result is Map && result['ok'] == true;
      _initialized = ok || (result is Map && result['initialized'] == true);
      debugPrint('[TikTok] initialize ok=$_initialized');
      return _initialized;
    } catch (e, st) {
      debugPrint('[TikTok] initialize failed safely: $e');
      debugPrintStack(stackTrace: st);
      return false;
    }
  }

  /// Standard event: Purchase (`TTPurchaseEvent` / event name "Purchase").
  static Future<void> trackPurchase({
    required String eventId,
    String? contentId,
    String contentType = 'product',
    String? description,
    String? currency,
    double? value,
  }) {
    return _trackDeduped(
      eventName: 'Purchase',
      eventId: eventId,
      invoke: () => _channel.invokeMethod<dynamic>('trackPurchase', {
        'eventId': eventId,
        if (contentId != null && contentId.isNotEmpty) 'contentId': contentId,
        'contentType': contentType,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (currency != null && currency.isNotEmpty) 'currency': currency,
        ?value: value,
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

  static Future<void> _trackDeduped({
    required String eventName,
    required String eventId,
    required Future<dynamic> Function() invoke,
  }) async {
    if (!Platform.isAndroid) return;

    final key = '$eventName:${eventId.trim()}';
    if (eventId.trim().isEmpty || _sentEventIds.contains(key)) {
      debugPrint('[TikTok] skip duplicate/empty $key');
      return;
    }

    // Reserve the key before the async call to collapse concurrent callbacks.
    _remember(key);

    try {
      await initialize();
      await invoke();
      debugPrint('[TikTok] tracked $key');
    } catch (e, st) {
      // Allow a later retry if the channel call failed hard.
      _sentEventIds.remove(key);
      debugPrint('[TikTok] track $eventName failed safely: $e');
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
