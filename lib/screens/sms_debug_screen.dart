import 'package:flutter/material.dart';
import '../services/sms_service.dart';
import '../services/firestore_service.dart';

class SmsDebugScreen extends StatefulWidget {
  @override
  _SmsDebugScreenState createState() => _SmsDebugScreenState();
}

class _SmsDebugScreenState extends State<SmsDebugScreen> {
  List<Map<String, dynamic>> parsed = [];
  bool isLoading = false;

  Future<void> scanSms() async {
    setState(() => isLoading = true);

    SmsService smsService = SmsService();
    FirestoreService firestore = FirestoreService();

    final data = await smsService.extractTransactions();

    // 🔥 Save to Firestore
    for (final txn in data) {
      await firestore.saveTransaction(txn);
    }

    setState(() {
      parsed = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SMS Debug Scanner")),
      body: Column(
        children: [
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: scanSms,
            child: Text("SCAN SMS"),
          ),

          if (isLoading)
            Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: parsed.length,
              itemBuilder: (context, index) {
                final txn = parsed[index];

                return ListTile(
                  title: Text("₹${txn['amount']}  |  ${txn['type']}"),
                  subtitle: Text("${txn['merchant']}"),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
