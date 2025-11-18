import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> saveTransaction(TransactionModel txn) async {
    await db.collection("transactions").add(txn.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final snap = await db
          .collection("transactions")
          .orderBy("timestamp", descending: true)
          .get();

      return snap.docs
          .map((doc) => TransactionModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("🔥 Firestore getAllTransactions error: $e");
      return [];
    }
  }

  Future<List<TransactionModel>> getRecentTransactions({int limit = 10}) async {
    try {
      final snap = await db
          .collection("transactions")
          .orderBy("timestamp", descending: true)
          .limit(limit)
          .get();

      return snap.docs
          .map((doc) => TransactionModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("🔥 Firestore getRecentTransactions error: $e");
      return [];
    }
  }

}
