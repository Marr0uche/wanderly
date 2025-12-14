import 'package:flutter/material.dart';
import '../../models/Lieu.dart';
import 'favorite_place_card.dart';

class FavoritePlacesScroller extends StatelessWidget {
  final List<Lieu> items;

  const FavoritePlacesScroller({super.key, required this.items});

  static const double _cardHeight = 200;
  static const double _cardWidth = 160;
  static const double _imageHeight = 110;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("Pas de lieux favoris"));
    }

    return SizedBox(
      height: _cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return FavoritePlaceCard(
            lieu: items[index],
            imageHeight: _imageHeight,
            width: _cardWidth,
          );
        },
      ),
    );
  }
}