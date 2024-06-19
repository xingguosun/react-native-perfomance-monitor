
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNPerformanceMonitorSpec.h"

@interface PerformanceMonitor : NSObject <NativePerformanceMonitorSpec>
#else
#import <React/RCTEventEmitter.h>
#import <React/RCTBridgeModule.h>

typedef enum EventType {
  PerformanceData
} EventType;

@interface PerformanceMonitor : RCTEventEmitter <RCTBridgeModule>
#endif

@end
