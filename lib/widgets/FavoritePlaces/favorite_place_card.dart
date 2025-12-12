import 'package:flutter/material.dart';
import '../../models/Lieu.dart';
import '../PlaceDetails/place_details_sheet.dart';

class FavoritePlaceCard extends StatelessWidget {
  final Lieu lieu;
  final double width;
  final double imageHeight;

  const FavoritePlaceCard({
	super.key, 
    required this.lieu,
    required this.width,
    required this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = lieu.tags["image"];
    final hasImage = imageUrl != null && imageUrl.toString().isNotEmpty;

    return GestureDetector(
      onTap: () => _openDetails(context),
      child: Container(
        width: width,
        decoration: _cardDecoration(context),
        child: Column(
          children: [
            _PlaceImage(
              imageUrl: imageUrl,
              hasImage: hasImage,
              height: imageHeight,
            ),
            Expanded(child: _PlaceInfo(lieu: lieu)),
          ],
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      isScrollControlled: true,
      builder: (_) => PlaceDetailsSheet(lieu: lieu),
    );
  }

  BoxDecoration _cardDecoration(BuildContext context) {
	  final isDark = Theme.of(context).brightness == Brightness.dark;

    return BoxDecoration(
     color: isDark
        ? const Color.fromARGB(255, 48, 77, 85)
        : const Color.fromARGB(255, 90, 118, 146),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          blurRadius: 6,
          color: Colors.black.withOpacity(0.15),
          offset: const Offset(0, 3),
        ),
      ],
    );
  }
}

class _PlaceImage extends StatelessWidget {
  final String? imageUrl;
  final bool hasImage;
  final double height;

  const _PlaceImage({
    required this.imageUrl,
    required this.hasImage,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: hasImage
          ? Image.network(
              imageUrl!,
              height: height,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Icon(Icons.photo, size: 40, color: Colors.grey),
    );
  }
}

class _PlaceInfo extends StatelessWidget {
  final Lieu lieu;

  const _PlaceInfo({required this.lieu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            lieu.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),

          if (lieu.rating != null) _Stars(rating: lieu.rating!),

          if (lieu.note != null && lieu.note!.isNotEmpty)
            Text(
              "\"${lieu.note}\"",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.white),
            ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double rating;

  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        rating.floor(),
        (_) => const Icon(Icons.star, size: 16, color: Colors.amber),
      ),
    );
  }
}


