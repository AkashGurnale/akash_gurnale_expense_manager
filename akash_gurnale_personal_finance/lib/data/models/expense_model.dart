import 'package:hive/hive.dart';

part 'expense_model.g.dart'; 

@HiveType(typeId: 0)
class Expense {
  @HiveField(0)
  final String description;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String paymentMethod;  // New field for payment method

  @HiveField(5)
  final String? notes;  // Optional field for additional notes

  @HiveField(6)
  final String? location;  // Optional field for transaction location

  @HiveField(7)
  final String transactionId;  // Unique ID for each transaction

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMethod,
    this.notes,
    this.location,
    required this.transactionId,
  });
}
