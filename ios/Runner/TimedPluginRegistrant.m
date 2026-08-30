//
//  TimedPluginRegistrant.m
//  Mirrors GeneratedPluginRegistrant with per-plugin wall-clock timing.
//  Keep in sync when `flutter pub get` adds/removes plugins
//  (compare against ios/Runner/GeneratedPluginRegistrant.m).
//

#import "TimedPluginRegistrant.h"
#import <CoreFoundation/CoreFoundation.h>

#if __has_include(<audio_service/AudioServicePlugin.h>)
#import <audio_service/AudioServicePlugin.h>
#else
@import audio_service;
#endif

#if __has_include(<audio_session/AudioSessionPlugin.h>)
#import <audio_session/AudioSessionPlugin.h>
#else
@import audio_session;
#endif

#if __has_include(<flutter_local_notifications/FlutterLocalNotificationsPlugin.h>)
#import <flutter_local_notifications/FlutterLocalNotificationsPlugin.h>
#else
@import flutter_local_notifications;
#endif

#if __has_include(<flutter_timezone/FlutterTimezonePlugin.h>)
#import <flutter_timezone/FlutterTimezonePlugin.h>
#else
@import flutter_timezone;
#endif

#if __has_include(<geocoding_ios/GeocodingPlugin.h>)
#import <geocoding_ios/GeocodingPlugin.h>
#else
@import geocoding_ios;
#endif

#if __has_include(<geolocator_apple/GeolocatorPlugin.h>)
#import <geolocator_apple/GeolocatorPlugin.h>
#else
@import geolocator_apple;
#endif

#if __has_include(<in_app_purchase_storekit/InAppPurchasePlugin.h>)
#import <in_app_purchase_storekit/InAppPurchasePlugin.h>
#else
@import in_app_purchase_storekit;
#endif

#if __has_include(<in_app_review/InAppReviewPlugin.h>)
#import <in_app_review/InAppReviewPlugin.h>
#else
@import in_app_review;
#endif

#if __has_include(<just_audio/JustAudioPlugin.h>)
#import <just_audio/JustAudioPlugin.h>
#else
@import just_audio;
#endif

#if __has_include(<media_kit_libs_ios_video/MediaKitLibsIosVideoPlugin.h>)
#import <media_kit_libs_ios_video/MediaKitLibsIosVideoPlugin.h>
#else
@import media_kit_libs_ios_video;
#endif

#if __has_include(<media_kit_video/MediaKitVideoPlugin.h>)
#import <media_kit_video/MediaKitVideoPlugin.h>
#else
@import media_kit_video;
#endif

#if __has_include(<package_info_plus/FPPPackageInfoPlusPlugin.h>)
#import <package_info_plus/FPPPackageInfoPlusPlugin.h>
#else
@import package_info_plus;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

#if __has_include(<share_plus/FPPSharePlusPlugin.h>)
#import <share_plus/FPPSharePlusPlugin.h>
#else
@import share_plus;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<sqflite_darwin/SqflitePlugin.h>)
#import <sqflite_darwin/SqflitePlugin.h>
#else
@import sqflite_darwin;
#endif

#if __has_include(<superwallkit_flutter/SuperwallkitFlutterPlugin.h>)
#import <superwallkit_flutter/SuperwallkitFlutterPlugin.h>
#else
@import superwallkit_flutter;
#endif

#if __has_include(<url_launcher_ios/URLLauncherPlugin.h>)
#import <url_launcher_ios/URLLauncherPlugin.h>
#else
@import url_launcher_ios;
#endif

#if __has_include(<wakelock_plus/WakelockPlusPlugin.h>)
#import <wakelock_plus/WakelockPlusPlugin.h>
#else
@import wakelock_plus;
#endif

static void DeenFocusTimePlugin(NSString *name, void (^block)(void)) {
  CFAbsoluteTime t0 = CFAbsoluteTimeGetCurrent();
  block();
  double ms = (CFAbsoluteTimeGetCurrent() - t0) * 1000.0;
  if (ms >= 50.0) {
    NSLog(@"[DeenFocus][Startup] plugin %-36s %6.1f ms  *** SLOW (>50ms)",
          name.UTF8String, ms);
  } else {
    NSLog(@"[DeenFocus][Startup] plugin %-36s %6.1f ms",
          name.UTF8String, ms);
  }
}

