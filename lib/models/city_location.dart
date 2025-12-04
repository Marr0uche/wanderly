class CityLocation {
	final int id;
	final String name;
	final double latitude;
	final double longitude;

	CityLocation({
		required this.id,
		required this.name,
		required this.latitude,
		required this.longitude,
	});

	factory CityLocation.fromJson(Map<String, dynamic> json) {
		return CityLocation(
			id: json['id'] as int,
			name: json['name'] as String? ?? 'Ville inconnue',
			latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
			longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
		);
	}


	Map<String, dynamic> toMap() {
		return {
			'id': id,
			'cityName': name,
			'cityLat': latitude,
			'cityLong': longitude,
		};
	}

	factory CityLocation.fromMap(Map<String, dynamic> map) {
		return CityLocation(
			id: map['id'],
			name: map['cityName'],
			latitude: map['cityLat'],
			longitude: map['cityLong'],
		);
	}

	CityLocation copyWith({int? id}) {
		return CityLocation(
			id: id ?? this.id,
			name: name,
			latitude: latitude,
			longitude: longitude,
		);
	}

	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		if (other is! CityLocation) return false;

		return (latitude - other.latitude).abs() < 0.0001 &&
			(longitude - other.longitude).abs() < 0.0001;
	}

	@override
	int get hashCode =>
		Object.hash((latitude * 10000).round(), (longitude * 10000).round());
}
