import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key, required this.locationText});
  final String locationText;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  double locationRadius = 0.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextButton(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(widget.locationText),
            ),
            onPressed: () async {
              openBottomSheet();
            },
          ),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Buscar una oferta o establecimiento',
            ),
          ),
          ElevatedButton(onPressed: null, child: Text('Buscar')),
          //Map Element Start
          // OSMFlutter(
          //   controller: MapController(
          //     initPosition: GeoPoint(
          //       latitude: 20.858359,
          //       longitude: -86.903677,
          //     ),
          //   ),
          //   osmOption: OSMOption(
          //     userTrackingOption: const UserTrackingOption(
          //       enableTracking: true,
          //       unFollowUser: false,
          //     ),
          //     zoomOption: const ZoomOption(
          //       initZoom: 8,
          //       minZoomLevel: 3,
          //       maxZoomLevel: 19,
          //       stepZoom: 1.0,
          //     ),
          //     userLocationMarker: UserLocationMaker(
          //       personMarker: const MarkerIcon(
          //         icon: Icon(
          //           Icons.location_history_rounded,
          //           color: Colors.red,
          //           size: 48,
          //         ),
          //       ),
          //       directionArrowMarker: const MarkerIcon(
          //         icon: Icon(Icons.double_arrow, size: 48),
          //       ),
          //     ),
          //     roadConfiguration: const RoadOption(
          //       roadColor: Colors.yellowAccent,
          //     ),
          //   ),
          // ),
          //Map Element End
        ],
      ),
    );
  } // Build

  void openBottomSheet() {
    {
      showModalBottomSheet<dynamic>(
        showDragHandle: true,
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Wrap(
                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Spacer(flex: 2),
                                const Text('Elige una Ubicacion'),
                                Spacer(),
                                ElevatedButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            // Map element start
                            // OSMFlutter(
                            //   controller: MapController(
                            //     initPosition: GeoPoint(
                            //       latitude: 47.4358055,
                            //       longitude: 8.4737324,
                            //     ),
                            //     areaLimit: const BoundingBox(
                            //       east: 10.4922941,
                            //       north: 47.8084648,
                            //       south: 45.817995,
                            //       west: 5.9559113,
                            //     ),
                            //   ),
                            //   osmOption: OSMOption(
                            //     userTrackingOption: const UserTrackingOption(
                            //       enableTracking: true,
                            //       unFollowUser: false,
                            //     ),
                            //     zoomOption: const ZoomOption(
                            //       initZoom: 8,
                            //       minZoomLevel: 3,
                            //       maxZoomLevel: 19,
                            //       stepZoom: 1.0,
                            //     ),
                            //     userLocationMarker: UserLocationMaker(
                            //       personMarker: const MarkerIcon(
                            //         icon: Icon(
                            //           Icons.location_history_rounded,
                            //           color: Colors.red,
                            //           size: 48,
                            //         ),
                            //       ),
                            //       directionArrowMarker: const MarkerIcon(
                            //         icon: Icon(Icons.double_arrow, size: 48),
                            //       ),
                            //     ),
                            //     roadConfiguration: const RoadOption(
                            //       roadColor: Colors.yellowAccent,
                            //     ),
                            //   ),
                            // ),
                            // Map element end
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text(widget.locationText),
                              ],
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Buscar una ciudad',
                              ),
                            ),
                            Slider(
                              min: 0.0,
                              max: 25.0,
                              value: locationRadius,
                              onChanged: (double value) {
                                setState(() {
                                  locationRadius = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }
}
