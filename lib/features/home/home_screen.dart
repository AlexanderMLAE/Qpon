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
  String _filtroPrecio = 'Todos';

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

      if (_filtroPrecio != 'Todos') {
        _filteredOffers = _filteredOffers.where((oferta) {
          final precio = (oferta['productPrice'] as num?)?.toDouble() ?? 0.0;
          switch (_filtroPrecio) {
            case 'Baratos (\$0-50)':
              return precio <= 50;
            case 'Medios (\$51-100)':
              return precio > 50 && precio <= 100;
            case 'Caros (\$100+)':
              return precio > 100;
            default:
              return true;
          }
        }).toList();
      }
    });
  }

  void _aplicarFiltroPrecio(String? nuevoFiltro) {
    setState(() {
      _filtroPrecio = nuevoFiltro ?? 'Todos';
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
        _buildHeader(),

        _buildSearchBar(),

        _buildFilterSection(),

        _buildOfertasList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Las Mejores Ofertas Cerca de Ti',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
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

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Filtro - Precio:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: _filtroPrecio,
            underline: Container(height: 0),
            onChanged: _aplicarFiltroPrecio,
            items:
                const [
                  'Todos',
                  'Baratos (\$0-50)',
                  'Medios (\$51-100)',
                  'Caros (\$100+)',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.black)),
                  );
                }).toList(),
          ),
        ],
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
