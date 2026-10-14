# Meta (Facebook) and TikTok Analytics SDK Setup

This document explains how to configure Meta (Facebook) App Events and TikTok App Events SDKs for conversion tracking in both iOS and Android.

## Prerequisites

### Meta (Facebook)
1. **Meta Business Account**: [business.facebook.com](https://business.facebook.com)
2. **Meta App**: Create at [developers.facebook.com/apps](https://developers.facebook.com/apps)
3. **Credentials needed**:
   - **App ID**: Found in App Dashboard → Settings → Basic
   - **Client Token**: Found in App Dashboard → Settings → Advanced
   - **Display Name**: Your app name (e.g., "Deen Focus")

### TikTok
1. **TikTok Ads Manager Account**: [ads.tiktok.com](https://ads.tiktok.com)
2. **TikTok Events Manager**: Create an app in Events Manager
3. **Credentials needed**:
   - **TikTok App ID (TT_APP_ID)**: Found in TikTok Events Manager → App Details
   - **App Secret**: Found in TikTok Events Manager → App Details
   - **App ID**: Your app package name (e.g., `com.rnr.deenfocus`)

---

## Configuration Methods

You can configure credentials in **THREE** ways (in order of precedence):

### Method 1: dart_defines.json (Recommended for development)

Create `dart_defines.json` in the repository root:

```json
{
  "META_APP_ID": "your_facebook_app_id",
  "META_CLIENT_TOKEN": "your_facebook_client_token",
  "META_DISPLAY_NAME": "Deen Focus",
  "TIKTOK_APP_ID": "com.rnr.deenfocus",
  "TIKTOK_TT_APP_ID": "your_tiktok_tt_app_id",
  "TIKTOK_APP_SECRET": "your_tiktok_app_secret"
}
```

**Note**: This file is `.gitignore`d. Never commit real credentials.

### Method 2: iOS Native Configuration (Required for Meta iOS)

1. Copy the example file:
   ```bash
   cp ios/Flutter/MetaSecrets.xcconfig.example ios/Flutter/MetaSecrets.xcconfig
   ```

2. Edit `ios/Flutter/MetaSecrets.xcconfig` with your credentials:
   ```
   FACEBOOK_APP_ID=your_facebook_app_id
   FACEBOOK_CLIENT_TOKEN=your_facebook_client_token
   FACEBOOK_DISPLAY_NAME=Deen Focus
   ```

**Note**: TikTok iOS reads from `dart_defines.json` at runtime. Native xcconfig is optional.

### Method 3: Android local.properties (Optional for early init)

Add to `android/local.properties`:

```properties
# Meta credentials
meta.app.id=your_facebook_app_id
meta.client.token=your_facebook_client_token
meta.display.name=Deen Focus

# TikTok credentials
tiktok.app.id=com.rnr.deenfocus
tiktok.tt.app.id=your_tiktok_tt_app_id
tiktok.app.secret=your_tiktok_app_secret
```

This enables early SDK initialization in `Application.onCreate()` for install attribution.

---

## Platform-Specific Configuration

### iOS Setup

#### 1. Meta (Facebook) Configuration

Already configured in `ios/Runner/Info.plist`:
- ✅ `FacebookAppID` from `$(FACEBOOK_APP_ID)`
- ✅ `FacebookClientToken` from `$(FACEBOOK_CLIENT_TOKEN)`
- ✅ `FacebookDisplayName` from `$(FACEBOOK_DISPLAY_NAME)`
- ✅ `CFBundleURLTypes` for deep linking
- ✅ `NSUserTrackingUsageDescription` for ATT (App Tracking Transparency)
- ✅ `SKAdNetworkItems` for attribution

**Required Action**: Create `ios/Flutter/MetaSecrets.xcconfig` (see Method 2 above).

#### 2. TikTok Configuration

- ✅ SDK added to `ios/Podfile`
- ✅ Bridge registered in `AppDelegate.swift`
- ✅ Credentials loaded from `dart_defines.json` at runtime
- ✅ Uses same `NSUserTrackingUsageDescription` as Meta

**Required Action**: Add TikTok credentials to `dart_defines.json`.

#### 3. Install Dependencies
```bash
cd ios
pod install
cd ..
```

### Android Setup

#### 1. Meta (Facebook) Configuration

Already configured:
- ✅ `com.facebook.sdk.ApplicationId` in `AndroidManifest.xml`
- ✅ `com.facebook.sdk.ClientToken` in `AndroidManifest.xml`
- ✅ SDK dependency in `android/app/build.gradle.kts`
- ✅ BuildConfig fields from `local.properties`

**Required Action**: Add Meta credentials to `android/local.properties` or `dart_defines.json`.

#### 2. TikTok Configuration

Already configured:
- ✅ SDK dependency in `android/app/build.gradle.kts`
- ✅ BuildConfig fields from `local.properties`
- ✅ Early initialization in `DeenFocusApplication`

**Required Action**: Add TikTok credentials to `android/local.properties` or `dart_defines.json`.

#### 3. ProGuard Rules

Already configured in `android/app/proguard-rules.pro`:
- ✅ Facebook SDK keep rules
- ✅ TikTok SDK keep rules

---

## Build Commands

### Development Builds (with dart_defines.json)

```bash
# iOS
flutter build ios --dart-define-from-file=dart_defines.json

# Android
flutter build apk --dart-define-from-file=dart_defines.json
```

### Release Builds

Ensure credentials are in:
- iOS: `ios/Flutter/MetaSecrets.xcconfig`
- Android: `android/local.properties` or CI environment variables

```bash
# iOS
flutter build ipa --dart-define-from-file=dart_defines.json

# Android
flutter build appbundle --dart-define-from-file=dart_defines.json
```

---

## Tracked Events

The SDK automatically tracks the following conversion events:

### 1. Install & Launch
- **Meta**: Auto-tracked via `FacebookAppEventsEnabled=true`
- **TikTok**: Auto-tracked via `installTrackingEnabled=true`

### 2. Purchase (Standard Product)
- **Triggered**: When `EventType.transactionComplete` fires from Superwall
- **Meta Event**: `fb_mobile_purchase`
- **TikTok Event**: `Purchase`
- **Parameters**: value, currency, contentId, contentType

### 3. Subscribe (Subscription Start)
- **Triggered**: When `EventType.subscriptionStart` fires from Superwall
- **Meta Event**: `Subscribe`
- **TikTok Event**: `Subscribe`
- **Parameters**: contentId, currency, value

### 4. StartTrial (Free Trial Start)
- **Triggered**: When `EventType.freeTrialStart` fires from Superwall
- **Meta Event**: `StartTrial`
- **TikTok Event**: `StartTrial`
- **Parameters**: contentId, currency, value

### Event Deduplication
- Each event has a unique ID: `{eventType}:{productId}:{minuteBucket}`
- Prevents duplicate events from being sent
- 200-entry cache per SDK

---

## Verification

### Meta Events Manager
1. Go to [business.facebook.com/events_manager2](https://business.facebook.com/events_manager2)
2. Select your app
3. Check "Events" tab for real-time postbacks
4. Test events appear within seconds

### TikTok Events Manager
1. Go to [ads.tiktok.com/marketing_api/apps](https://ads.tiktok.com/marketing_api/apps)
2. Select your app
3. Check "Events" tab
4. Test events appear within 1-2 minutes

### Debug Mode

Enable debug logging by:
1. Running in debug mode (`flutter run`)
2. Check console for:
   - `[Meta] initialize ok=true`
   - `[Meta] tracked Purchase:...`
   - `[TikTok] initialize ok=true`
   - `[TikTok] tracked Subscribe:...`

---

## Privacy & Compliance

### iOS App Tracking Transparency (ATT)
- **Prompt**: Shown automatically on iOS 14+ via `NSUserTrackingUsageDescription`
- **Current text**: "This identifier will be used to deliver personalized ads and measure Meta advertising performance."
- **Handling**: Meta SDK automatically requests ATT permission

### Android
- No special permissions required for event tracking
- IDFA collection enabled by default

### GDPR Compliance
- **User Consent**: You must obtain consent before tracking in EU/UK
- **Implementation**: Add consent management before calling `initialize()`
- **Example**:
  ```dart
  if (await userConsentGranted()) {
    await MetaAppEventsService.initialize();
    await TikTokAppEventsService.initialize();
  }
  ```

---

## Troubleshooting

### Events Not Appearing in Meta Events Manager

1. **Check initialization**:
   ```
   [Meta] initialize ok=true
   ```
   If false, verify credentials in `MetaSecrets.xcconfig` (iOS) or `local.properties` (Android)

2. **Check event tracking**:
   ```
   [Meta] tracked Purchase:transaction_123
   ```

3. **Verify App ID** matches Meta Events Manager

4. **Check ATT status** (iOS):
   ```
   [MetaAppEvents] ATT status=3 advertiserTracking=true
   ```
   Status 3 = authorized, 2 = denied

### Events Not Appearing in TikTok Events Manager

1. **Check initialization**:
   ```
   [TikTok] initialize ok=true
   ```

2. **Verify credentials** in `dart_defines.json`:
   - `TIKTOK_TT_APP_ID` must match TikTok Events Manager
   - `TIKTOK_APP_SECRET` must be correct

3. **Check Android package name** matches `TIKTOK_APP_ID`

4. **Wait 2-3 minutes** - TikTok has longer delay than Meta

### Build Errors

#### iOS: "No such module 'FBSDKCoreKit'"
```bash
cd ios
pod install
```

#### iOS: "Variable 'FACEBOOK_APP_ID' isn't declared"
Create `ios/Flutter/MetaSecrets.xcconfig` from example.

#### Android: "Unresolved reference: facebook_app_id"
Add credentials to `android/local.properties`.

---

## Dashboard Actions Required

### Meta Business Manager
1. Create Meta App at [developers.facebook.com/apps](https://developers.facebook.com/apps)
2. Add iOS Bundle ID: `com.rnr.deenfocus`
3. Add Android Package Name: `com.rnr.deenfocus`
4. Copy App ID and Client Token
5. In Events Manager, verify test events appear

### TikTok Ads Manager
1. Create app in [TikTok Events Manager](https://ads.tiktok.com/marketing_api/apps)
2. Add iOS Bundle ID: `com.rnr.deenfocus`
3. Add Android Package Name: `com.rnr.deenfocus`
4. Copy TikTok App ID (TT_APP_ID) and App Secret
5. Create ad campaigns using app events for optimization

---

## File Summary

### Credential Files (Create These)
- ❌ `dart_defines.json` (root) - **YOU MUST CREATE**
- ❌ `ios/Flutter/MetaSecrets.xcconfig` - **YOU MUST CREATE**
- ✅ `ios/Flutter/MetaSecrets.xcconfig.example` - Template provided
- ⚠️ `android/local.properties` - Optional, for early init

### Implementation Files (Already Done)
- ✅ `lib/core/analytics/meta_app_events_service.dart`
- ✅ `lib/core/analytics/tiktok_app_events_service.dart`
- ✅ `lib/core/config/app_config.dart`
- ✅ `lib/core/superwall/app_superwall.dart` (event tracking)
- ✅ `lib/main.dart` (initialization)
- ✅ `ios/Runner/MetaAppEventsBridge.swift`
- ✅ `ios/Runner/TikTokAppEventsBridge.swift`
- ✅ `ios/Runner/AppDelegate.swift` (registration)
- ✅ `ios/Runner/Info.plist` (Meta + ATT config)
- ✅ `ios/Podfile` (SDK dependencies)
- ✅ `android/app/src/main/kotlin/.../MetaAppEventsBridge.kt`
- ✅ `android/app/src/main/kotlin/.../TikTokAppEventsBridge.kt`
- ✅ `android/app/src/main/kotlin/.../DeenFocusApplication.kt`
- ✅ `android/app/src/main/kotlin/.../MainActivity.kt`
- ✅ `android/app/src/main/AndroidManifest.xml`
- ✅ `android/app/build.gradle.kts`
- ✅ `android/app/proguard-rules.pro`

---

## Next Steps

1. **Create credential files** (see above)
2. **Install iOS dependencies**: `cd ios && pod install`
3. **Build and run** on device (simulator doesn't support ATT)
4. **Make a test purchase** in the app
5. **Check Events Manager** for both Meta and TikTok
6. **Launch ad campaigns** using app events for optimization

---

## Support

- Meta SDK Docs: [developers.facebook.com/docs/app-events](https://developers.facebook.com/docs/app-events)
- TikTok SDK Docs: [business-api.tiktok.com/portal/docs](https://business-api.tiktok.com/portal/docs)
- Superwall Integration: Already wired in `app_superwall.dart`
