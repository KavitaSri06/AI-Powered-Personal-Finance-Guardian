import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveTransaction(Map<String, dynamic> txn) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("❌ ERROR: No user found");
      return;
    }

    await _db
        .collection("users")
        .doc(user.uid)
        .collection("transactions")
        .add(txn);

    print("🔥 Transaction saved to Firestore");
  }
}
