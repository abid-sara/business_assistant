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
          '''UPDATE $tableName SET deleted = ? where id = ? ''', [0, id]);
    } catch (e) {
      print("Error deleting from into table $tableName: $e");
      return -1;
    }
  }

  static Future<int> update(
      String tableName, int id, Map<String, dynamic> data) async {
    final database = await DBHelper.getDatabase();
    try {
      return await database.update(
        tableName,
        data,
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error updating into table $tableName: $e");
      return -1;
    }
  }

  static Future<int> selectAll(String tableName) async {
    final database = await DBHelper.getDatabase();

    try {
      return await database.rawQuery('''SELECT * FROM $tableName ''');
    } catch (e) {
      print("Error selecting from $tableName");
      return -1;
    }
  }
  
}
