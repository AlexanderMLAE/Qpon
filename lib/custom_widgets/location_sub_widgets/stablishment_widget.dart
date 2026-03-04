import 'package:flutter/material.dart';
import 'offer_card_widget.dart';
import 'database_service.dart';

class StablishmentScreen extends StatelessWidget {
  const StablishmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: StablishmentWidget(stablishmentName: 'Establecimiento Placeholder'),
    );
  }
}

// Everything above this may be unnecessary
class StablishmentWidget extends StatefulWidget {
  const StablishmentWidget({super.key, required this.stablishmentName});
  final String stablishmentName;

  @override
  State<StatefulWidget> createState() => _StablishmentWidgetState();
}

class _StablishmentWidgetState extends State<StablishmentWidget> {
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
    // ignore: unused_local_variable
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        title: Center(
          child: Text("", style: TextStyle(color: Colors.black)),
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
              '',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Icon(Icons.favorite_border, size: 60, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No se encontraron ofertas',
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
            'Ofertas encontradas',
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
                  productPrice:
                      (oferta['productPrice'] as num?)?.toDouble() ?? 0.0,
                  productDetails:
                      oferta['productDetails'] ?? 'Detalles de la oferta',
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
