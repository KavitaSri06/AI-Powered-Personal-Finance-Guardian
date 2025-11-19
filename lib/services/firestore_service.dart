import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../models/budget_model.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;

  // ----------------------------
  // SAVE TRANSACTION
  // ----------------------------
  Future<void> saveTransaction(TransactionModel txn) async {
    await db.collection("transactions").add(txn.toMap());
  }

  // ----------------------------
  // GET ALL TRANSACTIONS
  // ----------------------------
  Future<List<TransactionModel>> getAllTransactions() async {
    final snapshot = await db
        .collection("transactions")
        .orderBy("timestamp", descending: true)
        .get();

    return snapshot.docs
        .map((d) => TransactionModel.fromMap(d.data()))
        .toList();
  }

  // ----------------------------
  // GET RECENT
  // ----------------------------
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    final snapshot = await db
        .collection("transactions")
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((d) => TransactionModel.fromMap(d.data()))
        .toList();
  }

  Future<void> saveBudgetSettings(Map<String, dynamic> data) async {
    await db.collection("users")
        .doc("default_user")
        .collection("settings")
        .doc("budget")
        .set(data);
  }

  Future<Map<String, dynamic>?> getBudgetSettings() async {
    final doc = await db.collection("users")
        .doc("default_user")
        .collection("settings")
        .doc("budget")
        .get();

    return doc.data();
  }

  Future<Map<String, dynamic>> getBudgets() async {
    final doc = await db.collection("users").doc("default_user").get();
    return doc.data()?["budgets"] ?? {
      "monthlyLimit": 0,
      "food": 0,
      "shopping": 0,
      "fuel": 0,
      "travel": 0,
      "bills": 0,
      "subscriptions": 0,
      "others": 0,
    };
  }

}
