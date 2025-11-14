import 'package:flutter/material.dart';

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
          //Map Element Placeholder
          Image.network('https://i.imgur.com/5GVWIBO.png'),
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
                                Spacer(flex: 2,),
                                const Text('Elige una Ubicacion'),
                                Spacer(),
                                ElevatedButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            // Map element placeholder
                            Image.network('https://i.imgur.com/5GVWIBO.png'),
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
