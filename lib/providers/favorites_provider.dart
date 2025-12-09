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
		final osmId = await Dbhelper.instance.insertFavorite(city);
		favorites.insert(0, city.copyWith(osmId: osmId));
		print("Added favorite: ${city.cityName} with id ${city.cityKey}");
		notifyListeners();
	}

	Future<void> removeFavorite(CityLocation city) async {
		await Dbhelper.instance.deleteFavorite(city.osmId);
		favorites.removeWhere((c) => c.osmId == city.osmId);
		notifyListeners();
	}
}
