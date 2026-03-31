import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendar_widget.dart';

class DetallesOferta extends StatelessWidget {
  const DetallesOferta({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageURL,
    this.targetDate,
  });
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageURL;
  final DateTime? targetDate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalles Oferta',
      home: DetallesOfertaWidget(
        productName: productName,
        productPrice: productPrice,
        productDetails: productDetails,
        imageURL: imageURL,
        targetDate: targetDate,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DetallesOfertaWidget extends StatefulWidget {
  const DetallesOfertaWidget({
    super.key,
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageURL,
    this.targetDate,
  });
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageURL;
  final DateTime? targetDate;

  @override
  State<DetallesOfertaWidget> createState() => _DetallesOfertaWidgetState();
}

class _DetallesOfertaWidgetState extends State<DetallesOfertaWidget> {
  static const String _burgerBase64 =
      '/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxITEhU...';

  Uint8List? burgerBytes;
  int currentPageIndex = 0;

  DateTime _parseDate(String text) {
    final months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final regex = RegExp(r'(\d{1,2})\s+de\s+([a-zA-Z]+)');
    final match = regex.firstMatch(text.toLowerCase());

    if (match != null) {
      int day = int.tryParse(match.group(1) ?? '1') ?? 1;
      String monthStr = match.group(2) ?? 'enero';
      int month = months.indexOf(monthStr) + 1;
      if (month > 0) {
        return DateTime(DateTime.now().year, month, day);
      }
    }
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final double topHeaderHeight = MediaQuery.of(context).padding.top + 48;
    final double bottomHeaderHeight =
        MediaQuery.of(context).padding.bottom + 48;
    final double smallHeaderHeight = topHeaderHeight / 2;

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: Colors.white)),
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
                        child: Image.network(
                          widget.imageURL,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Imagen no encontrada',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    widget.productName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$ ${widget.productPrice}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 252, 18, 47),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.productDetails,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final String? eventosJson = prefs.getString(
                        'eventos_qpon',
                      );
                      Map<String, dynamic> datosDecodificados =
                          eventosJson != null ? json.decode(eventosJson) : {};

                      const termsText =
                          '• Válido hasta el 29 de marzo\n• No acumulable con otras ofertas\n• Presenta el código en la tienda';

                      final fecha = widget.targetDate ?? _parseDate(termsText);
                      final normalizedDate = DateTime(
                        fecha.year,
                        fecha.month,
                        fecha.day,
                      );

                      final newEvent = EventData(
                        title: widget.productName,
                        note: widget.productDetails,
                        productName: widget.productName,
                        productPrice: widget.productPrice,
                        productDetails: widget.productDetails,
                        imageURL: widget.imageURL,
                      );

                      datosDecodificados[normalizedDate.toIso8601String()] =
                          newEvent.toJson();
                      await prefs.setString(
                        'eventos_qpon',
                        json.encode(datosDecodificados),
                      );

                      updateCalendarNotifier.value =
                          !updateCalendarNotifier.value;

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Oferta guardada en el calendario'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 252, 18, 47),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Guardar Oferta',
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
                          '• Válido hasta el 29 de marzo\n• No acumulable con otras ofertas\n• Presenta el código en la tienda',
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
    );
  }
}
