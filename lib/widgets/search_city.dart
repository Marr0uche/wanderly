import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/map_provider.dart';

class CitySearchField extends StatelessWidget {
  final TextEditingController controller;

  const CitySearchField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final mapVM = Provider.of<MapProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? const Color.fromARGB(255, 101, 99, 86) : const Color.fromARGB(255, 199, 241, 253),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Rechercher une ville...",
          filled: true,
          fillColor: isDark ? const Color.fromARGB(255, 48, 77, 85) : const Color.fromARGB(255, 192, 204, 216),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white : Colors.black54,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white70 : Colors.black54,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.white : Colors.black87,
              width: 2,
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black87),
            onPressed: () => mapVM.searchCity(controller.text, context),
          ),
        ),
        onSubmitted: (value) => mapVM.searchCity(value, context),
      ),
    );
  }
}