import 'package:flutter/material.dart';

class Lieu {
	final String id;
	final String name;
	final double latitude;
	final double longitude;
	final Map<String, dynamic> tags;

	Lieu({
		required this.id,
		required this.name,
		required this.latitude,
		required this.longitude,
		required this.tags
	});

	Color get iconColor {
		if (tags["leisure"] == "park") return Colors.green;
		if (tags["tourism"] == "museum") return Colors.purple;
		if (tags["railway"] == "station") return Colors.blue;
		if (tags["amenity"] == "university") return Colors.orange;
		if (tags["tourism"] == "attraction") return Colors.red;
		return Colors.grey;
	}

	factory Lieu.fromJson(Map<String, dynamic> json) {
		final tags = json["tags"] ?? {};

		return Lieu(
			id: json["id"].toString(),
			name: tags["name"] ?? "Lieu sans nom",
			latitude: (json["lat"] ?? json["center"]?["lat"])?.toDouble() ?? 0,
			longitude: (json["lon"] ?? json["center"]?["lon"])?.toDouble() ?? 0,
			tags: tags,
		);
	}

	@override
	String toString() {
		return '$name{id: $id,\n latitude: $latitude,\n longitude: $longitude,\n tags: $tags}\n\n';
	}
}
