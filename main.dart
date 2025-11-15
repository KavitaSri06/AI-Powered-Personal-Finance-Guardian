import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'insights_screen.dart';
import 'transactions_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(FinanceGuardianApp());
}

class FinanceGuardianApp extends StatefulWidget {
  @override
  _FinanceGuardianAppState createState() => _FinanceGuardianAppState();
}

class _FinanceGuardianAppState extends State<FinanceGuardianApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    DashboardScreen(),
    InsightsScreen(),
    TransactionsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Dashboard"),
            BottomNavigationBarItem(icon: Icon(Icons.insights), label: "Insights"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Transactions"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
