class SavedOfferCard {
  final String productName;
  final double productPrice;
  final String productDetails;
  final String imageUrl;

  const SavedOfferCard({
    required this.productName,
    required this.productPrice,
    required this.productDetails,
    required this.imageUrl,
  });

  Map<String, Object?> toMap() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productDetails': productDetails,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'offerCard{name: $productName - price: $productPrice\ndetails: $productDetails - image: $imageUrl}';
  }
}
