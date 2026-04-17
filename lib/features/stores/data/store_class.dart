class Store {
  // could be useful later but im commenting it out rn since im not using it for anything yet
  final String id; /// Firestore ID
  final String name;
  final double long;
  final double lat;

  const Store({required this.name, required this.long, required this.lat, required this.id});

  Map<String, Object?> toMap() {
    return {'name': name, 'id': id, 'long': long, 'lat': lat};
  }

  @override
  String toString() {
    return "Location: name: $name - longitude: $long - latitude: $lat";
  }

  factory Store.fromMaptoLocation(Map<String, dynamic> locationMap) {
    return Store(
      name: locationMap['name'] as String? ?? 'Null name',
      long: locationMap['long'] as double? ?? -86.84552, // Qpon HQ Defaults
      lat: locationMap['lat'] as double? ?? 21.05021,
      id: locationMap['id'] as String? ?? 'ID-Was-Null',
    );
  }
}
