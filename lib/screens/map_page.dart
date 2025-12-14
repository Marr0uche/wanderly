import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../providers/map_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/favorite_places_provider.dart';

import '../widgets/search_city.dart';
import '../widgets/category_button.dart';
import '../widgets/map_widget.dart';
import '../widgets/weather_card.dart';
import '../widgets/FavoritePlaces/favoriteplaces.dart'; 
import '../utils/map_dialogs.dart'; 

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _cityController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng? _lastCenter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).loadInitialCity(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapVM = Provider.of<MapProvider>(context);
    final favVM = Provider.of<FavoritesProvider>(context);
    final favoritePlacesVM = Provider.of<FavoritesProviderPlace>(context);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_lastCenter == null ||
          _lastCenter!.latitude != mapVM.center.latitude ||
          _lastCenter!.longitude != mapVM.center.longitude) {
        _mapController.move(mapVM.center, 12.0);
        _lastCenter = mapVM.center;
      }
    });

    return Container(
      width: double.infinity,
      color: isDark
          ? const Color.fromARGB(255, 26, 31, 55)
          : const Color(0xFFE9EAEC),
      child: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            //  Champ de recherche de ville
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CitySearchField(controller: _cityController),
            ),

            //  Carte météo
            mapVM.weatherData == null
                ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                  )
                : WeatherCard(
                      data: mapVM.weatherData!,
                      cityName: mapVM.currentLocation.cityName,
                      isFavorite: favVM.favorites.any((c) => c.cityKey == mapVM.currentLocation.cityKey),
                      onToggleFavorite: () {
                          final city = mapVM.currentLocation;
                          favVM.favorites.any((c) => c.cityKey == city.cityKey)
                              ? favVM.removeFavorite(city)
                              : favVM.addFavorite(city);
                      },
                  ),

            //  Boutons de catégories
            const CategoryFilterButtons(),

            //  Carte
            MapWidget(
              mapController: _mapController,
              onOpenPlaceDetails: (lieu) => openPlaceDetails(context, lieu), 
            ),

            const SizedBox(height: 20),

            //  Favoris filtrés
            Builder(
              builder: (_) {
                final currentCityKey = mapVM.currentLocation.cityKey;

                final favoritesInCity = favoritePlacesVM.favoritePlaces
                    .where((f) => f.cityKey == currentCityKey)
                    .toList();

                return favoritesInCity.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              "Lieux favoris dans cette ville",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          FavoritePlacesScroller(items: favoritesInCity),
                        ],
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: const Center(
                          child: Text(
                            "Pas de lieux favoris dans cette ville",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
              },
            ),
            
			const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
