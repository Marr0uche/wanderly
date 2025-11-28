import 'package:flutter/material.dart';
import 'package:wanderly/models/city_location.dart';
import '../utils/favorites_service.dart';


class FavoritesProvider  extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService();
  List<CityLocation> favorites = [];

  // Charge les favoris depuis le service
  Future<void> localFavorites() async {
    favorites = await _favoritesService.getFavorites();
    notifyListeners();
  }

  // Ajoute une ville aux favoris
  Future<void> addFavorite(CityLocation city) async {
    await _favoritesService.ajouterFavorites(city);
    favorites.add(city);
    notifyListeners();
  }

  // Retire une ville des favoris
  Future<void> removeFavorite(CityLocation city) async {
    await _favoritesService.removeFavorites(city);
    favorites.remove(city);
    notifyListeners();
  }
}