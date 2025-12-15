// represente une ville ou une localisation issue d'OpenStreetMap
// utilisee pour representer une ville favorie, resultat de recherche ou ville courante

class CityLocation {

  // Identifiant OSM unique
	final int osmId;
  final String osmType;

  // Clé unique interne utilisée dans l'app
	final String cityKey;
	final String cityName;
	final double cityLat;
	final double cityLong;

	CityLocation({
		required this.osmId,
		required this.osmType,
		required this.cityKey,
		required this.cityName,
		required this.cityLat,
		required this.cityLong,
	});


  // Cree une CityLocation depuis un JSON venant de Nominatim API
	static String createKey(int osmId, String osmType) {
		final letter = osmType.isNotEmpty ? osmType[0].toUpperCase() : "U";
		return "$letter$osmId";
	}


  // Reconstruit une CityLocation depuis un stockage local
	factory CityLocation.fromJson(Map<String, dynamic> json) {
		return CityLocation(
			osmId: json['osm_id'] as int,
			osmType: json['osm_type'] as String,
			cityKey: "${(json['osm_type'] as String).isNotEmpty ? (json['osm_type'] as String)[0].toUpperCase() : "U"}${json['osm_id']}",
			cityName: json['name'] as String? ?? 'Ville inconnue',
			cityLat: (json['latitude'] as num?)?.toDouble() ?? 0.0,
			cityLong: (json['longitude'] as num?)?.toDouble() ?? 0.0,
		);
	}


	Map<String, dynamic> toMap() {
		return {
			'osmId': osmId,
			'osmType': osmType,
			'cityKey': cityKey,
			'cityName': cityName,
			'cityLat': cityLat,
			'cityLong': cityLong,
		};
	}

	factory CityLocation.fromMap(Map<String, dynamic> map) {
		return CityLocation(
			osmId: map['osmId'],
			osmType: map['osmType'],
			cityKey: map['cityKey'],
			cityName: map['cityName'],
			cityLat: map['cityLat'],
			cityLong: map['cityLong'],
		);
	}


  // Cree une copie de la ville avec modification partielle
	CityLocation copyWith({int? osmId}) {
		return CityLocation(
			osmId: osmId ?? this.osmId,
			osmType: osmType,
			cityKey: cityKey,
			cityName: cityName,
			cityLat: cityLat,
			cityLong: cityLong,
		);
	}


  // Deux CityLocation sont considerees egales si elles ont la meme cityKey
	@override
	bool operator ==(Object other) {
		if (identical(this, other)) return true;
		if (other is! CityLocation) return false;

		return other.cityKey == cityKey;
	}

	@override
	int get hashCode =>
		Object.hash((cityLat * 10000).round(), (cityLong * 10000).round());
}
