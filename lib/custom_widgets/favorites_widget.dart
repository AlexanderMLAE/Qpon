import 'package:flutter/material.dart';
import 'location_sub_widgets/offer_card_widget.dart';

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
            OfferCardWidget(
              productName: 'Produto',
              productPrice: 59.99,
              productDetails: 'Detalles especificos de la oferta',
              imageURL:
                  'https://res.cloudinary.com/amecar/image/fetch/w_849/f_auto/https://res.cloudinary.com/amecar/image/upload/f_auto/v1738363260/CarlsJr-Oferta14DeFebrero-WebsiteLoNuevo-960x540_28_zbnjwa.jpg',
            ),
          ],
        ),
      ),
    );
  }
}
