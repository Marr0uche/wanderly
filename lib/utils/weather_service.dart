import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static final String _apiKey = dotenv.env['API_KEY_OPENWEATHER'] ?? "";
  static const String _url = "https://api.openweathermap.org/data/2.5/weather";

  Future<WeatherData?> getWeather(String city) async {
    try {
      final uri = Uri.parse(
        "$_url?q=$city&units=metric&lang=fr&appid=$_apiKey",
      );
      final res = await http.get(uri);

      if (res.statusCode != 200) {
        print("Weather API error: ${res.body}");
        return null;
      }

      final json = jsonDecode(res.body);

      return WeatherData(
        temperature: json["main"]["temp"].round(),
        minTemp: json["main"]["temp_min"].round(),
        maxTemp: json["main"]["temp_max"].round(),
        humidity: json["main"]["humidity"] ?? 0,
		description: _capitalize(json["weather"][0]["description"] ?? ""),
        windSpeed: (json["wind"]["speed"] ?? 0).toDouble(),
        windDirection: _degToDirection(json["wind"]["deg"] ?? 0),
		iconCode: json["weather"][0]["icon"] ?? "",
      );
    } catch (e) {
      print("WeatherService error: $e");
      return null;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
	
	List<String> words = text.split(' ');
	for (int i = 0; i < words.length; i++) {
	  words[i] = words[i][0].toUpperCase() + words[i].substring(1);
	}

	return words.join(' ');
  }

  String _degToDirection(int deg) {
    const dirs = ["N", "N-E", "E", "S-E", "S", "S-O", "O", "N-O"];
    return dirs[((deg + 22.5) / 45).floor() % 8];
  }
}
