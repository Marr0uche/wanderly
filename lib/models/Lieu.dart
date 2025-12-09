import 'dart:convert';

import 'package:flutter/material.dart';

class Lieu {
	final int id;
	final String name;
	final double latitude;
	final double longitude;
	final Map<String, dynamic> tags;
	final String cityKey;

	final double? rating; 
  	final String? note; 

	Lieu({
		required this.id,
		required this.name,
		required this.latitude,
		required this.longitude,
		required this.tags,
		required this.cityKey,
		this.rating,
		this.note,
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
			tags: jsonDecode(map['tags']), 
			cityKey: map['cityKey'],
			rating: map['rating'],
      		note: map['note'],
		);
	}

	factory Lieu.fromJson(Map<String, dynamic> json, String cityKey) {
		final tags = json["tags"] ?? {};

		return Lieu(
			id: json["id"],
			name: tags["name"] ?? "Lieu sans nom",
			latitude: (json["lat"] ?? json["center"]?["lat"])?.toDouble() ?? 0,
			longitude: (json["lon"] ?? json["center"]?["lon"])?.toDouble() ?? 0,
			tags: tags,
			cityKey: cityKey,
		);
	}

	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'name': name,
			'lat': latitude,
			'lon': longitude,
			'tags': jsonEncode(tags),
			'cityKey': cityKey,
			'rating': rating,
      		'note': note,
		};
	}

	Lieu copyWith({int? id}) {
		return Lieu(
			id: id ?? this.id,
			name: name,
			latitude: latitude,
			longitude: longitude,
			tags: tags,
			cityKey: cityKey,
		);
	}

	Lieu copyWithRatNot({double? rating, String? note}) {
		return Lieu(
			id: id ,
			name: name,
			latitude: latitude,
			longitude: longitude,
			tags: tags,
			cityKey: cityKey,
			rating: rating ?? this.rating,
			note: note ?? this.note,
		);
  	}

	@override
	String toString() {
		return '$name{id: $id,\n latitude: $latitude,\n longitude: $longitude,\n tags: $tags,\n cityKey: $cityKey}\n\n';
	}
}
