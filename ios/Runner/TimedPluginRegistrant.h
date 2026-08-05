//
//  TimedPluginRegistrant.h
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

/// Registers the same plugins as GeneratedPluginRegistrant, logging ms per plugin.
@interface TimedPluginRegistrant : NSObject
+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry> *)registry;
@end

NS_ASSUME_NONNULL_END
