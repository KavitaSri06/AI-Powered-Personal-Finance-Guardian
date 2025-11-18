import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double totalSpent;
  final double totalCredited;
  final int totalTransactions;

  const SummaryCard({
    super.key,
    required this.totalSpent,
    required this.totalCredited,
    required this.totalTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Overview",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Total Spent: ₹${totalSpent.toStringAsFixed(2)}"),
            Text("Total Credited: ₹${totalCredited.toStringAsFixed(2)}"),
            Text("Transactions: $totalTransactions"),
          ],
        ),
      ),
    );
  }
}
