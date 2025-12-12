import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/Lieu.dart';

class PlaceDetailsInfo extends StatelessWidget {
	final Lieu lieu;

	const PlaceDetailsInfo({super.key, required this.lieu});

	@override
	Widget build(BuildContext context) {
		return Column(
			children: [
				if (lieu.tags["addr:street"] != null)
					Text(
						"${lieu.tags["addr:housenumber"] ?? ""} ${lieu.tags["addr:street"]}",
						style: const TextStyle(fontSize: 16, color: Colors.grey),
					),

				const SizedBox(height: 10),

				if (lieu.tags["website"] != null ||
					lieu.tags["contact:website"] != null)
				Row(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
					const Text("Site web : ", style: TextStyle(fontSize: 16)),
					Expanded(
						child: InkWell(
						onTap: () => launchUrl(
							Uri.parse(
							lieu.tags["website"] ??
								lieu.tags["contact:website"],
							),
						),
						child: Text(
							lieu.tags["website"] ?? lieu.tags["contact:website"],
							style: const TextStyle(
							fontSize: 16,
							color: Colors.blue,
							decoration: TextDecoration.underline,
							),
							softWrap: true,
						),
						),
					),
					],
				),

				const SizedBox(height: 10),

				if (lieu.tags["phone"] != null)
				Text("Téléphone : ${lieu.tags["phone"]}"),

				if (lieu.tags["contact:phone"] != null)
				Text("Téléphone : ${lieu.tags["contact:phone"]}"),

				if (lieu.tags["contact:email"] != null)
				Text("Email : ${lieu.tags["contact:email"]}"),

				if (lieu.tags["contact:facebook"] != null)
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
					Expanded(
						child: InkWell(
						onTap: () => launchUrl(
							Uri.parse(
							lieu.tags["contact:facebook"] ??
								lieu.tags["contact:facebook"],
							),
						),
						child: Text(
							lieu.tags["contact:facebook"] ??
								lieu.tags["contact:facebook"],
							style: const TextStyle(
							fontSize: 16,
							color: Colors.blue,
							decoration: TextDecoration.underline,
							),
							softWrap: true,
						),
						),
					),
					],
				),

				if (lieu.tags.containsKey("network"))
				Text("${lieu.tags["network"]}"),

				if (lieu.tags.containsKey("operator"))
				Text("${lieu.tags["operator"]}"),

				if (lieu.tags.containsKey("opening_hours"))
				Text("Horaires : ${lieu.tags["opening_hours"]}"),

				if (lieu.tags.containsKey("cuisine"))
				Text("${lieu.tags["cuisine"]}"),

				const SizedBox(height: 15),

				if (lieu.rating != null)
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: List.generate(
					5,
					(i) => Icon(
						i < lieu.rating! ? Icons.star : Icons.star_border,
						color: Colors.amber,
					),
					),
				),

				if (lieu.note != null && lieu.note!.isNotEmpty)
				Padding(
					padding: const EdgeInsets.symmetric(vertical: 8.0),
					child: Text(
					"\"${lieu.note}\"",
					textAlign: TextAlign.center,
					style: const TextStyle(fontStyle: FontStyle.italic),
					),
				),

				if (lieu.tags["image"] != null)
				ClipRRect(
					borderRadius: BorderRadius.circular(12),
					child: Image.network(
					lieu.tags["image"],
					fit: BoxFit.cover,
					errorBuilder: (_, __, ___) => const Text(
						"Image indisponible",
						style: TextStyle(color: Colors.grey),
					),
					),
				),
			],	
		);
	}
}
