import 'package:flutter/material.dart';
import 'location_sub_widgets/offer_card_widget.dart';
import 'location_sub_widgets/database_service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
              : _buildListaOfertas(),
    );
  }

  Widget _buildListaOfertas() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Las Mejores Ofertas Cerca de Ti',
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