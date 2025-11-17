import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finance Guardian"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Greeting Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "👋 Welcome back!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Track your spending and stay safe financially.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Quick Buttons
            Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(
                  context,
                  icon: Icons.sms,
                  label: "Scan SMS",
                  onTap: () => Navigator.pushNamed(context, "/smsdebug"),
                ),
                _actionButton(
                  context,
                  icon: Icons.list_alt,
                  label: "Transactions",
                  onTap: () => Navigator.pushNamed(context, "/transactions"),
                ),
                _actionButton(
                  context,
                  icon: Icons.insights,
                  label: "Insights",
                  onTap: () => Navigator.pushNamed(context, "/insights"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext context,
      {required IconData icon, required String label, required Function onTap}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.indigo.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.indigo.shade900),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
