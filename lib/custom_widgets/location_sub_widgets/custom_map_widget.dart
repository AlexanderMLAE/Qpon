import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;
import 'stablishment_widget.dart';

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

// TODO: Add a refresh button or have it refresh on its own somehow
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
  void fetchStores() {
    FirebaseFirestore.instance.collection("stores").get().then((querySnapshot) {
      debugPrint("Successfully completed");
      for (var docSnapshot in querySnapshot.docs) {
        debugPrint('${docSnapshot.id} => ${docSnapshot.data()}');
        createOneAnnotation(
          docSnapshot.id,
          docSnapshot.data()["long"],
          docSnapshot.data()["lat"],
          docSnapshot.data()["name"],
        );
      }
    }, onError: (e) => debugPrint("Error completing: $e"));
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
    final Map<String, Object> customAnnotationData = {"storeId": id, "storeName": name};
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
    openStablishment(annotation.customData);
  }

  void openStablishment(Map<String, Object>? stablishmentId) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) =>
              StablishmentWidget(stablishmentData: stablishmentId),
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
