/// Store class that holds all the datafor a store
///
/// Data retrieved from Firestore
///
/// [id] is the Firestore document ID
class Store {
  /// Firestore ID
  final String id;
  final String name;

  /// Longitude
  final double long;

  /// Latitude
  final double lat;

  const Store({
    required this.name,
    required this.long,
    required this.lat,
    required this.id,
  });

  /// Turn the [Store] object into a [Map]
  Map<String, Object?> toMap() {
    return {'name': name, 'id': id, 'long': long, 'lat': lat};
  }

  /// Turn to string for printing values
  @override
  String toString() {
    return "Location: name: $name - longitude: $long - latitude: $lat";
  }

  /// Constructor that returns a [Store] object from a [Map]
  factory Store.fromMaptoLocation(Map<String, dynamic> locationMap) {
    return Store(
      name: locationMap['name'] as String? ?? 'Null name',
      long: locationMap['long'] as double? ?? -86.84552, // Qpon HQ Defaults
      lat: locationMap['lat'] as double? ?? 21.05021,
      id: locationMap['id'] as String? ?? 'ID-Was-Null',
    );
  }
}
