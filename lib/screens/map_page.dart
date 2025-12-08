import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../providers/map_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/favorite_places_provider.dart';

import '../models/weather_data.dart';
import '../models/Lieu.dart';
import '../models/city_location.dart';
import '../widgets/favoriteplaces.dart';
import '../widgets/place_details_sheet.dart';
import 'favorites_page.dart';
import 'weather_card.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TextEditingController _cityController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mapVM = Provider.of<MapProvider>(context);
    final favVM = Provider.of<FavoritesProvider>(context);
	final favoritePlacesVM = Provider.of<FavoritesProviderPlace>(context);

	WidgetsBinding.instance.addPostFrameCallback(
      (_) => _mapController.move(mapVM.center, 12.0),
    );

    return Column(
      children: [
        // Recherche et titre ville
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: const [BoxShadow(blurRadius: 5, color: Colors.black26)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: "Rechercher une ville...",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => mapVM.searchCity(_cityController.text),
                  ),
                ),
                onSubmitted: mapVM.searchCity,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      icon: const Icon(Icons.list),
                      label: const Text("Favoris"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FavoritesPage()),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        mapVM.currentLocation.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

				  SizedBox(
                    width: 120,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          favVM.favorites.any(
                                (c) => c.name == mapVM.currentLocation.name,
                              )
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          final city = CityLocation(
                            id: mapVM.currentLocation.id,
                            name: mapVM.currentLocation.name,
                            latitude: mapVM.currentLocation.latitude,
                            longitude: mapVM.currentLocation.longitude,
                          );
                          favVM.favorites.contains(city)
                              ? favVM.removeFavorite(city)
                              : favVM.addFavorite(city);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Carte météo
        WeatherCard(
          mapVM.weatherData ??
              WeatherData(
                temperature: 0,
                description: "N/A",
                humidity: 0,
                minTemp: 0,
                maxTemp: 0,
                windSpeed: 0,
                windDirection: "N/A",
                iconCode: "01d",
              ),
        ),

        // Boutons catégories
        SizedBox(
          height: 45,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              _categoryButton(context, "parks", "Parcs"),
              _categoryButton(context, "museums", "Musées"),
              _categoryButton(context, "stations", "Gares"),
              _categoryButton(context, "universities", "Universités"),
              _categoryButton(context, "tourism", "Attractions"),
              _categoryButton(context, "restaurants", "Restaurants"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: TextButton(
                  onPressed: () async => await mapVM.activateAll(),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Tout Sélectionner'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: TextButton(
                  onPressed: () => mapVM.clearCategories(),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Tout Désélectionner'),
                ),
              ),
            ],
          ),
        ),

        // Carte
        Container(
          height: MediaQuery.of(context).size.height * 0.40,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.black12,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: mapVM.center,
                initialZoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c', 'd'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(mapVM.currentLocation.latitude, mapVM.currentLocation.longitude),
                      child: const Icon(Icons.my_location, color: Colors.red, size: 40),
                    ),
                    ...mapVM.lieux.map((p) {
                      if (p.name != "Lieu sans nom") {
                        return Marker(
                          width: 35,
                          height: 35,
                          point: LatLng(p.latitude, p.longitude),
                          child: GestureDetector(
                            onTap: () => _openPlaceDetails(context, p),
                            child: Icon(Icons.location_on, color: p.iconColor, size: 35),
                          ),
                        );
                      }
                      return null;
                    }).whereType<Marker>(),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Favoris filtrés par cityId
        Builder(
          builder: (_) {
            final currentCityId = mapVM.currentLocation.id;

            final favoritesInCity = favoritePlacesVM.favoritePlaces
                .where((f) => f.cityId == currentCityId)
                .toList();

            return favoritesInCity.isNotEmpty
                ? FavoritePlacesScroller(items: favoritesInCity)
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
      ],
    );
  }
}

void _openPlaceDetails(BuildContext context, Lieu lieu) {
  showModalBottomSheet(
    context: context,
	constraints: const BoxConstraints(maxWidth: double.infinity),
    isScrollControlled: true,
    builder: (context) {
      return PlaceDetailsSheet(lieu: lieu);
    },
  );
}

Widget _categoryButton(BuildContext context, String key, String label) {
  final mapVM = Provider.of<MapProvider>(context);
  final bool selected = mapVM.activeCategories.contains(key);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: ChoiceChip(
      label: Text(label),
      labelStyle: TextStyle(color: selected ? Theme.of(context).colorScheme.onPrimary : null),
      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
      selectedColor: Theme.of(context).colorScheme.primary,
      selected: selected,
      onSelected: (_) async => await mapVM.toggleCategory(key),
    ),
  );
}
