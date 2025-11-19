// lib/services/category_detector.dart
class CategoryDetector {
  // keywords for categories
  static final Map<String, List<String>> _keywords = {
    'food': [
      'zomato', 'swiggy', 'dominos', 'mcdonald', 'restaurant', 'canteen', 'food'
    ],
    'shopping': ['amazon', 'flipkart', 'myntra', 'ajio', 'shopping', 'purchase'],
    'fuel': ['petrol', 'fuel', 'hpcl', 'bharat', 'indianoil', 'petrolpump'],
    'travel': ['uber', 'ola', 'paytm.*cab', 'irctc', 'flight', 'bus', 'train'],
    'bills': ['electricity', 'water', 'bill', 'broadband', 'billing', 'gas'],
    'subscriptions': ['netflix', 'prime', 'spotify', 'hotstar', 'subscription', 'subscription'],
  };

  // merchant -> category overrides (exact-ish)
  static final Map<String, String> _merchantMap = {
    'zomato': 'food',
    'swiggy': 'food',
    'dominos': 'food',
    'amazon': 'shopping',
    'flipkart': 'shopping',
    'uber': 'travel',
    'ola': 'travel',
    'irctc': 'travel',
    'netflix': 'subscriptions',
    'prime': 'subscriptions',
    'spotify': 'subscriptions',
  };

  static String detect(String merchant, String body) {
    final mLower = merchant.toLowerCase();
    final bLower = body.toLowerCase();

    // merchant map first
    for (final key in _merchantMap.keys) {
      if (mLower.contains(key)) return _merchantMap[key]!;
    }

    // keywords on merchant and body
    for (final category in _keywords.keys) {
      final words = _keywords[category]!;
      for (final kw in words) {
        final regex = RegExp(kw, caseSensitive: false);
        if (regex.hasMatch(mLower) || regex.hasMatch(bLower)) {
          return category;
        }
      }
    }

    // fallback: UPI / txn messages often indicate payment (treat as shopping)
    if (bLower.contains('upi') || bLower.contains('txn id') || bLower.contains('debited from your a/c')) {
      return 'shopping';
    }

    return 'uncategorized';
  }
}
