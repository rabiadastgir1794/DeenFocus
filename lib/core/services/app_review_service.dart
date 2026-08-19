import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

import '../constants/store_listing.dart';
import 'app_review_policy.dart';
import 'storage_service.dart';

/// Native in-app review ([InAppReview]) with session/achievement gating
/// for automatic prompts. Manual Settings requests skip those limits.
class AppReviewService {
  AppReviewService._();

  static bool _busy = false;
  static bool _celebrationsBlocking = false;

  static void setCelebrationsBlocking(bool value) {
    _celebrationsBlocking = value;
  }

  static bool get celebrationsBlocking => _celebrationsBlocking;

  /// Record a meaningful session (cold start / resume after [sessionGap]).
  static Future<void> recordMeaningfulSession({DateTime? now}) async {
    final moment = now ?? DateTime.now();
    await StorageService.ensureAppFirstOpenRecorded();
    await StorageService.migrateLegacyAppReviewPromptIfNeeded(now: moment);
    await _recordSessionIfNeeded(moment);
  }

  /// Show the native prompt when automatic rules pass.
  static Future<void> maybeShowAutomatic({
    required int completedPrayers,
    required bool hasUnlockedAchievement,
    DateTime? now,
  }) async {
    if (!_isSupportedPlatform) return;
    if (_busy) return;

    final moment = now ?? DateTime.now();
    await StorageService.ensureAppFirstOpenRecorded();
    await StorageService.migrateLegacyAppReviewPromptIfNeeded(now: moment);

    if (!AppReviewPolicy.isAutomaticEligible(
      sessionCount: await StorageService.appReviewSessionCount,
      completedPrayers: completedPrayers,
      hasUnlockedAchievement: hasUnlockedAchievement,
      now: moment,
      lastAutomaticPromptAt: await StorageService.appReviewLastAutomaticAt,
      automaticPromptAt: await StorageService.appReviewAutomaticHistory,
      celebrationsBlocking: _celebrationsBlocking,
    )) {
      return;
    }

    _busy = true;
    try {
      await _showReviewOrStore();
      await StorageService.recordAppReviewAutomaticPrompt(moment);
    } catch (e, st) {
      debugPrint('AppReviewService: $e\n$st');
    } finally {
      _busy = false;
    }
  }

  /// Settings → Rate DeenFocus. Ignores session, cooldown, and annual limits.
  static Future<void> requestReviewManually() async {
    if (!_isSupportedPlatform) return;
    try {
      await _showReviewOrStore();
    } catch (e, st) {
      debugPrint('AppReviewService.manual: $e\n$st');
    }
  }

  /// Use from a Submit/Rate button when you want guaranteed store navigation.
  static Future<void> openStoreListingForFeedback() async {
    if (!_isSupportedPlatform) return;
    await _openStoreListing();
  }

  static bool get _isSupportedPlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  static Future<void> _recordSessionIfNeeded(DateTime now) async {
    final last = await StorageService.appReviewLastSessionAt;
    if (!AppReviewPolicy.shouldStartNewSession(now: now, lastSessionAt: last)) {
      return;
    }
    final next = AppReviewPolicy.sessionCountAfterRecording(
      currentCount: await StorageService.appReviewSessionCount,
      startedNewSession: true,
    );
    await StorageService.setAppReviewSession(count: next, at: now);
  }

  static Future<void> _showReviewOrStore() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
      return;
    }
    await _openStoreListing();
  }

  static Future<void> _openStoreListing() async {
    final review = InAppReview.instance;
    if (Platform.isIOS) {
      if (kIosAppStoreId.isEmpty) {
        debugPrint(
          'AppReviewService: kIosAppStoreId is empty, cannot open iOS listing.',
        );
        return;
      }
      await review.openStoreListing(appStoreId: kIosAppStoreId);
      return;
    }
    if (Platform.isAndroid) {
      await review.openStoreListing();
    }
  }
}
