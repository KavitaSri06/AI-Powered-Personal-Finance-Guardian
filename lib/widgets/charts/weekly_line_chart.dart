import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyLineChart extends StatelessWidget {
  final List<double> values;

  const WeeklyLineChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Center(child: Text("No weekly data"));
    }

    return SizedBox(
      height: 240,
      child: LineChart(
        LineChartData(
          minY: 0,
          gridData: FlGridData(show: true, drawVerticalLine: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 36),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final labels = ["D-6", "D-5", "D-4", "D-3", "D-2", "Yesterday", "Today"];
                  int idx = value.toInt();
                  if (idx < 0 || idx >= labels.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[idx],
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
          ),

          borderData: FlBorderData(show: false),

          lineBarsData: [
            LineChartBarData(
              color: Colors.teal,
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withOpacity(0.2),
              ),
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
