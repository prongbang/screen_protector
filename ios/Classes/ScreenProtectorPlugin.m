#import "ScreenProtectorPlugin.h"
#if __has_include(<screen_protector/screen_protector-Swift.h>)
#import <screen_protector/screen_protector-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "screen_protector-Swift.h"
#endif

@implementation ScreenProtectorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftScreenProtectorPlugin registerWithRegistrar:registrar];
}
@end
