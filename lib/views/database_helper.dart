import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'brightness_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;

  DatabaseHelper._instance();

  String tableBrightnessData = 'brightnessData';
  String colId = 'id';
  String colBrightnessCount = 'brightnessCount';
  String colDate = 'date';
  String colDateTime = 'dateTime';

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  Future<Database> _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'finaldatabase.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tableBrightnessData($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colBrightnessCount REAL, $colDate TEXT, $colDateTime TEXT)',
    );
  }

  Future<int> insertBrightnessData(BrightnessData brightnessData) async {
    Database db = await this.db;
    return await db.insert(
      tableBrightnessData,
      brightnessData.toMap(),
    );
  }

  Future<List<BrightnessData>> getBrightnessDataList() async {
    Database db = await this.db;
    List<Map<String, dynamic>> maps = await db.query(tableBrightnessData);
    return List.generate(maps.length, (index) {
      return BrightnessData.fromMap(maps[index]);
    });
  }

  Future<int> deleteAllBrightnessData() async {
    Database db = await this.db;
    return await db.delete(tableBrightnessData);
  }
  
  Future<double> getAverageBrightnessCount() async {
  Database db = await this.db;
  String todayDate = DateTime.now().toString().split(' ')[0];

  List<Map<String, dynamic>> result = await db.rawQuery(
    'SELECT AVG($colBrightnessCount) as averageBrightnessCount FROM $tableBrightnessData WHERE $colDate = ?',
    [todayDate],
  );
  if (result.isNotEmpty) {
    double averageBrightnessCount = result.first['averageBrightnessCount'];
    return averageBrightnessCount;
  } else {
    return 0.0;
  }
}


  // Future<void> resetDatabaseIfNeeded() async {
  //   DateTime now = DateTime.now();
  //   if (now.hour == 22 && now.minute == 55 && now.second == 0) {
  //     await deleteAllBrightnessData();
  //     print('Database Reset: All data cleared.');
  //   }
  // }
}
