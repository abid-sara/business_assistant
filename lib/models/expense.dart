import 'package:business_assistant/models/product.dart';

class Expense {
   int? id;
  final DateTime date;
  final double amount;
  final int deleted;
  final Product product;

  Expense({
    this.id,
    required this.date,
    required this.amount,
    required this.product, 
    this.deleted = 0,
  });

  factory Expense.fromMap(Map<String, dynamic> map, Product product) {
    try {
      return Expense(
        id: map['id'] as int?,
        amount: map['amount'] as double,
        date: DateTime.parse(map['date'] as String),
        deleted: map['deleted'] as int,
        product: product, // Assign the product object
      );
    } catch (e) {
      print('Error parsing Expense: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'deleted': deleted != 0 ? 1 : 0,
      'product_id': product.id, // Include product ID
    };
  }
}