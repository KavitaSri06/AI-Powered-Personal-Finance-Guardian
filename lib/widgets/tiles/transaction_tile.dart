import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../utils/category_styles.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final style = CategoryStyles.getStyle(transaction.category);

    final Color color = style["color"];
    final IconData icon = style["icon"];

    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/transactionDetails",
          arguments: transaction,
        );
      },
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(transaction.merchant,
          style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        transaction.category.toUpperCase(),
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
      trailing: Text(
        "₹${transaction.amount.toStringAsFixed(0)}",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: transaction.type == "debit" ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
