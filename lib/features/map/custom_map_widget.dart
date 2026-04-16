import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:proyecto_qpon/features/stores/data/location_class.dart';
import 'package:proyecto_qpon/shared/firestore_service.dart';
import '../stores/store_screen.dart';

class CustomMapWidget extends StatefulWidget {
  const CustomMapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  CameraOptions camera = CameraOptions(
    center: Point(coordinates: Position(-86.84686, 21.04848)),
    zoom: 14.35,
    bearing: 0,
    pitch: 0,
  );
  MapboxMap? mapboxMap;
  PointAnnotation? pointAnnotation;
  late PointAnnotationManager pointAnnotationManager;
  List<Location> _locations = [];

  /// Currently seen locatiosn?
  List<Location> _filteredLocations = [];

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
        onTapFunction(annotation);
      },
    );
    await fetchStores();
    await filterAnnotationsByName();
  }

  // Reading data from the "stores" collection and creating a point with the values found
  Future<void> fetchStores() async {
    _locations = await FirestoreService.getStoresList();
    debugPrint('Stores from firestore: $_locations');
    for (Location store in _locations) {
      createOneAnnotation(store.id, store.long, store.lat, store.name);
    }
  }

  Future<void> deleteAllAnnotations() async {

    final List annotations = await pointAnnotationManager.getAnnotations();
    debugPrint("Annotations deleted: $annotations");
    await pointAnnotationManager.deleteAll();
  }

  // Function that creates annotations, will probably not be used to manually create any points
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
    // TODO: placeholder
    final String searchQuery = 'pizzas';

    await deleteAllAnnotations();

    _filteredLocations = _locations.where((location) {
      final bool nameMatch = location.name.toString().toLowerCase().contains(
        searchQuery,
      );

      return nameMatch;
    }).toList();
    debugPrint("Filtered stores: $_filteredLocations");
    for (Location location in _filteredLocations) {
      createOneAnnotation(
        location.id,
        location.long,
        location.lat,
        location.name,
      );
    }
    
  }

  void onTapFunction(PointAnnotation annotation) {
    debugPrint(
      "Annotation Data: ${annotation.customData}, ${annotation.textField}",
    ); // lol idk
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

    return Column(children: [Expanded(child: mapWidget)]);
  }
}
