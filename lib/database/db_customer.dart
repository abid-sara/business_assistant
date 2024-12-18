import 'package:business_assistant/database/db_helper.dart';
import 'package:business_assistant/database/db_utility.dart';
import 'package:business_assistant/database/db_product.dart';
import 'package:sqflite/sqlite_api.dart';

Future<List<Map<String, dynamic>>> showCustomers() async {
  final database = await DBHelper.getDatabase();

  try {
    return await database.query(
      'Customer',
      where: 'deleted = ?',
      whereArgs: [0], //deleted is false so show the customers
    );
  } catch (e) {
    print("Error selecting from Order: $e");
    return [];
  }
}
