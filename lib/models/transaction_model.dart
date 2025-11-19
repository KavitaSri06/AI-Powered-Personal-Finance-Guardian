// lib/models/transaction_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final double amount;
  final String type; // 'debit' or 'credit'
  final String merchant;
  final DateTime timestamp;
  final String body;
  final String category;
  final String id; // firestore doc id (optional)

  TransactionModel({
    required this.amount,
    required this.type,
    required this.merchant,
    required this.timestamp,
    required this.body,
    required this.category,
    this.id = '',
  });

  factory TransactionModel.fromMap(Map<String, dynamic> m, {String? id}) {
    // amount may be number or string
    double parsedAmount = 0;
    final a = m['amount'];
    if (a is num) parsedAmount = a.toDouble();
    else if (a is String) {
      // remove commas and currency symbols
      final cleaned = a.replaceAll(RegExp(r'[^0-9.]'), '');
      parsedAmount = double.tryParse(cleaned) ?? 0;
    }

    // timestamp: can be firestore Timestamp, int millis, or ISO string
    DateTime parsedTs = DateTime.now();
    final ts = m['timestamp'];
    if (ts is Timestamp) {
      parsedTs = ts.toDate();
    } else if (ts is int) {
      parsedTs = DateTime.fromMillisecondsSinceEpoch(ts);
    } else if (ts is String) {
      // try ISO or millis string
      parsedTs = DateTime.tryParse(ts) ??
          DateTime.fromMillisecondsSinceEpoch(int.tryParse(ts) ?? 0);
    }

    final t = (m['type'] ?? 'debit').toString();
    final merchant = (m['merchant'] ?? 'Unknown').toString();
    final body = (m['body'] ?? '').toString();
    final category = (m['category'] ?? 'uncategorized').toString();

    return TransactionModel(
      amount: parsedAmount,
      type: t,
      merchant: merchant,
      timestamp: parsedTs,
      body: body,
      category: category,
      id: id ?? '',
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
