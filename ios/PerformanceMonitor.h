
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNPerformanceMonitorSpec.h"

@interface PerformanceMonitor : NSObject <NativePerformanceMonitorSpec>
#else
#import <React/RCTBridgeModule.h>

@interface PerformanceMonitor : NSObject <RCTBridgeModule>
#endif

@end
