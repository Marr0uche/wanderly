import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import '../providers/map_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/city_location.dart';
import '../models/weather_data.dart';
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

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _mapController.move(mapVM.center, 12.0),
    );

    return Column(
      children: [
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
                  decoration: const InputDecoration(
                    hintText: "Rechercher une ville...",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: mapVM.searchCity,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      mapVM.cityName ?? "Ville inconnue",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                    )
                  ],
                ),

                Text("Lat: ${mapVM.latitude} | Lon: ${mapVM.longitude}"),
              ],
            ),
          ),
		
		//WeatherCard
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

         Container(
			height: MediaQuery.of(context).size.height * 0.40,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
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
                    urlTemplate:
                        "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c', 'd'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
						point: mapVM.center,
						width: 40,
						height: 40,
						alignment: Alignment.topCenter,
						child: const Icon(
							Icons.location_on,
							color: Colors.red,
							size: 40,
						),
					  )
                    ],
                  ),
                ],
              ),
            ),
          ),


         Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
            ),
            child: const Center(
              child: Text(
                "Infos supplémentaires à venir...",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
      ],
    );
  }
}