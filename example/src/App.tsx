import React from 'react';
import { useEffect, useState } from 'react';

import { StyleSheet, View, Text } from 'react-native';
import {
  startMonitoring,
  stopMonitoring,
  type PerformanceData,
} from 'react-native-performance-monitor';

export default function App() {
  const [performanceData, setPerformanceData] = useState<PerformanceData>();

  useEffect(() => {
    startMonitoring((data) => {
      setPerformanceData(data);
    });

    return () => {
      stopMonitoring();
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.result}>
        {performanceData ? JSON.stringify(performanceData) : 'No data'}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
  result: {
    fontSize: 20,
    fontWeight: 'bold',
    color: 'green',
  },
});
