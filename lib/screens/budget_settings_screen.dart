import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  final TextEditingController monthlyController = TextEditingController();
  final TextEditingController foodController = TextEditingController();
  final TextEditingController shoppingController = TextEditingController();
  final TextEditingController billsController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController travelController = TextEditingController();
  final TextEditingController othersController = TextEditingController();

  final firestore = FirestoreService();

  void saveBudget() async {
    final data = {
      "monthlyLimit": double.tryParse(monthlyController.text) ?? 0,
      "food": double.tryParse(foodController.text) ?? 0,
      "shopping": double.tryParse(shoppingController.text) ?? 0,
      "bills": double.tryParse(billsController.text) ?? 0,
      "fuel": double.tryParse(fuelController.text) ?? 0,
      "travel": double.tryParse(travelController.text) ?? 0,
      "others": double.tryParse(othersController.text) ?? 0,
    };

    await firestore.saveBudgetSettings(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Budget saved successfully!")),
    );
  }

  Widget budgetField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Text("Monthly Budget",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            budgetField("Enter monthly limit", monthlyController),

            const SizedBox(height: 20),
            const Text("Category Budgets",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            budgetField("Food", foodController),
            budgetField("Shopping", shoppingController),
            budgetField("Bills", billsController),
            budgetField("Fuel", fuelController),
            budgetField("Travel", travelController),
            budgetField("Others", othersController),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveBudget,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                "Save Budget",
                style: TextStyle(fontSize: 17),
              ),
            )
          ],
        ),
      ),
    );
  }
}
