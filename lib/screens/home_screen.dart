import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/cards/summary_card.dart';
import '../widgets/tiles/transaction_tile.dart';
import '../models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finance Guardian")),
      body: FutureBuilder<List<TransactionModel>>(
        future: firestore.getRecentTransactions(limit: 10),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final txns = snapshot.data!;

          double totalSpent = 0, totalCredited = 0;
          for (var t in txns) {
            if (t.type == "debit") {
              totalSpent += t.amount;
            } else {
              totalCredited += t.amount;
            }
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SummaryCard(
                totalSpent: totalSpent,
                totalCredited: totalCredited,
                totalTransactions: txns.length,
              ),
              const SizedBox(height: 20),
              const Text("Recent Transactions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...txns.map((t) => TransactionTile(transaction: t)),
            ],
          );
        },
      ),
    );
  }
}
