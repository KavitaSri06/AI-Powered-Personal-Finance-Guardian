import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/firestore_service.dart';
import '../widgets/tiles/transaction_tile.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final firestore = FirestoreService();

  List<TransactionModel> all = [];
  List<TransactionModel> filtered = [];

  String search = "";
  String typeFilter = "all";
  String categoryFilter = "all";
  String dateFilter = "all";

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    all = await firestore.getAllTransactions();
    applyFilters();
  }

  void applyFilters() {
    List<TransactionModel> data = all;

    // Search
    if (search.isNotEmpty) {
      data = data.where((t) =>
      t.merchant.toLowerCase().contains(search.toLowerCase()) ||
          t.body.toLowerCase().contains(search.toLowerCase())).toList();
    }

    // Type
    if (typeFilter != "all") {
      data = data.where((t) => t.type == typeFilter).toList();
    }

    // Category
    if (categoryFilter != "all") {
      data = data.where((t) => t.category == categoryFilter).toList();
    }

    // Date Filter
    DateTime now = DateTime.now();
    if (dateFilter == "today") {
      data = data.where((t) =>
      t.timestamp.day == now.day &&
          t.timestamp.month == now.month &&
          t.timestamp.year == now.year).toList();
    } else if (dateFilter == "week") {
      data = data.where((t) => now.difference(t.timestamp).inDays <= 7).toList();
    } else if (dateFilter == "month") {
      data = data.where((t) =>
      t.timestamp.month == now.month &&
          t.timestamp.year == now.year).toList();
    }

    setState(() => filtered = data);
  }

  Widget filterChip(String label, String value, String group, Function(String) onSelected) {
    bool selected = value == group;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() {
        onSelected(label.toLowerCase());
        applyFilters();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: load,
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Search
          TextField(
            decoration: InputDecoration(
              hintText: "Search transactions...",
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: (v) {
              search = v;
              applyFilters();
            },
          ),

          SizedBox(height: 12),

          // Filters
          Wrap(
            spacing: 8,
            children: [
              filterChip("All", dateFilter, "all", (v) => dateFilter = "all"),
              filterChip("Today", dateFilter, "today", (v) => dateFilter = "today"),
              filterChip("Week", dateFilter, "week", (v) => dateFilter = "week"),
              filterChip("Month", dateFilter, "month", (v) => dateFilter = "month"),
            ],
          ),

          SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              filterChip("All", typeFilter, "all", (v) => typeFilter = "all"),
              filterChip("Debit", typeFilter, "debit", (v) => typeFilter = "debit"),
              filterChip("Credit", typeFilter, "credit", (v) => typeFilter = "credit"),
            ],
          ),

          SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              filterChip("All", categoryFilter, "all", (v) => categoryFilter = "all"),
              filterChip("Shopping", categoryFilter, "shopping", (v) => categoryFilter = "shopping"),
              filterChip("Food", categoryFilter, "food", (v) => categoryFilter = "food"),
              filterChip("Bills", categoryFilter, "bills", (v) => categoryFilter = "bills"),
              filterChip("Fuel", categoryFilter, "fuel", (v) => categoryFilter = "fuel"),
            ],
          ),

          SizedBox(height: 20),

          // ----------------------
          // USE TransactionTile HERE
          // ----------------------
          ...filtered.map((t) => TransactionTile(transaction: t)).toList(),
        ],
      ),
    );
  }
}
