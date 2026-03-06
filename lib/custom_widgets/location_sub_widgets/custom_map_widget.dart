import 'package:flutter/material.dart';
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

  void _onMapCreated(MapboxMap mapboxMap) {
    mapboxMap.location.updateSettings(
      LocationComponentSettings(enabled: true, puckBearingEnabled: true),
    );
    this.mapboxMap = mapboxMap;
  }

  // list view children for map options, maybe put this on the map settings
  Widget _getPermission() {
    return TextButton(
      child: Text('get location permission'),
      onPressed: () async {
        var status = await Geolocator.requestPermission();
        debugPrint("Location granted : $status");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MapWidget mapWidget = MapWidget(
      key: ValueKey("mapWidge"),
      onMapCreated: _onMapCreated,
      cameraOptions: camera,
    );

    final List<Widget> listViewChildren = <Widget>[];

    listViewChildren.addAll(<Widget>[_getPermission()]);

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 455,
          child: mapWidget,
        ),
        Expanded(child: ListView(children: listViewChildren)),
      ],
    );
  }
}
