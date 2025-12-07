import 'Lieu.dart';
import 'dart:convert';

class FavoritePlaceItem {
  final String title;
  final String image;
  final String description;
  final Lieu lieu;

  FavoritePlaceItem({
    required this.title,
    required this.image,
    required this.description,
    required this.lieu,
  });

  static List<FavoritePlaceItem> getFavoriteItems(List<Lieu> lieux) {
  return lieux.map((l) => FavoritePlaceItem(
    title: l.name,
    image: l.tags["image"] ?? "assets/images/noPhoto.png", // image par défaut si pas dispo
    description: l.tags["description"] ?? "Pas de description",
    lieu: l,
  )).toList();
}

  static List<FavoritePlaceItem> fromCity({
  required List<FavoritePlaceItem> allFavorites,
  required String cityName,
}) {
  return allFavorites.where((item) {
    return (item.lieu.tags["addr:city"] ?? "").toLowerCase() ==
           cityName.toLowerCase();
  }).toList();
}

Map<String, dynamic> toMap(String cityName) {
  return {
    "placeId": lieu.id.toString(),
    "cityName": cityName,
    "name": title,
    "lat": lieu.latitude,
    "lon": lieu.longitude,
    "imageUrl": image,
    "tags": jsonEncode(lieu.tags), 
  };
}
factory FavoritePlaceItem.fromMap(Map<String, dynamic> map) {
  return FavoritePlaceItem(
    title: map["name"],
    image: map["imageUrl"] ?? "assets/images/noPhoto.png",
    description: "Pas de description",
    lieu: Lieu(
      id: int.parse(map["placeId"]).toString(),
      latitude: map["lat"],
      longitude: map["lon"],
      name: map["name"],
      tags: Map<String, String>.from(jsonDecode(map["tags"] ?? "{}")),
    ),
  );
}
}
