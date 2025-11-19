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

    return CityLocation(
      double.parse(data[0]["lat"]),
      double.parse(data[0]["lon"]),
    );
  }
}
