#import "PerformanceMonitor.h"
#include <mach/mach.h>


@interface PerformanceMonitor()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTimestamp;
@property (nonatomic, assign) NSInteger frameCount;

@end

@implementation PerformanceMonitor
RCT_EXPORT_MODULE()

//// Example method
//// See // https://reactnative.dev/docs/native-modules-ios
//RCT_EXPORT_METHOD(multiply:(double)a
//                  b:(double)b
//                  resolve:(RCTPromiseResolveBlock)resolve
//                  reject:(RCTPromiseRejectBlock)reject)
//{
//    NSNumber *result = @(a * b);
//
//    resolve(result);
//}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.lastTimestamp = 0;
    self.frameCount = 0;
  }
  return self;
}

- (void)startObserving {
  [super startObserving];
  [self startMonitoring];
}

- (void)stopObserving {
  [super stopObserving];
  [self stopMonitoring];
}

- (NSArray<NSString *> *)supportedEvents {
  return @[@"performanceData"];
}

- (void)startMonitoring {
  self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePerformanceData:)];
  [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopMonitoring {
  [self.displayLink invalidate];
  self.displayLink = nil;
}

- (void)updatePerformanceData:(CADisplayLink *)link {
  if (self.lastTimestamp == 0) {
    self.lastTimestamp = link.timestamp;
    return;
  }

  self.frameCount++;
  NSTimeInterval delta = link.timestamp - self.lastTimestamp;

  if (delta >= 1.0) {
    double fps = self.frameCount / delta;
    double memoryUsage = [self getMemoryUsage];
    double cpuUsage = [self getCpuUsage];

    [self sendEventWithName:@"performanceData" body:@{@"fps": @(fps), @"memoryUsage": @(memoryUsage), @"cpuUsage": @(cpuUsage)}];
    self.lastTimestamp = link.timestamp;
    self.frameCount = 0;
  }
}

- (double)getMemoryUsage {
  mach_task_basic_info_data_t taskInfo;
  mach_msg_type_number_t infoCount = MACH_TASK_BASIC_INFO_COUNT;
  kern_return_t kernStatus = task_info(mach_task_self(), MACH_TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);

  if (kernStatus != KERN_SUCCESS) {
    return -1.0;
  }
  return taskInfo.resident_size / (1024.0 * 1024.0); // Convert to MB
}

- (double)getCpuUsage {
  thread_array_t threadList;
  mach_msg_type_number_t threadCount;

  kern_return_t kernStatus = task_threads(mach_task_self(), &threadList, &threadCount);
  if (kernStatus != KERN_SUCCESS) {
    return -1.0;
  }

  float totalCpu = 0;
  for (int i = 0; i < threadCount; i++) {
    thread_info_data_t threadInfo;
    mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
    kernStatus = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);

    if (kernStatus == KERN_SUCCESS) {
      thread_basic_info_t threadBasicInfo = (thread_basic_info_t)threadInfo;
      if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
        totalCpu += threadBasicInfo->cpu_usage / (float)TH_USAGE_SCALE;
      }
    }
  }

  return totalCpu * 100.0;
}

- (void)dealloc {
  [self stopMonitoring];
}


@end
