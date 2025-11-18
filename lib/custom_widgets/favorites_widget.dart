import 'package:flutter/material.dart';

class FavoritesWidget extends StatelessWidget {
  const FavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            const Text(
              'En este Apartado puedes agregar tus Ofertas Favoritas',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                            child: Image(
                              image: NetworkImage(
                                'https://res.cloudinary.com/amecar/image/fetch/w_849/f_auto/https://res.cloudinary.com/amecar/image/upload/f_auto/v1738363260/CarlsJr-Oferta14DeFebrero-WebsiteLoNuevo-960x540_28_zbnjwa.jpg',
                              ),
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Precio',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Nombre del Establecimiento',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Container(height: 1, color: Colors.red[300]),

                    const SizedBox(height: 8),

                    const Text(
                      'Detalles',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Detalles específicos de la oferta...',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
