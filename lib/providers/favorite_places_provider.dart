import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/Lieu.dart';


// Provider responsable des lieux favoris


class FavoritesProviderPlace extends ChangeNotifier {
	List<Lieu> favoritePlaces = [];
	String? lastLoadedCityKey;

	FavoritesProviderPlace();

	Future<void> loadFavoritePlaces(String cityKey) async {
		favoritePlaces = await Dbhelper.instance.fetchFavoritePlaces(cityKey);
		lastLoadedCityKey = cityKey;
		notifyListeners();
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

	Future<void> updatePlaceNote(int id, double rating, String? note) async {
		final dbClient = await Dbhelper.instance.db;

		await dbClient.update(
			'FavoritePlaces',
			{'rating': rating, 'note': note},
			where: 'id = ?',
			whereArgs: [id],
		);

		notifyListeners();

		final idx = favoritePlaces.indexWhere((p) => p.id == id);
		if (idx != -1) {
			favoritePlaces[idx] = favoritePlaces[idx].copyWithRatNot(
				rating: rating,
				note: note,
			);
		}

		notifyListeners();
  }
  
}
