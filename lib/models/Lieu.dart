import 'package:flutter/material.dart';

class Lieu {
	final int id;
	final String name;
	final double latitude;
	final double longitude;
	final Map<String, dynamic> tags;
	final int cityId;

	Lieu({
		required this.id,
		required this.name,
		required this.latitude,
		required this.longitude,
		required this.tags,
		required this.cityId,
	});

	Color get iconColor {
		if (tags["leisure"] == "park") return Colors.green;
		if (tags["tourism"] == "museum") return Colors.purple;
		if (tags["railway"] == "station") return Colors.blue;
		if (tags["amenity"] == "university") return Colors.orange;
		if (tags["tourism"] == "attraction") return Colors.red;
		return Colors.grey;
	}

	factory Lieu.fromMap(Map<String, dynamic> map) {
		return Lieu(
			id: map['id'],
			name: map['name'],
			latitude: map['lat'],
			longitude: map['lon'],
			tags: Map<String, dynamic>.from(map['tags']), 
			cityId: map['cityId'],
		);
	}

	factory Lieu.fromJson(Map<String, dynamic> json, int cityId) {
		final tags = json["tags"] ?? {};

		return Lieu(
			id: json["id"],
			name: tags["name"] ?? "Lieu sans nom",
			latitude: (json["lat"] ?? json["center"]?["lat"])?.toDouble() ?? 0,
			longitude: (json["lon"] ?? json["center"]?["lon"])?.toDouble() ?? 0,
			tags: tags,
			cityId: cityId,
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'name': name,
			'lat': latitude,
			'lon': longitude,
			'tags': tags.toString(),
			'cityId': cityId,
		};
	}

	Lieu copyWith({int? id}) {
		return Lieu(
			id: id ?? this.id,
			name: name,
			latitude: latitude,
			longitude: longitude,
			tags: tags,
			cityId: cityId,
		);
	}

	@override
	String toString() {
		return '$name{id: $id,\n latitude: $latitude,\n longitude: $longitude,\n tags: $tags,\n cityId: $cityId}\n\n';
	}
}
