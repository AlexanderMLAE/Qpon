import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:proyecto_qpon/database/local_database.dart' show LocalDatabase;
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import 'package:proyecto_qpon/features/offers/presentation/offer_details_screen.dart';
import 'package:proyecto_qpon/shared/globals.dart'
    show savedOfferUpdateNotifier;

@Preview(name: 'offer')
Widget preview() {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text(
          'Offer Card Widget Preview',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 227, 18, 47),
      ),
      body: Column(
        children: [
          OfferCardWidget(
            offer: Offer(
              productName: "wiwiwiwiwi",
              productPrice: 20.01,
              productDetails: "that one cat",
              imageUrl: "https://i.imgur.com/DlMOeSc.png",
              offerId: 'exaple',
              localId: null,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Card widget that shows basic [Offer] data
class OfferCardWidget extends StatelessWidget {
  /// Contains the data that will be displayed
  final Offer offer;

  const OfferCardWidget({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return OfferCard(offer: offer);
  }
}

class OfferCard extends StatefulWidget {
  final Offer offer;

  const OfferCard({super.key, required this.offer});

  @override
  State<StatefulWidget> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  Offer get _thisOffer => widget.offer;
  bool _isFavorited = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _offerImage(),
            const SizedBox(height: 12), // Blank separator
            _offerTitle(),
            const SizedBox(height: 8), // Blank separator
            Container(
              height: 1,
              color: Color.fromARGB(255, 227, 18, 47),
            ), // Separator
            const SizedBox(height: 8), // Blank separator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _detailsButton(),
                // Button
                _favoriteButton(),
              ],
            ),
            const SizedBox(height: 8),
            _offerDetails(),
          ],
        ),
      ),
    );
  }

  Row _offerImage() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: NetworkImage(_thisOffer.imageUrl),
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  /// [Card]'s title that displays the name of the offer
  Row _offerTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _thisOffer.productName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$ ${_thisOffer.productPrice}',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Button that pushes the [OfferDetails] screen
  ElevatedButton _detailsButton() {
    return ElevatedButton(
      onPressed: _openDetails,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 227, 18, 47),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text("Detalles", style: TextStyle(color: Colors.white)),
    );
  }

  IconButton _favoriteButton() {
    return (_thisOffer.localId == null)
        ? IconButton(
            isSelected: _isFavorited,
            onPressed: () {
              _saveOffer();
              setState(() {
                _isFavorited = true;
              });
            },
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
          )
        : IconButton(onPressed: _unsaveOffer, icon: Icon(Icons.favorite));
  }

  /// Short details text
  Text _offerDetails() {
    return Text(
      _thisOffer.productDetails,
      style: TextStyle(fontSize: 12, color: Colors.black),
    );
  }

  void _openDetails() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => OfferDetails(offer: _thisOffer),
        ),
      );
    });
  }

  Future<void> _saveOffer() async {
    LocalDatabase.insertSavedOfferCard(_thisOffer);
    debugPrint('Offer to be saved locally: ${_thisOffer.toString()}');
    // Global notifier so favorites knows to update
    savedOfferUpdateNotifier.value++;
  }

  Future<void> _unsaveOffer() async {
    LocalDatabase.deleteSavedOfferCard(_thisOffer.localId!);
    debugPrint('Offer to be deleted locally: ${_thisOffer.toString()}');
    // Same thing
    savedOfferUpdateNotifier.value++;
  }
}
