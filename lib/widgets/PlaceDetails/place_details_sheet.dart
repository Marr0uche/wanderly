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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            return Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 26, 31, 55)
                    : const Color(0xFFE9EAEC),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white30 : Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          PlaceDetailsHeader(lieu: updatedLieu),
                          const SizedBox(height: 20),
                          PlaceDetailsInfo(lieu: updatedLieu),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
