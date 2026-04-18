import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart'
    /// Importing as geolocator to specify source of Position class specifically
    as geolocator
    show Geolocator, Position;
import 'package:proyecto_qpon/features/stores/data/store_class.dart';
import 'package:proyecto_qpon/features/stores/store_screen.dart';
import 'package:proyecto_qpon/shared/firestore_service.dart';
import 'package:proyecto_qpon/shared/globals.dart';

class CustomMapData extends StatefulWidget {
  const CustomMapData({super.key});

  @override
  State<StatefulWidget> createState() => _CustomMapDataState();
}

class _CustomMapDataState extends State<CustomMapData> {
  CameraOptions camera = CameraOptions(zoom: 14.35);
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
    /// Center to user location
    Point userLocation = await getUserLocation();
    camera.center = userLocation;
    this.mapboxMap = mapboxMap;
    await mapboxMap.setCamera(camera);

    /// Location and permissions
    var permissionStatus = await geolocator.Geolocator.requestPermission();
    debugPrint("Location Status: $permissionStatus");
    mapboxMap.location.updateSettings(
      LocationComponentSettings(enabled: true, puckBearingEnabled: true),
    );

    /// Creating annotations for stores
    pointAnnotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();
    pointAnnotationManager.tapEvents(
      onTap: (PointAnnotation annotation) {
        onAnnotationTap(annotation);
      },
    );
    await fetchStores();
  }

  Future<Point> getUserLocation() async {
    final geolocator.Position currentPosition;
    try {
      currentPosition = await geolocator.Geolocator.getCurrentPosition();

      debugPrint("Current Position: $currentPosition");
    } catch (e) {
      debugPrint("Error getting location: $e");
      // QPon HQ default on error
      return Point(coordinates: Position(-86.84686, 21.04848));
    }
    // All went as expected
    return Point(
      coordinates: Position(
        currentPosition.longitude,
        currentPosition.latitude,
      ),
    );
  }

  /// Reading data from the "stores" collection and creating a point with the values found
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
  Future<void> createOneAnnotation(
    String id,
    double long,
    double lat,
    String name,
  ) async {
    final ByteData bytes = await rootBundle.load('assets/icon/store_logo.png');
    final Uint8List list = bytes.buffer.asUint8List();
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

    return mapWidget;
  }
}
