import 'package:flutter/material.dart';
import 'budget_settings_screen.dart';
import 'sms_debug_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget buildCard(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.blue.shade100,
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            buildCard(
              context,
              icon: Icons.account_balance_wallet,
              title: "Budgets",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BudgetSettingsScreen()),
                );
              },
            ),
            buildCard(
              context,
              icon: Icons.sms,
              title: "SMS Debug",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SmsDebugScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
