import 'package:flutter/material.dart';
import '../models/Lieu.dart';
import '../widgets/place_details_sheet.dart';

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
}
