import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import '../providers/map_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/city_location.dart';


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

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _mapController.move(mapVM.center, 12.0),
    );

    return Column(
      children: [
        // Recherche
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              hintText: "Rechercher une ville...",
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: mapVM.searchCity,
          ),
        ),

        // Nom ville + icône favori
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mapVM.cityName ?? "Ville inconnue",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(
                favVM.favorites.any((c) => c.name == mapVM.cityName)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                if (mapVM.cityName == null) return;
                final city = CityLocation(
                  name: mapVM.cityName!,
                  latitude: double.tryParse(mapVM.latitude) ?? 0.0,
                  longitude: double.tryParse(mapVM.longitude) ?? 0.0,
                );
                favVM.favorites.contains(city)
                    ? favVM.removeFavorite(city)
                    : favVM.addFavorite(city);
              },
            ),
          ],
        ),

        // Coordonnées
        Text("Latitude: ${mapVM.latitude}, Longitude: ${mapVM.longitude}"),

        // Carte
        Expanded(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: mapVM.center, initialZoom: 12.0),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: mapVM.center,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
