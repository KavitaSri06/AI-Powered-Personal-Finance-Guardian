import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class BudgetSettingsScreen extends StatefulWidget {
  const BudgetSettingsScreen({Key? key}) : super(key: key);

  @override
  State<BudgetSettingsScreen> createState() => _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends State<BudgetSettingsScreen> {
  final firestore = FirestoreService();
  final TextEditingController monthlyController = TextEditingController();

  final Map<String, TextEditingController> categoryControllers = {
    'food': TextEditingController(),
    'shopping': TextEditingController(),
    'bills': TextEditingController(),
    'fuel': TextEditingController(),
    'travel': TextEditingController(),
    'subscriptions': TextEditingController(),
    'others': TextEditingController(),
  };

  bool saving = false;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    try {
      final raw = await firestore.getBudgets();
      if (raw is Map) {
        final map = Map<String, dynamic>.from(raw);
        monthlyController.text = (map['monthly'] ?? '').toString();
        categoryControllers.forEach((k, c) {
          c.text = (map[k] ?? '').toString();
        });
      }
    } catch (e) {
      debugPrint('load budgets error: $e');
    }
  }

  Future<void> _save() async {
    setState(() => saving = true);
    final Map<String, dynamic> budgets = {};
    budgets['monthly'] = double.tryParse(monthlyController.text) ?? 0;
    categoryControllers.forEach((k, c) {
      budgets[k] = double.tryParse(c.text) ?? 0;
    });

    try {
      await firestore.saveBudgets(budgets);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget saved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      setState(() => saving = false);
    }
  }

  Widget _field(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field('Monthly Budget', monthlyController),
            const SizedBox(height: 8),
            const Align(alignment: Alignment.centerLeft, child: Text('Category Budgets', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            _field('Food', categoryControllers['food']!),
            _field('Shopping', categoryControllers['shopping']!),
            _field('Bills', categoryControllers['bills']!),
            _field('Fuel', categoryControllers['fuel']!),
            _field('Travel', categoryControllers['travel']!),
            _field('Subscriptions', categoryControllers['subscriptions']!),
            _field('Others', categoryControllers['others']!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saving ? null : _save,
              child: saving ? const CircularProgressIndicator(color: Colors.white) : const Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
