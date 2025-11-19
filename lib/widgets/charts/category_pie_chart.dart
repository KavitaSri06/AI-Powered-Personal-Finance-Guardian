import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> values;

  const CategoryPieChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return const Center(child: Text("No data available"));
    }

    final total = values.values.fold(0.0, (a, b) => a + b);

    final sections = values.entries.map((e) {
      final percent = total == 0 ? 0 : (e.value / total * 100);

      return PieChartSectionData(
        value: e.value,
        radius: 55,
        color: _getColor(e.key),
        title: percent == 0 ? "" : "${percent.toStringAsFixed(0)}%",
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 220,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          startDegreeOffset: -90,
          sections: sections,
        ),
      ),
    );
  }

  /// Nice category colors
  Color _getColor(String category) {
    switch (category.toLowerCase()) {
      case "shopping":
        return Colors.purple.shade400;
      case "food":
        return Colors.orange.shade400;
      case "fuel":
        return Colors.blue.shade400;
      case "travel":
        return Colors.green.shade400;
      case "bills":
        return Colors.red.shade400;
      case "subscriptions":
        return Colors.teal.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
