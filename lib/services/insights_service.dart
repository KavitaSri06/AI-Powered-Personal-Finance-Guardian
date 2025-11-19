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
        weeklyTotals: [0, 0, 0, 0, 0, 0, 0],
        monthlyTotals: List.filled(30, 0),
        messages: ["No transactions found. Scan SMS to get insights."],
      );
    }

    double totalSpent = 0;
    double totalCredited = 0;

    for (var t in txns) {
      if (t.type == "debit") {
        totalSpent += t.amount;
      } else {
        totalCredited += t.amount;
      }
    }

    // CATEGORY TOTALS
    final catTotals = CategoryTotalsService.calculate(txns);

    // WEEKLY TOTALS (LAST 7 DAYS)
    List<double> weekly = List.filled(7, 0);
    for (var t in txns) {
      int diff = DateTime.now().difference(t.timestamp).inDays;
      if (diff < 7) {
        weekly[6 - diff] += t.amount;
      }
    }

    // MONTHLY TOTALS (LAST 30 DAYS)
    List<double> monthly = List.filled(30, 0);
    for (var t in txns) {
      int diff = DateTime.now().difference(t.timestamp).inDays;
      if (diff < 30) {
        monthly[29 - diff] += t.amount;
      }
    }

    // DAILY AVG + PROJECTION
    double avgDaily = totalSpent / 30;
    double projected = avgDaily * 30;

    // 🔥 AI MESSAGES
    List<String> msgs = [];

    // 1️⃣ TOP CATEGORY
    if (catTotals.isNotEmpty) {
      var top = catTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      msgs.add("📌 Highest spending: *${top.key}* → ₹${top.value.toStringAsFixed(2)}");
    }

    // 2️⃣ TODAY VS YESTERDAY SPIKE
    if (weekly.length >= 7) {
      double yesterday = weekly[5];
      double today = weekly[6];
      if (yesterday > 0 && today > yesterday * 1.5) {
        msgs.add("⚠ You spent *${((today / yesterday) * 100).toStringAsFixed(0)}% more* today.");
      }
    }

    // 3️⃣ WEEKLY TREND
    double weekTotal = weekly.reduce((a, b) => a + b);
    if (weekTotal > avgDaily * 7 * 1.2) {
      msgs.add("🔥 Your weekly spending is ~20% higher than normal.");
    }

    // 4️⃣ PROJECTED SPENDING
    msgs.add("📅 Projected monthly spend → ₹${projected.toStringAsFixed(2)}");

    // 5️⃣ INCOME WARNING
    if (totalCredited > 0 && projected > totalCredited) {
      msgs.add("⚠ Your spending projection is higher than your credited income.");
    }

    // 6️⃣ CATEGORY GROWTH WARNING
    catTotals.forEach((cat, amt) {
      if (amt > avgDaily * 6) {
        msgs.add("📈 *$cat* spending is rising faster than usual → ₹$amt this week.");
      }
    });

    // RETURN FINAL RESULT BUNDLE
    return InsightsResult(
      totalSpent: totalSpent,
      totalCredited: totalCredited,
      avgDailySpend: avgDaily,
      projectedMonthlySpend: projected,
      categoryTotals: catTotals,
      weeklyTotals: weekly,
      monthlyTotals: monthly,
      messages: msgs,
    );
  }

  // 🔍 Budget logic
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

        if (percent >= 100) {
          status = "over";
        } else if (percent >= 80) {
          status = "warning";
        }
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
