class TransactionModel {
  final double amount;
  final String merchant;
  final String type;
  final DateTime timestamp;
  final String body;
  final String reference;

  TransactionModel({
    required this.amount,
    required this.merchant,
    required this.type,
    required this.timestamp,
    required this.body,
    required this.reference,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      amount: (map["amount"] ?? 0).toDouble(),
      merchant: map["merchant"] ?? "",
      type: map["type"] ?? "",
      timestamp: DateTime.parse(map["timestamp"]),
      body: map["body"] ?? "",
      reference: map["reference"] ?? "",
    );
  }
}
