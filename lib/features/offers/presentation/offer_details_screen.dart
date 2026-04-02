import 'package:flutter/material.dart';
import 'package:proyecto_qpon/database/local_database.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';

class OfferDetails extends StatefulWidget {
  final Offer offer;

  const OfferDetails({required this.offer, super.key});
  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  Offer get thisOffer => widget.offer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _offerDetailsAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _offerImage(),
            _offerTitle(),
            const SizedBox(height: 16), // Spacer i think
            _offerPrice(),
            const SizedBox(height: 16), // Spaces maybe
            _offerDetails(),
            const SizedBox(height: 24), // Yet another spacerhaps
            _saveOfferButton(),
            const SizedBox(height: 24), // Spacer!!!!!
            _offerTerms(),
          ],
        ),
      ),
    );
  }

  Container _offerImage() {
    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 22),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            thisOffer.imageUrl,
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text(
                'Imagen no encontrada',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _offerDetailsAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: const Color.fromARGB(255, 227, 18, 47),
      title: Text(
        'Oferta',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Text _offerTitle() {
    return Text(
      thisOffer.productName,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _offerPrice() {
    return Text(
      '\$ ${thisOffer.productPrice}',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(255, 252, 18, 47),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text _offerDetails() {
    return Text(
      thisOffer.productDetails,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[700], fontSize: 14),
    );
  }

  ElevatedButton _saveOfferButton() {
    return ElevatedButton(
      onPressed: saveOffer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 252, 18, 47),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: const Text(
        'Guardar Oferta',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container _offerTerms() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Términos y condiciones:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Válido hasta el 29 de marzo\n• No acumulable con otras ofertas\n• Presenta el código en la tienda',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Future<void> saveOffer() async {
    LocalDatabase.insertSavedOfferCard(thisOffer);
    debugPrint('Oferta mandada para guardar $thisOffer');
  }
}
