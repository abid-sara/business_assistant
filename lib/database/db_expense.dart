import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:sqflite/sqlite_api.dart';

Future<List<Map<String, dynamic>>> showExpense() async{
  final database = await DBHelper.getDatabase();

  try{
    return await database.query(
      'Expense',
      where: 'deleted = ?',
      whereArgs: [0], 
    );
  } catch (e) {
    print("Error selecting from Expense: $e");
    return [];
  }
}

Future <bool> deleteExpense(int expenseId) async{
  try {
    //delete
    DBAssistant.delete("Expense", expenseId);
    // update the customer count
    return true;
  } catch (e) {
    print("error deleting the expense");
    return false;
  }
}

Future<bool> insertExpense(Map<String , dynamic>data)async{
  try {
    int result = await DBAssistant.insert("Expense", data);
    return result > 0;
  } catch (e) {
    print("Error inserting the Expense: $e");
    return false;
  }
}



