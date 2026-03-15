import 'package:flutter/services.dart';

class QiblaCompassService {
  QiblaCompassService._();

  static const MethodChannel _methodChannel = MethodChannel(
    'com.app.deenly.deenly/qibla_compass_method',
  );
  static const EventChannel _eventChannel = EventChannel(
    'com.app.deenly.deenly/qibla_compass_events',
  );

  static Stream<double>? _headingStream;

  static Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) {
    return _methodChannel.invokeMethod<void>('setLocation', <String, double>{
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  static Stream<double> headingStream() {
    return _headingStream ??= Stream<double>.multi((controller) {
      final subscription = _eventChannel.receiveBroadcastStream().listen(
        (dynamic value) {
          if (value is num) {
            controller.add(value.toDouble());
            return;
          }
          controller.addError(const FormatException('Invalid heading value'));
        },
        onError: (Object error, StackTrace stackTrace) {
          if (error is MissingPluginException) {
            controller.close();
            return;
          }
          if (error is PlatformException &&
              error.code == 'HEADING_UNAVAILABLE') {
            controller.close();
            return;
          }
          controller.addError(error, stackTrace);
        },
      );

      controller.onCancel = () => subscription.cancel();
    });
  }
}
