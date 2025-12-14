import 'package:flutter/material.dart';
import '../../models/Lieu.dart';

 Widget placeDetailsImageCard(bool isDark, Lieu lieu) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.network(
          lieu.tags["image"],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: isDark
                ? const Color.fromARGB(255, 48, 77, 85)
                : const Color.fromARGB(255, 192, 204, 216),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Image indisponible",
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
