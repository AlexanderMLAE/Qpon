import 'package:flutter/material.dart';
import 'package:proyecto_qpon/database/local_database.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';

/// Screen that displays all of the details of a given [Offer]
class OfferDetails extends StatefulWidget {
  /// Contains the data that will be displayed
  final Offer offer;

  const OfferDetails({required this.offer, super.key});
  @override
  State<OfferDetails> createState() => _OfferDetailsState();
}

class _OfferDetailsState extends State<OfferDetails> {
  Offer get _thisOffer => widget.offer;

  /// Temporary turn into a map to display values that may currently be null in Firestore
  Map<String, dynamic> get _thisOfferMap => _thisOffer.toMap();

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
            _thisOfferMap['imageUrl'],
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
        _thisOfferMap['productName'],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Text _offerTitle() {
    return Text(
      _thisOfferMap['productName'],
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
      '\$ ${_thisOfferMap['productPrice']}',
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
      _thisOfferMap['productDetails'],
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[700], fontSize: 14),
    );
  }

  ElevatedButton _saveOfferButton() {
    return ElevatedButton(
      onPressed: (_thisOffer.localId == null) ? _saveOffer : _unsaveOffer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 252, 18, 47),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(
        (_thisOffer.localId == null)
            ? 'Guardar Oferta'
            : 'Eliminar Oferta de Favoritos',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// [Offer] Terms and Conditions
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
            '• Válido hasta ${_thisOfferMap['Example']}\n• [Ejemplo]\n• [Ejemplo]',
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  /// Saves the [Offer] on [LocalDatabase] to be displayed on the Favorites screen
  /// sae and unsave could maybe be a single function "handleSaving"
  /// is this clearer? will try later
  Future<void> _saveOffer() async {
    final int id = await _thisOffer.saveOffer();
    setState(() {
      _thisOffer.localId = id;
    });
    if (mounted) {
      _thisOffer.showSnackbar(context, true);
    }
  }

  /// Deletes the [Offer] from [LocalDatabase]
  Future<void> _unsaveOffer() async {
    await _thisOffer.unsaveOffer();
    setState(() {
      _thisOffer.localId = null;
    });
    if (mounted) {
      _thisOffer.showSnackbar(context, false);
    }
  }
}
