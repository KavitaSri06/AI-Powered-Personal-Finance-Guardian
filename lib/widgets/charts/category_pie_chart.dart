import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text("No data available"));
    }

    final sections = <PieChartSectionData>[];

    data.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          value: amount,
          title: category,
          radius: 60,
          titleStyle: TextStyle(fontSize: 12, color: Colors.white),
        ),
      );
    });

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
    );
  }
}
