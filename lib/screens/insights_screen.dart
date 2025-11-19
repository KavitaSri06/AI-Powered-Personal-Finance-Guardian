import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/insights_service.dart';
import '../services/insights_result.dart';
import '../widgets/cards/ai_message_card.dart';
import '../widgets/charts/category_pie_chart.dart';
import '../widgets/charts/weekly_line_chart.dart';
import '../widgets/charts/monthly_bar_chart.dart';


class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final firestore = FirestoreService();

  bool loading = true;
  InsightsResult? result;
  Map<String, dynamic> budgets = {};
  List<Map<String, dynamic>> budgetStatus = [];

  @override
  void initState() {
    super.initState();
    loadInsights();
  }

  Future<void> loadInsights() async {
    final txns = await firestore.getAllTransactions();
    final insights = InsightsService.generateInsights(txns: txns);

    budgets = await firestore.getBudgets();
    budgetStatus =
        InsightsService.computeBudgetStatus(insights.categoryTotals, budgets);

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
      appBar: AppBar(title: const Text("Insights & Analysis")),
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
            _monthlyChartCard(),
            SizedBox(height: 20),
            _budgetCard(),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("AI Financial Summary",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Spending by Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              CategoryPieChart(values: result!.categoryTotals),
              const SizedBox(height: 12),
            ]),
      ),
    );
  }

  Widget _weeklyChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: WeeklyLineChart(values: result!.weeklyTotals),
      ),
    );
  }
  Widget _monthlyChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Monthly Spending Overview",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 🔥 Monthly bar chart
            MonthlyBarChart(
              values: result!.monthlyTotals,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _budgetCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Budget Usage",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...budgetStatus.map((b) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b["category"].toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: (b["limit"] > 0)
                      ? (b["percent"] / 100).clamp(0.0, 1.0)
                      : 0,
                  color: (b["status"] == "over")
                      ? Colors.red
                      : (b["status"] == "warning")
                      ? Colors.orange
                      : Colors.blue,
                ),
                const SizedBox(height: 8),
                Text("₹${b["spent"]} / ₹${b["limit"]}",
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
          );
        })
      ],
    );
  }

  Widget _messagesCard() {
    return Column(
      children: [
        const Text("AI Insights",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...result!.messages.map((msg) => AIMessageCard(message: msg)),
      ],
    );
  }
}
