import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Section
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, User 👋",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Welcome back to Finance Guardian",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Stats Row
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Today's Spending",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "₹1,250",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "This Week",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "₹8,450",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32),

                // Recent Transactions Section
                Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 16),

                // Transaction List
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildTransactionItem(
                        icon: Icons.restaurant,
                        title: "Restaurant",
                        amount: "₹850",
                        date: "Today, 2:30 PM",
                        color: Colors.orange,
                      ),
                      Divider(height: 1, thickness: 1),
                      _buildTransactionItem(
                        icon: Icons.shopping_bag,
                        title: "Shopping",
                        amount: "₹2,400",
                        date: "Yesterday, 4:15 PM",
                        color: Colors.blue,
                      ),
                      Divider(height: 1, thickness: 1),
                      _buildTransactionItem(
                        icon: Icons.local_gas_station,
                        title: "Fuel",
                        amount: "₹1,200",
                        date: "2 days ago, 10:00 AM",
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32),

                // Go to Dashboard Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Placeholder for navigation
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Go to Dashboard",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String amount,
    required String date,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
