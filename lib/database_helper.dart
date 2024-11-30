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
    final db = await database; // Ensure database is initialized
    return await db.query(
      'Menus',
      where: 'tenant_id = ?',
      whereArgs: [tenantId],
    );
  }

  Future<List<Map<String, dynamic>>> fetchCanteensWithTenants() async {
    final db = await database;

    // Query to fetch canteens along with their tenants
    final result = await db.rawQuery('''
      SELECT 
        Canteens.canteen_id,
        Canteens.canteen_name,
        Canteens.latitude,
        Canteens.longitude,
        Tenants.tenant_id,
        Tenants.tenant_name,
        Tenants.tenant_description
      FROM Canteens
      LEFT JOIN Tenants ON Canteens.canteen_id = Tenants.canteen_id
      ORDER BY Canteens.canteen_id, Tenants.tenant_id
    ''');

    return result;
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT 'canteen' AS type, tenants.tenant_name, 
       tenants.tenant_id, 
       COALESCE(tenants.tenant_description, '') AS tenant_description, 
       canteens.canteen_name, NULL AS menu_name, NULL AS menu_price
      FROM Canteens
      LEFT JOIN Tenants ON Canteens.canteen_id = Tenants.canteen_id
      WHERE canteens.canteen_name LIKE ?

      UNION ALL

      SELECT 'tenant' AS type, tenants.tenant_name, 
            tenants.tenant_id, 
            COALESCE(tenants.tenant_description, '') AS tenant_description, 
            canteens.canteen_name, NULL AS menu_name, NULL AS menu_price
      FROM Tenants
      INNER JOIN Canteens ON Tenants.canteen_id = Canteens.canteen_id
      WHERE tenants.tenant_name LIKE ?

      UNION ALL

      SELECT 'menu' AS type, tenants.tenant_name, 
            tenants.tenant_id, 
            COALESCE(tenants.tenant_description, '') AS tenant_description, 
            canteens.canteen_name, Menus.menu_name, Menus.menu_price
      FROM Menus
      INNER JOIN Tenants ON Menus.tenant_id = Tenants.tenant_id
      INNER JOIN Canteens ON Tenants.canteen_id = Canteens.canteen_id
      WHERE Menus.menu_name LIKE ?
    ''', ['%$query%', '%$query%', '%$query%']);

    return result;
  }
}
