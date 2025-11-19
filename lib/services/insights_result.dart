class InsightsResult {
  final double totalSpent;
  final double totalCredited;
  final double avgDailySpend;
  final double projectedMonthlySpend;

  final Map<String, double> categoryTotals;

  final List<double> weeklyTotals;     // 7 days
  final List<double> monthlyTotals;    // 30 days for bar chart

  final List<String> messages;

  InsightsResult({
    required this.totalSpent,
    required this.totalCredited,
    required this.avgDailySpend,
    required this.projectedMonthlySpend,
    required this.categoryTotals,
    required this.weeklyTotals,
    required this.monthlyTotals,
    required this.messages,
  });
}
