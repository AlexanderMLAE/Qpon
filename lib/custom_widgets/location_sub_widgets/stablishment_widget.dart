import 'package:flutter/material.dart';
import 'package:proyecto_qpon/custom_widgets/location_sub_widgets/database_service.dart';
import 'offer_card_widget.dart';

// Everything above this may be unnecessary
class StablishmentWidget extends StatefulWidget {
  const StablishmentWidget({super.key, required this.stablishmentData});
  final Map<String, Object>? stablishmentData;

  @override
  State<StatefulWidget> createState() => _StablishmentWidgetState();
}

class _StablishmentWidgetState extends State<StablishmentWidget> {
  List<Map<String, dynamic>> _offers = [];
  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  Future<void> fetchOffers() async {
    String storeId = widget.stablishmentData?["storeId"] as String;
    try {
      final offers = await DatabaseService.getStoreOffers(storeId);
      setState(() {
        _offers = offers;
      });
    } catch (e) {
      debugPrint("err $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        title: Center(
          child: Text(
            "${widget.stablishmentData!["storeName"] ?? "Something went wrong"}",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Column(
        children: [
          Text("Store Data ${widget.stablishmentData}"),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                final offer = _offers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: OfferCardWidget(
                    productName: offer['productName'] ?? 'Producto',
                    productPrice:
                        (offer['productPrice'] as num?)?.toDouble() ?? 0.0,
                    productDetails:
                        offer['productDetails'] ?? 'Detalles de la oferta',
                    imageURL: offer['imageURL'] ?? 'https://i.imgur.com/vs8QJQY.png',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
