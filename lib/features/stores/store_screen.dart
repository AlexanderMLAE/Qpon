import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import 'package:proyecto_qpon/shared/firestore_service.dart';

// Everything above this may be unnecessary
class StoreWidget extends StatefulWidget {
  const StoreWidget({super.key, required this.storeData});
  final Map<String, Object>? storeData;

  @override
  State<StatefulWidget> createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<StoreWidget> {
  List<Offer> _offers = [];
  @override
  void initState() {
    super.initState();
    getOffers();
  }

  Future<void> getOffers() async {
    String storeId = widget.storeData?["storeId"] as String;
    try {
      final offers = await FirestoreService.getStoreOffersList(storeId);
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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 227, 18, 47),
        title: Center(
          child: Text(
            "${widget.storeData!["storeName"] ?? "Something went wrong"}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Text("Store Data ${widget.storeData}"),
          Expanded(child: Offer.buildOfferCard(_offers.length, _offers)),
        ],
      ),
    );
  }
}
