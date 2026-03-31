import 'package:flutter/material.dart';
import 'package:proyecto_qpon/custom_widgets/sub_widgets/database_service.dart';
import 'package:proyecto_qpon/custom_widgets/sub_widgets/offer_card_builder.dart';

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
    getOffers();
  }

  Future<void> getOffers() async {
    String storeId = widget.stablishmentData?["storeId"] as String;
    try {
      final offers = await DatabaseService.fetchStoreOffers(storeId);
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
            "${widget.stablishmentData!["storeName"] ?? "Something went wrong"}",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          Text("Store Data ${widget.stablishmentData}"),
          Expanded(
            child: OfferCardBuilder.buildOfferCard(_offers.length, _offers),
          ),
        ],
      ),
    );
  }
}
