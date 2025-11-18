import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyLineChart extends StatelessWidget {
  final List<double> data;

  const WeeklyLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text("No weekly data"));
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: data.reduce((a, b) => a > b ? a : b) + 100,

        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
                  (i) => FlSpot(i.toDouble(), data[i]),
            ),
            isCurved: true,
            barWidth: 3,
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
