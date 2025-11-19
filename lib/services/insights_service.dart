import '../models/transaction_model.dart';
import '../services/category_totals_service.dart';
import 'insights_result.dart';

class InsightsService {
  static InsightsResult generateInsights({
    required List<TransactionModel> txns,
    Map<String, dynamic>? budgets, // 🔥 NEW: user budgets
    double monthlyBudget = 0,       // 🔥 NEW: total monthly budget
  }) {
    if (txns.isEmpty) {
      return InsightsResult(
        totalSpent: 0,
        totalCredited: 0,
        avgDailySpend: 0,
        projectedMonthlySpend: 0,
        categoryTotals: {},
        weeklyTotals: [0, 0, 0, 0, 0, 0, 0],
        messages: ["No transactions found. Scan SMS to get insights."],
      );
    }

    double totalSpent = 0;
    double totalCredited = 0;

    // Sum totals
    for (var t in txns) {
      if (t.type == "debit") totalSpent += t.amount;
      if (t.type == "credit") totalCredited += t.amount;
    }

    // Category totals
    final catTotals = CategoryTotalsService.calculate(txns);

    // Weekly totals
    List<double> weekly = [0, 0, 0, 0, 0, 0, 0];
    for (var t in txns) {
      int diff = DateTime.now().difference(t.timestamp).inDays;
      if (diff < 7) weekly[6 - diff] += t.amount;
    }

    // AI calculations
    double avgDaily = totalSpent / DateTime.now().day;
    double projectedMonth = avgDaily * 30;
    double projectedNextWeek = avgDaily * 7;

    List<String> msgs = [];

    // Highest spending category
    if (catTotals.isNotEmpty) {
      final top = catTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      msgs.add("Your highest spending category is *${top.key}* → ₹${top.value}");
    }

    msgs.add("Predicted next week spend: ₹${projectedNextWeek.toStringAsFixed(2)}");
    msgs.add("Projected monthly spend: ₹${projectedMonth.toStringAsFixed(2)}");

    // 🔥 BUDGET AI LOGIC
    if (monthlyBudget > 0) {
      if (projectedMonth > monthlyBudget) {
        msgs.add("⚠️ You may exceed your monthly budget by ₹${(projectedMonth - monthlyBudget).toStringAsFixed(2)}.");
      } else {
        msgs.add("👍 You are on track! Estimated savings: ₹${(monthlyBudget - projectedMonth).toStringAsFixed(2)}.");
      }
    }

    // 🔥 Category budget warnings
    if (budgets != null && budgets.isNotEmpty) {
      final statuses = computeBudgetStatus(catTotals, budgets);

      for (var s in statuses) {
        if (s["status"] == "over") {
          msgs.add("❌ ${s["category"].toUpperCase()} budget exceeded!");
        } else if (s["status"] == "warning") {
          msgs.add("⚠️ ${s["category"].toUpperCase()} budget at 80%.");
        }
      }
    }

    return InsightsResult(
      totalSpent: totalSpent,
      totalCredited: totalCredited,
      avgDailySpend: avgDaily,
      projectedMonthlySpend: projectedMonth,
      categoryTotals: catTotals,
      weeklyTotals: weekly,
      messages: msgs,
    );
  }

  // Category-based budget calculations
  static List<Map<String, dynamic>> computeBudgetStatus(
      Map<String, double> categoryTotals,
      Map<String, dynamic> budgets) {
    final List<Map<String, dynamic>> result = [];

    categoryTotals.forEach((category, spent) {
      final limit = (budgets[category] ?? 0).toDouble();
      double percent = 0;
      String status = "ok";

      if (limit > 0) {
        percent = (spent / limit) * 100;

        if (percent >= 100) status = "over";
        else if (percent >= 80) status = "warning";
      }

      result.add({
        "category": category,
        "spent": spent,
        "limit": limit,
        "percent": percent,
        "status": status,
      });
    });

    return result;
  }
}
