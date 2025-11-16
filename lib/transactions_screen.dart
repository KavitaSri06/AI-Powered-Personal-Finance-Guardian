import 'package:flutter/material.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // Placeholder transactions data
  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Food',
      'amount': '₹250',
      'date': 'Oct 6',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
    {
      'title': 'Shopping',
      'amount': '₹1,200',
      'date': 'Oct 5',
      'icon': Icons.shopping_bag,
      'color': Colors.blue,
    },
    {
      'title': 'Transport',
      'amount': '₹450',
      'date': 'Oct 4',
      'icon': Icons.directions_car,
      'color': Colors.green,
    },
    {
      'title': 'Entertainment',
      'amount': '₹800',
      'date': 'Oct 3',
      'icon': Icons.movie,
      'color': Colors.purple,
    },
    {
      'title': 'Bills',
      'amount': '₹2,500',
      'date': 'Oct 2',
      'icon': Icons.receipt,
      'color': Colors.red,
    },
    {
      'title': 'Food',
      'amount': '₹350',
      'date': 'Oct 1',
      'icon': Icons.restaurant,
      'color': Colors.orange,
    },
  ];

  void _showAddExpenseBottomSheet() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String selectedCategory = 'Food';
    DateTime selectedDate = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Add Expense',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter expense title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Food', 'Shopping', 'Transport', 'Entertainment', 'Bills', 'Other']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[700]),
                      SizedBox(width: 12),
                      Text(
                        'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Placeholder for adding expense
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add Expense',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transactions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: _transactions.isEmpty
          ? Center(
        child: Text(
          'No transactions yet',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return Card(
            elevation: 1,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: transaction['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction['icon'],
                  color: transaction['color'],
                  size: 24,
                ),
              ),
              title: Text(
                transaction['title'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                transaction['date'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Text(
                transaction['amount'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseBottomSheet,
        icon: Icon(Icons.add),
        label: Text('Add Expense'),
      ),
    );
  }
}
