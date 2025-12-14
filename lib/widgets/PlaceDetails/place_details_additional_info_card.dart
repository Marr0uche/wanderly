import 'package:flutter/material.dart';
import '../../models/Lieu.dart';
import '../../utils/place_details.dart';


Widget placeDetailsAdditionalInfoCard(bool isDark, Lieu lieu) {
  return Container(
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
              Icons.info_outline,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "Informations supplémentaires",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._buildAdditionalInfoList(isDark, lieu),
      ],
    ),
  );
}

List<Widget> _buildAdditionalInfoList(bool isDark, Lieu lieu) {
  List<Widget> widgets = [];

  if (lieu.tags.containsKey("network")) {
    widgets.add(
      buildInfoRow(
        icon: Icons.train,
        text: lieu.tags["network"],
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags.containsKey("operator")) {
    widgets.add(
      buildInfoRow(
        icon: Icons.business,
        text: lieu.tags["operator"],
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags.containsKey("opening_hours")) {
    widgets.add(
      buildInfoRow(
        icon: Icons.access_time,
        text: lieu.tags["opening_hours"],
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags.containsKey("cuisine")) {
    widgets.add(
      buildInfoRow(
        icon: Icons.restaurant,
        text: lieu.tags["cuisine"],
        isDark: isDark,
      ),
    );
  }

  return widgets;
}
