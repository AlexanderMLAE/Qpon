import 'package:flutter/material.dart';
import 'package:proyecto_qpon/features/offers/presentation/offer_card_widget.dart';

/// Offer class that holds all the data from an offer
///
/// Data retrieved from Firestore
///
/// [offerId] refers to the id of the document on Firestore db and
/// [localId] refers to the id of the [Offer] on local SQLite db
///
/// This local id != null only when retrieved from local db
///
/// This is used to know whether a displayed [OfferCardWidget] is saved as a favorite
/// And was retrived using [fromMapToOffer]
/// Or if it comes directly from firestore

class Offer {
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageUrl;

  /// Firestore document ID
  final String offerId;

  /// Local SQLite element ID
  ///
  /// Null if it is not retrieved from local db
  final int? localId;

  const Offer({
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageUrl,
    required this.offerId,
    required this.localId,
  });

  /// Turn the [Offer] object into a [Map]
  ///
  /// This is used to insert it to the local database
  Map<String, Object?> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productDetails': productDetails,
      'imageUrl': imageUrl,
      'offerId': offerId,
    };
  }

  /// Turn the object into a string just to print its values more comfortably
  @override
  String toString() {
    return 'offerCard{name: $productName - price: $productPrice - details: $productDetails\n image: $imageUrl - firestore: $offerId - local: $localId}';
  }

  /// Gets an Offer as a [Map] from local db and returns an [Offer] object
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

  /// Gets a list of [Offer] objects and returns a scrollable list of offer cards
  static Widget buildOfferCard(
    /// Ammount of [Offer]s that will be drawn
    int length,

    /// Array of [Offer]s from Firestore or SQLite
    List<Offer> offers,
  ) {
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
