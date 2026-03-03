import 'package:permission_handler/permission_handler.dart';

/// Centralized permission requests and checks. Used by onboarding ViewModel.
abstract class PermissionService {
  static Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> checkLocation() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  static Future<bool> requestNotification() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> checkNotification() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<bool> openAppSettingsAsync() async {
    return await openAppSettings();
  }
}