@implementation TimedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry> *)registry {
  CFAbsoluteTime all0 = CFAbsoluteTimeGetCurrent();

  DeenFocusTimePlugin(@"AudioServicePlugin", ^{
    [AudioServicePlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioServicePlugin"]];
  });
  DeenFocusTimePlugin(@"AudioSessionPlugin", ^{
    [AudioSessionPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioSessionPlugin"]];
  });
  DeenFocusTimePlugin(@"FlutterLocalNotificationsPlugin", ^{
    [FlutterLocalNotificationsPlugin
        registerWithRegistrar:[registry registrarForPlugin:@"FlutterLocalNotificationsPlugin"]];
  });
  DeenFocusTimePlugin(@"FlutterTimezonePlugin", ^{
    [FlutterTimezonePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterTimezonePlugin"]];
  });
  DeenFocusTimePlugin(@"GeocodingPlugin", ^{
    [GeocodingPlugin registerWithRegistrar:[registry registrarForPlugin:@"GeocodingPlugin"]];
  });
  DeenFocusTimePlugin(@"GeolocatorPlugin", ^{
    [GeolocatorPlugin registerWithRegistrar:[registry registrarForPlugin:@"GeolocatorPlugin"]];
  });
  DeenFocusTimePlugin(@"InAppPurchasePlugin", ^{
    [InAppPurchasePlugin registerWithRegistrar:[registry registrarForPlugin:@"InAppPurchasePlugin"]];
  });
  DeenFocusTimePlugin(@"InAppReviewPlugin", ^{
    [InAppReviewPlugin registerWithRegistrar:[registry registrarForPlugin:@"InAppReviewPlugin"]];
  });
  DeenFocusTimePlugin(@"JustAudioPlugin", ^{
    [JustAudioPlugin registerWithRegistrar:[registry registrarForPlugin:@"JustAudioPlugin"]];
  });
  DeenFocusTimePlugin(@"MediaKitLibsIosVideoPlugin", ^{
    [MediaKitLibsIosVideoPlugin
        registerWithRegistrar:[registry registrarForPlugin:@"MediaKitLibsIosVideoPlugin"]];
  });
  DeenFocusTimePlugin(@"MediaKitVideoPlugin", ^{
    [MediaKitVideoPlugin registerWithRegistrar:[registry registrarForPlugin:@"MediaKitVideoPlugin"]];
  });
  DeenFocusTimePlugin(@"FPPPackageInfoPlusPlugin", ^{
    [FPPPackageInfoPlusPlugin
        registerWithRegistrar:[registry registrarForPlugin:@"FPPPackageInfoPlusPlugin"]];
  });
  DeenFocusTimePlugin(@"PathProviderPlugin", ^{
    [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  });
  DeenFocusTimePlugin(@"PermissionHandlerPlugin", ^{
    [PermissionHandlerPlugin
        registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  });
  DeenFocusTimePlugin(@"FPPSharePlusPlugin", ^{
    [FPPSharePlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPSharePlusPlugin"]];
  });
  DeenFocusTimePlugin(@"SharedPreferencesPlugin", ^{
    [SharedPreferencesPlugin
        registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  });
  DeenFocusTimePlugin(@"SqflitePlugin", ^{
    [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  });
  DeenFocusTimePlugin(@"SuperwallkitFlutterPlugin", ^{
    [SuperwallkitFlutterPlugin
        registerWithRegistrar:[registry registrarForPlugin:@"SuperwallkitFlutterPlugin"]];
  });
  DeenFocusTimePlugin(@"URLLauncherPlugin", ^{
    [URLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"URLLauncherPlugin"]];
  });
  DeenFocusTimePlugin(@"WakelockPlusPlugin", ^{
    [WakelockPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"WakelockPlusPlugin"]];
  });

  NSLog(@"[DeenFocus][Startup] all plugins registered in %.1f ms",
        (CFAbsoluteTimeGetCurrent() - all0) * 1000.0);
}

@end
