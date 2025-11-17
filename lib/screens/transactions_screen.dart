import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatelessWidget {
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Transactions"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("transactions")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No transactions found."),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              final amount = data["amount"] ?? 0;
              final merchant = data["merchant"] ?? "Unknown";
              final type = data["type"] ?? "debit";
              final timestamp = data["timestamp"] ?? "";
              final body = data["body"] ?? "";

              // Format date
              String formattedDate = "";
              try {
                formattedDate = DateFormat("dd MMM yyyy, hh:mm a")
                    .format(DateTime.parse(timestamp));
              } catch (_) {
                formattedDate = timestamp;
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor:
                    type == "debit" ? Colors.red.shade100 : Colors.green.shade100,
                    child: Icon(
                      type == "debit" ? Icons.arrow_upward : Icons.arrow_downward,
                      color: type == "debit" ? Colors.red : Colors.green,
                    ),
                  ),
                  title: Text(
                    "₹$amount",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    "$merchant\n$formattedDate",
                    style: const TextStyle(height: 1.4),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
