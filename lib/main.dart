import 'package:finance_guardian/screens/budget_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app/app_navigation.dart';
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

      // ❗️ DO NOT MAKE THIS const
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),

        fontFamily: "Inter",

        // ⭐ Correct CardThemeData — no const needed
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 15),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      routes: {
        "/smsdebug": (_) => SmsDebugScreen(),
        "/transactions": (_) => TransactionsScreen(),
        "/transactionDetails": (_) => TransactionDetailsScreen(),
        "/insights": (_) => InsightsScreen(),
        "/budgets": (_) => BudgetSettingsScreen(),
      },

      home:  AppNavigation(),
    );
  }
}
