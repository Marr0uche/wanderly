import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/Lieu.dart';

class FavoritesProviderPlace extends ChangeNotifier {
	List<Lieu> favoritePlaces = [];
	
	FavoritesProviderPlace(int cityId) {
		loadFavoritePlaces(cityId);
	}

	Future<void> loadFavoritePlaces(int cityId) async {
		favoritePlaces = await Dbhelper.instance.fetchFavoritePlaces(cityId);
		notifyListeners();
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
