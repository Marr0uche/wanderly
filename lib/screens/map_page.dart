import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wanderly/models/Lieu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/map_provider.dart';
import '../providers/favorites_provider.dart';
import '../models/city_location.dart';
import '../models/weather_data.dart';
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
										favVM.favorites.any((c) => c.name == mapVM.currentLocation.name)
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
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 6),
						child: TextButton(
							child: Text('Tout Sélectionner'),
							onPressed: () => mapVM.activateAll(),
							style: TextButton.styleFrom(
					          foregroundColor: Theme.of(context).colorScheme.onPrimary,
					          backgroundColor: Theme.of(context).colorScheme.primary
							  
							),
						),
					),
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 6),
						child: TextButton(
							child: Text('Tout Désélectionner'),
							onPressed: () => mapVM.clearCategories(),
							style: TextButton.styleFrom(
								foregroundColor: Theme.of(context).colorScheme.onPrimary,
								backgroundColor: Theme.of(context).colorScheme.primary,
							),
						),
					),
				],
			),
        ),
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
                    urlTemplate:
                        "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                    subdomains: const ['a', 'b', 'c', 'd'],
                  ),
                  MarkerLayer(
                    markers: [
						Marker(
							width: 40,
							height: 40,
							point: LatLng(
								mapVM.currentLocation.latitude,
								mapVM.currentLocation.longitude,
							),
							child: const Icon(
								Icons.my_location,
								color: Colors.red,
								size: 40,
							),
						),
					  ...mapVM.lieux.map((p) {
						if(p.name != "Lieu sans nom"){ 
							return Marker(
								width: 35,
								height: 35,
								point: LatLng(p.latitude, p.longitude),
								child: GestureDetector(
									onTap: () => _openPlaceDetails(context, p),
									child: Icon( Icons.location_on, color: p.iconColor,size: 35),
								),
							);
						}
						return null;
					  }).whereType<Marker>()
					  
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

void _openPlaceDetails(BuildContext context, Lieu lieu) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lieu.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Adresse
                  if (lieu.tags["addr:street"] != null)
                    Text(
                      "${lieu.tags["addr:housenumber"] ?? ""} ${lieu.tags["addr:street"]}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                  const SizedBox(height: 8),

                  // Site Web cliquable
                  if (lieu.tags["website"] != null || lieu.tags["contact:website"] != null)
                    InkWell(
                      onTap: () => launchUrl(Uri.parse(lieu.tags["website"] ?? lieu.tags["contact:website"])),
                      child: Text(
                        "Site web : ${lieu.tags["website"] ?? lieu.tags["contact:website"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                 	 // Téléphone
					if (lieu.tags["phone"] != null)
						Text("Téléphone : ${lieu.tags["phone"]}"),

					if (lieu.tags["contact:phone"] != null)
						Text(
							"Téléphone : ${lieu.tags["contact:phone"]}",
							style: const TextStyle(fontSize: 16),
						),
					
					if (lieu.tags["contact:email"] != null)
						Text(
							"Email : ${lieu.tags["contact:email"]}",
							style: const TextStyle(fontSize: 16),
						),

					if (lieu.tags.containsKey("network"))
						Text("${lieu.tags["network"]}"),
						
					if (lieu.tags.containsKey("operator"))
						Text("${lieu.tags["operator"]}"),

                  const SizedBox(height: 15),

                  // Image avec gestion erreurs + fade-in
                  if (lieu.tags["image"] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        lieu.tags["image"],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) {
                          return const Text(
                            "Image indisponible",
                            style: TextStyle(color: Colors.grey),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
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
			onSelected: (_) => mapVM.toggleCategory(key),
		),
	);
}
