export type PerformanceData = {
  cpu: number;
  memory: number;
  fps: number;
};

export type StartMonitoringCallback = (data: PerformanceData) => void;
