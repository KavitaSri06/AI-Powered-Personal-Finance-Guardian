import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        transaction.type == "debit"
            ? Icons.arrow_upward
            : Icons.arrow_downward,
        color: transaction.type == "debit" ? Colors.red : Colors.green,
      ),
      title: Text("₹${transaction.amount}"),
      subtitle: Text(transaction.merchant),
      trailing: Text(
        "${transaction.timestamp.day}/${transaction.timestamp.month}",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
