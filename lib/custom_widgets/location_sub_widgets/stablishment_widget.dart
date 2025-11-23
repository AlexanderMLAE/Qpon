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
// Everything above this may be unnecessary
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
              children: [
                for (var i = 0; i < 5; i++) ...[ // 5 for now, we'll see later when added to DB
                  OfferCardWidget(
                    productName: 'Product $i',
                    productPrice: i.toDouble(),
                    productDetails: 'Detalles $i',
                    imageURL: 'https://res.cloudinary.com/amecar/image/fetch/w_849/f_auto/https://res.cloudinary.com/amecar/image/upload/f_auto/v1738363260/CarlsJr-Oferta14DeFebrero-WebsiteLoNuevo-960x540_28_zbnjwa.jpg',
                  ),
                  if (i < 4) const Divider(),
                ],
              ],
            ),
          ), // Top bar end
        ],
      ),
    );
  }
}