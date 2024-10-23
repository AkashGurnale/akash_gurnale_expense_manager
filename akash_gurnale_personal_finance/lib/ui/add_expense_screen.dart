import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../data/models/categories.dart';
import '../data/models/expense_model.dart';

class AddExpenseScreen extends StatefulWidget {
  final Category? initialCategory;

  AddExpenseScreen({this.initialCategory});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user input
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  Category? _selectedCategory;
  String? _paymentMethod;

  @override
  void initState() {
    super.initState();
    _selectedCategory =
        widget.initialCategory;
  }

  Future<void> _saveExpense() async {
    final box = Hive.box<Expense>('expenses'); 
    final expense = Expense(
      description: _descriptionController.text,
      amount: double.parse(_amountController.text),
      category: _selectedCategory!.name,
      date: DateTime.now(),
      paymentMethod: _paymentMethod!,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      location:
          _locationController.text.isNotEmpty ? _locationController.text : null,
      transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
    );

    await box.add(expense); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  hint: Text('Select Category'),
                  items: [
                    Category(
                        name: 'Food', icon: Icons.fastfood, color: Colors.red),
                    Category(
                        name: 'Transport',
                        icon: Icons.directions_car,
                        color: Colors.green),
                    Category(
                        name: 'Health',
                        icon: Icons.local_hospital,
                        color: Colors.blue),
                    Category(
                        name: 'Shopping',
                        icon: Icons.shopping_cart,
                        color: Colors.orange),
                    Category(
                        name: 'Bills', icon: Icons.receipt, color: Colors.cyan),
                    Category(
                        name: 'Travel',
                        icon: Icons.airplanemode_active,
                        color: Colors.indigo),
                    Category(
                        name: 'Misc',
                        icon: Icons.more_horiz,
                        color: Colors.grey),
                  ].map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Row(
                        children: [
                          Icon(category.icon,
                              color: category.color), 
                          SizedBox(width: 10),
                          Text(category.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Dropdown for payment method
                DropdownButtonFormField<String>(
                  value: _paymentMethod,
                  hint: Text('Select Payment Method'),
                  items: ['Cash', 'Credit Card', 'Debit Card', 'Online']
                      .map((method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _paymentMethod = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a payment method';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Input field for notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(labelText: 'Notes (optional)'),
                ),

                SizedBox(height: 20),

                // Input field for location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: 'Location (optional)'),
                ),

                SizedBox(height: 20),

                // Button to submit the form
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveExpense(); // Save the expense
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Expense saved!')),
                      );
                      Navigator.pop(context); // Navigate back
                    }
                  },
                  child: Text('Add Expense'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
