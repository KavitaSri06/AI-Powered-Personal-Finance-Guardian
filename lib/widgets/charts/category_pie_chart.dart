import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> values;

  const CategoryPieChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Text("No data available");
    }

    final sections = values.entries.map((e) {
      return PieChartSectionData(
        value: e.value,
        title: e.key,
        radius: 60,
        titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
      );
    }).toList();

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
