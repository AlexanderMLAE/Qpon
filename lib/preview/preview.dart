import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: 'Preview')
Widget preview() {
  return Center(child: BottomSheetPreview());
}

class BottomSheetPreview extends StatefulWidget {
  const BottomSheetPreview({super.key});

  @override
  State<BottomSheetPreview> createState() => _BottomSheetPreviewState();
}

class _BottomSheetPreviewState extends State<BottomSheetPreview> {
  int locationRadius = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [Text('Bottom Sheet Preview'), _topBar()]),
    );
  }

  Container _topBar() {
    return Container(
      // Top bar
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_helpButton(), _settingsButton()],
      ),
    );
  }

  SizedBox _helpButton() {
    return SizedBox(
      height: 30,
      child: IconButton(
        style: ButtonStyle(alignment: Alignment.center),
        icon: const Icon(Icons.help_outline),
        onPressed: () async {
          _openHelpBottomSheet();
        },
      ),
    );
  }

  SizedBox _settingsButton() {
    return SizedBox(
      height: 30,
      child: IconButton(
        style: ButtonStyle(alignment: Alignment.center),
        icon: const Icon(Icons.settings),
        onPressed: () async {
          _openSettingsBottomSheet();
        },
      ),
    );
  }

  void _openSettingsBottomSheet() {
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
                            _settingsSheetTopBar(context),
                            //Map
                            SizedBox(height: 200, child: Placeholder()),
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text('location placeholder'),
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

  void _openHelpBottomSheet() {
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
                            _helpSheetTopBar(context),
                            //Map
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text('location placeholder'),
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

  Row _settingsSheetTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Spacer(flex: 2),
        const Text(
          'ooo do you want uh some of this on your that',
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

  Row _helpSheetTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Spacer(flex: 2),
        const Text('other text', style: TextStyle(fontWeight: FontWeight.bold)),
        Spacer(),
        ElevatedButton(
          child: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
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
}
