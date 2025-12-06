import 'dart:convert';
import 'package:http/http.dart' as http;

class OverpassService {
	final String _endpoint = "https://overpass.kumi.systems/api/interpreter";

	Future<List<Map<String, dynamic>>> fetchPlaces({
		required double lat,
		required double lon,
		required int radius,
		required Set<String> categories,
	}) async 
	{

		final filters = buildOverpassFilters(categories, lat, lon, radius);
		final String query =
			"""
			[out:json][timeout:25];
			(
				$filters
			);
			out center;
		""";

		final response = await http.post(
			Uri.parse(_endpoint),
			body: {"data": query},
		);

		if (response.statusCode != 200 || !response.body.trim().startsWith("{")) {
			throw Exception("Overpass error: ${response.body}");
		}

		final data = jsonDecode(response.body);

		print(data);

		return (data["elements"] as List).cast<Map<String, dynamic>>();
	}

	Map<String, String> osmTagForCategory = {
		"parks": '["leisure"="park"]',
		"museums": '["tourism"="museum"]',
		"stations": '["railway"="station"]',
		"universities": '["amenity"="university"]',
		"tourism": '["tourism"="attraction"]', // attrape-tout
	};

	String buildOverpassFilters(Set<String> categories, double lat, double lon, int radius) {
		List<String> filters = [];

		for (final c in categories) {
			if (osmTagForCategory.containsKey(c)) {
				filters.add('node${osmTagForCategory[c]}(around:$radius,$lat,$lon);');
			}
		}

		return filters.join("\n");
	}
}
