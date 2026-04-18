import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/map/data/map_data.dart';

class CustomMapWidget extends StatefulWidget {
  const CustomMapWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CustomMapWidgetState();
}

class _CustomMapWidgetState extends State<CustomMapWidget> {
  CustomMapData mapWidget = CustomMapData();

  @override
  Widget build(BuildContext context) {
    return Column(children: [Expanded(child: mapWidget)]);
  }
}
