import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _database_name = "BUSINESS_ASSISTANT.db";
  static const _database_version = 1;
  static var database;

  static Future getDatabase() async {
    if (database != null) {
      return database;
    }
    database = openDatabase(
      join(await getDatabasesPath(), _database_name),
      onCreate: _onCreate,
      version: _database_version,
      onUpgrade: (db, oldVersion, newVersion) {},
    );
    return database;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE "User" (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT,
          username TEXT,
          password TEXT,
          business_name TEXT,
          )
      ''');

    await db.execute('''
        CREATE TABLE "Order" (
        code INTEGER PRIMARY KEY,
        price DOUBLE NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',  
        deleted BOOLEAN NOT NULL DEFAULT 0,
        order_date TEXT NOT NULL,
        delivery_date TEXT NOT NULL,
        delivery_address TEXT NOT NULL,
        delivery_price DOUBLE NOT NULL
        )
    ''');

    await db.execute('''
        CREATE TABLE "OrderProduct" (
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER NOT NULL,
        PRIMARY KEY (order_id, product_id),
        FOREIGN KEY (order_id) REFERENCES "Order" (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES Product (id) ON DELETE CASCADE
        )
    ''');
  }
}
