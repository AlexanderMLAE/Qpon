import 'package:flutter/material.dart';
// TODO: consider renaming some classes
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key, required this.locationText});
  final String locationText;

  @override
  Widget build(BuildContext context) {
    return LocationWidget(locationText: locationText);
  }
}

class LocationWidget extends StatefulWidget {
  const LocationWidget({super.key, required this.locationText});
  final String locationText;

  @override
  State<LocationWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends State<LocationWidget> {
  int locationRadius = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          // Top bar
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Spacer(flex: 1),
              Text(
                'Ubicación',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              TextButton(
                child: Text(
                  '${widget.locationText} - ${locationRadius}Km',
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
                onPressed: () async {
                  openBottomSheet();
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  labelText: 'Buscar una oferta o establecimiento',
                ),
              ),
              ElevatedButton(onPressed: null, child: Text('Buscar')),
            ],
          ),
        ),
      ],
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
            builder: (BuildContext context, StateSetter setStateModal) {
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
                                  child: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
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
                              value: locationRadius.toDouble(),
                              onChanged: (double value) {
                                setStateModal(() {
                                  locationRadius = value.toInt();
                                });
                                setState(() {
                                  locationRadius = value.toInt();
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
