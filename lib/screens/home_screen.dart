import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/cards/summary_card.dart';
import '../widgets/tiles/transaction_tile.dart';
import '../models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Finance Guardian"),
        elevation: 0,
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: firestore.getRecentTransactions(limit: 10),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final txns = snapshot.data!;

          // -----------------------------
          //  CALCULATE TOTALS
          // -----------------------------
          double totalSpent = 0;
          double totalCredited = 0;

          for (var t in txns) {
            if (t.type == "debit") {
              totalSpent += t.amount;
            } else {
              totalCredited += t.amount;
            }
          }

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              // -----------------------------
              //  SUMMARY CARD
              // -----------------------------
              SummaryCard(
                totalSpent: totalSpent,
                totalCredited: totalCredited,
                totalTransactions: txns.length,
              ),

              SizedBox(height: 20),

              Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              ...txns.map(
                    (t) => TransactionTile(transaction: t),
              ),
            ],
          );
        },
      ),
    );
  }
}
