import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends StatelessWidget {
const FavoritesPage({super.key});

@override
Widget build(BuildContext context) {
final favVM = Provider.of<FavoritesProvider>(context);
return Scaffold(
  appBar: AppBar(title: const Text("Villes favorites")),
  body: ListView.builder(
    itemCount: favVM.favorites.length,
    itemBuilder: (context, index) {
      final city = favVM.favorites[index];
      return ListTile(
        title: Text(city.name),
        subtitle: Text("Lat: ${city.latitude}, Lon: ${city.longitude}"),
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