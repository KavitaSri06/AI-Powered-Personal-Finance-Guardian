import 'package:flutter/material.dart';

class CategoryStyle {
  final IconData icon;
  final Color color;
  final String label;

  CategoryStyle({
    required this.icon,
    required this.color,
    required this.label,
  });
}

class CategoryStyles {
  static final Map<String, CategoryStyle> _styles = {
    "food": CategoryStyle(
      icon: Icons.fastfood,
      color: Colors.orange,
      label: "Food",
    ),
    "shopping": CategoryStyle(
      icon: Icons.shopping_bag,
      color: Colors.purple,
      label: "Shopping",
    ),
    "fuel": CategoryStyle(
      icon: Icons.local_gas_station,
      color: Colors.blueGrey,
      label: "Fuel",
    ),
    "travel": CategoryStyle(
      icon: Icons.flight,
      color: Colors.teal,
      label: "Travel",
    ),
    "bills": CategoryStyle(
      icon: Icons.receipt_long,
      color: Colors.indigo,
      label: "Bills",
    ),
    "subscriptions": CategoryStyle(
      icon: Icons.subscriptions,
      color: Colors.green,
      label: "Subscriptions",
    ),
    "others": CategoryStyle(
      icon: Icons.category,
      color: Colors.grey,
      label: "Others",
    ),
  };

  static CategoryStyle getStyle(String? category) {
    final key = category?.toLowerCase().trim() ?? "others";

    return _styles[key] ?? _styles["others"]!;
  }
}
