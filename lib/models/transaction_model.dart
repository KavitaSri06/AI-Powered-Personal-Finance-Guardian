class TransactionModel {
  final double amount;
  final String type;
  final String merchant;
  final DateTime timestamp;
  final String body;
  final String category;

  TransactionModel({
    required this.amount,
    required this.type,
    required this.merchant,
    required this.timestamp,
    required this.body,
    required this.category,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    // parse timestamp safely
    DateTime time;

    final ts = map['timestamp'];

    if (ts is int) {
      // millis
      time = DateTime.fromMillisecondsSinceEpoch(ts);
    } else if (ts is String) {
      time = DateTime.tryParse(ts) ?? DateTime.now();
    } else {
      time = DateTime.now();
    }

    return TransactionModel(
      amount: (map['amount'] ?? 0).toDouble(),
      type: map['type'] ?? 'debit',
      merchant: map['merchant'] ?? 'Unknown',
      timestamp: time,
      body: map['body'] ?? '',
      category: map['category'] ?? 'Others',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'type': type,
      'merchant': merchant,
      'timestamp': timestamp.toIso8601String(),
      'body': body,
      'category': category,
    };
  }
}
