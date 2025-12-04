import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/location_service.dart';
import '../utils/nominatim_service.dart';
import '../models/weather_data.dart';
import '../utils/weather_service.dart';
import '../models/city_location.dart';

class MapProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final NominatimService _nominatimService = NominatimService();
  final WeatherService _weatherService = WeatherService();
  CityLocation currentLocation = CityLocation(id: -1, name: "Ma position", latitude: 47.845431, longitude: 1.937851);
  LatLng center = const LatLng(47.845431, 1.937851);
  WeatherData? weatherData;
  String? error;
  
  bool isLoading = false;

  // Initialise la position actuelle
  Future<void> init() async {
	isLoading = true;
	notifyListeners();

	final pos = await _locationService.getCurrentPosition();
	if (pos == null) return;

	center = LatLng(pos.latitude, pos.longitude);
	currentLocation = CityLocation(id: -1, name: "Ma position", latitude: pos.latitude, longitude: pos.longitude);

	final city = await _nominatimService.getCityNameFromCoordinates(pos.latitude, pos.longitude);
	if (city != null){
		currentLocation = CityLocation(id: -1, name: city, latitude: pos.latitude, longitude: pos.longitude);
		weatherData = await getWeather(city);
	}
	isLoading = false;
	notifyListeners();
  }

  // Recherche une ville par son nom
  Future<void> searchCity(String city) async {
	try{
	isLoading = true;
	notifyListeners();
	if (city.trim().isEmpty) {
	  error = "Nom de ville invalide";
	  isLoading = false;
	  notifyListeners();
	  return;
	}

	error = null;
	notifyListeners();

	city =  city[0].toUpperCase() + city.substring(1);

	final result = await _nominatimService.searchCity(city);

	if (result == null) {
	  error = "Ville introuvable";
	  isLoading = false;
	  notifyListeners();
	  return;
	}

	center = LatLng(result.latitude, result.longitude);
	currentLocation = CityLocation(id: result.id, name: city, latitude: result.latitude, longitude: result.longitude);
	weatherData = await getWeather(city);

	} catch (e) {
	  error = "Erreur inattendue : $e";
	}

	isLoading = false;
	notifyListeners();
  }

  Future<WeatherData?> getWeather(String city) async {
	return await _weatherService.getWeather(city);
  }


}
