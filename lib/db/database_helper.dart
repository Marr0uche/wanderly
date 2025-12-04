import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/city_location.dart';

class Dbhelper {
  static final Dbhelper instance = Dbhelper._instance();
  static Database? _database;

  Dbhelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'wanderly.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
		CREATE TABLE Favorites (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			cityName TEXT NOT NULL,
			cityLat REAL NOT NULL,
			cityLong REAL NOT NULL
		)
		''');
  }

  Future<int> insertFavorite(CityLocation favorite) async {
    final dbClient = await db;
    return await dbClient.insert('Favorites', favorite.toMap());
  }

  Future<List<CityLocation>> fetchFavorites() async {
    final dbClient = await db;
    final maps = await dbClient.query('favorites', orderBy: 'id DESC');

    return maps.map((m) => CityLocation.fromMap(m)).toList();
  }

  Future<int> updateFavorite(CityLocation favorite) async {
    final dbClient = await db;
    return await dbClient.update(
      'Favorites',
      favorite.toMap(),
      where: 'id = ?',
      whereArgs: [favorite.id],
    );
  }

  Future<int> deleteFavorite(int id) async {
    final dbClient = await db;
    return await dbClient.delete('Favorites', where: 'id = ?', whereArgs: [id]);
  }
}
