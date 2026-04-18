import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/map/presentation/custom_map_widget.dart';
import 'package:proyecto_qpon/shared/globals.dart';

// Consider renaming some classes
// Probably doesnt need a stateless widget? i should look more into this
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
  /// (WIP) Radius around the point selected by user, stores outside this radius won't be shown
  int locationRadius = 1;
  final CustomMapWidget _mapWidget = CustomMapWidget();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(updateMap);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _topBar(),
          // Actual body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color.fromARGB(255, 227, 18, 47),
                            ),
                          ),
                          child: _searchField(),
                        ),
                      ),
                      const SizedBox(width: 6), // Spacer
                      ElevatedButton(
                        onPressed: updateMap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            227,
                            18,
                            47,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Buscar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Spacer
                  // Map
                  Expanded(child: _mapWidget),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Displayed at the top (WIP) used to find specific stores
  TextField _searchField() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Buscar establecimiento',
        prefixIcon: const Icon(
          Icons.search,
          color: Color.fromARGB(255, 227, 18, 47),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        // TODO: Fix clear button not showing up
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                },
              )
            : null,
      ),
    );
  }

  /// Contains the map settings button and will possibly house a help widget as well
  Container _topBar() {
    return Container(
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
                _openBottomSheet();
              },
            ),
          ),
        ],
      ),
    );
  } // Build

  void updateMap() {
    final searchQuery = _controller.text.toLowerCase().trim();
    storeSearchUpdateNotifier.changeSearchQuery(searchQuery);
  }

  /// Map Settings (WIP) Non functional
  void _openBottomSheet() {
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
                            _sheetTopBar(context),
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
                            _radiusSlider(setStateOnSheet),
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

  /// Sets the radius around the center point for displaying stores on map
  Row _radiusSlider(StateSetter setStateOnSheet) {
    return Row(
      children: [
        Text('1km'),
        Expanded(
          child: Slider(
            divisions: 25,
            showValueIndicator: ShowValueIndicator.alwaysVisible,
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
        ),
        Text('25km'),
      ],
    );
  }

  Row _sheetTopBar(BuildContext context) {
    return Row(
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
    );
  }
}
