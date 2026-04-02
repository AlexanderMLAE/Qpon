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
      productName: offerMap['productName'] as String,
      productPrice: offerMap['productPrice'] as double,
      productDetails: offerMap['productDetails'] as String,
      imageUrl: offerMap['imageUrl'] as String,
      offerId: offerMap['offerId'] as String,
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
