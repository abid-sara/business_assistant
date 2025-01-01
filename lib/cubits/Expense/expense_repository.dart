import 'package:business_assistant/models/expense.dart';
import 'package:business_assistant/database/db_expense.dart';
import 'package:business_assistant/database/db_helper.dart';

class ExpenseRepository {
 Future<List<Expense>> getExpenses() async {
  final database = await DBHelper.getDatabase();
  final List<Map<String, dynamic>> expenseMaps = await database.query('Expense');
  
  print('Expense maps: $expenseMaps'); // Debugging line
  
  // Convert the list of maps into a list of Expense objects
  return expenseMaps.map((map) => Expense.fromMap(map)).toList();
}


  Future<int?> insertExpense(Expense expense) async {
    final database = await DBHelper.getDatabase();
    return await database.insert('Expense', expense.toMap());
  }
}