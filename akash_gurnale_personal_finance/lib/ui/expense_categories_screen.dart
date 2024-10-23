import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/categories.dart';

class ExpenseCategoriesScreen extends StatelessWidget {
  final List<Category> expenseCategories =  [
    Category(name: 'Food', icon: Icons.fastfood, color: Colors.red),
    Category(name: 'Transport', icon: Icons.directions_car, color: Colors.green),
    Category(name: 'Health', icon: Icons.local_hospital, color: Colors.blue),
    Category(name: 'Shopping', icon: Icons.shopping_cart, color: Colors.orange),
    Category(name: 'Bills', icon: Icons.receipt, color: Colors.cyan),
    Category(name: 'Travel', icon: Icons.airplanemode_active, color: Colors.indigo),
    Category(name: 'Misc', icon: Icons.more_horiz, color: Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: expenseCategories.length,
        itemBuilder: (context, index) {
          final category = expenseCategories[index];
          return GestureDetector(
            onTap: () {
              // Navigate to AddExpenseScreen with selected category
              context.push('/add-expense', extra: category);
            },
            child: Card(
              color: category.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, size: 50.0, color: Colors.white),
                  SizedBox(height: 10),
                  Text(category.name, style: TextStyle(color: Colors.white, fontSize: 18.0)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
