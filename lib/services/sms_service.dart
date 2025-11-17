import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsService {
  final SmsQuery _query = SmsQuery();

  /// Request permission to read SMS
  Future<bool> requestPermission() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      status = await Permission.sms.request();
    }
    return status.isGranted;
  }

  /// Read ALL SMS from inbox
  Future<List<SmsMessage>> getAllMessages() async {
    final granted = await requestPermission();
    if (!granted) {
      print("❌ SMS Permission Denied");
      return [];
    }

    try {
      final messages = await _query.getAllSms;
      print("📥 SMS Count: ${messages.length}");
      return messages;
    } catch (e) {
      print("❌ ERROR: $e");
      return [];
    }
  }

  /// Extract financial transactions
  Future<List<Map<String, dynamic>>> extractTransactions() async {
    final messages = await getAllMessages();
    final List<Map<String, dynamic>> txns = [];

    final moneyKeywords = [
      "debited",
      "credited",
      "withdrawn",
      "upi",
      "payment",
      "rs",
      "inr",
      "₹",
      "purchase",
      "spent"
    ];

    // FIXED MASTER REGEXES 🔥
    final amountRegex = RegExp(
      r'(?:INR|Rs\.?|₹)\s*([0-9,]+\.?[0-9]*)',
      caseSensitive: false,
    );

    final merchantRegex = RegExp(
      r'at\s+([A-Za-z0-9 &._-]+)',
      caseSensitive: false,
    );

    final refRegex = RegExp(
      r'(?:UPI|Txn|Ref|Reference)[^A-Za-z0-9]*([A-Za-z0-9]+)',
      caseSensitive: false,
    );

    for (final msg in messages) {
      final bodyRaw = msg.body ?? "";
      final body = bodyRaw.toLowerCase();

      if (!moneyKeywords.any((kw) => body.contains(kw))) continue;

      // ▶ Extract Amount
      final amountMatch = amountRegex.firstMatch(bodyRaw);
      if (amountMatch == null) continue;

      String amtStr = amountMatch.group(1)!.replaceAll(",", "");
      final amount = double.tryParse(amtStr) ?? 0;

      // ▶ Extract Type
      String type = "unknown";
      if (body.contains("debited")) type = "debit";
      if (body.contains("credited")) type = "credit";

      // ▶ Extract Merchant
      final merchantMatch = merchantRegex.firstMatch(bodyRaw);
      String merchant =
          merchantMatch?.group(1)?.replaceAll(".", "").trim() ?? "Unknown";

      // ▶ Extract UPI Reference
      final refMatch = refRegex.firstMatch(bodyRaw);
      String reference = refMatch?.group(1) ?? "N/A";

      txns.add({
        "amount": amount,
        "merchant": merchant,
        "type": type,
        "reference": reference,
        "timestamp": msg.date?.toString() ?? "",
        "body": bodyRaw,
      });
    }

    print("✅ Extracted ${txns.length} transactions");
    return txns;
  }
}
