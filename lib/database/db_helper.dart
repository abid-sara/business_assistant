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
        business_name TEXT
          )
      ''');

    await db.execute('''
        CREATE TABLE "Order" (
        id INTEGER PRIMARY KEY,
        price DOUBLE NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',  
        deleted BOOLEAN NOT NULL DEFAULT 0,
        order_date TEXT NOT NULL,
        delivery_date TEXT NOT NULL,
        delivery_address TEXT NOT NULL,
        delivery_price DOUBLE NOT NULL,
        customer_id INTEGER NOT NULL,
        FOREIGN KEY (customer_id) REFERENCES Customer (id) ON DELETE CASCADE
        )
    ''');

    await db.execute('''
        CREATE TABLE Customer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        phone_num TEXT NOT NULL,
        email TEXT NOT NULL,
        note TEXT,
        count INTEGER NOT NULL DEFAULT 0,
        deleted BOOLEAN NOT NULL DEFAULT 0
        )
      ''');

    await db.execute('''
        CREATE TABLE Product (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        unit_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        deleted BOOLEAN NOT NULL DEFAULT 0,
        supplier_name TEXT NOT NULL,
        supplier_phone_num TEXT NOT NULL,
        supplier_address TEXT NOT NULL,
        product_description TEXT,
        minimum_quantity INTEGER NOT NULL,
        additional_info TEXT,
        product_image TEXT
    )
    ''');

    await db.execute('''
        CREATE TABLE "OrderProduct" (
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER NOT NULL,
        PRIMARY KEY (order_id, product_id),
        FOREIGN KEY (order_id) REFERENCES "Order" (id) ON DELETE CASCADE,
        FOREIGN KEY (product_id) REFERENCES "Product" (id) ON DELETE CASCADE
        )
    ''');

    await db.execute('''
        CREATE TABLE "Income" (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        date TEXT NOT NULL,
        amount DOUBLE NOT NULL,
        FOREIGN KEY (order_id) REFERENCES "Order" (id) ON DELETE CASCADE
        )
    ''');

    await db.execute('''
        CREATE TABLE "Expense" (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        amount DOUBLE NOT NULL,
        FOREIGN KEY (product_id) REFERENCES "Product" (id) ON DELETE CASCADE
        )
    ''');
  }
}
