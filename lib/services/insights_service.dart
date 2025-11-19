import '../models/transaction_model.dart';
import 'insights_result.dart';
import 'category_totals_service.dart';

class InsightsService {
  static InsightsResult generateInsights({required List<TransactionModel> txns}) {
    if (txns.isEmpty) {
      return InsightsResult(
        totalSpent: 0,
        totalCredited: 0,
        avgDailySpend: 0,
        projectedMonthlySpend: 0,
        categoryTotals: {},
        weeklyTotals: List.filled(7, 0),
        monthlyTotals: List.filled(12, 0),   // 🔥 NEW
        messages: ["No transactions found. Scan SMS to get insights."],
      );
    }

    double totalSpent = 0;
    double totalCredited = 0;

    for (var t in txns) {
      if (t.type == "debit") totalSpent += t.amount;
      else totalCredited += t.amount;
    }

    // CATEGORY TOTALS
    final catTotals = CategoryTotalsService.calculate(txns);

    // WEEKLY TOTALS
    List<double> weekly = List.filled(7, 0);
    for (var t in txns) {
      int diff = DateTime.now().difference(t.timestamp).inDays;
      if (diff < 7 && diff >= 0) weekly[6 - diff] += t.amount;
    }

    // MONTHLY TOTALS (12 MONTHS ONLY)
    List<double> monthlyTotals = List.filled(12, 0);

    for (var t in txns) {
      if (t.type == "debit") {
        int monthIndex = t.timestamp.month - 1; // Jan = 0
        monthlyTotals[monthIndex] += t.amount;
      }
    }

    double avgDaily = totalSpent / 30;
    double projected = avgDaily * 30;

    // AI MESSAGES
    List<String> msgs = [];

    // TOP CATEGORY
    if (catTotals.isNotEmpty) {
      var topEntry = catTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      msgs.add("📌 Highest spending: *${topEntry.key}* → ₹${topEntry.value}");
    }

    // SPENDING SPIKE
    if (weekly.length >= 2) {
      double yesterday = weekly[5];
      double today = weekly[6];

      if (yesterday > 0 && today > yesterday * 1.5) {
        msgs.add("🔥 Today you spent ~${((today / yesterday) * 100).toStringAsFixed(0)}% more than yesterday.");
      }
    }

    // PROJECTED MONTHLY SPEND
    msgs.add("📅 Projected monthly spend → ₹${projected.toStringAsFixed(2)}");

    // CATEGORY SPIKE (WEEK)
    catTotals.forEach((cat, amt) {
      if (amt > avgDaily * 6) {
        msgs.add("📈 *$cat* spending is rising unusually → ₹$amt this week.");
      }
    });

    return InsightsResult(
      totalSpent: totalSpent,
      totalCredited: totalCredited,
      avgDailySpend: avgDaily,
      projectedMonthlySpend: projected,
      categoryTotals: catTotals,
      weeklyTotals: weekly,
      monthlyTotals: monthlyTotals,  // 🔥 ADDED
      messages: msgs,
    );
  }

  static List<Map<String, dynamic>> computeBudgetStatus(
      Map<String, double> categoryTotals,
      Map<String, dynamic> budgets) {
    final List<Map<String, dynamic>> result = [];

    categoryTotals.forEach((category, spent) {
      final limit = (budgets[category] ?? 0).toDouble();
      double percent = (limit > 0) ? (spent / limit) * 100 : 0;

      result.add({
        "category": category,
        "spent": spent,
        "limit": limit,
        "percent": percent,
        "status": percent >= 100
            ? "over"
            : percent >= 80
            ? "warning"
            : "ok",
      });
    });

    return result;
  }
}
