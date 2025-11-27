import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanderly/models/city_location.dart';


/*
 * Classe responsable de la gestion des villes favorites
 * On utilise SharedPreferences pour stocker les donnees localement
 */

class FavoritesService {

  static const _key = 'favorites_cities';

  // Recupere la liste des villes favorites
  Future<List<CityLocation>> getFavorites() async{
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) {
      return [];
    }

    // Decode la liste JSON en liste d'objets CityLocation
    final List decoded = jsonDecode(data);
    return decoded.map((e) => CityLocation.fromJson(e)).toList();  }


  //Sauvegarde la liste des villes favorites
  Future<void> saveFavorites(List<CityLocation> cities) async{
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(cities.map((c) => c.toJson()).toList());
    await prefs.setString(_key, encoded);    }


  // Ajoute une ville a la liste des favorites
  Future<void> ajouterFavorites(CityLocation city) async{
    final favorites = await getFavorites();
    if (!favorites.contains(city)){
      favorites.add(city);
      await saveFavorites(favorites);
    }
  }

  // Retire une ville de la liste des favorites
  Future<void> removeFavorites(CityLocation city) async{
    final favorites = await getFavorites();
    if (favorites.contains(city)){
      favorites.remove(city);
      await saveFavorites(favorites);
    }
  }
}