import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/category_styles.dart';

class TransactionDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TransactionModel txn =
    ModalRoute.of(context)!.settings.arguments as TransactionModel;

    final style = CategoryStyles.getStyle(txn.category);
    final Color color = style["color"];
    final IconData icon = style["icon"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------------------
            //  Category & Icon
            // ---------------------------
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 40, color: color),
              ),
            ),

            SizedBox(height: 20),

            Center(
              child: Text(
                "₹${txn.amount.toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: txn.type == "debit" ? Colors.red : Colors.green,
                ),
              ),
            ),

            SizedBox(height: 6),
            Center(
              child: Text(
                txn.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),

            SizedBox(height: 25),

            // ---------------------------
            // Details card
            // ---------------------------
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow("Merchant", txn.merchant),
                    _detailRow("Category", txn.category),
                    _detailRow("Date", txn.timestamp.toString()),
                    _detailRow("Type", txn.type),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Text(
              "Message",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),

            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                txn.body,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          Text(value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
