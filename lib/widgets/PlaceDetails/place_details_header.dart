import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Lieu.dart';
import '../../providers/favorite_places_provider.dart';
import 'place_note_dialog.dart';

class PlaceDetailsHeader extends StatelessWidget {
  final Lieu lieu;

  const PlaceDetailsHeader({super.key, required this.lieu});

  @override
  Widget build(BuildContext context) {
    final favVM = context.watch<FavoritesProviderPlace>();
    final isFav = favVM.isPlaceFavorite(lieu);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color.fromARGB(255, 48, 77, 85) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: lieu.iconColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  lieu.isCustom ? Icons.push_pin : Icons.place,
                  color: lieu.iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),

              // Le titre et catégorie du lieu
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lieu.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (lieu.tags.containsKey("amenity"))
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color.fromARGB(
                                  255,
                                  90,
                                  118,
                                  146,
                                ).withOpacity(0.3)
                              : const Color.fromARGB(255, 192, 204, 216),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          lieu.tags["amenity"],
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
			  
              // Bouton favori
              Container(
                decoration: BoxDecoration(
                  color: isFav
                      ? Colors.red.withOpacity(0.1)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                    size: 28,
                  ),
                  onPressed: () {
                    if (isFav) {
                      favVM.removeFavoritePlace(lieu);
                    } else {
                      favVM.addFavoritePlace(lieu);
                    }
                  },
                ),
              ),
            ],
          ),
          // Bouton note - seulement afficher si favori
          if (isFav) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => PlaceNoteDialog(lieu: lieu),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color.fromARGB(255, 90, 118, 146)
                      : const Color.fromARGB(255, 90, 118, 146),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.edit_note, size: 20),
                label: const Text(
                  "Ajouter / Modifier une note",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
