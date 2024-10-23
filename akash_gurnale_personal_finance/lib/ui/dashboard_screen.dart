import 'package:akash_gurnale_personal_finance/ui/expense_categories_screen.dart';
import 'package:akash_gurnale_personal_finance/ui/expenses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/models/expense_model.dart';
import 'expense_details_screen.dart';
import 'add_expense_screen.dart'; 
import 'package:intl/intl.dart'; 

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  double _totalExpenses = 0;
  List<Expense> _recentTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadTotalExpenses();
    _loadRecentTransactions();
  }

  // Load total expenses
  void _loadTotalExpenses() {
    final box = Hive.box<Expense>('expenses');
    double total = 0;
    for (var expense in box.values) {
      total += expense.amount;
    }
    setState(() {
      _totalExpenses = total;
    });
  }

  // Load 10 most recent transactions
  void _loadRecentTransactions() {
    final box = Hive.box<Expense>('expenses');
    List<Expense> transactions = box.values.toList().cast<Expense>();
    transactions.sort((a, b) => b.date.compareTo(a.date)); // Sort by date (most recent first)
    setState(() {
      _recentTransactions = transactions.take(10).toList(); // Get only the 10 most recent
    });
  }

  // Function to handle bottom navigation bar tap
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      _buildDashboardContent(),
      ExpenseCategoriesScreen(),
      ExpensesListScreen(),
    ];

    return Scaffold(
      body: _screens[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, 
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Expenses'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        tooltip: 'Add Expense',
      ),
    );
  }

  Widget _buildDashboardContent() {
    return CustomScrollView(
      slivers: [
        // SliverAppBar
        SliverAppBar(
          expandedHeight: 200.0,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Dashboard'),
            background: Container(
              color: Colors.blueAccent,
              child: Center(
                child: Text(
                  'Manage Your Expenses',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses: \$${_totalExpenses.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),

        // SliverList for displaying recent transactions
        _recentTransactions.isEmpty
            ? SliverToBoxAdapter(
                child: Center(child: Text('No transactions yet.')),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final transaction = _recentTransactions[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to ExpenseDetailsScreen when a transaction is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseDetailsScreen(expense: transaction),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text(transaction.description),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Amount: \$${transaction.amount.toStringAsFixed(2)}'),
                              Text('Category: ${transaction.category}'),
                              Text('Date: ${DateFormat.yMMMd().format(transaction.date)}'),
                            ],
                          ),
                          trailing: Icon(Icons.monetization_on, color: Colors.green),
                        ),
                      ),
                    );
                  },
                  childCount: _recentTransactions.length,
                ),
              ),
      ],
    );
  }
}
