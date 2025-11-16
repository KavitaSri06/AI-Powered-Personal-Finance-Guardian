import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSettingsItem(
            context: context,
            icon: Icons.account_balance_wallet,
            title: "Edit Income",
            onTap: () {
              _showEditIncomeDialog(context);
            },
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.category,
            title: "Manage Categories",
            onTap: () {
              _showManageCategoriesDialog(context);
            },
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.notifications,
            title: "Notification Settings",
            onTap: () {
              _showNotificationSettingsDialog(context);
            },
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.file_download,
            title: "Export Data (PDF/CSV)",
            onTap: () {
              _showExportDataDialog(context);
            },
          ),
          _buildSettingsItem(
            context: context,
            icon: Icons.info,
            title: "About App",
            onTap: () {
              _showAboutAppDialog(context);
            },
          ),
          SizedBox(height: 16),
          _buildSettingsItem(
            context: context,
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              _showLogoutDialog(context);
            },
            isDestructive: true,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withValues(alpha: 0.1)
                : Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Colors.blue,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDestructive ? Colors.red : Colors.grey[900],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showEditIncomeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Income"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Monthly Income",
                hintText: "Enter amount",
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Income updated successfully")),
              );
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showManageCategoriesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Manage Categories"),
        content: Text("Category management feature coming soon!"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notification Settings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text("Daily Reminders"),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text("Budget Alerts"),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text("Weekly Reports"),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Done"),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Export Data"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text("Export as PDF"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("PDF export initiated")),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.table_chart, color: Colors.green),
              title: Text("Export as CSV"),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("CSV export initiated")),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("About App"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Finance Guardian",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text("Version: 1.0.0"),
            SizedBox(height: 8),
            Text(
              "A personal finance tracking app to help you manage your expenses and stay on top of your budget.",
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Logged out successfully")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }
}
