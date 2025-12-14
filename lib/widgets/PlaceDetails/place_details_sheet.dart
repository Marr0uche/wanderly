import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/favorite_places_provider.dart';
import '../../models/Lieu.dart';
import 'place_details_header.dart';
import 'place_details_info.dart';

class PlaceDetailsSheet extends StatelessWidget {
  final Lieu lieu;

  const PlaceDetailsSheet({super.key, required this.lieu});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProviderPlace>(
      builder: (_, favVM, _) {
        final updatedLieu = favVM.favoritePlaces.firstWhere(
          (p) => p.id == lieu.id,
          orElse: () => lieu,
        );

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: updatedLieu.tags["image"] != null ? 0.55 : 0.35,
          minChildSize: 0.25,
          maxChildSize: 0.95,
		  snap: true,
          snapSizes: const [0.35, 0.55, 0.95],
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  PlaceDetailsHeader(lieu: updatedLieu),
                  const SizedBox(height: 12),
                  PlaceDetailsInfo(lieu: updatedLieu),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

