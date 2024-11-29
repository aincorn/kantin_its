import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "canteen_database.db";

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the path to the app's document directory
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    // Check if the database already exists
    final fileExists = await File(path).exists();
    if (!fileExists) {
      // If not, copy the database from the assets
      ByteData data = await rootBundle.load('assets/$_databaseName');
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
      print('Database copied to local storage: $path');
    } else {
      print('Database already exists at: $path');
    }

    // Open the database
    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> fetchMenusByTenant(int tenantId) async {
    final db = await database;
    return await db.query(
      'Menus',
      where: 'tenant_id = ?',
      whereArgs: [tenantId],
    );
  }

  // Function to delete all rows from a table
  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final db = await database;

    final result = await db.rawQuery('''
      -- Search by canteen name
      SELECT 'canteen' AS type, tenants.tenant_name, 
            tenants.tenant_id, -- Include tenant_id
            COALESCE(tenants.tenant_description, '') AS tenant_description, 
            canteens.canteen_name, NULL AS menu_name
      FROM Canteens
      LEFT JOIN Tenants ON Canteens.canteen_id = Tenants.canteen_id
      WHERE canteens.canteen_name LIKE ?

      UNION ALL

      -- Search by tenant name
      SELECT 'tenant' AS type, tenants.tenant_name, 
            tenants.tenant_id, -- Include tenant_id
            COALESCE(tenants.tenant_description, '') AS tenant_description, 
            canteens.canteen_name, NULL AS menu_name
      FROM Tenants
      INNER JOIN Canteens ON Tenants.canteen_id = Canteens.canteen_id
      WHERE tenants.tenant_name LIKE ?

      UNION ALL

      -- Search by menu name
      SELECT 'menu' AS type, tenants.tenant_name, 
            tenants.tenant_id, -- Include tenant_id
            COALESCE(tenants.tenant_description, '') AS tenant_description, 
            canteens.canteen_name, Menus.menu_name
      FROM Menus
      INNER JOIN Tenants ON Menus.tenant_id = Tenants.tenant_id
      INNER JOIN Canteens ON Tenants.canteen_id = Canteens.canteen_id
      WHERE Menus.menu_name LIKE ?
    ''', ['%$query%', '%$query%', '%$query%']);

    return result;
  }
}
