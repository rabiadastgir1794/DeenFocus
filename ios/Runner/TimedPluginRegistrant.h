//
//  TimedPluginRegistrant.h
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

/// Registers Flutter plugins with per-plugin wall-clock timing (DEBUG/Release).
@interface TimedPluginRegistrant : NSObject
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry> *)registry;
@end

NS_ASSUME_NONNULL_END
