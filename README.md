# react-native-performance-monitor

Get memory, CPU usage and FPS

## Installation

```sh
npm install @panda-tool/react-native-performance-monitor
```

## Usage

```js
import {
    startMonitoring,
    stopMonitoring,
    type PerformanceData,
} from '@panda-tool/react-native-performance-monitor';

// ...

const [performanceData, setPerformanceData] = useState<PerformanceData>();

useEffect(() => {
startMonitoring((data) => {
    setPerformanceData(data);
});

return () => {
    stopMonitoring();
};
}, []);
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
