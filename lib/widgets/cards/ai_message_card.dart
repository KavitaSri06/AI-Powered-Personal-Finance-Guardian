import 'package:flutter/material.dart';

class AIMessageCard extends StatelessWidget {
  final String message;

  const AIMessageCard({Key? key, required this.message}) : super(key: key);

  Color _getBackground(String msg) {
    if (msg.contains("❌")) return Colors.red.withOpacity(0.10);
    if (msg.contains("⚠️")) return Colors.orange.withOpacity(0.10);
    if (msg.contains("👍")) return Colors.green.withOpacity(0.10);
    return Colors.blue.withOpacity(0.07);
  }

  Color _getTextColor(String msg) {
    if (msg.contains("❌")) return Colors.red;
    if (msg.contains("⚠️")) return Colors.orange;
    if (msg.contains("👍")) return Colors.green;
    return Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackground(message),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w500,
          color: _getTextColor(message),
        ),
      ),
    );
  }
}
