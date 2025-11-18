import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<double> weeks;

  const MonthlyBarChart({super.key, required this.weeks});

  @override
  Widget build(BuildContext context) {
    if (weeks.isEmpty) {
      return Center(child: Text("No monthly data"));
    }

    return BarChart(
      BarChartData(
        maxY: weeks.reduce((a, b) => a > b ? a : b) + 100,
        barGroups: List.generate(
          weeks.length,
              (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: weeks[i],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
