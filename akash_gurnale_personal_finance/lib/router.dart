import 'package:akash_gurnale_personal_finance/data/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'ui/add_expense_screen.dart';
import 'ui/expense_categories_screen.dart'; // For Category model

class AppRouter {
  // Define the GoRouter instance
  final GoRouter router = GoRouter(
    routes: [
      // Expense categories screen route
      GoRoute(
        path: '/',
        name: 'expense-categories',
        builder: (context, state) => ExpenseCategoriesScreen(),
      ),
      // Add expense screen route
      GoRoute(
        path: '/add-expense',
        name: 'add-expense',
        builder: (context, state) {
          final category = state.extra as Category?; // Retrieve the selected category (if passed)
          return AddExpenseScreen(initialCategory: category); // Pass the category to AddExpenseScreen
        },
      ),
    ],
  );
}
