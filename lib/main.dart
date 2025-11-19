import 'package:finance_guardian/screens/budget_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app/app_navigation.dart';   // ✅ IMPORTANT
import 'screens/sms_debug_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/transaction_details_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.signInAnonymously();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Guardian',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),

      routes: {
        "/smsdebug": (_) => SmsDebugScreen(),
        "/transactions": (_) => TransactionsScreen(),
        "/transactionDetails": (_) => TransactionDetailsScreen(),
        "/insights": (_) => InsightsScreen(),


      },

      home: AppNavigation(), // 👈 now this works
    );
  }
}
