import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ----------------------------------------------------------
  // SAVE TRANSACTION
  // ----------------------------------------------------------
  Future<void> saveTransaction(TransactionModel txn) async {
    await _db.collection("transactions").add(txn.toMap());
  }

  // ----------------------------------------------------------
  // GET ALL TRANSACTIONS
  // ----------------------------------------------------------
  Future<List<TransactionModel>> getAllTransactions() async {
    final snapshot = await _db
        .collection("transactions")
        .orderBy("timestamp", descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList();
  }

  // ----------------------------------------------------------
  // 🔥 RESTORED: GET RECENT TRANSACTIONS
  // ----------------------------------------------------------
  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    final snapshot = await _db
        .collection("transactions")
        .orderBy("timestamp", descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList();
  }

  // ----------------------------------------------------------
  // SAVE BUDGETS
  // ----------------------------------------------------------
  Future<void> saveBudgets(Map<String, dynamic> budgets) async {
    await _db.collection("settings").doc("budgets").set(budgets);
  }

  // ----------------------------------------------------------
  // GET BUDGETS
  // ----------------------------------------------------------
  Future<Map<String, dynamic>> getBudgets() async {
    final doc = await _db.collection("settings").doc("budgets").get();

    if (!doc.exists) {
      return {
        "monthly": 0.0,
        "food": 0.0,
        "shopping": 0.0,
        "bills": 0.0,
        "fuel": 0.0,
        "travel": 0.0,
        "others": 0.0,
      };
    }

    return doc.data() ?? {};
  }
}
