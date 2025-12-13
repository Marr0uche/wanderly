import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/map_provider.dart';


class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final mapVM = Provider.of<MapProvider>(context, listen: false);
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Rechercher un lieu…",
		  isDense: true,
		  contentPadding: const EdgeInsets.symmetric(vertical: 12),
          constraints: const BoxConstraints(maxHeight: 37),
          filled: true,
          fillColor: isDark
              ? const Color.fromARGB(255, 48, 77, 85)
              : const Color.fromARGB(255, 192, 204, 216),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search),
        ),
        onSubmitted: (value) {
          if (value.trim().isEmpty) return;
		  mapVM.searchLocation(value, context);
        },
      ),
    );
  }
}
