import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../utils/location_service.dart';
import '../utils/nominatim_service.dart';
import '../models/weather_data.dart';
import '../utils/weather_service.dart';
import '../models/city_location.dart';
import '../models/Lieu.dart';
import '../utils/overpass_service.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart';

class MapProvider extends ChangeNotifier {
	final LocationService _locationService = LocationService();
	final NominatimService _nominatimService = NominatimService();
	final WeatherService _weatherService = WeatherService();
	CityLocation currentLocation = CityLocation(osmId: -1, osmType: "R", cityKey: "R-1", cityName: "Ma position", cityLat: 47.845431, cityLong: 1.937851);
	LatLng center = const LatLng(47.845431, 1.937851);
	WeatherData? weatherData;
	String? error;

	final OverpassService _overpass = OverpassService();
	List<Lieu> lieux = [];
	Set<String> activeCategories = {"tourism", "restaurants"};

	bool addingCustomLocation = false;
	
	bool isLoading = false;

	// Initialise la position actuelle
	Future<void> init() async {
		isLoading = true;
		notifyListeners();

		final pos = await _locationService.getCurrentPosition();
		if (pos == null) return;

		center = LatLng(pos.latitude, pos.longitude);
		currentLocation = CityLocation(osmId: -1, osmType: "R", cityKey: "R-1", cityName: "Ma position", cityLat: pos.latitude, cityLong: pos.longitude);

		final city = await _nominatimService.getCityNameFromCoordinates(pos.latitude, pos.longitude);
		if (city != null){
			currentLocation = city;
			weatherData = await getWeather(currentLocation.cityName);
			await loadPlaces();
		}
		isLoading = false;
		notifyListeners();
	}

	//Va à une ville spécifique sans recherche
	Future<void> goToCity(CityLocation city) async {
		isLoading = true;
		notifyListeners();

		currentLocation = city;
		center = LatLng(city.cityLat, city.cityLong);
		weatherData = await getWeather(city.cityName);
		await loadPlaces();

		isLoading = false;
		notifyListeners();
	}


	// Recherche une ville par son nom
	Future<void> searchCity(String city, BuildContext context) async {
		try{
			isLoading = true;
			notifyListeners();
			if (city.trim().isEmpty) {
				error = "Nom de ville invalide";
				isLoading = false;
				notifyListeners();
				return;
			}

			city = city[0].toUpperCase() + city.substring(1);

			// On vérifie si la ville existe via les suggestions
			final suggestions = await _nominatimService.searchCitySuggestions(city);

			if (suggestions.isEmpty) {
				error = "Aucun résultat trouvé";
				isLoading = false;
				notifyListeners();
				return;
			}

			// On prend la suggestion choisi ou la premiere
			CityLocation? chosen;

			if (suggestions.length > 1) {
				chosen = await _openCityChoiceDialog(context, suggestions);
			} else {
				chosen = suggestions.first;
			}

			center = LatLng(chosen!.cityLat, chosen.cityLong);
			currentLocation = chosen;
			weatherData = await getWeather(currentLocation.cityName);
			//print("getWeather result: $weatherData");

			await loadPlaces();
			//print("loadPlaces done");


		} catch (e) {
			error = "Erreur inattendue : $e";
		}

		isLoading = false;
		notifyListeners();
	}

	Future<CityLocation?> _openCityChoiceDialog(BuildContext context, List<CityLocation> options) async {
		final favVM = Provider.of<FavoritesProvider>(context, listen: false);
		return showDialog<CityLocation>(
			context: context,
			builder: (context) {
				return AlertDialog(
					title: const Text("Quelle ville vouliez-vous dire ?"),
					content: SizedBox(
						width: double.maxFinite,
						child: ListView.builder(
							shrinkWrap: true,
							itemCount: options.length,
							itemBuilder: (_, i) {
								final city = options[i];

								final isFav = favVM.favorites.any(
									(c) => c.cityKey == city.cityKey,
								);

								return ListTile(
									title: Text(city.cityName),
									subtitle: Text("lat: ${city.cityLat}, lon: ${city.cityLong}"),
									trailing: Icon(
										isFav ? Icons.favorite : Icons.favorite_border,
										color: Colors.red,
									),
									onTap: () => Navigator.pop(context, city),
								);
							},
						),
					),
				);
			},
		);
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

		if (currentLocation.cityLat == 0) return;

		lieux = (await _overpass.fetchPlaces(
			lat: currentLocation.cityLat,
			lon: currentLocation.cityLong,
			radius: 1200,
			categories: activeCategories,
		)).map((e) => Lieu.fromJson(e, currentLocation.cityKey)).toList();

		notifyListeners();
  	}


	Future<void> loadInitialCity(BuildContext context) async {
		isLoading = true;
		notifyListeners();

		final favVM = Provider.of<FavoritesProvider>(context, listen: false);

		await favVM.loadFavorites();

		final CityLocation? city;

		if (favVM.favorites.isNotEmpty) {
			//  Prendre la premiere ville favorite
			city = favVM.favorites.first;
		} else {
			city = await goToCurrentLocation();
		}

		if (city != null) {
			currentLocation = city;
			center = LatLng(currentLocation.cityLat, currentLocation.cityLong);
			weatherData = await getWeather(currentLocation.cityName);
			await loadPlaces();
		}

		isLoading = false;
		notifyListeners();
	}

	
	Future<CityLocation?> goToCurrentLocation() async {
		isLoading = true;
		notifyListeners();

		final pos = await _locationService.getCurrentPosition();
		if (pos == null) {
			isLoading = false;
			notifyListeners();
			return null;
		}
		center = LatLng(pos.latitude, pos.longitude);
		final city = await _nominatimService.getCityNameFromCoordinates(
			pos.latitude,
			pos.longitude,
		);

		CityLocation finalCity;

		if (city != null) {
			finalCity = city;
		} else {
			finalCity = CityLocation(
			osmId: -1,
			osmType: "R",
			cityKey: "R-1",
			cityName: "Ma position",
			cityLat: pos.latitude,
			cityLong: pos.longitude,
			);
		}

		currentLocation = finalCity;
		weatherData = await getWeather(finalCity.cityName);
		await loadPlaces();

		isLoading = false;
		notifyListeners();

		return finalCity;
	}


	void startAddingCustomLocation() {
		addingCustomLocation = true;
		notifyListeners();
	}

	void stopAddingCustomLocation() {
		addingCustomLocation = false;
		notifyListeners();
	}

	Future<Lieu?> addCustomLocation(String name, LatLng latlng) async {
		isLoading = true;
		notifyListeners();

		// On récupère la ville pour générer une cityKey
		final city = await _nominatimService.getCityNameFromCoordinates(
			latlng.latitude,
			latlng.longitude,
		);

		if (city == null) return null;

		String cityKey = currentLocation.cityKey;

		final customLieu = Lieu(
			id: DateTime.now().millisecondsSinceEpoch,
			name: name,
			latitude: latlng.latitude,
			longitude: latlng.longitude,
			isCustom: true,
			tags: {},
			cityKey: cityKey,
		);

		isLoading = false;
		notifyListeners();

		return customLieu;
	}


}
