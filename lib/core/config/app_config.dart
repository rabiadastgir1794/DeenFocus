abstract class AppConfig {
  /// Must match the JSON key in repo-root `dart_defines.json`.
  static const String superwallApiKeyAndroidDefine =
      'SUPERWALL_API_KEY_ANDROID';

  /// Must match the JSON key in repo-root `dart_defines.json`.
  static const String superwallApiKeyIOSDefine = 'SUPERWALL_API_KEY_IOS';

  static const String superwallApiKeyAndroid = String.fromEnvironment(
    superwallApiKeyAndroidDefine,
  );
  static const String superwallApiKeyIOS = String.fromEnvironment(
    superwallApiKeyIOSDefine,
  );

  /// Google Play / package App ID used by TikTok (defaults applied in service).
  static const String tiktokAppId = String.fromEnvironment(
    'TIKTOK_APP_ID',
    defaultValue: 'com.rnr.deenfocus',
  );

  /// TikTok App ID from Events Manager (not the Play package name).
  static const String tiktokTtAppId = String.fromEnvironment(
    'TIKTOK_TT_APP_ID',
  );

  /// TikTok App Secret from Events Manager — never commit this value.
  static const String tiktokAppSecret = String.fromEnvironment(
    'TIKTOK_APP_SECRET',
  );

  /// Meta / Facebook App ID from Meta App Dashboard.
  static const String metaAppId = String.fromEnvironment('META_APP_ID');

  /// Meta Client Token (Settings → Advanced) — required by current Meta SDK.
  static const String metaClientToken = String.fromEnvironment(
    'META_CLIENT_TOKEN',
  );

  /// Display name shown to Meta (Info.plist FacebookDisplayName).
  static const String metaDisplayName = String.fromEnvironment(
    'META_DISPLAY_NAME',
    defaultValue: 'Deen Focus',
  );

  static String get mapTilesUrlTemplate {
    const raw = String.fromEnvironment('MAP_TILES_URL');
    return raw.isEmpty ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png' : raw;
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
