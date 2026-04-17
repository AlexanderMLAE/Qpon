import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:proyecto_qpon/features/stores/data/store_class.dart';
import 'package:proyecto_qpon/shared/firestore_service.dart';
import 'package:proyecto_qpon/shared/globals.dart';
import '../stores/store_screen.dart';

/// Personalized [MapboxMap] widget to use in map screen
class CustomMapWidget extends StatefulWidget {
  const CustomMapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CustomMapWidgetState();
}

/// TODO: Implement Store Class
/* class Location could be useful later but im commenting it out rn since im not using it for anything yet
class Location {
  final String? name;
  final double? long;
  final double? lat;

  Location({this.name, this.long, this.lat});

  factory Location.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Location(
      name: data?['name'],
      long: data?["long"],
      lat: data?["lat"],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (long != null) "long": long,
      if (lat != null) "lat": lat,
    };
  }
}
*/

class _CustomMapWidgetState extends State<CustomMapWidget> {
  /// Default camera options centered on UT
  ///
  /// Would be better if it centered on user location
  CameraOptions camera = CameraOptions(
    center: Point(coordinates: Position(-86.84686, 21.04848)),
    zoom: 14.35,
    bearing: 0,
    pitch: 0,
  );
  MapboxMap? mapboxMap;
  PointAnnotation? pointAnnotation;
  late PointAnnotationManager pointAnnotationManager;
  List<Store> _locations = [];

  /// Currently seen locatiosn?
  List<Store> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    storeSearchUpdateNotifier.addListener(filterAnnotationsByName);
  }

  @override
  void dispose() {
    storeSearchUpdateNotifier.removeListener(filterAnnotationsByName);
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCamera(camera);
    // Location logic
    var permissionStatus = await Geolocator.requestPermission();
    debugPrint("Location Status: $permissionStatus");
    mapboxMap.location.updateSettings(
      LocationComponentSettings(enabled: true, puckBearingEnabled: true),
    );
    // Annotations for stores
    pointAnnotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();
    pointAnnotationManager.tapEvents(
      onTap: (PointAnnotation annotation) {
        onAnnotationTap(annotation);
      },
    );
    await fetchStores();
  }

  /// Reading data from the "stores" collection and creating a point with the values found
  /// Reads data from the "stores" collection and creates a point with the values found
  Future<void> fetchStores() async {
    _locations = await FirestoreService.getStoresList();
    debugPrint('Stores from firestore: $_locations');
    for (Store store in _locations) {
      createOneAnnotation(store.id, store.long, store.lat, store.name);
    }
  }

  Future<void> deleteAllAnnotations() async {
    final List annotations = await pointAnnotationManager.getAnnotations();
    debugPrint("Annotations deleted: $annotations");
    await pointAnnotationManager.deleteAll();
  }

  /// Function that creates annotations
  /// Creates annotations, in this specific case, annotations for store locations
  /// obtained with [getStores]
  Future<void> createOneAnnotation(
    /// Firestore document id of the store
    String id,

    /// Longitude
    double long,

    /// Lattitude
    double lat,

    /// Name field of the store document
    String name,
  ) async {
    /// Local annotation icon that represents a store.
    final ByteData bytes = await rootBundle.load('assets/icon/store_logo.png');
    final Uint8List list = bytes.buffer.asUint8List();

    /// Custom data that holds store name and ID To show in a Store Screen
    final Map<String, Object> customAnnotationData = {
      "storeId": id,
      "storeName": name,
    };
    pointAnnotationManager
        .create(
          PointAnnotationOptions(
            customData: customAnnotationData,
            geometry: Point(coordinates: Position(long, lat)),
            textField: name,
            textSize: 12,
            textOffset: [0.0, -2.0],
            textColor: Colors.black.toARGB32(),
            iconSize: 0.1,
            iconOffset: [0.0, -5.0],
            symbolSortKey: 10,
            image: list,
          ),
        )
        .then((value) => pointAnnotation = value);
  }

  Future<void> filterAnnotationsByName() async {
    final String searchQuery = storeSearchUpdateNotifier.query;

    await deleteAllAnnotations();

    _filteredLocations = _locations.where((location) {
      final bool nameMatch = location.name.toString().toLowerCase().contains(
        searchQuery,
      );

      return nameMatch;
    }).toList();
    debugPrint("Filtered locations: $_filteredLocations");
    for (Store location in _filteredLocations) {
      createOneAnnotation(
        location.id,
        location.long,
        location.lat,
        location.name,
      );
    }
  }

  /// Separated for readability
  void onAnnotationTap(PointAnnotation annotation) {
    debugPrint(
      "Annotation Data: ${annotation.customData}, ${annotation.textField}",
    );
    openStore(annotation.customData);
  }

  /// Pushes the store details screen of a given store through its ID
  void openStore(Map<String, Object>? storeId) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => StoreWidget(storeData: storeId),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidge"),
      onMapCreated: _onMapCreated,
    );

    return Column(children: [Expanded(child: mapWidget)]);
  }
}
