import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({Key? key}) : super(key: key);

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2,'0')}';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    TransactionModel? txn;

    if (args is TransactionModel) {
      txn = args;
    } else if (args is Map) {
      try {
        txn = TransactionModel.fromMap(Map<String, dynamic>.from(args));
      } catch (_) {}
    }

    if (txn == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Transaction Details")),
        body: const Center(child: Text("No details available")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Transaction Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(radius: 48, child: Icon(Icons.shopping_bag, size: 36)),
            const SizedBox(height: 16),
            Text("₹${txn.amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 28, color: Colors.red)),
            const SizedBox(height: 6),
            Text(txn.type.toUpperCase(), style: const TextStyle(letterSpacing: 1.2)),
            const SizedBox(height: 18),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _twoCol("Merchant", txn.merchant ?? "Unknown"),
                    _twoCol("Category", txn.category ?? "Uncategorized"),
                    _twoCol("Date", _formatDate(txn.timestamp)),
                    _twoCol("Type", txn.type),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Message", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(txn.body ?? ""),
            ),
          ],
        ),
      ),
    );
  }

  Widget _twoCol(String left, String right) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(left, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(right, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
