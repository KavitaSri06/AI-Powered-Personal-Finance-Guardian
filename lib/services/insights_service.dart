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

    // category totals
    final catTotals = CategoryTotalsService.calculate(txns);

    // weekly totals (simple)
    List<double> weekly = [0, 0, 0, 0, 0, 0, 0];

    for (var t in txns) {
      int diff = DateTime.now().difference(t.timestamp).inDays;
      if (diff < 7) {
        weekly[6 - diff] += t.amount;
      }
    }

    double avgDaily = totalSpent / 30;
    double projected = avgDaily * 30;

    // messages
    List<String> msgs = [];
    if (catTotals.isNotEmpty) {
      String topCat = catTotals.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      double topAmt = catTotals[topCat]!;
      msgs.add("Your highest spending category is *$topCat* → ₹$topAmt");
    }

    msgs.add("Projected monthly spend: ₹${projected.toStringAsFixed(2)}");

    return InsightsResult(
      totalSpent: totalSpent,
      totalCredited: totalCredited,
      avgDailySpend: avgDaily,
      projectedMonthlySpend: projected,
      categoryTotals: catTotals,
      weeklyTotals: weekly,
      messages: msgs,
    );
  }
}
