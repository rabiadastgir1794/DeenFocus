import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'storage_service.dart';

const String _kFcmDefaultAndroidChannelId = 'fcm_default';

/// Background isolate handler. Must be a top-level function registered before
/// [runApp]. Do not add UI work here.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
    '[FCM] Background message: ${message.messageId} '
    'title=${message.notification?.title} dataKeys=${message.data.keys.toList()}',
  );
}

/// Centralized Firebase Cloud Messaging service.
///
/// Handles FCM token lifecycle, foreground/background message handling, and
/// notification permissions. Preserves existing prayer alarms and local
/// notifications (AppNotificationService owns those).
///
/// Remote FCM messages complement local notifications; they do NOT replace
/// prayer alarms or daily wrap-up reminders.
class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  FirebaseMessaging? _messaging;
  bool _initialized = false;
  String? _cachedToken;

  bool get isInitialized => _initialized;
  String? get currentToken => _cachedToken;

  /// Call immediately after [Firebase.initializeApp], before [runApp].
  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Initializes FCM and registers message handlers.
  /// Safe to call multiple times.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      _messaging = FirebaseMessaging.instance;

      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint(
        '[FCM] Permission status: ${settings.authorizationStatus.name}',
      );

      await _ensureAndroidNotificationChannel();
      await _waitForApnsToken();
      await _refreshToken();

      _messaging!.onTokenRefresh.listen(_handleTokenRefresh);
      _setupMessageHandlers();

      _initialized = true;
      debugPrint(
        '[FCM] Initialized successfully tokenReady=${_cachedToken != null}',
      );
    } catch (e, st) {
      debugPrint('[FCM] Initialization failed: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> _ensureAndroidNotificationChannel() async {
    if (!Platform.isAndroid) return;
    const channel = AndroidNotificationChannel(
      _kFcmDefaultAndroidChannelId,
      'Deen Focus',
      description: 'Messages from Deen Focus',
      importance: Importance.high,
    );
    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _waitForApnsToken() async {
    if (!Platform.isIOS) return;
    for (var attempt = 0; attempt < 5; attempt++) {
      final apns = await _messaging!.getAPNSToken();
      if (apns != null) {
        debugPrint('[FCM] APNs token ready');
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
    debugPrint('[FCM] APNs token not ready; iOS getToken may fail');
  }

  Future<void> _refreshToken() async {
    try {
      final token = await _messaging!.getToken();
      if (token != null && token != _cachedToken) {
        _cachedToken = token;
        await _storeToken(token);
        debugPrint('[FCM] Token refreshed');
      }
    } catch (e) {
      debugPrint('[FCM] Token refresh failed: $e');
    }
  }

  /// Stores the FCM token locally. Backend can retrieve it for sending notifications.
  Future<void> _storeToken(String token) async {
    try {
      await StorageService.setFcmToken(token);
    } catch (e) {
      debugPrint('[FCM] Token storage failed: $e');
    }
  }

  /// Handles token refresh events (e.g., after reinstall or token rotation).
  void _handleTokenRefresh(String token) {
    _cachedToken = token;
    unawaited(_storeToken(token));
    debugPrint('[FCM] Token refreshed');
  }

  /// Sets up foreground and background message handlers.
  void _setupMessageHandlers() {
    // Foreground messages (app is open and visible)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages (app is in background, notification tapped)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from a terminated state via notification tap
    _checkInitialMessage();
  }

  /// Handles messages received while the app is in the foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint(
      '[FCM] Foreground message: ${message.messageId} '
      'title=${message.notification?.title} dataKeys=${message.data.keys.toList()}',
    );
    _handleMessageData(message.data);
  }

  /// Handles notification tap (app opened from background).
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint(
      '[FCM] Notification tapped: ${message.messageId} '
      'dataKeys=${message.data.keys.toList()}',
    );

    // Route to the appropriate screen based on message.data
    _handleMessageData(message.data);
  }

  /// Checks if the app was opened from a terminated state via notification tap.
  Future<void> _checkInitialMessage() async {
    try {
      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '[FCM] App opened from terminated state via notification: '
          '${initialMessage.messageId}',
        );
        _handleMessageData(initialMessage.data);
      }
    } catch (e) {
      debugPrint('[FCM] getInitialMessage failed: $e');
    }
  }

  /// Handles the data payload from an FCM message.
  /// Implement navigation or business logic based on message.data keys.
  void _handleMessageData(Map<String, dynamic> data) {
    if (data.isEmpty) return;

    // Example: navigate based on 'type' key
    final type = data['type'] as String?;
    switch (type) {
      case 'prayer_reminder':
        // Navigate to prayer tab or show details
        debugPrint('[FCM] Handling prayer_reminder notification');
        break;
      case 'quran_reminder':
        // Navigate to Quran tab
        debugPrint('[FCM] Handling quran_reminder notification');
        break;
      case 'weekly_progress':
        // Navigate to home/stats
        debugPrint('[FCM] Handling weekly_progress notification');
        break;
      default:
        debugPrint('[FCM] Unknown notification type: $type');
    }
  }

  /// Subscribes to a topic (e.g., for broadcast notifications).
  Future<void> subscribeToTopic(String topic) async {
    if (!_initialized || _messaging == null) return;

    try {
      await _messaging!.subscribeToTopic(topic);
      debugPrint('[FCM] Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('[FCM] subscribeToTopic failed: $e');
    }
  }

  /// Unsubscribes from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    if (!_initialized || _messaging == null) return;

    try {
      await _messaging!.unsubscribeFromTopic(topic);
      debugPrint('[FCM] Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('[FCM] unsubscribeFromTopic failed: $e');
    }
  }

  /// Deletes the FCM token (e.g., on logout or opt-out).
  Future<void> deleteToken() async {
    if (!_initialized || _messaging == null) return;

    try {
      await _messaging!.deleteToken();
      _cachedToken = null;
      await StorageService.clearFcmToken();
      debugPrint('[FCM] Token deleted');
    } catch (e) {
      debugPrint('[FCM] deleteToken failed: $e');
    }
  }

  /// Gets the current FCM token (retrieves from cache or fetches new).
  Future<String?> getToken() async {
    if (_cachedToken != null) return _cachedToken;
    await _refreshToken();
    return _cachedToken;
  }
}
