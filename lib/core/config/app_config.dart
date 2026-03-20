abstract class AppConfig {
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

  static bool get hasGoogleMapsApiKey => googleMapsApiKey.trim().isNotEmpty;
  static bool get hasOpenAiApiKey => openAiApiKey.trim().isNotEmpty;
}
