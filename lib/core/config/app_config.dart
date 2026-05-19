abstract class AppConfig {
  /// Superwall public API key(s) from the Superwall dashboard.
  /// Set [superwallApiKey] for both platforms, or use the platform-specific
  /// fields when your project has different keys.
  ///
  /// https://superwall.com/docs/home
  static const String superwallApiKeyAndroid = 'pk_eto5ZxwTG6izKc6PXVIzh';
  static const String superwallApiKeyIOS = 'pk_mBLowYWwk1tvka_ZSLM3b';

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
  static const String groqApiKey = String.fromEnvironment(
    'GROQ_API_KEY',
    defaultValue:
        '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',
  );
  static const String groqChatCompletionsUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String groqChatModel = 'llama-3.3-70b-versatile';
  static const int groqChatMaxTokens = 200;
  static const String appDemoVideoUrl = String.fromEnvironment('APP_DEMO_URL');

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.trim().isNotEmpty;
  static bool get hasGroqApiKey => groqApiKey.trim().isNotEmpty;
  static bool get hasAppDemoVideoUrl => appDemoVideoUrl.trim().isNotEmpty;
}
