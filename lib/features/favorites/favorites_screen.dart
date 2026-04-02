import 'package:flutter/material.dart';
import 'package:proyecto_qpon/database/local_database.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({super.key});

  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  List<Offer> _offers = [];

  @override
  void initState() {
    super.initState();
  _loadOffers();
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

  Widget _buildEmptyState() {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            ElevatedButton(onPressed: _loadOffers, child: Text('load')),
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

  Widget _buildListaOfertas() {
    return Column(
      children: [
        ElevatedButton(onPressed: deleteFavorites, child: Text('Delete')),
        ElevatedButton(onPressed: _loadOffers, child: Text('Reload')),
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Tus Ofertas Favoritas',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Offer.buildOfferCard(_offers.length, _offers),
        ),
      ],
    );
  }

  Future<void> deleteFavorites() async {
    await LocalDatabase.deleteSavedOfferCards();
  }
}
