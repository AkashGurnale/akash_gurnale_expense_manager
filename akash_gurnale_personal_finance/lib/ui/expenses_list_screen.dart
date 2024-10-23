import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/expense_model.dart';
import 'expense_details_screen.dart'; 

class ExpensesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expensesBox = Hive.box<Expense>('expenses');

    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: expensesBox.listenable(),
        builder: (context, Box<Expense> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No expenses added yet.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final expense = box.getAt(index);

              return GestureDetector(
                onTap: () {
                  // Navigate to the details screen when an expense is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpenseDetailsScreen(expense: expense!),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      expense!.description,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${expense.category}'),
                        Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
                        Text('Date: ${expense.date.toString().substring(0, 10)}'),
                      ],
                    ),
                    trailing: Icon(Icons.monetization_on, color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
