import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../providers/map_provider.dart';
import '../providers/favorite_places_provider.dart';
import '../models/Lieu.dart';
import '../utils/map_dialogs.dart';
import 'map_search_bar.dart';

class MapWidget extends StatelessWidget {
  final MapController mapController;
  final Function(Lieu) onOpenPlaceDetails;

  const MapWidget({
    super.key,
    required this.mapController,
    required this.onOpenPlaceDetails,
  });

  @override
  Widget build(BuildContext context) {
    final mapVM = Provider.of<MapProvider>(context);
    final favoritePlacesVM = Provider.of<FavoritesProviderPlace>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // ... (Reste du code MapWidget inchangé, il était déjà correct)
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
        child: Stack( 
		  children:  [ 
			FlutterMap(
				mapController: mapController,
				options: MapOptions(
					initialCenter: mapVM.center,
					initialZoom: 12.0,
					onTap: (_, latlng) {
					if (mapVM.addingCustomLocation) {
						mapVM.stopAddingCustomLocation();
						openNameInputDialog(context, latlng); 
					}
					},
				),
				children: [
					// TileLayer
					TileLayer(
					urlTemplate: isDark
						? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
						: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
					subdomains: const ['a', 'b', 'c', 'd'],
					),

					// MarkerLayer
					MarkerLayer(
						markers: [
							// Marqueur de la ville actuelle
							Marker(
							width: 40,
							height: 40,
							point: LatLng(mapVM.currentLocation.cityLat, mapVM.currentLocation.cityLong),
							child: const Icon(Icons.my_location, color: Colors.red, size: 40),
							),
							// Marqueurs des lieux d'intérêt (non-custom)
							...mapVM.lieux.map((p) {
							if (p.name != "Lieu sans nom") {
								return Marker(
								width: 35,
								height: 35,
								point: LatLng(p.latitude, p.longitude),
								child: GestureDetector(
									onTap: () => onOpenPlaceDetails(p),
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
								onTap: () => onOpenPlaceDetails(p),
								child: const Icon(
									Icons.location_on,
									size: 40,
									color: Colors.deepPurpleAccent,
								),
								),
							);
							}),
						],
					),

					// Bouton de recentrage
					Positioned(
						top: 12,
						left: 12,
						right: 70,
						child: MapSearchBar(),
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
							mapController.move(
								LatLng(
								mapVM.currentLocation.cityLat,
								mapVM.currentLocation.cityLong,
								),
								12,
							);
							},
							child: const Icon(Icons.my_location, color: Colors.white),
						),
					)
				],
			),
		   ], 
	      ),
		),
      );
  }
}