import 'package:finance_guardian/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// debug screen
import 'screens/sms_debug_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/insights_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Anonymous login
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

      // 👇 HERE ARE THE ROUTES
      routes: {
        "/smsdebug": (_) => SmsDebugScreen(),
        "/transactions": (_) => TransactionsScreen(),
        // insights screen later
      },
      home: HomeScreen(),
    );
  }
}
