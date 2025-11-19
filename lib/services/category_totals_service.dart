// lib/services/category_totals_service.dart
import '../models/transaction_model.dart';

class CategoryTotalsService {
  /// BACKWARDS-COMPATIBILITY SHIM
  /// Some parts of the code call `CategoryTotalsService.calculate(...)`.
  /// Keep that API working by forwarding to computeCategoryTotals.
  static Map<String, double> calculate(List<TransactionModel> txns) {
    return computeCategoryTotals(txns);
  }

  /// MAIN METHOD → Used by Insights Engine
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
      // skip non-expense transactions
      if (t.type != "debit") continue;

      // protect against nulls and normalize
      final category = (t.category ?? "others").trim().toLowerCase();

      if (totals.containsKey(category)) {
        totals[category] = totals[category]! + t.amount;
      } else {
        totals["others"] = totals["others"]! + t.amount;
      }
    }

    return totals;
  }

  /// DAILY TOTAL
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
    final tomorrow = now.add(Duration(days: 1));

    return txns
        .where((t) =>
    t.type == "debit" &&
        t.timestamp.isAfter(weekStart) &&
        t.timestamp.isBefore(tomorrow))
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
