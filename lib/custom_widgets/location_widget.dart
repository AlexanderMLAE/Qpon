import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key, this.locationText = 'Placeholder'});
  final String locationText;
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
                            Image.network(
                              'https://media.discordapp.net/attachments/949080189349015696/1437807049978417303/image.png?ex=691495a9&is=69134429&hm=a1133b3c42fc25b49547b51b99369f6b6cccd0d52d1fe459ce728aef860cfd2a&=&format=webp&quality=lossless&width=1227&height=815',
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text(locationText),
                              ],
                            ),
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
          Image.network(
            'https://media.discordapp.net/attachments/949080189349015696/1437807049978417303/image.png?ex=691495a9&is=69134429&hm=a1133b3c42fc25b49547b51b99369f6b6cccd0d52d1fe459ce728aef860cfd2a&=&format=webp&quality=lossless&width=1227&height=815',
          ),
        ],
      ),
    );
  }
}
