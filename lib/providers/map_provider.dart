import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/location_service.dart';
import '../utils/nominatim_service.dart';
import '../models/weather_data.dart';
import '../utils/weather_service.dart';
import '../models/city_location.dart';
import '../models/Lieu.dart';
import '../utils/overpass_service.dart';

class MapProvider extends ChangeNotifier {
	final LocationService _locationService = LocationService();
	final NominatimService _nominatimService = NominatimService();
	final WeatherService _weatherService = WeatherService();
	CityLocation currentLocation = CityLocation(id: -1, name: "Ma position", latitude: 47.845431, longitude: 1.937851);
	LatLng center = const LatLng(47.845431, 1.937851);
	WeatherData? weatherData;
	String? error;

	final OverpassService _overpass = OverpassService();
	List<Lieu> lieux = [];
	Set<String> activeCategories = {"parks"};
	
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
			currentLocation = city;
			weatherData = await getWeather(city.name);
			activateAll();
			await loadPlaces();
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
			await loadPlaces();

		} catch (e) {
			error = "Erreur inattendue : $e";
		}

		isLoading = false;
		notifyListeners();
	}

	Future<WeatherData?> getWeather(String city) async {
		return await _weatherService.getWeather(city);
	}

	/* Tout ce qui est lieux */

	Future<void> toggleCategory(String category) async {
		isLoading = true;
		notifyListeners();

		if (activeCategories.contains(category)) {
			activeCategories.remove(category);
		} else {
			activeCategories.add(category);
		}
		await loadPlaces();

		isLoading = false;
		notifyListeners();
	}

	void clearCategories() {
		activeCategories.clear();
		lieux = [];
		notifyListeners();
	}

	Future<void> activateAll() async {
		isLoading = true;
		notifyListeners();

		activeCategories = {
			"parks",
			"museums",
			"stations",
			"universities",
			"tourism",
      		"restaurants"
		};
		await loadPlaces();
		isLoading = false;
		notifyListeners();
	}

	Future<void> loadPlaces() async {

		if (currentLocation.latitude == 0) return;

		lieux = (await _overpass.fetchPlaces(
			lat: currentLocation.latitude,
			lon: currentLocation.longitude,
			radius: 2000,
			categories: activeCategories,
		)).map((e) => Lieu.fromJson(e, currentLocation.id)).toList();

		notifyListeners();
  	}

}
