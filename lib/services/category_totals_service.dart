import '../models/transaction_model.dart';

class CategoryTotalsService {
  /// Backwards compatibility:
  /// Some places in your old code use: CategoryTotalsService.calculate(txns)
  /// We keep it working by forwarding to computeCategoryTotals.
  static Map<String, double> calculate(List<TransactionModel> txns) {
    return computeCategoryTotals(txns);
  }

  /// MAIN METHOD for Insights
  static Map<String, double> computeCategoryTotals(List<TransactionModel> txns) {
    final Map<String, double> totals = {
      "food": 0,
      "shopping": 0,
      "fuel": 0,
      "travel": 0,
      "bills": 0,
      "subscriptions": 0,
      "others": 0,
    };

    for (var t in txns) {
      if (t.type != "debit") continue;

      final category = (t.category ?? "others").trim().toLowerCase();

      if (totals.containsKey(category)) {
        totals[category] = totals[category]! + t.amount;
      } else {
        totals["others"] = totals["others"]! + t.amount;
      }
    }

    return totals;
  }

  /// TODAY's TOTAL
  static double todayTotal(List<TransactionModel> txns) {
    final now = DateTime.now();

    return txns
        .where((t) =>
    t.type == "debit" &&
        t.timestamp.day == now.day &&
        t.timestamp.month == now.month &&
        t.timestamp.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// WEEK TOTAL
  static double weekTotal(List<TransactionModel> txns) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    return txns
        .where((t) =>
    t.type == "debit" &&
        t.timestamp.isAfter(weekStart) &&
        t.timestamp.isBefore(now.add(Duration(days: 1))))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// MONTH TOTAL
  static double monthTotal(List<TransactionModel> txns) {
    final now = DateTime.now();

    return txns
        .where((t) =>
    t.type == "debit" &&
        t.timestamp.month == now.month &&
        t.timestamp.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
