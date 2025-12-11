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

	return CityLocation( osmId: data[0]["osm_id"], osmType: data[0]["osm_type"], cityName: data[0]["name"] ?? city, cityKey: CityLocation.createKey(data[0]["osm_id"], data[0]["osm_type"]),
			cityLat: double.parse(data[0]["lat"]), cityLong: double.parse(data[0]["lon"]),
		);
  }

  Future<List<CityLocation>> searchCitySuggestions(String query) async {
		final url = "https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&extratags=1&polygon_geojson=0&limit=10";

		final response = await http.get(
			Uri.parse(url),
			headers: {"User-Agent": "wanderly/1.0"},
		);

		if (response.statusCode != 200) return [];

		final List data = jsonDecode(response.body);

		return data.map((json) {
			return CityLocation(
				osmId: json["osm_id"],
				osmType: json["osm_type"],
				cityName: json["display_name"],
				cityLat: double.parse(json["lat"]),
				cityLong: double.parse(json["lon"]),
				cityKey: CityLocation.createKey(json["osm_id"], json["osm_type"]),
			);
		}).toList();
	}


	Future<CityLocation?> getCityNameFromCoordinates(double lat, double lon) async {
		final url = Uri.parse(
			"https://nominatim.openstreetmap.org/reverse?lat=$lat&lon=$lon&format=json");

		final response = await http.get(url, headers: {'User-Agent': 'wanderly/1.0'});

		if (response.statusCode != 200) return null;

		final data = jsonDecode(response.body);
		print("getcitynamefromcoordinates: $data");

		final name = data["address"]?["city"] ??
			data["address"]?["town"] ??
			data["address"]?["village"] ??
			data["address"]?["municipality"];

		if (name == null) return null;

		return await searchCity(name);
	}
}