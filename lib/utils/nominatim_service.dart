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

   return CityLocation( name: data[0]["display_name"] ?? city, 
   latitude: double.parse(data[0]["latitude"]), longitude: double.parse(data[0]["longitude"]),
    );
  }

  // Recherche inversee : a partir de lat/lon, obtenir le nom de la ville
  Future<String?> getCityNameFromCoordinates(double lat, double lon) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json"
    );

    final response = await http.get(url, headers: {'User-Agent': 'wanderly/1.0'});

    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);

    return data['address']['city'] ??
           data['address']['town'] ??
           data['address']['village'] ??
           "Ville inconnue";
  }
}
