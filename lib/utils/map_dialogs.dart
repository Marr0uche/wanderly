import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';

import '../models/Lieu.dart';
import '../providers/map_provider.dart';
import '../providers/favorite_places_provider.dart';
import '../widgets/place_details_sheet.dart'; 


void enterCustomLocationMode(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Touchez la carte pour choisir un emplacement"),
    ),
  );

  Provider.of<MapProvider>(context, listen: false).startAddingCustomLocation();
}


void openNameInputDialog(BuildContext context, LatLng latlng) async {
  final TextEditingController nameCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Nom du lieu personnalisé lié à la ville actuelle"),
      content: TextField(
        controller: nameCtrl,
        decoration: const InputDecoration(hintText: "ex : Ma maison"),
      ),
      actions: [
        TextButton(
          child: const Text("Annuler"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Enregistrer"),
          onPressed: () async {
            final name = nameCtrl.text.trim();
            if (name.isNotEmpty) {
              Navigator.pop(context);
              // Les 'listen: false' sont nécessaires dans un callback
              final mapVM = Provider.of<MapProvider>(context, listen: false); 
              final favoritePlacesVM = Provider.of<FavoritesProviderPlace>(context, listen: false);

              final customLieu = await mapVM.addCustomLocation(name, latlng);

              if (customLieu != null) {
                favoritePlacesVM.addFavoritePlace(customLieu);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Lieu personnalisé ajouté !")),
                );
              }
            }
          },
        ),
      ],
    ),
  );
}


void openPlaceDetails(BuildContext context, Lieu lieu) {
  showModalBottomSheet(
    context: context,
    constraints: const BoxConstraints(maxWidth: double.infinity),
    isScrollControlled: true,
    builder: (context) {
      return PlaceDetailsSheet(lieu: lieu);
    },
  );
}