import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';
import '../providers/favorite_places_provider.dart';
import '../models/Lieu.dart';

class PlaceDetailsSheet extends StatelessWidget {
  final Lieu lieu;

  const PlaceDetailsSheet({super.key, required this.lieu});

  @override
  Widget build(BuildContext context) {
	final favoritePlacesVM = Provider.of<FavoritesProviderPlace>(context);

	return Consumer<FavoritesProviderPlace>(
		builder: (context, favVM, _) {
		
		// get updated info from provider
		final updatedLieu = favVM.favoritePlaces.firstWhere(
			(p) => p.id == lieu.id,
			orElse: () => lieu, // if not a favorite yet
		);

			return DraggableScrollableSheet(
			expand: false,
			initialChildSize: 0.35,
			minChildSize: 0.25,
			maxChildSize: 0.95,
			builder: (context, scrollController) {
				return SingleChildScrollView(
					controller: scrollController,
					child: Container(
						padding: const EdgeInsets.all(20),
						child: Column(
						crossAxisAlignment: CrossAxisAlignment.center,
						children: [
							Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Expanded(
								child: Text(
									updatedLieu.name + (updatedLieu.tags.containsKey("amenity") ? " (${updatedLieu.tags["amenity"]})" : ""),
									style: const TextStyle(
									fontSize: 24,
									fontWeight: FontWeight.bold,
									),
								),
								),
								IconButton(
								icon: Icon(
									favoritePlacesVM.favoritePlaces.any(
										(c) => c.name == updatedLieu.name,
										)
										? Icons.favorite
										: Icons.favorite_border,
									color: Colors.red,
								),
								onPressed: () {
									favoritePlacesVM.isPlaceFavorite(updatedLieu)
										? favoritePlacesVM.removeFavoritePlace(updatedLieu)
										: favoritePlacesVM.addFavoritePlace(updatedLieu);
								},
								),

								if (favoritePlacesVM.isPlaceFavorite(updatedLieu))
								ElevatedButton(
									child: const Text("Ajouter / Modifier une note"),
									onPressed: () =>
										_openNotePopup(context, updatedLieu, favoritePlacesVM),
								),
							],
							),
							const SizedBox(height: 12),

							if (updatedLieu.tags["addr:street"] != null)
							Text(
								"${updatedLieu.tags["addr:housenumber"] ?? ""} ${updatedLieu.tags["addr:street"]}",
								style: const TextStyle(
								fontSize: 16,
								color: Colors.grey,
								),
							),

							const SizedBox(height: 10),

							if (updatedLieu.tags["website"] != null ||
								updatedLieu.tags["contact:website"] != null)
							Row(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
								const Text(
									"Site web : ",
									style: TextStyle(fontSize: 16),
								),
								Expanded(
									child: InkWell(
									onTap: () => launchUrl(
										Uri.parse(
										updatedLieu.tags["website"] ??
											updatedLieu.tags["contact:website"],
										),
									),
									child: Text(
										updatedLieu.tags["website"] ??
											lieu.tags["contact:website"],
										style: const TextStyle(
										fontSize: 16,
										color: Colors.blue,
										decoration: TextDecoration.underline,
										),
										softWrap: true,
									),
									),
								),
								],
							),

							const SizedBox(height: 10),

							if (updatedLieu.tags["phone"] != null)
							Text("Téléphone : ${updatedLieu.tags["phone"]}"),

							if (updatedLieu.tags["contact:phone"] != null)
								Text("Téléphone : ${updatedLieu.tags["contact:phone"]}"),

							if (updatedLieu.tags["contact:email"] != null)
							Text("Email : ${updatedLieu.tags["contact:email"]}"),

							if (updatedLieu.tags["contact:facebook"] != null)
							Row(mainAxisAlignment: MainAxisAlignment.center,
								children: [
								Expanded(
									child: InkWell(
									onTap: () => launchUrl(
										Uri.parse(
										updatedLieu.tags["contact:facebook"] ??
											updatedLieu.tags["contact:facebook"],
										),
									),
									child: Text(
										updatedLieu.tags["contact:facebook"] ??
											updatedLieu.tags["contact:facebook"],
										style: const TextStyle(
										fontSize: 16,
										color: Colors.blue,
										decoration: TextDecoration.underline,
										),
										softWrap: true,
									),
									),
								),
							],),
							

							if (updatedLieu.tags.containsKey("network"))
								Text("${updatedLieu.tags["network"]}"),

							if (updatedLieu.tags.containsKey("operator"))
								Text("${updatedLieu.tags["operator"]}"),

							if(updatedLieu.tags.containsKey("opening_hours"))
								Text("Horaires : ${updatedLieu.tags["opening_hours"]}"),

							if (updatedLieu.tags.containsKey("cuisine"))
							Text("${updatedLieu.tags["cuisine"]}"),

							const SizedBox(height: 15),


							if (updatedLieu.rating != null)
							Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: List.generate(
								5,
								(i) => Icon(
									i < updatedLieu.rating! ? Icons.star : Icons.star_border,
									color: Colors.amber,
								),
								),
							),

							if (updatedLieu.note != null && updatedLieu.note!.isNotEmpty)
							Padding(
								padding: const EdgeInsets.symmetric(vertical: 8.0),
								child: Text(
								"\"${updatedLieu.note}\"",
								textAlign: TextAlign.center,
								style: const TextStyle(fontStyle: FontStyle.italic),
								),
							),

							if (updatedLieu.tags["image"] != null)
							ClipRRect(
								borderRadius: BorderRadius.circular(12),
								child: Image.network(
								updatedLieu.tags["image"],
								fit: BoxFit.cover,
								errorBuilder: (_, __, ___) => const Text(
									"Image indisponible",
									style: TextStyle(color: Colors.grey),
								),
								),
							),

							const SizedBox(height: 20),
						],
						),
					),
				);
			},
			);
		}
	);
}


void _openNotePopup(
  BuildContext context,
  Lieu lieu,
  FavoritesProviderPlace vm,
) {
  final noteController = TextEditingController(text: lieu.note ?? "");
  double rating = lieu.rating ?? 0;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Note pour ${lieu.name}"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (i) {
                    return IconButton(
                      icon: Icon(
                        i < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          rating = (i + 1).toDouble();
                        });
                      },
                    );
                  }),
                ),

                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Votre note"),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Annuler"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text("Enregistrer"),
                onPressed: () {
                  vm.updatePlaceNote(lieu.id, rating, noteController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    },
  );
}
}
