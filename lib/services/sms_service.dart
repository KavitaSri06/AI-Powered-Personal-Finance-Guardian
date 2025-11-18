import 'package:flutter/services.dart';
import 'package:finance_guardian/services/category_detector.dart';
import '../models/transaction_model.dart';

class SmsService {
  static const platform = MethodChannel('sms_reader');

  Future<List<TransactionModel>> extractTransactions() async {
    try {
      final List<dynamic> smsList =
          await platform.invokeMethod("getSms") ?? [];

      print("📥 SMS Count: ${smsList.length}");

      List<TransactionModel> parsed = [];

      for (var sms in smsList) {
        final String body = sms["body"]?.toString() ?? "";
        final int timestampMillis = sms["date"] ?? 0;

        if (body.isEmpty) continue;

        // ---------------------------------------------------
        // 1️⃣ Extract Amount
        // ---------------------------------------------------
        final amountRegex = RegExp(r'Rs\.?\s?([\d,]+\.?\d*)');
        final amountMatch = amountRegex.firstMatch(body);

        if (amountMatch == null) continue;

        final amountStr = amountMatch.group(1)!.replaceAll(",", "");
        final double amount = double.tryParse(amountStr) ?? 0;

        // ---------------------------------------------------
        // 2️⃣ Extract Merchant
        // ---------------------------------------------------
        final merchantRegex = RegExp(r'at\s+([A-Za-z0-9 &.\-]+)');
        final merchantMatch = merchantRegex.firstMatch(body);

        final String merchant = merchantMatch != null
            ? merchantMatch.group(1)!.trim()
            : "Unknown";

        // ---------------------------------------------------
        // 3️⃣ Transaction Type
        // ---------------------------------------------------
        final lower = body.toLowerCase();

        final String type = lower.contains("debited")
            ? "debit"
            : lower.contains("credited")
            ? "credit"
            : "unknown";

        // ---------------------------------------------------
        // 4️⃣ Convert timestamp
        // ---------------------------------------------------
        final DateTime timestamp =
        DateTime.fromMillisecondsSinceEpoch(timestampMillis);

        // ---------------------------------------------------
        // 5️⃣ CATEGORY DETECTION ENGINE
        // ---------------------------------------------------
        final String category =
        CategoryDetector.detect(merchant, body);

        // ---------------------------------------------------
        // 6️⃣ Build TransactionModel
        // ---------------------------------------------------
        final txn = TransactionModel(
          amount: amount,
          type: type,
          merchant: merchant,
          timestamp: timestamp,
          body: body,
          category: category,
        );

        parsed.add(txn);
      }

      print("✅ Extracted ${parsed.length} transactions");
      return parsed;

    } catch (e) {
      print("❌ SMS parsing error: $e");
      return [];
    }
  }
}
