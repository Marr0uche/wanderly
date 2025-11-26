import 'package:flutter/material.dart';
import 'map_page.dart';
import 'favorites_page.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class HomePage extends StatelessWidget {
const HomePage({super.key});

@override
Widget build(BuildContext context) {
  final themeVM = Provider.of<ThemeProvider>(context);

  return Scaffold(
    appBar: AppBar(
      title: const Text("Wanderly"),
      actions: [
        IconButton(
          icon: Icon(themeVM.isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
          onPressed: () => themeVM.toggleTheme(),
        ),
      ],
    ),
    body: Column(
      children: [
        Expanded(
          child: const MapPage(), // Affiche la carte + recherche
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.list),
            label: const Text("Voir villes favorites"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}