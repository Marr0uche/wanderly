import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/Lieu.dart';

class FavoritesProviderPlace extends ChangeNotifier {
	List<Lieu> favoritePlaces = [];
	String? lastLoadedCityKey;

	FavoritesProviderPlace();

	Future<void> loadFavoritePlaces(String cityKey) async {
		favoritePlaces = await Dbhelper.instance.fetchFavoritePlaces(cityKey);
		lastLoadedCityKey = cityKey;
		notifyListeners();

		//print("Loaded favorite places for cityKey: $cityKey");
		//print("Favorite Places: $favoritePlaces");
		//await Dbhelper.instance.debugPrintFavoritePlaces();
	}

	bool isPlaceFavorite(Lieu place) {
		return favoritePlaces.any((p) => p.id == place.id);
	}

  	Future<void> addFavoritePlace(Lieu place) async {
		final id = await Dbhelper.instance.insertFavoritePlace(place);
		favoritePlaces.insert(0, place.copyWith(id: id));
		notifyListeners();
	}

	Future<void> removeFavoritePlace(Lieu place) async {
		await Dbhelper.instance.deleteFavoritePlace(place.id);
		favoritePlaces.removeWhere((c) => c.id == place.id);
		notifyListeners();
	}
  
}
