import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyLineChart extends StatelessWidget {
  final List<double> values;

  const WeeklyLineChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Text("No weekly data");
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int i = value.toInt();
                  if (i < 0 || i >= values.length) return const SizedBox();
                  return Text(["D-6","D-5","D-4","D-3","D-2","Yesterday","Today"][i],
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              barWidth: 3,
              spots: [
                for (int i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
