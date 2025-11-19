import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/insights_service.dart';
import '../services/insights_result.dart';
import '../widgets/charts/category_pie_chart.dart';
import '../widgets/charts/weekly_line_chart.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final firestore = FirestoreService();

  bool loading = true;
  InsightsResult? result;

  @override
  void initState() {
    super.initState();
    loadInsights();
  }

  Future<void> loadInsights() async {
    final txns = await firestore.getAllTransactions();
    final insights = InsightsService.generateInsights(txns: txns);

    setState(() {
      result = insights;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Insights & Analysis"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _summaryCard(),
            const SizedBox(height: 20),
            _pieChartCard(),
            const SizedBox(height: 20),
            _weeklyChartCard(),
            const SizedBox(height: 20),
            _messagesCard(),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("AI Financial Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("• Total Spent: ₹${result!.totalSpent.toStringAsFixed(2)}"),
          Text("• Total Credited: ₹${result!.totalCredited.toStringAsFixed(2)}"),
          Text("• Avg Daily Spend: ₹${result!.avgDailySpend.toStringAsFixed(2)}"),
          Text("• Projected Monthly Spend: ₹${result!.projectedMonthlySpend.toStringAsFixed(2)}"),
        ]),
      ),
    );
  }

  Widget _pieChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Spending by Category",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          CategoryPieChart(values: result!.categoryTotals),
          const SizedBox(height: 12),
          const Divider(),
          ...result!.categoryTotals.entries.map((e) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(e.key.toUpperCase()),
              Text("₹${e.value.toStringAsFixed(2)}"),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _weeklyChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: WeeklyLineChart(values: result!.weeklyTotals),
      ),
    );
  }

  Widget _messagesCard() {
    return Column(
      children: result!.messages.map((m) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(m),
          ),
        );
      }).toList(),
    );
  }
}
