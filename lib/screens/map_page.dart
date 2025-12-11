import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../providers/map_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/favorite_places_provider.dart';

import '../models/Lieu.dart';
import '../widgets/favoriteplaces.dart';
import '../widgets/place_details_sheet.dart';
import 'weather_card.dart';

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
  
	final theme = Theme.of(context);
	final isDark = theme.brightness == Brightness.dark;
	WidgetsBinding.instance.addPostFrameCallback((_) {
		if (_lastCenter == null ||
			_lastCenter!.latitude != mapVM.center.latitude ||
			_lastCenter!.longitude != mapVM.center.longitude) {
			_mapController.move(mapVM.center, 12.0);
			_lastCenter = mapVM.center;
		}
    });

    return  Container(
		width: double.infinity,
		color: Theme.of(context).brightness == Brightness.dark
			? const Color.fromARGB(255, 26, 31, 55) 
			: const Color(0xFFE9EAEC),             
		child: Column(
			children: [
				// Recherche et titre ville
				Container(

					width: double.infinity,
					decoration: BoxDecoration(
						color: isDark ? const Color.fromARGB(255, 101, 99, 86) : const Color.fromARGB(255, 199, 241, 253),
						borderRadius: BorderRadius.circular(12),
						boxShadow: [
						BoxShadow(
							color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
							blurRadius: 5,
							offset: const Offset(0, 3),
						),
						],
					),
					child: TextField(
						controller: _cityController,
						decoration: InputDecoration(
							hintText: "Rechercher une ville...",
							filled: true,
							fillColor: isDark ? const Color.fromARGB(255, 48, 77, 85) : const Color.fromARGB(255, 192, 204, 216),
							border: OutlineInputBorder(
								borderRadius: BorderRadius.circular(12),
								borderSide: BorderSide(
								color: isDark ? Colors.white : Colors.black54,
								width: 1.5,
								),
							),
							enabledBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(12),
								borderSide: BorderSide(
								color: isDark ? Colors.white70 : Colors.black54,
								width: 1.2,
								),
							),
							focusedBorder: OutlineInputBorder(
								borderRadius: BorderRadius.circular(12),
								borderSide: BorderSide(
								color: isDark ? Colors.white : Colors.black87,
								width: 2,
								),
							),
							suffixIcon: IconButton(
								icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black87),
								onPressed: () => mapVM.searchCity(_cityController.text, context),
							),
						),
						onSubmitted: (value) => mapVM.searchCity(value, context),
					),
				),

        // Carte météo   
		mapVM.weatherData == null
    	? const Padding(
			padding: EdgeInsets.all(16),
			child: Center(
			child: CircularProgressIndicator(),
			),
		)
    	: WeatherCard(
			data: mapVM.weatherData!,
			cityName: mapVM.currentLocation.cityName,
			isFavorite: favVM.favorites.any(
			(c) => c.cityKey == mapVM.currentLocation.cityKey,
			),
			onToggleFavorite: () {
			final city = mapVM.currentLocation;
			favVM.favorites.any((c) => c.cityKey == city.cityKey)
				? favVM.removeFavorite(city)
				: favVM.addFavorite(city);
			},
		),
		Padding(
			padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
			child: Wrap(
				spacing: 8,
				runSpacing: 8, 
				children: [
					_categoryButton(context, "parks", "Parcs"),
					_categoryButton(context, "museums", "Musées"),
					_categoryButton(context, "stations", "Gares"),
					_categoryButton(context, "universities", "Universités"),
					_categoryButton(context, "tourism", "Attractions"),
					_categoryButton(context, "restaurants", "Restaurants"),

					TextButton(
						onPressed: () async => await mapVM.activateAll(),
						style: TextButton.styleFrom(
							backgroundColor: isDark
								? const Color.fromARGB(255, 48, 77, 85)       
								: const Color.fromARGB(255, 90, 118, 146),      
							foregroundColor: Colors.white,
							padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(10),
							),
						),
						child: const Text("Tout Sélectionner"),
					),

					TextButton(
						onPressed: () => mapVM.clearCategories(),
						style: TextButton.styleFrom(
							backgroundColor: isDark
								? const Color.fromARGB(255, 48, 77, 85)       
								: const Color.fromARGB(255, 90, 118, 146),   
							foregroundColor: Colors.white,
							padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(10),
							),
						),
						child: const Text("Tout Désélectionner"),
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
				//Pour créer un lieu custom
				onTap: (_, latlng) {
                    // Si on est en mode ajout de lieu custom
                    if (mapVM.addingCustomLocation) {
                      mapVM.stopAddingCustomLocation();
                      _openNameInputDialog(context, latlng);
                    }
				},
              ),
              children: [
                TileLayer(
					urlTemplate: isDark
						? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
						: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
					subdomains: const ['a', 'b', 'c', 'd'],
				),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40,
                      height: 40,
                      point: LatLng(mapVM.currentLocation.cityLat, mapVM.currentLocation.cityLong),
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
					// Markers pour les lieux personnalisés
					...favoritePlacesVM.favoritePlaces
						.where((p) => p.isCustom)
						.map((p) {
						return Marker(
							width: 40,
							height: 40,
							point: LatLng(p.latitude, p.longitude),
							child: GestureDetector(
								onTap: () => _openPlaceDetails(context, p),

								child: const Icon(
									Icons.push_pin,
									size: 40,
									color: Colors.deepPurpleAccent,
								),
							),
						);
					}),
                  ],
                ),
                Positioned(
					right: 10,
					top: 10,
					child: FloatingActionButton(
						heroTag: "btnCenter",
						mini: true,
						backgroundColor: isDark
							? const Color.fromARGB(255, 48, 77, 85)
							: const Color.fromARGB(255, 90, 118, 146),
						onPressed: () async {
						await mapVM.goToCurrentLocation();
						_mapController.move(
							LatLng(
							mapVM.currentLocation.cityLat,
							mapVM.currentLocation.cityLong,
							),
							13,
						);
						},
						child: const Icon(Icons.my_location, color: Colors.white),
          			),
				)
              ],
            ),
          ),
        ),
        
		SizedBox(height: 20),
        
        // Favoris filtrés par cityKey
        Builder(
          builder: (_) {
            final currentCityKey = mapVM.currentLocation.cityKey;

            final favoritesInCity = favoritePlacesVM.favoritePlaces
                .where((f) => f.cityKey == currentCityKey)
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
		SizedBox(height: 20),
		ElevatedButton.icon(
            onPressed: () => _enterCustomLocationMode(context),
            icon: const Icon(Icons.add_location_alt),
            label: const Text("Ajouter un lieu personnalisé"),
        )
      ],
        ),
    );
  }
}

