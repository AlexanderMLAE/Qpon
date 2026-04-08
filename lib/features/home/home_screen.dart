import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/home/filters/filter_price.dart';
import 'package:proyecto_qpon/features/offers/data/offer_class.dart';
import '../../shared/firestore_service.dart';

/// Base home screen with [Offer]s obtained from Firestore
/// TODO: More in depth documentation
class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<Offer> _ofertas = [];
  List<Offer> _filteredOffers = [];
  bool _cargando = true;
  final TextEditingController _searchController = TextEditingController();

  double? _minPrice;
  double? _maxPrice;
  bool _priceFilterActive = false;

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
      final ofertas = await FirestoreService.getOffersList();

      debugPrint("Offers in home $_ofertas");
      setState(() {
        _ofertas = ofertas;
        _filteredOffers = ofertas;
        _cargando = false;
      });
    } catch (e) {
      debugPrint("Error getting offers in home $e");
      setState(() {
        _cargando = false;
      });
    }
  }

  // Filter offers by name or details -- will be expanded later
  void _filtrarOfertas() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredOffers = _ofertas.where((oferta) {
        final nombreMatch = oferta.productName
            .toString()
            .toLowerCase()
            .contains(query);

        final detallesMatch = oferta.productDetails
            .toString()
            .toLowerCase()
            .contains(query);

        final textMatch = nombreMatch || detallesMatch;

        bool priceMatch = true;
        if (_priceFilterActive) {
          final productPrice = oferta.productPrice.toDouble();

          if (_minPrice != null && productPrice < _minPrice!) {
            priceMatch = false;
          }
          if (_maxPrice != null && productPrice > _maxPrice!) {
            priceMatch = false;
          }
        }

        return textMatch && priceMatch;
      }).toList();
    });
  }

  void _onPriceFilterApplied(double? minPrice, double? maxPrice) {
    setState(() {
      _minPrice = minPrice;
      _maxPrice = maxPrice;
      _priceFilterActive = (minPrice != null || maxPrice != null);
      _filtrarOfertas();
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

        PriceFilterWidget(
          onFilterApplied: _onPriceFilterApplied,
          initialMinPrice: _minPrice,
          initialMaxPrice: _maxPrice,
          isActive: _priceFilterActive,
        ),

        _buildOfertasList(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          : Offer.buildOfferCard(_filteredOffers.length, _filteredOffers),
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
