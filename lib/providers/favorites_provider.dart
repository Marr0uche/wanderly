import 'package:flutter/material.dart';
import 'package:wanderly/models/city_location.dart';
import '../db/database_helper.dart';

class FavoritesProvider extends ChangeNotifier {
  List<CityLocation> favorites = [];

	FavoritesProvider() {
		loadFavorites();
	}

	Future<void> loadFavorites() async {
		favorites = await Dbhelper.instance.fetchFavorites();
		notifyListeners();
	}

	Future<void> addFavorite(CityLocation city) async {
		final id = await Dbhelper.instance.insertFavorite(city);
		favorites.insert(0, city.copyWith(id: id));
		notifyListeners();
	}

	Future<void> removeFavorite(CityLocation city) async {
		await Dbhelper.instance.deleteFavorite(city.id!);
		favorites.removeWhere((c) => c.id == city.id);
		notifyListeners();
	}
}
