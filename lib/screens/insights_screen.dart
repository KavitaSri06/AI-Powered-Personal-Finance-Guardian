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
    if (loading || result == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insights & Analysis"),
        elevation: 0,
      ),
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
            const SizedBox(height: 20),

            _budgetCard(),
            const SizedBox(height: 20),

            _messagesCard(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SUMMARY CARD
  // ------------------------------------------------------------
  Widget _summaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("AI Financial Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Text("• Total Spent: ₹${result!.totalSpent.toStringAsFixed(2)}"),
              Text("• Total Credited: ₹${result!.totalCredited.toStringAsFixed(2)}"),
              Text("• Avg Daily Spend: ₹${result!.avgDailySpend.toStringAsFixed(2)}"),
              Text("• Projected Monthly Spend: ₹${result!.projectedMonthlySpend.toStringAsFixed(2)}"),
            ]),
      ),
    );
  }

  // ------------------------------------------------------------
  // PIE CHART + LEGEND BELOW
  // ------------------------------------------------------------
  Widget _pieChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Spending by Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Clean pie chart (no labels inside)
              CategoryPieChart(values: result!.categoryTotals),

              const SizedBox(height: 20),
              const Divider(),

              // Clean LEGEND
              const SizedBox(height: 10),
              ...result!.categoryTotals.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      Text("₹${e.value.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              })
            ]),
      ),
    );
  }

  // ------------------------------------------------------------
  // WEEKLY TREND CHART
  // ------------------------------------------------------------
  Widget _weeklyChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weekly Trend",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            WeeklyLineChart(values: result!.weeklyTotals),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // MONTHLY BAR CHART
  // ------------------------------------------------------------
  Widget _monthlyChartCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Monthly Spending Overview",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            MonthlyBarChart(values: result!.monthlyTotals),
          ],
        ),
      ),
    );
  }


  // ------------------------------------------------------------
  // BUDGET PROGRESS CARD
  // ------------------------------------------------------------
  Widget _budgetCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Budget Usage",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),

        ...budgetStatus.map((b) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b["category"].toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 6),

                  LinearProgressIndicator(
                    value: (b["percent"] / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    color: (b["status"] == "over")
                        ? Colors.red
                        : (b["status"] == "warning")
                        ? Colors.orange
                        : Colors.indigo,
                  ),

                  const SizedBox(height: 8),
                  Text("₹${b["spent"]} / ₹${b["limit"]}",
                      style:
                      const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
          );
        })
      ],
    );
  }

  // ------------------------------------------------------------
  // AI INSIGHTS MESSAGES
  // ------------------------------------------------------------
  Widget _messagesCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("AI Insights",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),

        ...result!.messages.map((msg) => AIMessageCard(message: msg)),
      ],
    );
  }
}
