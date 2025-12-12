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

    return Row(
      children: [
        Expanded(
          child: Text(
            lieu.name + (lieu.tags.containsKey("amenity") ? " (${lieu.tags["amenity"]})" : ""),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: Icon(
            isFav ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            isFav
                ? favVM.removeFavoritePlace(lieu)
                : favVM.addFavoritePlace(lieu);
          },
        ),
        if (isFav)
			ElevatedButton(
				child: const Text("Ajouter / Modifier une note"),
				onPressed: () =>
					showDialog(
						context: context,
						builder: (_) => PlaceNoteDialog(lieu: lieu),
					),
			),
      ],
    );
  }
}

