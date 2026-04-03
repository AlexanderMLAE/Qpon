import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/offers/presentation/offer_card_widget.dart';

class Offer {
  final String productName; // product_name -- On firestore --
  final double productPrice; // product_price
  final String productDetails; // product_details
  final String imageUrl; // image_url
  final String offerId; // id of the offer document

  const Offer({
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageUrl,
    required this.offerId,
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
    return 'offerCard{name: $productName - price: $productPrice\ndetails: $productDetails - image: $imageUrl - id: $offerId}';
  }

  // Gets an offer as a map and return an offer object
  factory Offer.fromMapToOffer(Map<String, dynamic> offerMap) {
    return Offer(
      productName: offerMap['productName'] as String? ?? 'Null name',
      productPrice: offerMap['productPrice'] as double? ?? 00.00,
      productDetails: offerMap['productDetails'] as String? ?? 'Null details',
      imageUrl:
          // Qpon logo as fallback image
          offerMap['imageUrl'] as String? ?? 'https://i.imgur.com/vs8QJQY.png',
      offerId: offerMap['offerId'] as String? ?? 'ID WAS NULL',
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
          // Will probably change this so that the OfferCardWidget takes an offer object as parameter instead
          child: OfferCardWidget(offer: offer),
        );
      },
    );
  }
}
