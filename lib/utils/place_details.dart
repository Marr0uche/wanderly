import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildInfoRow({
  required IconData icon,
  required String text,
  required bool isDark,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark
              ? const Color.fromARGB(255, 90, 118, 146)
              : const Color.fromARGB(255, 90, 118, 146),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildLinkRow({
  required IconData icon,
  required String url,
  required bool isDark,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark
              ? const Color.fromARGB(255, 90, 118, 146)
              : const Color.fromARGB(255, 90, 118, 146),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => launchUrl(Uri.parse(url)),
            child: Text(
              url,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
