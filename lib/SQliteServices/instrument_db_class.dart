// import 'dart:io';
// import 'package:admin/SQliteServices/sqliteKeywords.dart';
// import 'package:admin/dataClasses/Instruments.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';
//
// class InstrumentDbClass with ChangeNotifier {
//   static Database database;
//
//   Future<Database> getDataBase() async {
//     if (database == null) {
//       database = await initializeDatabase();
//     }
//     return database;
//   }
//
//   Future<Database> initializeDatabase() async {
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = directory.path + SqliteKeywords.dbname;
//     var db = openDatabase(path, version: 1, onCreate: createDb);
//     return db;
//   }
//
//   void createDb(Database db, int newversion) async {
//     db.execute(
//         'CREATE TABLE ${SqliteKeywords.table_name}(${SqliteKeywords.instrument_token} TEXT PRIMARY KEY, ${SqliteKeywords.name} TEXT, ${SqliteKeywords.exchange} TEXT,${SqliteKeywords.tradingsymbol} TEXT)');
//   }
//
//   Future<List<Map<String, dynamic>>> getAllinstruments() async {
//     Database db = database;
//
//     var result = db.rawQuery('SELECT * FROM ${SqliteKeywords.table_name}');
//     return result;
//   }
//
//   Future<int> insertIntoTable(Instruments instruments) async {
//     print(instruments.toMap());
//     Database db = database;
//     var result =
//         await db.insert(SqliteKeywords.table_name, instruments.toMap());
//     return result;
//   }
//
//   Future<int> deleteInstruments() {
//     Database db = database;
//     var result = db.delete(SqliteKeywords.table_name);
//     return result;
//   }
// }
