import 'package:flutter/material.dart';
import 'package:proyecto_qpon/custom_widgets/location_sub_widgets/map_widget.dart';
import 'package:proyecto_qpon/custom_widgets/location_sub_widgets/stablishment_widget.dart';

// Consider renaming some classes
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
  int locationRadius = 1;
  MapWidget _mapWidget = MapWidget();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Ubicacion',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            // Top bar
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 30,
                  child: TextButton(
                    style: ButtonStyle(alignment: Alignment.center),
                    child: Text(
                      '${widget.locationText} - ${locationRadius}Km',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      openBottomSheet();
                    },
                  ),
                ),
              ],
            ),
          ),
          // Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Buscar oferta o establecimiento',
                        prefixIcon: const Icon(Icons.search, color: Colors.red),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _controller.clear();
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: openStablishment,
                    child: Text('Buscar'),
                  ),
                  // Map
                  Expanded(child: _mapWidget),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } // Build

  void updateMap() {
    setState(() {
      _mapWidget = MapWidget();
    });
  }

  void openStablishment() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) =>
              StablishmentWidget(stablishmentName: 'Plaza las Americas'),
        ),
      );
    });
  }

  void openBottomSheet() {
    {
      showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateOnSheet) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 8.0,
                    bottom: 50.0,
                  ),
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
                                const Text(
                                  'Elige una Ubicacion',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  child: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            //Map
                            SizedBox(height: 200, child: _mapWidget),
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
                              min: 1.0,
                              max: 25.0,
                              value: locationRadius.toDouble(),
                              onChanged: (double value) {
                                setStateOnSheet(() {
                                  locationRadius = value.toInt();
                                });
                                setState(() {
                                  locationRadius = value.toInt();
                                });
                              },
                            ),
                            Text(
                              '1km  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  25km',
                            ), // ugly lol
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
