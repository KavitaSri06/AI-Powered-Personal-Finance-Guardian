// lib/services/insights_service.dart
import 'dart:collection';

import '../models/transaction_model.dart';

class InsightsResult {
  final Map<String, double> categoryTotals;
  final List<double> weeklyTotals; // last 7 days, oldest -> newest
  final double totalSpent;
  final double totalCredited;
  final List<String> insights;

  InsightsResult({
    required this.categoryTotals,
    required this.weeklyTotals,
    required this.totalSpent,
    required this.totalCredited,
    required this.insights,
  });
}

class InsightsService {
  /// Generate insights from a list of transactions.
  /// Expects TransactionModel.timestamp to be DateTime. Defensive about nulls.
  static InsightsResult generateInsights(List<TransactionModel> txns) {
    // normalize
    final now = DateTime.now();

    // CATEGORY totals
    final Map<String, double> catTotals = {};
    double totalSpent = 0;
    double totalCredited = 0;

    for (final t in txns) {
      final amount = t.amount;
      final type = (t.type ?? 'debit').toLowerCase();
      final category = (t.category ?? 'Others').trim();
      catTotals[category] = (catTotals[category] ?? 0) + amount;

      if (type == 'debit') totalSpent += amount;
      if (type == 'credit') totalCredited += amount;
    }

    // Weekly totals (last 7 days)
    // Create 7 buckets: 6 days ago ... today
    final List<double> weekly = List<double>.filled(7, 0);
    for (final t in txns) {
      final ts = t.timestamp ?? now;
      final daysDiff = now.difference(ts).inDays;
      if (daysDiff >= 0 && daysDiff < 7) {
        // bucket index: 6 - daysDiff => so oldest->newest
        final idx = 6 - daysDiff;
        if ((t.type ?? 'debit').toLowerCase() == 'debit') {
          weekly[idx] = weekly[idx] + t.amount;
        }
      }
    }

    // Build insights list (simple rules)
    final List<String> insights = [];

    // Top 3 categories
    final sortedCats = SplayTreeMap<String, double>.fromIterable(
      catTotals.keys,
      value: (k) => catTotals[k]!,
      compare: (a, b) => catTotals[b]!.compareTo(catTotals[a]!), // descending
    );

    if (sortedCats.isNotEmpty) {
      final top = sortedCats.keys.first;
      final topAmount = catTotals[top]!;
      insights.add(
          "Top category: $top — ₹${topAmount.toStringAsFixed(0)} (${_pct(topAmount, totalSpent)}) of your spending.");
      final top3 = sortedCats.keys.take(3).toList();
      if (top3.length > 1) {
        insights.add("Top categories: ${top3.join(', ')}.");
      }
    }

    // Spending trend basic message
    final thisWeek = weekly.sublist(4).fold(0.0, (a, b) => a + b); // last 3 days example
    final weekTotal = weekly.fold(0.0, (a, b) => a + b);
    if (weekTotal > 0) {
      final avg = weekTotal / 7;
      final last = weekly.last;
      if (last > avg * 1.5) {
        insights.add("Spending spike today: ₹${last.toStringAsFixed(0)} (above weekly average).");
      }
    }

    // Overspend warning if monthly extrapolation > threshold (simple heuristic)
    final monthlyEstimate = (weekly.fold(0.0, (a, b) => a + b) / 7) * 30;
    if (monthlyEstimate > 10000) {
      insights.add("Estimated monthly spend ~₹${monthlyEstimate.toStringAsFixed(0)} — consider reviewing budgets.");
    }

    // Credit vs Debit ratio
    if (totalCredited > 0) {
      final ratio = (totalSpent / totalCredited);
      if (ratio > 1.5) {
        insights.add("You are spending ~${ratio.toStringAsFixed(1)}x your credited amount recently.");
      }
    }

    return InsightsResult(
      categoryTotals: catTotals,
      weeklyTotals: weekly,
      totalSpent: totalSpent,
      totalCredited: totalCredited,
      insights: insights,
    );
  }

  static String _pct(double part, double total) {
    if (total <= 0) return "0%";
    final p = (part / total) * 100;
    return "${p.toStringAsFixed(0)}%";
  }
}
