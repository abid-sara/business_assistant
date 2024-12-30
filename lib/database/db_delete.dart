import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> deleteDatabaseFile() async {
  final dbPath = join(await getDatabasesPath(), 'BUSINESS_ASSISTANT.db');
  final dbFile = File(dbPath);

  if (await dbFile.exists()) {
    await dbFile.delete();
    print("Database deleted successfully");
  }
}
