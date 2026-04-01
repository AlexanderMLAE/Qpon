import 'package:flutter/material.dart';
import 'package:proyecto_qpon/shared/offer_card_builder.dart';
import '../../shared/firestore_service.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Map<String, dynamic>> _ofertas = [];
  List<Map<String, dynamic>> _filteredOffers = [];
  bool _cargando = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarOfertas();
    _searchController.addListener(_filtrarOfertas);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _cargarOfertas() async {
    try {
      final ofertas = await DatabaseService.fetchOffers();
      setState(() {
        _ofertas = ofertas;
        _filteredOffers = ofertas;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
    }
  }

  void _filtrarOfertas() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredOffers = _ofertas.where((oferta) {
        final nombreMatch =
            oferta['productName']?.toString().toLowerCase().contains(query) ??
            false;
        final localMatch =
            oferta['localName']?.toString().toLowerCase().contains(query) ??
            false;
        final detallesMatch =
            oferta['productDetails']?.toString().toLowerCase().contains(
              query,
            ) ??
            false;

        return nombreMatch || localMatch || detallesMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [

        _buildSearchBar(),

        _buildOfertasList(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromARGB(255, 227, 18, 47)),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar oferta o establecimiento',
            prefixIcon: const Icon(
              Icons.search,
              color: Color.fromARGB(255, 227, 18, 47),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildOfertasList() {
    return Expanded(
      child: _filteredOffers.isEmpty
          ? _buildEmptyState()
          : OfferCardBuilder.buildOfferCard(
              _filteredOffers.length,
              _filteredOffers,
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Color.fromARGB(255, 227, 18, 47),
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'No hay ofertas disponibles'
                : 'No se encontraron resultados para "${_searchController.text}"',
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
