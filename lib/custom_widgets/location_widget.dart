import 'package:flutter/material.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({super.key, this.locationText = 'Muerto Morelos'});
  final String locationText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          TextButton(onPressed: null, child: Align(alignment: Alignment.topRight, child: Text(locationText))),
          TextField(decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Buscar una oferta o establecimiento')),
          ElevatedButton(onPressed: null, child: Text('Buscar')),
        ],
      ),
    );
  }
}