import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:sqflite/sqlite_api.dart';

Future<List<Map<String, dynamic>>> showIncome() async{
  final database = await DBHelper.getDatabase();

  try{
    return await database.query(
      'Income',
      where: 'deleted = ?',
      whereArgs: [0], 
    );
  } catch (e) {
    print("Error selecting from Income: $e");
    return [];
  }
}

Future <bool> deleteIncome(int incomeId) async{
  try {
    //delete
    DBAssistant.delete("Income", incomeId);

    return true;
  } catch (e) {
    print("error deleting the income");
    return false;
  }
}

Future<bool> insertIncome(Map<String , dynamic>data)async{
  try {
    int result = await DBAssistant.insert("Income", data);
    return result > 0;
  } catch (e) {
    print("Error inserting the income: $e");
    return false;
  }
}



