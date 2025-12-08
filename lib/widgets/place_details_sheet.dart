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

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                width: constraints.maxWidth, 
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            lieu.name + (lieu.tags.containsKey("amenity") ? " (${lieu.tags["amenity"]})" : ""),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            favoritePlacesVM.favoritePlaces.any(
                                  (c) => c.name == lieu.name,
                                )
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            favoritePlacesVM.favoritePlaces.contains(lieu)
                                ? favoritePlacesVM.removeFavoritePlace(lieu)
                                : favoritePlacesVM.addFavoritePlace(lieu);
						  },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (lieu.tags["addr:street"] != null)
                      Text(
                        "${lieu.tags["addr:housenumber"] ?? ""} ${lieu.tags["addr:street"]}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                    const SizedBox(height: 10),

                    if (lieu.tags["website"] != null ||
                        lieu.tags["contact:website"] != null)
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
                                  lieu.tags["website"] ??
                                      lieu.tags["contact:website"],
                                ),
                              ),
                              child: Text(
                                lieu.tags["website"] ??
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

                    if (lieu.tags["phone"] != null)
                      Text("Téléphone : ${lieu.tags["phone"]}"),

                    if (lieu.tags["contact:phone"] != null)
                      Text("Téléphone : ${lieu.tags["contact:phone"]}"),

                    if (lieu.tags["contact:email"] != null)
                      Text("Email : ${lieu.tags["contact:email"]}"),

					if (lieu.tags["contact:facebook"] != null)
                      Text("${lieu.tags["contact:facebook"]}"),

					if (lieu.tags.containsKey("network"))
                      Text("${lieu.tags["network"]}"),

                    if (lieu.tags.containsKey("operator"))
                      Text("${lieu.tags["operator"]}"),

				 	if(lieu.tags.containsKey("opening_hours"))
					  Text("Horaires : ${lieu.tags["opening_hours"]}"),

					if (lieu.tags.containsKey("cuisine"))
                      Text("${lieu.tags["cuisine"]}"),

                    const SizedBox(height: 15),

                    if (lieu.tags["image"] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          lieu.tags["image"],
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
      },
    );
  }
}
