import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/map/presentation/custom_map_widget.dart';
import 'package:proyecto_qpon/shared/globals.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final CustomMapWidget _mapWidget = CustomMapWidget();
  final TextEditingController _controller = TextEditingController();
  bool showClearButton = false;
  @override
  void initState() {
    _controller.addListener(_onSearchFieldChange);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchFieldChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _searchFilter(),
              const SizedBox(height: 8), // Separator
              // Map
              Expanded(child: _mapWidget),
            ],
          ),
        ),
      ),
    );
  }

  Row _searchFilter() {
    return Row(
      children: [
        _searchBox(),
        const SizedBox(width: 6), // Separator
        _searchButton(),
      ],
    );
  }

  Expanded _searchBox() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 227, 18, 47)),
        ),
        child: _searchBoxTextField(),
      ),
    );
  }

  TextField _searchBoxTextField() {
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
        suffixIcon: showClearButton
            ? IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  _controller.clear();
                  _applySearchFilter();
                },
              )
            : null,
      ),
    );
  }

  ElevatedButton _searchButton() {
    return ElevatedButton(
      onPressed: _applySearchFilter,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 227, 18, 47),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Buscar', style: TextStyle(color: Colors.white)),
    );
  }

  void _applySearchFilter() {
    final searchQuery = _controller.text.toLowerCase().trim();
    storeSearchUpdateNotifier.changeSearchQuery(searchQuery);
  }

  /// Manualy handling visibility of clear button because idfk WHY it wont show up if i do it the normal way but whatever
  void _onSearchFieldChange() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        showClearButton = true;
      });
      return;
    }
    setState(() {
      showClearButton = false;
    });
    storeSearchUpdateNotifier.changeSearchQuery('');
  }

  // Settings removed temporarily

  // Container _topBar() {
  //   return Container(
  //     // Top bar
  //     color: Colors.white,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         SizedBox(
  //           height: 30,
  //           child: IconButton(
  //             style: ButtonStyle(alignment: Alignment.center),
  //             icon: const Icon(Icons.),
  //             onPressed: () async {
  //               _openSettingsBottomSheet();
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void openSettingsBottomSheet() {
  //   {
  //     showModalBottomSheet<dynamic>(
  //       isScrollControlled: true,
  //       enableDrag: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setStateOnSheet) {
  //             return SingleChildScrollView(
  //               child: Padding(
  //                 padding: EdgeInsets.only(
  //                   left: 8.0,
  //                   right: 8.0,
  //                   top: 8.0,
  //                   bottom: 50.0,
  //                 ),
  //                 child: Wrap(
  //                   children: <Widget>[
  //                     Center(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         verticalDirection: VerticalDirection.down,
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: <Widget>[
  //                           _sheetTopBar(context),
  //                           //Map
  //                           Row(
  //                             children: <Widget>[
  //                               Icon(Icons.location_on),
  //                               Text(widget.locationText),
  //                             ],
  //                           ),
  //                           TextField(
  //                             decoration: InputDecoration(
  //                               border: OutlineInputBorder(),
  //                               labelText: 'Buscar una ciudad',
  //                             ),
  //                           ),
  //                           _radiusSlider(setStateOnSheet),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     );
  //   }
  // }

  // Temporarily removed, part of settings

  // Row _radiusSlider(StateSetter setStateOnSheet) {
  //   return Row(
  //     children: [
  //       Text('1km'),
  //       Expanded(
  //         child: Slider(
  //           divisions: 25,
  //           showValueIndicator: ShowValueIndicator.alwaysVisible,
  //           min: 1.0,
  //           max: 25.0,
  //           value: locationRadius.toDouble(),
  //           onChanged: (double value) {
  //             setStateOnSheet(() {
  //               locationRadius = value.toInt();
  //             });
  //             setState(() {
  //               locationRadius = value.toInt();
  //             });
  //           },
  //         ),
  //       ),
  //       Text('25km'),
  //     ],
  //   );
  // }

  // Row _helpSheetTopBar(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       Spacer(flex: 2),
  //       const Text(
  //         'Ayuda e información',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       Spacer(),
  //       ElevatedButton(
  //         child: const Icon(Icons.close),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //     ],
  //   );
  // }
}
