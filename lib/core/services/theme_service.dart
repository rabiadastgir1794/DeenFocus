import 'package:flutter/material.dart';

import 'storage_service.dart';
import 'widget_sync_service.dart';

class ThemeService extends ChangeNotifier {
  ThemeService() {
    _load();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkModeEnabled => _themeMode == ThemeMode.dark;

  Future<void> _load() async {
    final saved = await StorageService.darkModeEnabled;
    if (saved == null) {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = saved ? ThemeMode.dark : ThemeMode.light;
    }
    notifyListeners();
    await WidgetSyncService.instance.syncTimeline();
  }

  Future<void> setDarkModeEnabled(bool value) async {
    final nextMode = value ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode == nextMode) return;
    _themeMode = nextMode;
    notifyListeners();
    await StorageService.setDarkModeEnabled(value);
    await WidgetSyncService.instance.syncTimeline();
  }
}
