import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../services/location_service.dart';
import '../services/nominatim_service.dart';

class MapViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final NominatimService _nominatimService = NominatimService();

  LatLng center = const LatLng(47.845431, 1.937851);
  String latitude = "47.845431";
  String longitude = "1.937851";

  String? error;

  Future<void> init() async {
	final pos = await _locationService.getCurrentPosition();
	if (pos == null) return;

	center = LatLng(pos.latitude, pos.longitude);
	latitude = pos.latitude.toString();
	longitude = pos.longitude.toString();
	notifyListeners();
  }

  Future<void> searchCity(String city) async {
	try{

	if (city.trim().isEmpty) {
	  error = "Nom de ville invalide";
	  notifyListeners();
	  return;
	}

	error = null;
	notifyListeners();

	final result = await _nominatimService.searchCity(city);

	if (result == null) {
	  error = "Ville introuvable";
	  notifyListeners();
	  return;
	}

	center = LatLng(result.lat, result.lon);
	latitude = result.lat.toString();
	longitude = result.lon.toString();

	} catch (e) {
	  error = "Erreur inattendue : $e";
	}


	notifyListeners();
  }
}
