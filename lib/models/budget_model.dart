class BudgetModel {
  double monthlyLimit;
  Map<String, double> categoryLimits;
  bool aiEnabled;

  BudgetModel({
    required this.monthlyLimit,
    required this.categoryLimits,
    this.aiEnabled = false,
  });

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      "monthlyLimit": monthlyLimit,
      "categoryLimits": categoryLimits,
      "aiEnabled": aiEnabled,
    };
  }

  // Read from Firestore Map
  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      monthlyLimit: (map["monthlyLimit"] ?? 0).toDouble(),
      categoryLimits: Map<String, double>.from(
        (map["categoryLimits"] ?? {}).map(
              (key, value) => MapEntry(key, (value ?? 0).toDouble()),
        ),
      ),
      aiEnabled: map["aiEnabled"] ?? false,
    );
  }
}
