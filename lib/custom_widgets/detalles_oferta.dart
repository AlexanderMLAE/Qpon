import 'package:flutter/material.dart';

class DetallesOferta extends StatelessWidget {
  const DetallesOferta({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: DetallesOfertaWidget(),
    );
  }
}

class DetallesOfertaWidget extends StatefulWidget {
  const DetallesOfertaWidget({super.key});

  @override
  State<StatefulWidget> createState() => _DetallesOfertaWidgetState();
}

class _DetallesOfertaWidgetState extends State<DetallesOfertaWidget> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(children: <Widget>[Text('hola')]),
    );
  }
}
