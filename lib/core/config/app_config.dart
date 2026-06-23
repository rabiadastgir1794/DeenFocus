abstract class AppConfig {
  static const String superwallApiKeyAndroid = String.fromEnvironment(
    'SUPERWALL_API_KEY_ANDROID',
  );
  static const String superwallApiKeyIOS = String.fromEnvironment(
    'SUPERWALL_API_KEY_IOS',
  );

  static const String mapTilesUrlTemplate = String.fromEnvironment(
    'MAP_TILES_URL',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
  );
  static const String groqApiKey = String.fromEnvironment('GROQ_API_KEY');
  static const String groqChatCompletionsUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String groqChatModel = 'llama-3.3-70b-versatile';
  static const int groqChatMaxTokens = 200;
  static const String appDemoVideoUrl = String.fromEnvironment('APP_DEMO_URL');

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.trim().isNotEmpty;
  static bool get hasGroqApiKey => groqApiKey.trim().isNotEmpty;
  static bool get hasAppDemoVideoUrl => appDemoVideoUrl.trim().isNotEmpty;
}
