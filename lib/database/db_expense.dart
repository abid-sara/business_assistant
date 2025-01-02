import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/models/expense.dart';
import 'package:business_assistant/models/product.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Expense>> showExpense() async {
  final database = await DBHelper.getDatabase();

  try {
    final result = await database.query(
      'Expense',
      where: 'deleted = ?',
      whereArgs: [0], // Fetch only non-deleted expenses
    );

    List<Expense> expenseList = [];
    for (var map in result) {
      // Fetch the corresponding Product object
      final productData = await database.query(
        'Product',
        where: 'id = ?',
        whereArgs: [map['product_id']],
      );

      if (productData.isNotEmpty) {
        final product = Product.fromMap(productData.first);
        expenseList.add(Expense.fromMap(map, product));
      }
    }

    return expenseList; // Return the list of Expense objects
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
      {'deleted': 1},
      where: 'id = ?',
      whereArgs: [expenseId],
    );
    return result > 0;
  } catch (e) {
    print("Error deleting the expense: $e");
    return false;
  }
}

Future<bool> insertExpense(Expense expense) async {
  try {
    final database = await DBHelper.getDatabase();
    final result = await database.insert('Expense', expense.toMap());
    return result > 0;
  } catch (e) {
    print("Error inserting the expense: $e");
    return false;
  }
}