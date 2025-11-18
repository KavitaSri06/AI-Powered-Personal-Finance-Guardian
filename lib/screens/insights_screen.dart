// lib/screens/insights_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../services/insights_service.dart';
import '../services/firestore_service.dart';
import '../widgets/cards/insight_card.dart';
import '../models/transaction_model.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final FirestoreService _fs = FirestoreService();
  bool _loading = true;
  InsightsResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final List<TransactionModel> txns = await _fs.getAllTransactions();
      final res = InsightsService.generateInsights(txns);
      setState(() {
        _result = res;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insights'),
        elevation: 0,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final res = _result!;
    final categories = res.categoryTotals;
    final weekly = res.weeklyTotals;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // AI Summary top card (first generated insight)
          Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Summary',
                      style:
                      Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  if (res.insights.isNotEmpty)
                    Text(res.insights.first,
                        style: Theme.of(context).textTheme.bodyLarge),
                  if (res.insights.length > 1)
                    SizedBox(height: 8),
                  if (res.insights.length > 1)
                    Text(res.insights.sublist(1).join('\n'),
                        style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          SizedBox(height: 14),

          // Category Pie Chart + Legend
          Text('Spending by Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: categories.isEmpty
                ? Center(child: Text('No category data'))
                : Row(
              children: [
                Expanded(child: _buildPieChart(categories)),
                SizedBox(width: 8),
                Expanded(child: _buildLegend(categories)),
              ],
            ),
          ),

          SizedBox(height: 18),

          // Weekly trend (line chart)
          Text('Weekly Trend (last 7 days)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          SizedBox(height: 180, child: _buildLineChart(weekly)),

          SizedBox(height: 18),

          // Insight cards
          Text('Insights', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          ...res.insights.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InsightCard(
              title: s.split('.').first,
              subtitle: s,
              icon: Icons.star_border,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> categories) {
    final total = categories.values.fold(0.0, (a, b) => a + b);
    final sections = <PieChartSectionData>[];
    final colors = [
      Colors.indigo,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.blue,
      Colors.teal,
      Colors.grey
    ];
    int i = 0;
    categories.forEach((k, v) {
      final pct = total > 0 ? (v / total) * 100 : 0;
      sections.add(PieChartSectionData(
        value: v,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 42,
        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        color: colors[i % colors.length],
      ));
      i++;
    });

    return PieChart(PieChartData(
      sections: sections,
      centerSpaceRadius: 28,
      sectionsSpace: 2,
    ));
  }

  Widget _buildLegend(Map<String, double> categories) {
    final total = categories.values.fold(0.0, (a, b) => a + b);
    final palette = [
      Colors.indigo,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.blue,
      Colors.teal,
      Colors.grey
    ];

    int i = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.entries.map((e) {
        final pct = total > 0 ? (e.value / total) * 100 : 0;
        final color = palette[i % palette.length];
        i++;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Container(width: 12, height: 12, color: color),
              SizedBox(width: 8),
              Expanded(child: Text(e.key)),
              Text('₹${e.value.toStringAsFixed(0)}  (${pct.toStringAsFixed(0)}%)'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLineChart(List<double> weekly) {
    // weekly length 7 (oldest -> newest)
    final spots = <FlSpot>[];
    for (int i = 0; i < weekly.length; i++) {
      spots.add(FlSpot(i.toDouble(), weekly[i]));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (weekly.length - 1).toDouble(),
          minY: 0,
          maxY: (weekly.isEmpty ? 10 : (weekly.reduce((a, b) => a > b ? a : b) * 1.2)),
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
                // label days: D-6 ... D0
                final idx = value.toInt();
                final label = ['D-6', 'D-5', 'D-4', 'D-3', 'D-2', 'Yesterday', 'Today'];
                final text = (idx >= 0 && idx < label.length) ? label[idx] : '';
                return Text(text, style: TextStyle(fontSize: 10));
              }),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, meta) {
                return Text('₹${v.toInt()}');
              }),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
