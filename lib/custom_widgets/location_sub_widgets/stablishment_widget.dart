import 'package:flutter/material.dart';
import 'offer_card_widget.dart';

class StablishmentScreen extends StatelessWidget {
  const StablishmentScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: StablishmentWidget(stablishmentName: 'Establecimiento Placeholder',),
    );
  }
}

class StablishmentWidget extends StatefulWidget {
  const StablishmentWidget({super.key, required this.stablishmentName});
  final String stablishmentName;
  

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
      body: Column(
        children: [
          Container(
            // Top bar
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.stablishmentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[ // These should be generated iteratively from data in DB, but this will do as a visual placeholder
                OfferCardWidget(
                  productName: 'Producto Placeholder 1',
                  productPrice: 100.00,
                ),
                Divider(),
                OfferCardWidget(
                  productName: 'Producto Placeholder 2',
                  productPrice: 100.00,
                ),
                Divider(),
                OfferCardWidget(
                  productName: 'Producto Placeholder 3',
                  productPrice: 100.00,
                ),
                Divider(),
                OfferCardWidget(
                  productName: 'Producto Placeholder 4',
                  productPrice: 100.00,
                ),
                Divider(),
                OfferCardWidget(
                  productName: 'Producto Placeholder 5',
                  productPrice: 100.00,
                ),
              ],
            ),
          ), // Top bar end
        ],
      ),
    );
  }
}
