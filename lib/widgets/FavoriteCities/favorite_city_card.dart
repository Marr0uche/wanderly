import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wanderly/models/city_location.dart';
import 'delete_confirmation_modal.dart';
import '../../providers/map_provider.dart';

Widget cityCard( BuildContext context, CityLocation city,bool isDark) {
	final mapVM = Provider.of<MapProvider>(context);
	return Container(
		margin: const EdgeInsets.only(bottom: 12),
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
		child: Material(
			color: Colors.transparent,
			child: InkWell(
				onTap: () {
					mapVM.selectCity(city);
					Navigator.pop(context, city);
				},
				borderRadius: BorderRadius.circular(16),
				child: Padding(
					padding: const EdgeInsets.all(16),
					child: Row(
						children: [
							Container(
								width: 56,
								height: 56,
								decoration: BoxDecoration(
								color: isDark
									? const Color.fromARGB(255, 90, 118, 146).withOpacity(0.3)
									: const Color.fromARGB(255, 192, 204, 216),
								borderRadius: BorderRadius.circular(12),
								),
								child: Icon(
								Icons.location_city,
								color: isDark
									? Colors.white
									: const Color.fromARGB(255, 48, 77, 85),
								size: 28,
								),
							),
							const SizedBox(width: 16),
							Expanded(
								child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
									city.cityName,
									style: TextStyle(
										fontSize: 18,
										fontWeight: FontWeight.bold,
										color: isDark ? Colors.white : Colors.black87,
									),
									),
									const SizedBox(height: 6),
									Row(
									children: [
										Icon(
										Icons.my_location,
										size: 14,
										color: isDark ? Colors.white60 : Colors.black54,
										),
										const SizedBox(width: 4),
										Expanded(
										child: Text(
											"${city.cityLat.toStringAsFixed(4)}, ${city.cityLong.toStringAsFixed(4)}",
											style: TextStyle(
											fontSize: 13,
											color: isDark ? Colors.white60 : Colors.black54,
											),
											overflow: TextOverflow.ellipsis,
										),
										),
									],
									),
								],
								),
							),
							Row(
								mainAxisSize: MainAxisSize.min,
								children: [
								IconButton(
									icon: const Icon(Icons.delete_outline),
									color: Colors.red.withOpacity(0.8),
									tooltip: "Supprimer",
									onPressed: () => _showDeleteConfirmation(context, city),
								),
								],
							),
						],
					),
				),
			),
		),
	);
}

void _showDeleteConfirmation(
  BuildContext context,
  CityLocation city,
) {
  showDialog(
    context: context,
    builder: (context) => DeleteConfirmationModal(city: city),
  );
}
