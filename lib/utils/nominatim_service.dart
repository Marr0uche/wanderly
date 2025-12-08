import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city_location.dart';

class NominatimService {
  Future<CityLocation?> searchCity(String city) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$city&format=json&limit=1",
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'wanderly/1.0'},
    );

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data.isEmpty) return null;

   return CityLocation( id: data[0]["place_id"], name: data[0]["name"] ?? city, 
   		latitude: double.parse(data[0]["lat"]), longitude: double.parse(data[0]["lon"]),
    );
  }

  Future<List<String>> getSuggestions(String city) async {
    if (city.length < 2) return [];

    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=$city&format=json&limit=5",
    );

    final response = await http.get(
      url,
      headers: {'User-Agent': 'wanderly/1.0'},
    );

    if (response.statusCode != 200) return [];

    final List data = jsonDecode(response.body);

    return data.map((e) => e["display_name"] as String).toList();
  }


  // Recherche inversee : a partir de lat/lon, obtenir le nom de la ville
  Future<CityLocation?> getCityNameFromCoordinates(double lat, double lon) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json"
    );

    final response = await http.get(url, headers: {'User-Agent': 'wanderly/1.0'});

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);

    return CityLocation(
      id: data["place_id"],
      name: data["address"]?["village"] ?? data["address"]?["municipality"] ?? "Ville inconnue",
      latitude: double.parse(data["lat"]),
      longitude: double.parse(data["lon"]),
    );
  }
}
