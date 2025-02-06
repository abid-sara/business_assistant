import '/database/db_helper.dart';

class DBAssistant {
  static Future<int> insert(String tableName, Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    try {
      return await database.insert(tableName, data);
    } catch (e) {
      print("Error inserting into table $tableName: $e");
      return -1;
    }
  }

  static Future<int> delete(String tableName, int id) async {
    final database = await DBHelper.getDatabase();
    try {
      return await database.rawUpdate(
          '''UPDATE $tableName SET deleted = ? WHERE id = ?''', [1, id]);
    } catch (e) {
      print("Error deleting from table $tableName: $e");
      return -1;
    }
  }

  static Future<bool> update(
      String tableName, int id, Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    try {
      int result = await database.update(
        tableName,
        data,
        where: "id = ?",
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print("Error updating table $tableName: $e");
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> selectAll(String tableName) async {
    final database = await DBHelper.getDatabase();
    try {
      return await database.query(tableName);
    } catch (e) {
      print("Error selecting from table $tableName: $e");
      return [];
    }
  }
}
