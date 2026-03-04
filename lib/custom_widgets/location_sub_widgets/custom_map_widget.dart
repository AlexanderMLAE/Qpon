import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class CustomMapWidget extends StatefulWidget {
  const CustomMapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {

  CameraOptions camera = CameraOptions(
    center: Point(coordinates: Position(-86.84686, 21.04848)),
    zoom: 16.35,
    bearing: 0,
    pitch: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(children: [MapWidget(
      cameraOptions: camera,
    )]);
  }
}
