class FavoriteProduct {
  final String productId;
  final String title;
  final String imageUrl;
  final String price;
  final String salePrice;

  FavoriteProduct({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.salePrice,
  });

  // Method to create a FavoriteProduct from JSON data
  factory FavoriteProduct.fromJson(Map<String, dynamic> json) {
    return FavoriteProduct(
      productId: json['productId'],
      title: json['title'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      salePrice: json['salePrice'],
    );
  }
}
