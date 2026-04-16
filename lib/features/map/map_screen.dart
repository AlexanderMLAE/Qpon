import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/map/custom_map_widget.dart';
import 'package:proyecto_qpon/shared/globals.dart';

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
  final CustomMapWidget _mapWidget = CustomMapWidget();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState(){
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
                      const SizedBox(width: 6),
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
                  const SizedBox(height: 8),
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
                openBottomSheet();
              },
            ),
          ),
        ],
      ),
    );
  } // Build

  void updateMap() {
    final searchQuery = _controller.text.toLowerCase().trim();
    storeSearch.changeSearchQuery(searchQuery);
    locationSearchUpdateNotifier.value++;
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
                            _sheetTopBar(context),
                            //Map
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
