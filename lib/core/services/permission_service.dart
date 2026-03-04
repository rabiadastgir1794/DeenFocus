import 'package:permission_handler/permission_handler.dart';

/// Centralized permission requests and checks. Used by onboarding ViewModel.
abstract class PermissionService {
  static Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<PermissionStatus> requestLocationStatus() async {
    return Permission.location.request();
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

  /// Placeholder request flow for screen-time style access.
  /// Opens app settings where user can grant system-level controls.
  static Future<bool> requestScreenTimeAccess() async {
    return await openAppSettings();
  }
}
