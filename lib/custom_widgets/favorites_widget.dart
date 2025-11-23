import 'package:flutter/material.dart';
import 'location_sub_widgets/offer_card_widget.dart';
import 'location_sub_widgets/database_service.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({super.key});

  @override
  State<FavoritesWidget> createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<FavoritesWidget> {
  List<Map<String, dynamic>> _ofertas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarOfertas();
  }

  Future<void> _cargarOfertas() async {
    try {
      final ofertas = await DatabaseService.getOfertasFavoritas(1);
      setState(() {
        _ofertas = ofertas;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Favoritos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _ofertas.isEmpty
              ? _buildEmptyState()
              : _buildListaOfertas(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      alignment: Alignment.topCenter,
      child: const Padding(
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

  Widget _buildListaOfertas() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Tus Ofertas Favoritas',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _ofertas.length,
            itemBuilder: (context, index) {
              final oferta = _ofertas[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OfferCardWidget(
                  productName: oferta['productName'] ?? 'Producto',
                  productPrice: (oferta['productPrice'] as num?)?.toDouble() ?? 0.0,
                  productDetails: oferta['productDetails'] ?? 'Detalles de la oferta',
                  imageURL: oferta['imageURL'] ?? '',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}