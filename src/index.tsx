import {
  NativeEventEmitter,
  NativeModules,
  Platform,
  type EmitterSubscription,
} from 'react-native';
import type { PerformanceData, StartMonitoringCallback } from '../type';

const LINKING_ERROR =
  `The package 'react-native-performance-monitor' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const PerformanceMonitor = NativeModules.PerformanceMonitor
  ? NativeModules.PerformanceMonitor
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );
const performanceMonitorEmitter = new NativeEventEmitter(PerformanceMonitor);
let subscription: EmitterSubscription | null = null;
const startMonitoring = (callback: StartMonitoringCallback) => {
  if (subscription) {
    return;
  }
  subscription = performanceMonitorEmitter.addListener(
    'performanceData',
    callback
  );
};

const stopMonitoring = () => {
  if (subscription) {
    subscription.remove();
    subscription = null;
  }
};

export { startMonitoring, stopMonitoring };
export type { PerformanceData };
