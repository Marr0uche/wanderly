import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/location_service.dart';
import '../utils/nominatim_service.dart';
import '../models/weather_data.dart';
import '../utils/weather_service.dart';

class MapProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final NominatimService _nominatimService = NominatimService();
  final WeatherService _weatherService = WeatherService();
  LatLng center = const LatLng(47.845431, 1.937851);
  String latitude = "47.845431";
  String longitude = "1.937851";
  String? cityName = "Ma Position";
  WeatherData? weatherData;
  String? error;

  // Initialise la position actuelle
  Future<void> init() async {
	final pos = await _locationService.getCurrentPosition();
	if (pos == null) return;

	center = LatLng(pos.latitude, pos.longitude);
	latitude = pos.latitude.toString();
	longitude = pos.longitude.toString();

	final city = await _nominatimService.getCityNameFromCoordinates(pos.latitude, pos.longitude);
	if (city != null){
		cityName = city;
		weatherData = await getWeather(city);
	}
	notifyListeners();
  }

  // Recherche une ville par son nom
  Future<void> searchCity(String city) async {
	try{

	if (city.trim().isEmpty) {
	  error = "Nom de ville invalide";
	  notifyListeners();
	  return;
	}

	error = null;
	notifyListeners();

	city =  city[0].toUpperCase() + city.substring(1);

	final result = await _nominatimService.searchCity(city);

	if (result == null) {
	  error = "Ville introuvable";
	  notifyListeners();
	  return;
	}

	center = LatLng(result.latitude, result.longitude);
	latitude = result.latitude.toString();
	longitude = result.longitude.toString();
  	cityName = city;
	weatherData = await getWeather(city);

	} catch (e) {
	  error = "Erreur inattendue : $e";
	}


	notifyListeners();
  }

  // Met a jour la ville depuis les favoris
  void setCityFromFavorites(String city, LatLng newCenter) {
    center = newCenter;
    latitude = newCenter.latitude.toString();
    longitude = newCenter.longitude.toString();
    notifyListeners();
  }

  Future<WeatherData?> getWeather(String city) async {
	return await _weatherService.getWeather(city);
  }


}
