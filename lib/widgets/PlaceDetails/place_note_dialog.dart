import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Lieu.dart';
import '../../providers/favorite_places_provider.dart';

class PlaceNoteDialog extends StatefulWidget {
	final Lieu lieu;

	const PlaceNoteDialog({super.key, required this.lieu});

	@override
	State<PlaceNoteDialog> createState() => _PlaceNoteDialogState();
}

class _PlaceNoteDialogState extends State<PlaceNoteDialog> {
	late TextEditingController _noteController;
	late double rating;

	@override
	void initState() {
		super.initState();
		_noteController = TextEditingController(text: widget.lieu.note ?? "");
		rating = widget.lieu.rating ?? 0;
	}

	@override
	Widget build(BuildContext context) {
		final favVM = context.read<FavoritesProviderPlace>();

		return AlertDialog(
			title: Text("Commentaire personnel pour ${widget.lieu.name}"),
			content: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: List.generate(5, (i) {
							return IconButton(
								icon: Icon(
									i < rating ? Icons.star : Icons.star_border,
									color: Colors.amber,
									size: 32,
								),
								onPressed: () {
									setState(() => rating = (i + 1).toDouble());
								},
							);
						}),
					),

					TextField(
						controller: _noteController,
						maxLines: 3,
						decoration: const InputDecoration(labelText: "Votre note"),
					),
				],
			),
			actions: [
				TextButton(
					onPressed: () => Navigator.pop(context),
					child: const Text("Annuler"),
				),
				ElevatedButton(
					onPressed: () {
						favVM.updatePlaceNote(widget.lieu.id, rating, _noteController.text);
						Navigator.pop(context);
					},
					child: const Text("Enregistrer"),
				),
			],
		);
	}
}
