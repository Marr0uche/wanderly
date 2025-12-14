import 'package:flutter/material.dart';

Widget emptyState(bool isDark) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_city_outlined,
          size: 100,
          color: isDark
              ? Colors.white.withOpacity(0.3)
              : Colors.black.withOpacity(0.3),
        ),
        const SizedBox(height: 24),
        Text(
          "Aucune ville favorite",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            "Ajoutez des villes à vos favoris pour y accéder rapidement",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
      ],
    ),
  );
}
