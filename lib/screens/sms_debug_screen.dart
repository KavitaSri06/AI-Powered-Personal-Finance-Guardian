import 'package:flutter/material.dart';
import '../services/sms_service.dart';
import '../services/firestore_service.dart';
import '../models/transaction_model.dart';

class SmsDebugScreen extends StatefulWidget {
  const SmsDebugScreen({super.key});

  @override
  State<SmsDebugScreen> createState() => _SmsDebugScreenState();
}

class _SmsDebugScreenState extends State<SmsDebugScreen> {
  bool loading = false;
  List<TransactionModel> parsed = [];

  Future<void> scanSms() async {
    setState(() => loading = true);

    final sms = SmsService();
    final firestore = FirestoreService();

    final data = await sms.extractTransactions(); // returns List<TransactionModel>

    for (final txn in data) {
      await firestore.saveTransaction(txn);   // FIXED
    }

    setState(() {
      parsed = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SMS Debug Scanner")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: loading ? null : scanSms,
            child: const Text("SCAN SMS"),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: parsed.length,
              itemBuilder: (context, index) {
                final t = parsed[index];
                return ListTile(
                  title: Text("₹${t.amount} • ${t.type}"),
                  subtitle: Text(t.merchant),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
