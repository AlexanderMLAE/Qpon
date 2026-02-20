import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
	const FaqScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final faqs = <Map<String, String>>[
			{
				'question': '¿Cómo canjeo un cupón?',
				'answer': 'Selecciona el cupón desde la app y sigue las instrucciones que aparecen en pantalla en el establecimiento participante.'
			},
			{
				'question': '¿Necesito conexión a internet?',
				'answer': 'Sí, se requiere conexión para sincronizar cupones y validar el canje en tiempo real.'
			},
			{
				'question': '¿Cómo contacto soporte?',
				'answer': 'Escríbenos al correo soporte@qpon.mx o utiliza el chat del Centro de privacidad para recibir ayuda.'
			},
		];

		return Scaffold(
			appBar: AppBar(
				title: const Text('Preguntas frecuentes'),
				backgroundColor: Colors.red.shade700,
				foregroundColor: Colors.white,
				iconTheme: const IconThemeData(color: Colors.white),
				titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
			),
			body: ListView.separated(
				padding: const EdgeInsets.all(16),
				itemBuilder: (context, index) {
					final item = faqs[index];
					return ExpansionTile(
						tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
						title: Text(
							item['question'] ?? '',
							style: const TextStyle(fontWeight: FontWeight.w600),
						),
						children: [
							Padding(
								padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
								child: Align(
									alignment: Alignment.centerLeft,
									child: Text(item['answer'] ?? ''),
								),
							),
						],
					);
				},
				separatorBuilder: (_, _) => const Divider(height: 1),
				itemCount: faqs.length,
			),
		);
	}
}
