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
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT NOT NULL,
        cityLat REAL NOT NULL,
        cityLong REAL NOT NULL
      )
    ''');

    // Table pour les lieux favoris
    await db.execute('''
      CREATE TABLE FavoritePlaces (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityId INTEGER NOT NULL,
        name TEXT NOT NULL,
        lat REAL NOT NULL,
        lon REAL NOT NULL,
        tags TEXT
      )
    ''');
  }

 
  Future<int> insertFavorite(CityLocation favorite) async {
    final dbClient = await db;
    return await dbClient.insert('Favorites', favorite.toMap());
  }

  Future<List<CityLocation>> fetchFavorites() async {
    final dbClient = await db;
    final maps = await dbClient.query('Favorites', orderBy: 'id DESC');

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

  
	Future<int> insertFavoritePlace(Lieu place) async {
		final dbClient = await db;
		return await dbClient.insert('FavoritePlaces', place.toMap());
	}

  Future<List<Lieu>> fetchFavoritePlaces(int cityId) async {
		final dbClient = await db;
		final maps = await dbClient.query(
			'FavoritePlaces',
			where: 'cityId = ?',
			whereArgs: [cityId],
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
