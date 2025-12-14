import 'package:flutter/material.dart';
import '../../models/Lieu.dart';
import '../../utils/place_details.dart';

Widget placeDetailsContactCard(bool isDark, Lieu lieu) {
  final hasContactInfo =
      lieu.tags["addr:street"] != null ||
      lieu.tags["website"] != null ||
      lieu.tags["contact:website"] != null ||
      lieu.tags["phone"] != null ||
      lieu.tags["contact:phone"] != null ||
      lieu.tags["contact:email"] != null ||
      lieu.tags["contact:facebook"] != null;

  if (!hasContactInfo) return const SizedBox.shrink();

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
              Icons.contact_mail,
              color: isDark ? Colors.white70 : Colors.black54,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              "Informations de contact",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._buildContactInfoList(isDark, lieu),
      ],
    ),
  );
}

List<Widget> _buildContactInfoList(bool isDark, Lieu lieu) {
  List<Widget> widgets = [];

  if (lieu.tags["addr:street"] != null) {
    widgets.add(
      buildInfoRow(
        icon: Icons.location_on,
        text:
            "${lieu.tags["addr:housenumber"] ?? ""} ${lieu.tags["addr:street"]}",
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags["website"] != null || lieu.tags["contact:website"] != null) {
    widgets.add(
      buildLinkRow(
        icon: Icons.language,
        url: lieu.tags["website"] ?? lieu.tags["contact:website"],
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags["phone"] != null) {
    widgets.add(
      buildInfoRow(
        icon: Icons.phone,
        text: lieu.tags["phone"],
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags["contact:phone"] != null) {
    widgets.add(
      buildInfoRow(
        icon: Icons.phone,
        text: lieu.tags["contact:phone"],
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags["contact:email"] != null) {
    widgets.add(
      buildInfoRow(
        icon: Icons.email,
        text: lieu.tags["contact:email"],
        isDark: isDark,
      ),
    );
  }

  if (lieu.tags["contact:facebook"] != null) {
    widgets.add(
      buildLinkRow(
        icon: Icons.facebook,
        url: lieu.tags["contact:facebook"],
        isDark: isDark,
      ),
    );
  }

  return widgets;
}
