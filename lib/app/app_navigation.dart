import 'package:finance_guardian/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/sms_debug_screen.dart';
import '../screens/insights_screen.dart';
import '../screens/budget_settings_screen.dart';

class AppNavigation extends StatefulWidget {
  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    TransactionsScreen(),
    InsightsScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list),
            label: "Transactions",
          ),

          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: "Insights",
          ),


          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),

        ],
      ),
    );
  }
}
