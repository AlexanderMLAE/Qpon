class SavedOfferCard {
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageUrl;
  final String offerId;

  const SavedOfferCard({
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
}
