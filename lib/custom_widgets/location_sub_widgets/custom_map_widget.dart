import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' show Geolocator;

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
  PointAnnotationManager? pointAnnotationManager;
  List<PointAnnotation> annotations = [];

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    mapboxMap.setCamera(camera);
    // Location logic
    var permissionStatus =
      await Geolocator.requestPermission();
    debugPrint("Location Status: $permissionStatus");
    mapboxMap.location.updateSettings(
      LocationComponentSettings(enabled: true, puckBearingEnabled: true),
    );
    // Annotations for stores
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      pointAnnotationManager = value;
      // Load image from assets, Qpon icon as placeholder
      final ByteData bytes =
          await rootBundle.load('assets/symbols/custom-icon.png');
      final Uint8List list = bytes.buffer.asUint8List();
      createOneAnnotation(list);
    });
  }
    void createOneAnnotation(Uint8List list) {
    pointAnnotationManager
        ?.create(PointAnnotationOptions(
            geometry: Point(
                coordinates: Position(
              0.381457,
              6.687337,
            )),
            textField: "custom-icon",
            textOffset: [0.0, -2.0],
            textColor: Colors.red.value,
            iconSize: 1.3,
            iconOffset: [0.0, -5.0],
            symbolSortKey: 10,
            image: list))
        .then((value) => pointAnnotation = value);
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidge"),
      onMapCreated: _onMapCreated,
    );

    return Column(
      children: [
        Expanded(
          child: mapWidget,
        ),
      ],
    );
  }
}
