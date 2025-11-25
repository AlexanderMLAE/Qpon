import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class DetallesOferta extends StatelessWidget {
  const DetallesOferta({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Detalles Oferta',
      home: DetallesOfertaWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DetallesOfertaWidget extends StatefulWidget {
  const DetallesOfertaWidget({super.key});

  @override
  State<DetallesOfertaWidget> createState() => _DetallesOfertaWidgetState();
}

class _DetallesOfertaWidgetState extends State<DetallesOfertaWidget> {
  static const String _burgerBase64 = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxITEhU...';
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double topHeaderHeight = MediaQuery.of(context).padding.top + 48;
    final double bottomHeaderHeight = MediaQuery.of(context).padding.bottom + 48;
    final double smallHeaderHeight = topHeaderHeight / 2;

    Uint8List? burgerBytes;
    String cleaned = _burgerBase64.trim();
    if (cleaned.startsWith('data:image')) {
      final int idx = cleaned.indexOf('base64,');
      if (idx != -1) cleaned = cleaned.substring(idx + 7);
    }
    try {
      if (cleaned.isNotEmpty) burgerBytes = base64Decode(cleaned);
    } catch (_) {
      burgerBytes = null;
    }

    Widget imageWidget;
    if (burgerBytes != null && burgerBytes.isNotEmpty) {
      imageWidget = Image.memory(
        burgerBytes,
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    } else {
      imageWidget = Image.asset(
        'assets/images/oferta_burger.jpg',
        width: double.infinity,
        height: 220,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.network(
            'https://res.cloudinary.com/amecar/image/upload/f_auto/v1738363260/CarlsJr-Oferta14DeFebrero-WebsiteLoNuevo-960x540_28_zbnjwa.jpg',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text('Imagen no encontrada', style: TextStyle(color: Colors.black54)),
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Colors.white)),

          // Header superior rojo con "Qpon"
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topHeaderHeight,
            child: Container(
              color: const Color.fromARGB(255, 252, 18, 47),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Qpon',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Header pequeño NEGRO "Oferta"
          Positioned(
            top: topHeaderHeight,
            left: 0,
            right: 0,
            height: smallHeaderHeight,
            child: Container(
              color: Colors.black,
              child: Center(
                child: Text(
                  'Oferta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          // Contenido scrollable
          Positioned(
            top: topHeaderHeight + smallHeaderHeight,
            bottom: bottomHeaderHeight,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 220,
                    margin: const EdgeInsets.only(bottom: 22),
                    child: Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(18),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: imageWidget,
                      ),
                    ),
                  ),
                  Text(
                    'Oferta Especial',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$79.99',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 252, 18, 47),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Disfruta de nuestras mejores ofertas y promociones exclusivas. Aplica solo en sucursales participantes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 252, 18, 47),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Reclamar Oferta',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
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
                          '• Válido hasta el 31 de diciembre\n• No acumulable con otras ofertas\n• Presenta el código en la tienda',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 252, 18, 47),
        indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite),
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.calendar_month),
            icon: Icon(Icons.calendar_month),
            label: 'Calendario',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_on),
            icon: Icon(Icons.location_on),
            label: 'Ubicación',
          ),
        ],
      ),
    );
  }
}