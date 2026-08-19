abstract class AppConfig {
  static const String superwallApiKeyAndroid = String.fromEnvironment(
    'SUPERWALL_API_KEY_ANDROID',
  );
  static const String superwallApiKeyIOS = String.fromEnvironment(
    'SUPERWALL_API_KEY_IOS',
  );

  static String get mapTilesUrlTemplate {
    const raw = String.fromEnvironment('MAP_TILES_URL');
    return raw.isEmpty
        ? 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png'
        : raw;
  }

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );
  static const String groqApiKey = String.fromEnvironment('GROQ_API_KEY');
  static const String groqChatCompletionsUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String groqChatModel = 'openai/gpt-oss-120b';
  /// Completion budget for Groq `openai/gpt-oss-120b`. Reasoning models spend
  /// tokens thinking before they write `message.content`; 200 often yields an
  /// empty reply (`finish_reason: length`).
  static const int groqChatMaxTokens = 1024;
  static const String appDemoVideoUrl = String.fromEnvironment('APP_DEMO_URL');

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.trim().isNotEmpty;
  static bool get hasGroqApiKey => groqApiKey.trim().isNotEmpty;
  static bool get hasAppDemoVideoUrl => appDemoVideoUrl.trim().isNotEmpty;
}
