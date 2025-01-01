import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:business_assistant/models/income.dart';

Future<List<Income>> showIncome() async {
  final database = await DBHelper.getDatabase();

  try {
    List<Map<String, dynamic>> data = await database.query(
      'Income',
      where: 'deleted = ?',
      whereArgs: [0],
    );

    // Convert the List<Map> into a List of Income objects
    List<Income> incomeList = data.map((map) {
      return Income.fromMap(map);  // Use the factory constructor that handles the date parsing
    }).toList();

    return incomeList;
  } catch (e) {
    print("Error selecting from Income: $e");
    return [];
  }
}


Future<bool> deleteIncome(int incomeId) async {
  try {
    //delete
    DBAssistant.delete("Income", incomeId);
    return true;
  } catch (e) {
    print("Error deleting the income");
    return false;
  }
}


Future<bool> insertIncome(Income income) async {
  try {
    // Convert the Income object to a Map, ensuring the DateTime is converted to a string
    Map<String, dynamic> data = income.toMap();

    int result = await DBAssistant.insert("Income", data);

    return result > 0;
  } catch (e) {
    print("Error inserting the income: $e");
    return false;
  }
}



