import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_guardian/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build the main app
    await tester.pumpWidget(FinanceGuardianApp());

    // Verify that at least one expected widget exists (Login screen)
    expect(find.byType(Scaffold), findsWidgets);
  });
}
