import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/offers/presentation/offer_card_widget.dart';

class Offer {
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageUrl;
  final String offerId;
  final int? localId;

  const Offer({
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageUrl,
    required this.offerId,
    required this.localId,
  });

  // Turn the object into a map, useful when inserting to a db
  Map<String, Object?> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productDetails': productDetails,
      'imageUrl': imageUrl,
      'offerId': offerId,
    };
  }

  // Turn the object into a string just to print its values more comfortably
  @override
  String toString() {
    return 'offerCard{name: $productName - price: $productPrice - details: $productDetails\n image: $imageUrl - firestore: $offerId - local: $localId}';
  }

  // Gets an offer as a map from local db and returns an offer object
  factory Offer.fromMapToOffer(Map<String, dynamic> offerMap) {
    return Offer(
      productName: offerMap['productName'] as String? ?? 'Null name',
      productPrice: (offerMap['productPrice'] as num?)?.toDouble() ?? 0.0,
      productDetails: offerMap['productDetails'] as String? ?? 'Null details',
      imageUrl:
          // Qpon logo as fallback image
          offerMap['imageUrl'] as String? ?? 'https://i.imgur.com/vs8QJQY.png',
      offerId: offerMap['offerId'] as String? ?? 'Id-was-null',
      localId: offerMap['id'] as int?,
    );
  }

  // Gets a list of offer objects and returns a scrollable list of offer cards
  static Widget buildOfferCard(int length, List<Offer> offers) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: OfferCardWidget(offer: offer),
        );
      },
    );
  }
}
