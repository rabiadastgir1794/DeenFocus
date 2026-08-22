import 'package:flutter/foundation.dart';

import 'feature_demo_kind.dart';
import 'feature_demo_phase.dart';

/// Local state machine for interactive App Demo walkthroughs.
class FeatureDemoController extends ChangeNotifier {
  FeatureDemoController({
    required this.kind,
    required this.isCupertinoPlatform,
  });

  final FeatureDemoKind kind;
  final bool isCupertinoPlatform;

  FeatureDemoPhase _phase = FeatureDemoPhase.intro;
  FeatureDemoPhase get phase => _phase;

  FeatureDemoWidgetSize _widgetSize = FeatureDemoWidgetSize.medium;
  FeatureDemoWidgetSize get widgetSize => _widgetSize;

  bool _liveActivityEnabled = false;
  bool get liveActivityEnabled => _liveActivityEnabled;

  bool get isImmersive =>
      _phase != FeatureDemoPhase.intro &&
      _phase != FeatureDemoPhase.completion &&
      _phase != FeatureDemoPhase.enableOffer;

  void startDemo() {
    switch (kind) {
      case FeatureDemoKind.tajweed:
        _goTo(FeatureDemoPhase.tajweedQuran);
      case FeatureDemoKind.widgets:
        _goTo(FeatureDemoPhase.widgetsHome);
      case FeatureDemoKind.liveActivity:
        _liveActivityEnabled = false;
        _goTo(FeatureDemoPhase.liveSettings);
    }
  }

  // —— Tajweed ——

  void tapTajweedDrill() {
    if (_phase != FeatureDemoPhase.tajweedQuran) return;
    _goTo(FeatureDemoPhase.tajweedSurahRecite);
  }

  void tapTajweedLegend() {
    if (_phase != FeatureDemoPhase.tajweedSurahLegend) return;
    _goTo(FeatureDemoPhase.tajweedSurahRecite);
  }

  void tapTajweedRecite() {
    if (_phase != FeatureDemoPhase.tajweedSurahLegend &&
        _phase != FeatureDemoPhase.tajweedSurahRecite) {
      return;
    }
    _goTo(FeatureDemoPhase.tajweedDownload);
  }

  void finishTajweedDownload() {
    if (_phase != FeatureDemoPhase.tajweedDownload) return;
    _goTo(FeatureDemoPhase.tajweedPractice);
  }

  void tapTajweedMic() {
    if (_phase != FeatureDemoPhase.tajweedPractice) return;
    _goTo(FeatureDemoPhase.tajweedResult);
  }

  void finishTajweedDemo() {
    if (_phase != FeatureDemoPhase.tajweedResult) return;
    _goTo(FeatureDemoPhase.completion);
  }

  void retryTajweedPractice() {
    if (_phase != FeatureDemoPhase.tajweedResult) return;
    _goTo(FeatureDemoPhase.tajweedPractice);
  }

  void goBack() {
    switch (_phase) {
      case FeatureDemoPhase.tajweedQuran:
        reset();
      case FeatureDemoPhase.tajweedSurahLegend:
      case FeatureDemoPhase.tajweedSurahRecite:
        _goTo(FeatureDemoPhase.tajweedQuran);
      case FeatureDemoPhase.tajweedDownload:
        _goTo(FeatureDemoPhase.tajweedSurahRecite);
      case FeatureDemoPhase.tajweedPractice:
        _goTo(FeatureDemoPhase.tajweedDownload);
      case FeatureDemoPhase.tajweedResult:
        _goTo(FeatureDemoPhase.tajweedPractice);
      default:
        break;
    }
  }

  // —— Widgets ——

  void longPressHome() {
    if (_phase != FeatureDemoPhase.widgetsHome) return;
    _goTo(FeatureDemoPhase.widgetsEditMode);
  }

  void openWidgetGallery() {
    if (_phase != FeatureDemoPhase.widgetsEditMode &&
        _phase != FeatureDemoPhase.widgetsPlaced) {
      return;
    }
    _goTo(FeatureDemoPhase.widgetsGallery);
  }

  void selectWidgetSize(FeatureDemoWidgetSize size) {
    if (_phase != FeatureDemoPhase.widgetsGallery) return;
    _widgetSize = size;
    notifyListeners();
  }

  void confirmWidgetPlacement() {
    if (_phase != FeatureDemoPhase.widgetsGallery) return;
    _goTo(FeatureDemoPhase.widgetsPlaced);
  }

  void finishWidgetsDemo() {
    if (_phase != FeatureDemoPhase.widgetsPlaced) return;
    _goTo(FeatureDemoPhase.completion);
  }

  // —— Live Activity ——

  void enableLiveActivity() {
    if (_phase != FeatureDemoPhase.liveSettings) return;
    _liveActivityEnabled = true;
    notifyListeners();
    if (isCupertinoPlatform) {
      _goTo(FeatureDemoPhase.liveLockScreen);
    } else {
      _goTo(FeatureDemoPhase.liveOngoingNotification);
    }
  }

  void advanceLiveActivity() {
    switch (_phase) {
      case FeatureDemoPhase.liveLockScreen:
        _goTo(FeatureDemoPhase.liveCompactIsland);
      case FeatureDemoPhase.liveCompactIsland:
        _goTo(FeatureDemoPhase.liveExpandedIsland);
      case FeatureDemoPhase.liveExpandedIsland:
        _goTo(FeatureDemoPhase.completion);
      case FeatureDemoPhase.liveOngoingNotification:
        _goTo(FeatureDemoPhase.liveNotificationShade);
      case FeatureDemoPhase.liveNotificationShade:
        _goTo(FeatureDemoPhase.completion);
      default:
        break;
    }
  }

  void openEnableOffer() {
    if (_phase != FeatureDemoPhase.completion) return;
    if (kind != FeatureDemoKind.liveActivity) return;
    _goTo(FeatureDemoPhase.enableOffer);
  }

  void reset() {
    _widgetSize = FeatureDemoWidgetSize.medium;
    _liveActivityEnabled = false;
    if (_phase == FeatureDemoPhase.intro) {
      notifyListeners();
      return;
    }
    _phase = FeatureDemoPhase.intro;
    notifyListeners();
  }

  void _goTo(FeatureDemoPhase next) {
    if (_phase == next) return;
    _phase = next;
    notifyListeners();
  }
}
