import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/transaction_model.dart';
import '../widgets/tiles/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final firestore = FirestoreService();

  List<TransactionModel> allTxns = [];
  List<TransactionModel> filteredTxns = [];

  String activeFilter = "all";

  @override
  void initState() {
    super.initState();
    loadTxns();
  }

  Future<void> loadTxns() async {
    allTxns = await firestore.getAllTransactions();
    applyFilter("all");
  }

  void applyFilter(String filter) {
    activeFilter = filter;

    DateTime now = DateTime.now();

    setState(() {
      switch (filter) {
        case "debit":
          filteredTxns =
              allTxns.where((t) => t.type == "debit").toList();
          break;

        case "credit":
          filteredTxns =
              allTxns.where((t) => t.type == "credit").toList();
          break;

        case "today":
          filteredTxns = allTxns.where((t) =>
          t.timestamp.day == now.day &&
              t.timestamp.month == now.month &&
              t.timestamp.year == now.year).toList();
          break;

        case "week":
          DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
          filteredTxns = allTxns.where((t) =>
          t.timestamp.isAfter(weekStart) &&
              t.timestamp.isBefore(now.add(Duration(days: 1)))).toList();
          break;

        case "month":
          filteredTxns = allTxns.where((t) =>
          t.timestamp.month == now.month &&
              t.timestamp.year == now.year).toList();
          break;

        default:
          filteredTxns = List.from(allTxns);
      }
    });
  }

  Widget filterButton(String label, String key) {
    bool isActive = activeFilter == key;

    return GestureDetector(
      onTap: () => applyFilter(key),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Transactions"),
        elevation: 0,
      ),
      body: Column(
        children: [
          // -------------------------
          // FILTER BUTTONS ROW
          // -------------------------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                filterButton("All", "all"),
                filterButton("Debit", "debit"),
                filterButton("Credit", "credit"),
                filterButton("Today", "today"),
                filterButton("Week", "week"),
                filterButton("Month", "month"),
              ],
            ),
          ),

          Divider(height: 1),

          // -------------------------
          // TRANSACTION LIST
          // -------------------------
          Expanded(
            child: filteredTxns.isEmpty
                ? Center(
              child: Text(
                "No transactions found",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: filteredTxns.length,
              itemBuilder: (context, index) {
                return TransactionTile(transaction: filteredTxns[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
