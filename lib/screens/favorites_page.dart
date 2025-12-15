import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanderly/widgets/FavoriteCities/favorite_city_card.dart';
import '../providers/favorites_provider.dart';
import '../widgets/FavoriteCities/empty_cities_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favVM = Provider.of<FavoritesProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 26, 31, 55)
          : const Color(0xFFE9EAEC),
      appBar: AppBar(
        title: const Text(
          "Villes Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark
            ? const Color.fromARGB(255, 48, 77, 85)
            : const Color.fromARGB(255, 90, 118, 146),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (favVM.favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${favVM.favorites.length} ville${favVM.favorites.length > 1 ? 's' : ''}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: favVM.favorites.isEmpty
          ? emptyState(isDark)
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favVM.favorites.length,
              itemBuilder: (context, index) {
                final city = favVM.favorites[index];
                return cityCard(
                  context,
                  city,
                  isDark
                );
              },
            ),
    );
  }
}
