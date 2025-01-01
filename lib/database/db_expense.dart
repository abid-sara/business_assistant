import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/models/expense.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Expense>> showExpense() async {
  final database = await DBHelper.getDatabase();

  try {
    final result = await database.query(
      'Expense',
      where: 'deleted = ?',
      whereArgs: [0], // Fetch only non-deleted expenses
    );

    return result.map((map) => Expense.fromMap(map)).toList(); // Convert to Expense objects
  } catch (e) {
    print("Error selecting from Expense: $e");
    return [];
  }
}
Future<bool> deleteExpense(int expenseId) async {
  try {
    final database = await DBHelper.getDatabase();
    final result = await database.update(
      'Expense',
      {'deleted': 1}, // Mark as deleted instead of actually deleting
      where: 'id = ?',
      whereArgs: [expenseId],
    );

    if (result > 0) {
      return true; // Return true if deletion was successful
    } else {
      print("Expense not found for ID: $expenseId");
      return false;
    }
  } catch (e) {
    print("Error deleting the expense: $e");
    return false;
  }
}
Future<Expense> insertExpense(Map<String, dynamic> data) async {
  final database = await DBHelper.getDatabase();

  try {
    // Fetch the product details and calculate amount
    final product = await database.query(
      'Product',
      where: 'id = ?',
      whereArgs: [data['product_id']],
      limit: 1,
    );

    if (product.isNotEmpty) {
      final productData = product.first;
      double unitPrice = productData['unit_price'];
      int quantity = data['quantity'];

      double amount = unitPrice * quantity;
      data['amount'] = amount;

      // Insert the expense into the database
      int result = await database.insert('Expense', data);
      if (result > 0) {
        return Expense.fromMap(data); // Return inserted expense
      } else {
        throw Exception("Failed to insert expense");
      }
    } else {
      throw Exception("Product not found");
    }
  } catch (e) {
    print("Error inserting the Expense: $e");
    throw e; // Re-throw the error
  }
}

