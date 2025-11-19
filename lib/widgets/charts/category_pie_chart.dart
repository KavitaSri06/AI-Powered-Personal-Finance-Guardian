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

    final total = values.values.fold(0.0, (a, b) => a + b);

    final sections = values.entries.map((e) {
      final percent = (e.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: e.value,
        color: _colorFor(e.key),
        radius: 55,
        title: "$percent%",
        titleStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 40,
              sectionsSpace: 2,
              sections: sections,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Legend (labels + colors)
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: values.keys.map((cat) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _colorFor(cat),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(cat.toUpperCase(), style: const TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        )
      ],
    );
  }

  Color _colorFor(String category) {
    switch (category.toLowerCase()) {
      case "food": return Colors.orange;
      case "shopping": return Colors.purple;
      case "fuel": return Colors.blue;
      case "travel": return Colors.green;
      case "bills": return Colors.red;
      case "subscriptions": return Colors.teal;
      default: return Colors.grey;
    }
  }
}
