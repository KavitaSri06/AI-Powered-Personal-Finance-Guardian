class CategoryDetector {
  static String detect(String merchant, String body) {
    final text = (merchant + " " + body).toLowerCase();

    // ---------------------------------------
    // 1️⃣ FOOD & DINING
    // ---------------------------------------
    const foodKeywords = [
      "zomato",
      "swiggy",
      "pizza",
      "kfc",
      "burger",
      "mcdonald",
      "eatery",
      "restaurant",
      "hotel",
      "café",
      "coffee",
      "food",
      "mess"
    ];

    if (_match(text, foodKeywords)) return "Food";

    // ---------------------------------------
    // 2️⃣ SHOPPING
    // ---------------------------------------
    const shoppingKeywords = [
      "amazon",
      "flipkart",
      "myntra",
      "ajio",
      "store",
      "shop",
      "mart",
      "bigbazaar",
      "croma",
      "lifestyle",
      "reliance",
      "pantaloons",
      "dmart"
    ];

    if (_match(text, shoppingKeywords)) return "Shopping";

    // ---------------------------------------
    // 3️⃣ FUEL / PETROL
    // ---------------------------------------
    const fuelKeywords = [
      "hpcl",
      "bpcl",
      "ioc",
      "petrol",
      "fuel",
      "gas",
      "pump",
    ];

    if (_match(text, fuelKeywords)) return "Fuel";

    // ---------------------------------------
    // 4️⃣ TRAVEL / TRANSPORT
    // ---------------------------------------
    const travelKeywords = [
      "ola",
      "uber",
      "rapido",
      "irctc",
      "train",
      "flight",
      "air",
      "bus",
      "metro",
      "cab"
    ];

    if (_match(text, travelKeywords)) return "Travel";

    // ---------------------------------------
    // 5️⃣ BILLS & UTILITIES
    // ---------------------------------------
    const billsKeywords = [
      "electricity",
      "bescom",
      "tneb",
      "bsnl",
      "jio",
      "airtel",
      "wifi",
      "broadband",
      "gas bill",
      "water bill",
      "postpaid",
      "prepaid",
      "dth",
      "tatasky"
    ];

    if (_match(text, billsKeywords)) return "Bills";

    // ---------------------------------------
    // 6️⃣ SUBSCRIPTIONS
    // ---------------------------------------
    const subscriptionKeywords = [
      "netflix",
      "spotify",
      "youtube",
      "prime",
      "hotstar",
      "zee5",
      "sonyliv",
      "membership",
      "subscription"
    ];

    if (_match(text, subscriptionKeywords)) return "Subscriptions";

    // ---------------------------------------
    // DEFAULT
    // ---------------------------------------
    return "General";
  }

  // Utility matcher
  static bool _match(String text, List<String> patterns) {
    for (final p in patterns) {
      if (text.contains(p)) return true;
    }
    return false;
  }
}
