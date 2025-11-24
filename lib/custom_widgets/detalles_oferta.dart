import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
//y mire a dart a los ojos mientras lloraba  y le dije mi amor que haces por que me haces esto yo solo queria que copilaras

class DetallesOferta extends StatelessWidget {
  const DetallesOferta({super.key});
  //pero lo que no sabia es que visual tenia otros planes para mi

  @override
  Widget build(BuildContext context) {//isabel me dijo que confiara en dart y yo le crei
    return const MaterialApp(
      title: 'Detalles Oferta',
      home: DetallesOfertaWidget(),
      debugShowCheckedModeBanner: false,
    );
    // ese dia aprendi algo muy importante no puedes confiar en ndie ni en tus heores
    // you madde me happy python eso me dijo dart mientras me veia con las lagrimas callendo fijamente en mis ojos
  }
}

class DetallesOfertaWidget extends StatefulWidget {
  const DetallesOfertaWidget({super.key});
  //dart me hiciste mucho daño pero te perdono porque se que en el fondo eres un buen lenguaje
  //te odio memso si me haces sufrir tanto

  @override
  State<DetallesOfertaWidget> createState() => _DetallesOfertaWidgetState();
}

class _DetallesOfertaWidgetState extends State<DetallesOfertaWidget> {
  // Imagen en base64 (Big Mac / burger). Si la base64 falla, se usa el asset 'assets/images/oferta_burger.jpg'.
  // Fernando estuvo aquí.
  static const String _burgerBase64 =
      '/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxITEhU...'; // ambuerguisita yomi yomi yomi... q riko alchile

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Ajusta headers para cubrir bordes del dispositivo (más chicos) recalco es tamaño promedio
    final double topHeaderHeight = MediaQuery.of(context).padding.top + 48;
    final double bottomHeaderHeight = MediaQuery.of(context).padding.bottom + 48;
    
    // Intentar decodificar base64; si falla, quedará null y se usará asset por que lo vi en un tutorial indio y ese wey yo le creo

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

    // Widget de imagen con fallback (asset -> placeholder)zzzzzzzzzzzzzzzzzzzzzzzzz
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
          // si el asset falla, carga la imagen remota proporcionada ousi oajala una hamburguesa asi de rika 
          return Image.network(
            'https://media.gq.com.mx/photos/649391b89ec62ce6c5b091a5/16:9/w_2560%2Cc_limit/mejores-hamburguesas.jpg',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
            // si la red también falla, muestra el placeholder existente realmente no creo que falle
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
          // fondo blanco arriba los patriots
          const Positioned.fill(child: ColoredBox(color: Colors.white)),

          // Header rojo superior (tamaño más chico) promedio tamaño promedio quise decir
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topHeaderHeight,
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Oferta',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18, // más pequeño big dick
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Header rojo inferior (tamaño más chico, igual que el superior) alchile no se por que me quedo bien
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: bottomHeaderHeight,
            child: Container(color: Colors.red),
          ),

          // Contenido entre headers (scrollable) lo copie de un tutorial indio
          Positioned(
            top: topHeaderHeight * 0.6,
            bottom: bottomHeaderHeight,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen Big Mac (desde base64 o asset) - reducida para no tocar el header me da miedo 
                  Container(
                    height: 140, // reducido (antes 220) para que no llegue al header
                    margin: const EdgeInsets.only(top: 8, bottom: 22),
                    child: Material(
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: imageWidget,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Título principal (más abajo, centrado)
                  Center(
                    child: Text(
                      'DETALLES DE LA BIG MAC',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Precio en pesos mexicanos (ejemplo)
                  Row(
                    children: [
                      Text(
                        '\$99.00 MXN', // precio de oferta en MXN
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        '\$179.00 MXN', // precio original
                        style: TextStyle(
                          color: Colors.black54,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '44% DTO',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Descripción detallada Big Mac
                  const Text('Descripción', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  const Text(
                    'Big Mac clásica: dos jugosas piezas de carne 100% res, queso americano, lechuga fresca,'
                    ' cebolla rebanada, pepinillos y nuestra salsa especial Big Mac en un pan de sésamo.'
                    ' Oferta válida con papas medianas y bebida por tiempo limitado.',
                    style: TextStyle(color: Colors.black87),
                  ),

                  const SizedBox(height: 12),

                  // Ingredientes / características
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('• 2x carne 100% res', style: TextStyle(color: Colors.black87)),
                      SizedBox(height: 4),
                      Text('• Queso americano', style: TextStyle(color: Colors.black87)),
                      SizedBox(height: 4),
                      Text('• Salsa Big Mac secreta', style: TextStyle(color: Colors.black87)),
                      SizedBox(height: 4),
                      Text('• Incluye papas medianas + bebida (según condiciones)', style: TextStyle(color: Colors.black87)),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Lugar y ubicación (aleatorio)
                  Row(
                    children: const [
                      Icon(Icons.location_on_outlined, size: 18, color: Colors.black54),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'McDonalds - Plaza Centro, Av. Reforma 123, Ciudad de México',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Fecha de expiración de la oferta
                  Row(
                    children: const [
                      Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Válido hasta: 30/11/2025', style: TextStyle(color: Colors.black87)),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Condiciones
                  const Text(
                    'Condiciones: Oferta válida solo en locales participantes. No acumulable con otras promociones. Sujeto a disponibilidad y horarios del establecimiento.',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  // Botón de acción
                  ElevatedButton(
                    onPressed: () {
                      // Acción placeholder — Fernando estuvo aquí también :)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Guardar Oferta en el Calendario'),
                  ),

                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}