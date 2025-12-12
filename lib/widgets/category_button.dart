import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/map_provider.dart';

class CategoryFilterButtons extends StatelessWidget {
  const CategoryFilterButtons({super.key});

  Widget _buildCategoryButton(BuildContext context, String key, String label) {
    final mapVM = Provider.of<MapProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool selected = mapVM.activeCategories.contains(key);

    final Color selectedColor = isDark
        ? const Color.fromARGB(255, 88, 138, 152)
        : const Color.fromARGB(255, 90, 118, 146);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
          ),
        ),
        selected: selected,
        selectedColor: selectedColor,
        checkmarkColor: Colors.white,
        backgroundColor:
            isDark ? const Color.fromARGB(255, 48, 77, 85) : Colors.white70,
        shape: StadiumBorder(
          side: BorderSide(
            color: selected
                ? const Color.fromARGB(255, 118, 121, 137)
                : (isDark ? const Color.fromARGB(137, 113, 138, 155) : const Color.fromARGB(255, 48, 77, 85)),
            width: 1.5,
          ),
        ),
        onSelected: (_) async => await mapVM.toggleCategory(key),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapVM = Provider.of<MapProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildCategoryButton(context, "parks", "Parcs"),
          _buildCategoryButton(context, "museums", "Musées"),
          _buildCategoryButton(context, "stations", "Gares"),
          _buildCategoryButton(context, "universities", "Universités"),
          _buildCategoryButton(context, "tourism", "Attractions"),
          _buildCategoryButton(context, "restaurants", "Restaurants"),

          TextButton(
            onPressed: () async => await mapVM.activateAll(),
            style: TextButton.styleFrom(
              backgroundColor: isDark
                ? const Color.fromARGB(255, 48, 77, 85)
                : const Color.fromARGB(255, 90, 118, 146),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Tout Sélectionner"),
          ),

          TextButton(
            onPressed: () => mapVM.clearCategories(),
            style: TextButton.styleFrom(
              backgroundColor: isDark
                ? const Color.fromARGB(255, 48, 77, 85)
                : const Color.fromARGB(255, 90, 118, 146),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Tout Désélectionner"),
          ),
        ],
      ),
    );
  }
}