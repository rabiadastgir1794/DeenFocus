abstract class AppConfig {
  /// Superwall public API key(s) from the Superwall dashboard.
  /// Set [superwallApiKey] for both platforms, or use the platform-specific
  /// fields when your project has different keys.
  ///
  /// https://superwall.com/docs/home
  static const String superwallApiKey = '';
  static const String superwallAndroidApiKey = '';
  static const String superwallIosApiKey = '';

  /// Optional override for flutter_map raster tiles (`{z}`/`{x}`/`{y}`).
  /// Default uses the OSM public tile server (no key). For heavy production
  /// traffic, switch to a commercial provider and pass the URL via dart-define.
  static const String mapTilesUrlTemplate = String.fromEnvironment(
    'MAP_TILES_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );
  static const String openAiApiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue:
        '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',
  );
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String openAiChatModel = 'gpt-4o-mini';
  static const String appDemoVideoUrl = String.fromEnvironment('APP_DEMO_URL');

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.trim().isNotEmpty;
  static bool get hasOpenAiApiKey => openAiApiKey.trim().isNotEmpty;
  static bool get hasAppDemoVideoUrl => appDemoVideoUrl.trim().isNotEmpty;
}
