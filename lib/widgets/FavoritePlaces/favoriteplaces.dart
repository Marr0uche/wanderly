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

/*

class FavoritePlacesScroller extends StatelessWidget {
  final List<Lieu> items;

  const FavoritePlacesScroller({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text("Pas de lieux favoris"));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          final imageUrl = item.tags["image"];
          final hasImage = imageUrl != null && imageUrl.toString().isNotEmpty;

          return GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
			  constraints: const BoxConstraints(maxWidth: double.infinity),
              isScrollControlled: true,
              builder: (_) => PlaceDetailsSheet(lieu: item),
            ),
            child: Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // IMAGE SAFE
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: hasImage
                        ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder: (context, _, __) =>
                                _placeholderImage(),
                          )
                        : _placeholderImage(),
                  ),

                  // NAME
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          if (item.rating != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                item.rating!.floor(),
                                (_) => const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                              ),
                            ),

                          if (item.note != null && item.note!.isNotEmpty)
                            Text(
                              "\"${item.note}\"",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 110,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Icon(Icons.photo, size: 40, color: Colors.grey),
    );
  }
}*/
