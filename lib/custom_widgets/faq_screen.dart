import 'package:flutter/material.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _searchQuery = '';

  final List<Map<String, String>> _allFaqs = [
    {
      'question': '¿Cómo veo una Oferta?',
      'answer':
          'Selecciona la oferta que deseas ver desde la app y sigue las instrucciones que aparecen en pantalla en el establecimiento participante.',
    },
    {
      'question': '¿Necesito conexión a internet?',
      'answer':
          'Sí, se requiere conexión para sincronizar ofertas y validar nuevas ofertas en tiempo real.',
    },
    {
      'question': '¿Cómo contacto soporte?',
      'answer': 'Escríbenos al correo qpon@gmail.com para recibir ayuda.',
    },
    {
      'question': '¿Cuánto tiempo son válidas las ofertas?',
      'answer':
          'Cada oferta tiene una fecha de vigencia indicada en sus detalles.',
    },
    {
      'question': '¿Puedo usar una oferta más de una vez?',
      'answer':
          'Depende de las restricciones de cada oferta. Algunas son limitadas, todo depende del establecimiento.',
    },
    {
      'question': '¿Cómo me registro en Qpon?',
      'answer':
          'Puedes registrarte utilizando tu correo electrónico, cuenta de Google o número de teléfono desde la pantalla de inicio.',
    },
    {
      'question': '¿Qué pasa si el establecimiento no acepta mi oferta?',
      'answer':
          'Si el establecimiento es participante y la oferta está vigente, te sugerimos contactarnos desde Soporte en la app para reportar la situación.',
    },
    {
      'question': '¿Tiene algún costo usar la app?',
      'answer':
          'No, Qpon es totalmente gratis para todos los usuarios. Solo pagas por los productos o servicios en el establecimiento.',
    },
    {
      'question': '¿Cómo comparto una oferta con mis amigos?',
      'answer':
          'Se espera proximamente agregar funciones, de momento no es compartido.',
    },
    {
      'question': '¿Puedo guardar mis ofertas favoritos?',
      'answer':
          'Sí, selecciona el ícono de corazón o la opción de "Guardar" para conservarlos en tu lista personal y encontrarlos más rápido.',
    },
    {
      'question': '¿Qué hago si olvidé mi contraseña?',
      'answer':
          'Ve a la pantalla de inicio de sesión y selecciona "¿Olvidaste tu contraseña?". Te enviaremos un correo con las instrucciones para restablecerla.',
    },
    {
      'question': '¿Se actualizan las ofertas frecuentemente?',
      'answer':
          '¡Sí! Agregamos nuevas ofertas y promociones constantemente para ofrecerte siempre los mejores beneficios.',
    },
    {
      'question': '¿Cómo elimino mi cuenta?',
      'answer':
          'Para eliminar tu cuenta definitivamente, ve a Configuración, luego en Privacidad y Seguridad selecciona "Eliminar mi cuenta".',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = _allFaqs.where((faq) {
      final questionMatches = faq['question']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final answerMatches = faq['answer']!.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return questionMatches || answerMatches;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preguntas frecuentes'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar preguntas...',
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 252, 18, 47),),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                  color: const Color.fromARGB(255, 252, 18, 47),
                  width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredFaqs.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No encontramos preguntas que coincidan con tu búsqueda.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredFaqs[index];
                      return ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        title: Text(
                          item['question'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                              left: 12,
                              right: 12,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(item['answer'] ?? ''),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemCount: filteredFaqs.length,
                  ),
          ),
        ],
      ),
    );
  }
}
