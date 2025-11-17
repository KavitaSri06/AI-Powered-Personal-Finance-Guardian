import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test to ensure test framework works',
          (WidgetTester tester) async {
        // Build a simple test widget
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Test Running')),
            ),
          ),
        );

        // Verify the text exists
        expect(find.text('Test Running'), findsOneWidget);
      });
}
