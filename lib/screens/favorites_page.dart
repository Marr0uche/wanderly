import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/map_provider.dart';


class FavoritesPage extends StatelessWidget {
	const FavoritesPage({super.key});

	@override
	Widget build(BuildContext context) {
		final favVM = Provider.of<FavoritesProvider>(context);
		final mapVM = Provider.of<MapProvider>(context);

		return Scaffold(
			appBar: AppBar(title: const Text("Villes favoris")),
			body: ListView.builder(
				itemCount: favVM.favorites.length,
				itemBuilder: (context, index) {
					final city = favVM.favorites[index];
					return ListTile(
						onTap: () {
							mapVM.goToCity(city);
							Navigator.pop(context, city);
						},
						title: Text(city.cityName),
						subtitle: Text("Lat: ${city.cityLat}, Lon: ${city.cityLong}"),
						trailing: IconButton(
							icon: const Icon(Icons.delete),
							onPressed: () => favVM.removeFavorite(city),
						),
					);
				},
			),
		);

	}
}