import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/favoriteplace_item.dart';
import '../models/Lieu.dart';

class FavoritesProviderPlace extends ChangeNotifier {
  List<FavoritePlaceItem> favorites = [];

  Future<void> loadFavorites(String cityName) async {
    favorites = await Dbhelper.instance.fetchFavoritePlaces(cityName);
    notifyListeners();
  }

  Future<void> toggleFavorite(Lieu lieu, String cityName) async {
    final exists = favorites.any((f) => f.lieu.id == lieu.id);

    if (exists) {
      await Dbhelper.instance.deleteFavoritePlace(lieu.id.toString());
    } else {
      final fav = FavoritePlaceItem(
        title: lieu.name,
        image: lieu.tags["image"] ?? "assets/images/noPhoto.png",
        description: lieu.tags["description"] ?? "Pas de description",
        lieu: lieu,
      );
      await Dbhelper.instance.insertFavoritePlace(fav, cityName);
    }

    await loadFavorites(cityName);
  }

  bool isFavorite(String placeId) {
    return favorites.any((f) => f.lieu.id.toString() == placeId);
  }
}
