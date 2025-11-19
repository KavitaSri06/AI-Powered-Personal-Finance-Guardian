// lib/utils/category_styles.dart
import 'package:flutter/material.dart';

class CategoryStyles {
  // Returns a small style map: { "color": Color, "icon": IconData }
  // Call: final style = CategoryStyles.getStyle("food");
  static Map<String, dynamic> getStyle(String category) {
    final c = (category ?? "").toLowerCase();

    if (c.contains("food") || c.contains("restaurant") || c.contains("zomato") || c.contains("swiggy")) {
      return {"color": Colors.deepOrange, "icon": Icons.restaurant};
    }

    if (c.contains("shopping") || c.contains("amazon") || c.contains("flipkart") || c.contains("store") || c.contains("mall")) {
      return {"color": Colors.purple, "icon": Icons.shopping_bag};
    }

    if (c.contains("fuel") || c.contains("petrol") || c.contains("diesel") || c.contains("hpcl") || c.contains("indian oil")) {
      return {"color": Colors.amber.shade700, "icon": Icons.local_gas_station};
    }

    if (c.contains("travel") || c.contains("uber") || c.contains("ola") || c.contains("flight") || c.contains("train") || c.contains("bus")) {
      return {"color": Colors.indigo, "icon": Icons.directions_car};
    }

    if (c.contains("bill") || c.contains("electricity") || c.contains("water") || c.contains("broadband") || c.contains("phone")) {
      return {"color": Colors.teal, "icon": Icons.receipt_long};
    }

    if (c.contains("subscr") || c.contains("netflix") || c.contains("spotify") || c.contains("prime") || c.contains("membership")) {
      return {"color": Colors.blueGrey, "icon": Icons.subscriptions};
    }

    // default / unknown
    return {"color": Colors.blue, "icon": Icons.account_balance_wallet};
  }
}
