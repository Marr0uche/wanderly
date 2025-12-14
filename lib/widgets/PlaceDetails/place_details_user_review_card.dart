import 'package:flutter/material.dart';
import '../../models/Lieu.dart';

Widget placeDetailsUserReviewCard(bool isDark, Lieu lieu) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? const Color.fromARGB(255, 48, 77, 85) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.rate_review,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "Votre avis",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        if (lieu.rating != null) ...[
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < lieu.rating! ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 24,
              ),
            ),
          ),
        ],
        if (lieu.note != null && lieu.note!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color.fromARGB(255, 90, 118, 146).withOpacity(0.2)
                  : const Color.fromARGB(255, 192, 204, 216),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "\"${lieu.note}\"",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
