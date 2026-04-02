import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import 'package:proyecto_qpon/features/offers/presentation/offer_details_screen.dart';

class OfferCardWidget extends StatelessWidget {
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
  Offer get thisOffer => widget.offer;
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
            _detailsButton(),
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
              image: NetworkImage(thisOffer.imageUrl),
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Row _offerTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          thisOffer.productName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          '\$ ${thisOffer.productPrice}',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

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

  Text _offerDetails() {
    return Text(
      thisOffer.productDetails,
      style: TextStyle(fontSize: 12, color: Colors.black),
    );
  }

  void _openDetails() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => OfferDetails(offer: thisOffer),
        ),
      );
    });
  }
}
