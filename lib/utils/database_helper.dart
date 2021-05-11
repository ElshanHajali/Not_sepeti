import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_proje_not_sepeti/models/kategory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'notlar.dart';

class DatabaseHelper {
  static DatabaseHelper _dataBaseHelper;
  static Database _database;

  factory DatabaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DatabaseHelper._internel();
      return _dataBaseHelper;
    } else {
      return _dataBaseHelper;
    }
  }

  DatabaseHelper._internel();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  Future<Database> _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "notlar.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "notlar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    // open the database
    return await openDatabase(path, readOnly: false);
    //----------------------------------------------------
    /*var lock = Lock();
    Database _db;
    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasesPath = await getDatabasesPath();
          var path = join(databasesPath, "appDB.db");
          print("OLUSACAK DBNIN PATH'i : ");
          var file = new File(path);

          //check if file exists
          if (!await file.exists()) {
            ByteData data = await rootBundle.load(join("assets", "notlar.db"));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await new File(path).writeAsBytes(bytes);
          }
          //open the Database
          _db = await openDatabase(path);
        }
      });
    }
    return _db;*/
  }

  // CRUD must follow (create ,read, update, delete)
  //kategory burda baslayir DB hissesin
  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("kategory");
    return sonuc;
  }

  Future<int> kategoryEkle(Kategory kategory) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("kategory", kategory.toMap());
    return sonuc;
  }

  Future<int> kategoryGuncelle(Kategory kategory) async {
    var db = await _getDatabase();
    var sonuc = await db.update("kategory", kategory.toMap(),
        where: 'katogoryID = ?', whereArgs: [kategory.katogoryID]);
    return sonuc;
  }

  Future<int> kategorySil(int katogoryID) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete("kategory", where: 'katogoryID = ?', whereArgs: [katogoryID]);
    return sonuc;
  }

//-----notlar burda baslayir
  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("not", orderBy: 'notID DESC');
    return sonuc;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert("not", not.toMap());
    return sonuc;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db
        .update("not", not.toMap(), where: 'notID = ?', whereArgs: [not.notID]);
    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var sonuc = await db.delete("not", where: 'notID = ?', whereArgs: [notID]);
    return sonuc;
  }

  String dataFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "january";
        break;
      case 2:
        month = "february";
        break;
      case 3:
        month = "march";
        break;
      case 4:
        month = "april";
        break;
      case 5:
        month = "may";
        break;
      case 6:
        month = "june";
        break;
      case 7:
        month = "july";
        break;
      case 8:
        month = "august";
        break;
      case 9:
        month = "september";
        break;
      case 10:
        month = "october";
        break;
      case 11:
        month = "november";
        break;
      case 12:
        month = "december";
        break;
    }
    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "yesterday";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "monday";
        case 2:
          return "tuesday";
        case 3:
          return "wednesday";
        case 4:
          return "thursday";
        case 5:
          return "friday";
        case 6:
          return "saturday";
        case 7:
          return "sunday";
      }
    } else if (tm.year == today.year) {
      return '${tm.day} $month';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
  }
}
//useful link for database
// --- https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_asset_db.md