void _enterCustomLocationMode(BuildContext context) {
	ScaffoldMessenger.of(context).showSnackBar(
		const SnackBar(
		content: Text("Touchez la carte pour choisir un emplacement"),
		),
	);

	Provider.of<MapProvider>(context, listen: false).startAddingCustomLocation();
}

void _openNameInputDialog(BuildContext context, LatLng latlng) async {
	final TextEditingController nameCtrl = TextEditingController();

	showDialog(
		context: context,
		builder: (_) => AlertDialog(
			title: const Text("Nom du lieu personnalisé lié à la ville actuelle"),
			content: TextField(
				controller: nameCtrl,
				decoration: const InputDecoration(hintText: "ex : Ma maison"),
			),
			actions: [
				TextButton(
					child: const Text("Annuler"),
					onPressed: () => Navigator.pop(context),
				),
				TextButton(
					child: const Text("Enregistrer"),
					onPressed: () async {
						final name = nameCtrl.text.trim();
						if (name.isNotEmpty) {
							Navigator.pop(context);
							final mapVM = Provider.of<MapProvider>(context, listen: false);
							final favoritePlacesVM = Provider.of<FavoritesProviderPlace>(context, listen: false);

							final customLieu = await mapVM.addCustomLocation(name, latlng);

							if (customLieu != null) {
								favoritePlacesVM.addFavoritePlace(customLieu);

								ScaffoldMessenger.of(context).showSnackBar(
									const SnackBar(content: Text("Lieu personnalisé ajouté !")),
								);
							}
						}
					},
				),
			],
		),
	);
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
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final bool selected = mapVM.activeCategories.contains(key);

  final Color selectedColor = isDark
      ? const Color.fromARGB(255, 48, 77, 85)       
        : const Color.fromARGB(255, 90, 118, 146);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    child: ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected
              ? Colors.white                     
              : (isDark ? Colors.white70 : Colors.black87),
        ),
      ),
      selected: selected,
      selectedColor: selectedColor,
      checkmarkColor: Colors.white,             
      backgroundColor:
          isDark ? const Color.fromARGB(255, 48, 77, 85) : Colors.white70,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? const Color.fromARGB(255, 118, 121, 137)                     
              : (isDark ? Colors.white54 : const Color.fromARGB(255, 48, 77, 85)),
          width: 1.5,
        ),
      ),
      onSelected: (_) async => await mapVM.toggleCategory(key),
    ),
  );
}