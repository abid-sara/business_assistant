import 'package:business_assistant/models/expense.dart';
import 'package:business_assistant/models/product.dart';
import 'package:business_assistant/database/db_helper.dart';

class ExpenseRepository {
  Future<List<Expense>> getExpenses() async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await database.query('Expense');
    print('Expense maps: $maps'); // Debugging line

    List<Expense> expenseList = [];
    for (var map in maps) {
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

    return expenseList;
  }

  Future<int?> insertExpense(Expense expense) async {
    final database = await DBHelper.getDatabase();
    final result = await database.insert('Expense', expense.toMap());
    print('Inserted expense with ID: $result'); // Debugging line

    // Set the ID after insertion if it's null
    if (expense.id == null) {
      expense.id = result;  // Set the ID after insertion
    }

    return result;
  }

  Future<double> calculateTotalExpenses() async {
    final database = await DBHelper.getDatabase();
    final result = await database.rawQuery('SELECT SUM(amount) as total FROM Expense');
    return result.first['total'] ?? 0.0;
  }

  Future<List<Map<String, dynamic>>> getLatestExpenses(int limit) async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await database.query(
      'Expense',
      columns: ['date', 'amount'], // Only select date and amount
      orderBy: 'date DESC',
      limit: limit,
    );
    print('Latest expenses: $maps'); // Debugging line

    List<Map<String, dynamic>> expenseList = [];
    for (var map in maps) {
      expenseList.add({
        'date': map['date'],
        'amount': map['amount'],
        'type': 'expense',
      });
    }

    return expenseList;
  }

  Future<double> calculateTotalExpensesInRange(DateTime start, DateTime end) async {
    final database = await DBHelper.getDatabase();
    final result = await database.rawQuery(
      'SELECT SUM(amount) as total FROM Expense WHERE date BETWEEN ? AND ?',
      [start.toIso8601String(), end.toIso8601String()],
    );
    return result.first['total'] ?? 0.0;
  }


  Future<Map<String, double>> getExpensesGroupedByDate() async {
    final database = await DBHelper.getDatabase();
    final List<Map<String, dynamic>> maps = await database.query('Expense');
    print('Expense maps: $maps'); // Debugging line

    Map<String, double> expenseMap = {};
    for (var map in maps) {
      final date = map['date'].split('T')[0]; // Extract date part
      final amount = map['amount'] as double;
      if (expenseMap.containsKey(date)) {
        expenseMap[date] = expenseMap[date]! + amount;
      } else {
        expenseMap[date] = amount;
      }
    }
    print('Expense map: $expenseMap'); // Debugging line
    return expenseMap;
  }
  
}