import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
    return Container(
      height: _cardHeight,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ScrollConfiguration(
		//pour pouvoir scroll sur les lieux favoris
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
          scrollbars: false,
        ),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FavoritePlaceCard(
                lieu: items[index],
                imageHeight: _imageHeight,
                width: _cardWidth,
              ),
            );
          },
        ),
      ),
    );
  }
}