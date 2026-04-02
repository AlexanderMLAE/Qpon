import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'package:proyecto_qpon/shared/firestore_service.dart';
import '../stores/store_screen.dart';

class CustomMapWidget extends StatefulWidget {
  const CustomMapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CustomMapWidgetState();
}
// class Location could be useful later but im commenting it out rn since im not using it for anything yet
// class Location {
//   final String? name;
//   final double? long;
//   final double? lat;

//   Location({this.name, this.long, this.lat});

//   factory Location.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     final data = snapshot.data();
//     return Location(
//       name: data?['name'],
//       long: data?["long"],
//       lat: data?["lat"],
//     );
//   }
//   Map<String, dynamic> toFirestore() {
//     return {
//       if (name != null) "name": name,
//       if (long != null) "long": long,
//       if (lat != null) "lat": lat,
//     };
//   }
// }

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
  List<PointAnnotation> annotations = [];

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
    fetchStores();
  }

  // Reading data from the "stores" collection and creating a point with the values found
  Future<void> fetchStores() async {
    final stores = await FirestoreService.fetchStores();
    debugPrint('Stores from firestore: $stores');
    for (var store in stores) {
      createOneAnnotation(
        store["id"],
        store["long"],
        store["lat"],
        store["name"],
      );
    }
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
          builder: (context) =>
              StoreWidget(storeData: storeId),
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
