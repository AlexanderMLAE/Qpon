import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'offer_card_widget.dart';

// Everything above this may be unnecessary
class StablishmentWidget extends StatefulWidget {
  const StablishmentWidget({super.key, required this.stablishmentData});
  final Map<String, Object>? stablishmentData;

  @override
  State<StatefulWidget> createState() => _StablishmentWidgetState();
}

class _StablishmentWidgetState extends State<StablishmentWidget> {
  List<Map<String, dynamic>> offers = [];
  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  void fetchOffers() {
    String storeId = widget.stablishmentData?["storeId"] as String;
    FirebaseFirestore.instance.collection("offers").where("store", isEqualTo: storeId).get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
          setState(() {
            offers.add(docSnapshot.data());
          });
          debugPrint("Offer data: $offers");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        title: Center(
          child: Text("${widget.stablishmentData!["storeName"] ?? "Something went wrong" }", style: TextStyle(color: Colors.black)),
        ),
      ),
      body: Column(
        children: [
          Text("Store Data ${widget.stablishmentData}"),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final offer = offers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: OfferCardWidget(
                    productName: offer['product_name'] ?? 'Producto',
                    productPrice:
                        (offer['product_price'] as num?)?.toDouble() ?? 0.0,
                    productDetails:
                        offer['product_details'] ?? 'Detalles de la oferta',
                    imageURL: offer['image_url'] ?? '',
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
