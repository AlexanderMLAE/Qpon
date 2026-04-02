import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/offers/presentation/offer_card_widget.dart';

class OfferCardBuilder {
  static Widget buildOfferCard(int length, List<Map<String, dynamic>> offers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OfferCardWidget(
            productName: offer['productName'] ?? 'Name',
            productPrice: (offer['productPrice'] as num?)?.toDouble() ?? 0.0,
            productDetails: offer['productDetails'] ?? 'Details',
            imageUrl: offer['imageUrl'] ?? 'https://i.imgur.com/vs8QJQY.png',
            offerId: offer['offerId'] ?? 'was null',
          ),
        );
      },
    );
  }
}
