import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/favorites_provider.dart';
import '../../models/city_location.dart';
class DeleteConfirmationModal extends StatelessWidget{
	final CityLocation city;
  	const DeleteConfirmationModal({super.key, required this.city});

	@override
	Widget build(BuildContext context) {
  		final isDark = Theme.of(context).brightness == Brightness.dark;
		final favVM = Provider.of<FavoritesProvider>(context, listen: false);

		return AlertDialog(
			backgroundColor: isDark
				? const Color.fromARGB(255, 48, 77, 85)
				: Colors.white,
			shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
			title: Row(
				children: [
				Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
				const SizedBox(width: 12),
				Expanded(
					child: Text(
					"Supprimer",
					style: TextStyle(
						color: isDark ? Colors.white : Colors.black87,
						fontWeight: FontWeight.bold,
					),
					),
				),
				],
			),
			content: Text(
				"Voulez-vous vraiment supprimer ${city.cityName} de vos favoris ?",
				style: TextStyle(
				color: isDark ? Colors.white70 : Colors.black87,
				fontSize: 16,
				),
			),
			actions: [
				ElevatedButton(
				onPressed: () => Navigator.pop(context),
				style: ElevatedButton.styleFrom(
					backgroundColor: isDark
						? const Color.fromARGB(255, 70, 90, 100)
						: const Color.fromARGB(255, 230, 230, 230),
					foregroundColor: isDark ? Colors.white70 : Colors.black54,
					shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(8),
					),
				),
				child: Text(
					"Annuler",
					style: TextStyle(
					color: isDark ? Colors.white70 : Colors.black54,
					fontSize: 16,
					),
				),
				
				),
				ElevatedButton(
				onPressed: () {
					favVM.removeFavorite(city);
					Navigator.pop(context);
					ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(
						content: Text("${city.cityName} supprimée des favoris"),
						backgroundColor: isDark
							? const Color.fromARGB(255, 90, 118, 146)
							: const Color.fromARGB(255, 48, 77, 85),
						behavior: SnackBarBehavior.floating,
						shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(10),
						),
					),
					);
				},
				style: ElevatedButton.styleFrom(
					backgroundColor: Colors.red,
					foregroundColor: Colors.white,
					shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(8),
					),
				),
				child: const Text("Supprimer", style: TextStyle(fontSize: 16)),
				),
			],
		);
	}
}