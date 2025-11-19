import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../utils/category_styles.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;   // <-- IMPORTANT NAME

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyles.getStyle(transaction.category);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: style.color.withOpacity(0.2),
        child: Icon(style.icon, color: style.color),
      ),
      title: Text(
        transaction.merchant,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${transaction.category.toUpperCase()} • ${transaction.type}",
      ),
      trailing: Text(
        "₹${transaction.amount.toStringAsFixed(2)}",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: transaction.type == "debit" ? Colors.red : Colors.green,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          "/transactionDetails",
          arguments: transaction,
        );
      },
    );
  }
}
