class CityLocation {
    final String name;
    final double latitude;
    final double longitude;

    CityLocation({
        required this.name,
        required this.latitude,
        required this.longitude,
    });

factory CityLocation.fromJson(Map<String, dynamic> json) {
  return CityLocation(
    name: json['name'] as String? ?? 'Ville inconnue',
    latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
    longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
  );
}

Map<String, dynamic> toJson() {
    return {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
    };
}

@override
bool operator ==(Object other) =>
    identical(this, other) ||
    other is CityLocation &&
    runtimeType == other.runtimeType &&
    name == other.name &&
    latitude == other.latitude &&
    longitude == other.longitude;
    
@override
int get hashCode => name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
}
