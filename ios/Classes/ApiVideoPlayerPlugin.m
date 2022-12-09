#import "ApiVideoPlayerPlugin.h"
#if __has_include(<api_video_player/api_video_player-Swift.h>)
#import <api_video_player/api_video_player-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "api_video_player-Swift.h"
#endif

@implementation ApiVideoPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftApiVideoPlayerPlugin registerWithRegistrar:registrar];
}
@end
