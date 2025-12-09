import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/city_location.dart';
import '../models/Lieu.dart';

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

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Table pour les villes favorites
    await db.execute('''
      CREATE TABLE Favorites (
        osmId INTEGER PRIMARY KEY AUTOINCREMENT,
		osmType TEXT NOT NULL,
		cityKey TEXT NOT NULL,
        cityName TEXT NOT NULL,
        cityLat REAL NOT NULL,
        cityLong REAL NOT NULL
      )
    ''');

    // Table pour les lieux favoris
    await db.execute('''
      CREATE TABLE FavoritePlaces (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityKey TEXT NOT NULL,
        name TEXT NOT NULL,
        lat REAL NOT NULL,
        lon REAL NOT NULL,
        tags TEXT,
		rating REAL,    
  		note TEXT     
      )
    ''');
  }

 
  Future<int> insertFavorite(CityLocation favorite) async {
    final dbClient = await db;
    return await dbClient.insert('Favorites', favorite.toMap());
  }

  Future<List<CityLocation>> fetchFavorites() async {
    final dbClient = await db;
    final maps = await dbClient.query('Favorites', orderBy: 'osmId DESC');

    return maps.map((m) => CityLocation.fromMap(m)).toList();
  }

  Future<int> updateFavorite(CityLocation favorite) async {
    final dbClient = await db;
    return await dbClient.update(
      'Favorites',
      favorite.toMap(),
      where: 'osmId = ?',
      whereArgs: [favorite.osmId],
    );
  }

  Future<int> deleteFavorite(int osmId) async {
    final dbClient = await db;
    return await dbClient.delete('Favorites', where: 'osmId = ?', whereArgs: [osmId]);
  }


  Future<void> debugPrintFavoritePlaces() async {
    final dbClient = await db;
    final maps = await dbClient.query('FavoritePlaces');
    print("=== FavoritePlaces Table ===");
    maps.forEach(print);
  }

  
	Future<int> insertFavoritePlace(Lieu place) async {
		final dbClient = await db;
		return await dbClient.insert('FavoritePlaces', place.toMap());
	}

  Future<List<Lieu>> fetchFavoritePlaces(String cityKey) async {
		final dbClient = await db;
		final maps = await dbClient.query(
			'FavoritePlaces',
			where: 'cityKey = ?',
			whereArgs: [cityKey],
		);

		return maps.map((m) => Lieu.fromMap(m)).toList();
	}

  Future<int> deleteFavoritePlace(int placeId) async {
		final dbClient = await db;
		return await dbClient.delete(
		'FavoritePlaces',
		where: 'id = ?',
		whereArgs: [placeId],
		);
	}

  Future<bool> isFavoritePlace(int placeId) async {
		final dbClient = await db;
		final result = await dbClient.query(
		'FavoritePlaces',
		where: 'id = ?',
		whereArgs: [placeId],
		);
		return result.isNotEmpty;
	}
}
