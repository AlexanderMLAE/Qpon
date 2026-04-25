import 'package:flutter/material.dart';
import 'package:proyecto_qpon/database/local_database.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import 'package:proyecto_qpon/shared/globals.dart';

/// Screen that displays the [Offer]s saved locally
class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({super.key});

  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  // Offers that will be displayed as Offer Cards
  List<Offer> _offers = [];

  // Listener added and removed to refresh offers when one is added
  @override
  void initState() {
    super.initState();
    savedOfferUpdateNotifier.addListener(_loadOffers);
    _loadOffers();
  }

  @override
  void dispose() {
    savedOfferUpdateNotifier.removeListener(_loadOffers);
    super.dispose();
  }

  Future<void> _loadOffers() async {
    try {
      final offers = await LocalDatabase.getSavedOfferCards();
      setState(() {
        _offers = offers;
      });
      debugPrint('Ofertas Guardadas en state: $_offers');
    } catch (e) {
      debugPrint('Error leyendo ofertas $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _offers.isEmpty ? _buildEmptyState() : _buildListaOfertas(),
    );
  }

  /// When there's no saved [Offer]s
  Widget _buildEmptyState() {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Text(
              'En este Apartado puedes agregar tus Ofertas Favoritas',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No tienes ofertas favoritas aún',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Draw the [Offer]s saved as offer cards
  Widget _buildListaOfertas() {
    return Column(
      children: [
        // Placeholder probably
        ElevatedButton(onPressed: _deleteFavorites, child: Text('Delete')),
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Tus Ofertas Favoritas',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Offer.buildOfferCard(_offers.length, _offers)),
      ],
    );
  }

  /// Deletes ALL of the saved offers from favorites
  Future<void> _deleteFavorites() async {
    await LocalDatabase.deleteAllSavedOfferCards();
    // Make the notifier know something happened so we reload the offers, is this better than just calling _loadOffers from here?
    savedOfferUpdateNotifier.updateSavedOffer();
  }
}
