import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

import '../constants/store_listing.dart';
import 'storage_service.dart';

/// Schedules a single in-app review prompt after [StorageService] reports three
/// days since first open, using [InAppReview] only (no custom URLs or dialogs).
class AppReviewService {
  AppReviewService._();

  static bool _busy = false;

  static Future<void> onAppResumed() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    if (_busy) return;

    await StorageService.ensureAppFirstOpenRecorded();
    if (!await StorageService.shouldShowAppReviewPrompt) return;

    _busy = true;
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      } else if (Platform.isIOS && kIosAppStoreId.isNotEmpty) {
        await review.openStoreListing(appStoreId: kIosAppStoreId);
      } else if (Platform.isAndroid) {
        await review.openStoreListing();
      }
    } catch (e, st) {
      debugPrint('AppReviewService: $e\n$st');
    } finally {
      await StorageService.setAppReviewPromptCompleted();
      _busy = false;
    }
  }
}
