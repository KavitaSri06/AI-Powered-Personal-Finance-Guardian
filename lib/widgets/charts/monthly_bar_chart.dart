import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<double> values;

  const MonthlyBarChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.length != 12) {
      return const Text("Invalid monthly data");
    }

    return SizedBox(
      height: 240,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const months = ["J","F","M","A","M","J","J","A","S","O","N","D"];
                  if (value.toInt() < 0 || value.toInt() > 11) return Container();
                  return Text(months[value.toInt()]);
                },
              ),
            ),
          ),

          barGroups: List.generate(12, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: values[i],
                  width: 12,
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
