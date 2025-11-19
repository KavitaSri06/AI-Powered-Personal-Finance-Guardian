// lib/services/sms_service.dart
import 'package:flutter/services.dart';
import '../models/transaction_model.dart';
import 'category_detector.dart';

class SmsService {
  static const MethodChannel _channel = MethodChannel('sms_reader');

  /// Returns parsed TransactionModel list
  Future<List<TransactionModel>> extractTransactions() async {
    try {
      final List<dynamic>? raw =
      await _channel.invokeMethod<List<dynamic>>('getSms');

      final smsList = raw ?? [];

      print("📥 SMS Count: ${smsList.length}");

      final List<TransactionModel> parsed = [];

      for (var s in smsList) {
        if (s is! Map) continue;
        final map = Map<String, dynamic>.from(s);

        final body = (map['body'] ?? map['message'] ?? '').toString();
        final dateRaw = map['date'] ?? map['timestamp'] ?? map['time'] ?? 0;

        if (body.trim().isEmpty) continue;

        // amount regex, tolerant with commas and symbols
        final amountRegex = RegExp(r'(?:rs\.?|inr|₹)\s*\.?([\d,]+\.?\d*)', caseSensitive: false);
        final match = amountRegex.firstMatch(body);
        if (match == null) {
          // fallback: look for numbers like 1250.00 or 1,250.00
          final fallback = RegExp(r'([\d,]+\.\d{2})').firstMatch(body);
          if (fallback == null) continue;
        }

        String amountStr = '';
        final m = amountRegex.firstMatch(body);
        if (m != null) amountStr = m.group(1) ?? '';
        else {
          final f = RegExp(r'([\d,]+\.\d{2})').firstMatch(body);
          amountStr = f?.group(1) ?? '';
        }
        amountStr = amountStr.replaceAll(',', '');
        final amount = double.tryParse(amountStr) ?? 0.0;

        // merchant heuristics
        final merchantRegex = RegExp(r'at\s+([A-Za-z0-9 &.\-]{2,40})', caseSensitive: false);
        final mm = merchantRegex.firstMatch(body);
        final merchant = mm != null ? mm.group(1)!.trim() : (map['address'] ?? 'Unknown').toString();

        // type
        final type = body.toLowerCase().contains('credited') ? 'credit' : 'debit';

        // timestamp
        DateTime ts = DateTime.now();
        if (dateRaw is int) {
          ts = DateTime.fromMillisecondsSinceEpoch(dateRaw);
        } else if (dateRaw is String) {
          ts = DateTime.tryParse(dateRaw) ?? DateTime.fromMillisecondsSinceEpoch(int.tryParse(dateRaw) ?? 0);
        }

        // category detection
        final category = CategoryDetector.detect(merchant, body);

        final txn = TransactionModel(
          amount: amount,
          type: type,
          merchant: merchant,
          timestamp: ts,
          body: body,
          category: category,
        );

        parsed.add(txn);
      }

      print("✅ Extracted ${parsed.length} transactions");
      return parsed;
    } on MissingPluginException catch (e) {
      print("❌ SMS parsing error: $e");
      // fallback: return empty list
      return [];
    } catch (e) {
      print("❌ SMS parsing error: $e");
      return [];
    }
  }
}
