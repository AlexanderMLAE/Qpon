import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/offers/presentation/offer_card_widget.dart';

class Offer {
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageUrl;
  final String offerId;

  const Offer({
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageUrl,
    required this.offerId,
  });

  Map<String, Object?> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productDetails': productDetails,
      'imageUrl': imageUrl,
      'offerId': offerId,
    };
  }

  @override
  String toString() {
    return 'offerCard{name: $productName - price: $productPrice\ndetails: $productDetails - image: $imageUrl - id: $offerId}';
  }

  factory Offer.fromMapToOffer(Map<String, dynamic> offerMap) {
    return Offer(
      productName: offerMap['productName'] as String,
      productPrice: offerMap['productPrice'] as double,
      productDetails: offerMap['productDetails'] as String,
      imageUrl: offerMap['imageUrl'] as String,
      offerId: offerMap['offerId'] as String,
    );
  }

  static Widget buildOfferCard(int length, List<Offer> offers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OfferCardWidget(
            productName: offer.productName,
            productPrice: (offer.productPrice as num?)?.toDouble() ?? 0.0,
            productDetails: offer.productDetails,
            imageUrl: offer.imageUrl,
            offerId: offer.offerId,
          ),
        );
      },
    );
  }
}
