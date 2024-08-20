import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/inventory_model.dart';
import '../model/user_model.dart';

class DatabaseHelper {
  static const inventoryItemTable = "InventoryItemTable";

  String users = "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute(users);
    await db.execute('''
      CREATE TABLE $inventoryItemTable (
        id TEXT PRIMARY KEY,
        name TEXT,
        quantity INTEGER,
        price REAL,
        description TEXT
      )
    ''');
  }

  Future<int> signup(Users user) async {
    final db = await instance.database;

    return db.insert('users', user.toMap());
  }

  Future<bool> login(Users user) async {
    final db = await instance.database;

    var result = await db.rawQuery("select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 3) {
    await db.execute('''
      CREATE TABLE users (
        usrId INTEGER PRIMARY KEY AUTOINCREMENT,
        usrName TEXT UNIQUE,
        usrPassword TEXT
      )
    ''');
  }
}

  Future<List<InventoryModel>> fetchInventory() async {
    // clearItems();
    try {
      final db = await instance.database;
      List<Map<String, dynamic>> inventoryList = await db.query(inventoryItemTable);
      var result = inventoryList.map((e) => InventoryModel.fromMap(e)).toList();
      return result;
    } catch (e) {
      print('Error fetching inventory list: $e');
      return [];
    }
  }

  Future<void> insertInventory(InventoryModel item) async {
    try {
      final db = await instance.database;
      await db.insert(
        inventoryItemTable,
        item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error inserting Inventory item: $e');
    }
  }

  Future<void> updateInventory(InventoryModel item) async {
    try {
      final db = await instance.database;
      await db.update(
        inventoryItemTable,
        item.toMap(),
        where: "id = ?",
        whereArgs: [item.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error updating Inventory item: $e');
    }
  }

  Future<void> deleteInventory(InventoryModel item) async {
    try {
      final db = await instance.database;
      await db.delete(
        inventoryItemTable,
        where: "id = ?",
        whereArgs: [item.id],
      );
    } catch (e) {
      print('Error deleting Inventory item: $e');
    }
  }

  Future<void> clearItems() async {
    final db = await instance.database;
    await db.delete(inventoryItemTable);
  }
}
