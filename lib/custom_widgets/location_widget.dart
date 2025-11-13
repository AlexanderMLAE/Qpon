import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key, this.locationText = 'Placeholder', this.locationRadius = 1});
  final String locationText;
  final int locationRadius;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextButton(
            child: Align(
              alignment: Alignment.topRight,
              child: Text(locationText),
            ),
            onPressed: () {
              showModalBottomSheet<dynamic>(
                isScrollControlled: true,
                enableDrag: true,
                context: context,
                builder: (BuildContext context) {
                  return Wrap(
                    children: <Widget>[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Elige una Ubicacion'),
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
                                Text(locationText),
                              ],
                            ),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Buscar una ciudad',
                              ),
                            ),
                            Slider(min: 0.0, max: 25.0, value: 12.5, onChanged: null),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ), // END OF BOTTOM SHEET
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
  }
  // end of BUILD
  void changeRadius(int rad) {
    //locationRadius = rad;
  }
}
