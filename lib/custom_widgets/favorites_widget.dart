import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Importar FirebaseAuth
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
  
  // Variable para saber si el usuario está logueado
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    // Obtenemos el usuario actual al iniciar
    _currentUser = FirebaseAuth.instance.currentUser;
    _cargarOfertas();
  }

  Future<void> _cargarOfertas() async {
    // Si queremos recargar, mostramos loading (opcional, depende de gustos)
    // setState(() => _cargando = true); 

    if (_currentUser == null) {
      // Si no hay usuario, no intentamos cargar nada de la BD
      if (mounted) {
        setState(() {
          _ofertas = [];
          _cargando = false;
        });
      }
      return;
    }

    try {
      // 2. CAMBIO CLAVE:
      // Intentamos usar el ID real. 
      // NOTA: Si tu DatabaseService espera un 'int' (1), esto dará error porque uid es String.
      // Si usas Firebase Database, deberías cambiar tu servicio para aceptar Strings.
      // Por ahora dejo el '1' comentado para que no se rompa si tu BD es local,
      // pero la meta es usar: _currentUser!.uid
      
      final ofertas = await DatabaseService.getOfertasFavoritas(1); 
      
      if (mounted) {
        setState(() {
          _ofertas = ofertas;
          _cargando = false;
        });
      }
    } catch (e) {
      debugPrint('Error cargando favoritos: $e');
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 18, 47), // Color rojo de tu marca
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 18, 47)),
        )
      );
    }

    if (_currentUser == null) {
      return _buildGuestState();
    }

    if (_ofertas.isEmpty) {
      return _buildEmptyState();
    }

    // 3. RefreshIndicator: Permite deslizar hacia abajo para recargar
    return RefreshIndicator(
      onRefresh: _cargarOfertas,
      color: const Color.fromARGB(255, 252, 18, 47),
      child: _buildListaOfertas(),
    );
  }

  Widget _buildGuestState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.lock_outline, size: 60, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'Inicia sesión para ver tus favoritos',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    // Usamos ListView aquí también para que el RefreshIndicator funcione
    // incluso cuando la lista está vacía (permite recargar si agregaste algo)
    return ListView(
      children: [
        Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 60),
          child: const Column(
            children: [
              Text(
                'En este apartado puedes agregar tus Ofertas Favoritas',
                textAlign: TextAlign.center,
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
      ],
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