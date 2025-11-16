import 'package:flutter/material.dart';

class StablishmentScreen extends StatelessWidget {
  const StablishmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: StablishmentWidget(),
    );
  }
}

class StablishmentWidget extends StatefulWidget {
  const StablishmentWidget({super.key});

  @override
  State<StatefulWidget> createState() => _StablishmentWidgetState();
}

class _StablishmentWidgetState extends State<StablishmentWidget> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        title: Center(
          child: Text(
            "Qpon",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(children: [
        Container(
          // Top bar
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              Text(
                'Establecimiento', 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
